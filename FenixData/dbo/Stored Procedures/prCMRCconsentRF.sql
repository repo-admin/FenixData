
CREATE PROCEDURE [dbo].[prCMRCconsentRF]
			@Decision  AS Int, -- 3... zamítám, 1... schvaluji  2015-11-04 hodnota 2 se už nepoužívá
			@Id        AS Int, -- ID záznamu z tabulky [dbo].[CommunicationMessagesRefurbishedOrderConfirmation]

			@DeleteMessageId AS Int,													--2015-11-04 MessageId záznamu z tabulky [dbo].[CommunicationMessagesRefurbishedOrderConfirmation]
			@DeleteMessageTypeId AS Int,											--2015-11-04 z tabulky [dbo].[cdlMessageTypes]
			@DeleteMessageTypeDescription AS nvarchar(200),		--2015-11-04 z tabulky [dbo].[cdlMessageTypes]

			@ModifyUserId        AS Int = 0,
			@ReturnValue     int            = -1 OUTPUT,
			@ReturnMessage   nvarchar(2048) = null OUTPUT
AS

SET NOCOUNT ON;
DECLARE @myDatabaseName  nvarchar(100)
BEGIN TRY
/*
2014-09-26, 2014-09-30, 2014-10-23, 2014-11-03, 2014-11-07, 2014-11-12, 2014-11-24, 2014-12-01, 2015-04-22 M.Weczerek
2015-11-04  M.Rezler  Decision: přidána hodnota 3  (D0 odeslána),  hodnota 2 se nepoužívá 
*/

    SELECT @myDatabaseName = DB_NAME() 

       DECLARE  @myAdresaLogistika  varchar(500),@myAdresaProgramator  varchar(500) 
       SET @myAdresaLogistika   = [dbo].[fnHomeAdresses] (4)
       SET @myAdresaProgramator = [dbo].[fnHomeAdresses] (2)
       
       DECLARE @errTask nvarchar (126), @errLine int, @errNumb int
     
       DECLARE  @myMessage [nvarchar] (max), @myReturnValue [int],@myReturnMessage nvarchar(2048)
       
       DECLARE  @myPocetPolozekCelkem [int], @myPocetPolozekPomooc[int], @mOK [bit]
       SET @mOK = 1 
       -- ---
       DECLARE @msg    varchar(max)
       DECLARE @MailTo varchar(150)
       DECLARE @MailBB varchar(150)
       DECLARE @sub    varchar(1000) 
       DECLARE @Result int
       SET @msg = ''

       SELECT  @ReturnValue=0,  @ReturnMessage='OK'
       DECLARE @myError AS INT
       SET @myError = 0

       DECLARE @myShipmentOrderID  AS Integer
       SELECT  @myShipmentOrderID = [RefurbishedOrderID] FROM [dbo].[CommunicationMessagesRefurbishedOrderConfirmation] WHERE id = @Id


     IF @Decision = 3		--2  2015-11-04
     BEGIN -- zamítnuto 
         BEGIN TRAN

               UPDATE [dbo].[CardStockItems] SET [ItemOrKitUnConsilliation] = ISNULL([ItemOrKitUnConsilliation],0) - COI.ItemOrKitQuantity
               FROM [dbo].[CardStockItems] CSI
               INNER JOIN [dbo].[CommunicationMessagesRefurbishedOrderConfirmationItems] COI 
                   ON      COI.ItemVerKit = CSI.ItemVerKit 
                       AND COI.ItemOrKitId = CSI.ItemOrKitID 
                       AND COI.ItemOrKitQualityId = CSI.ItemOrKitQuality  
                       AND COI.ItemOrKitUnitOfMeasureId = CSI.ItemOrKitUnitOfMeasureId
               INNER JOIN [dbo].[CommunicationMessagesRefurbishedOrderConfirmation]      COH
                   ON COI.[CMSOId] = COH.ID
               INNER JOIN [dbo].[CommunicationMessagesRefurbishedOrder]                 CMRO
                   ON COH.RefurbishedOrderID = CMRO.ID
               WHERE COI.[CMSOId] = @Id AND CMRO.StockId = CSI.StockId  AND COI.IsActive = 1
               --WHERE COI.[CMSOId] = @myShipmentOrderID AND CMRO.StockId = CSI.StockId  
               SET @myError = @myError + @@ERROR

---- ============ 2014-10-23  START
               
--               UPDATE [dbo].[CardStockItems] 
--               SET    [ItemOrKitUnConsilliation] = ISNULL([ItemOrKitUnConsilliation],0) - cc.ItemOrKitQuantity*cc.COIItemOrKitQuantity
--               FROM [dbo].[CardStockItems] CSI     --SELECT cc.ItemOrKitQuantity*cc.COIItemOrKitQuantity,* 
--               INNER JOIN (
--               SELECT bb.*,aa.ItemOrKitQuantity AS COIItemOrKitQuantity FROM (
--                              SELECT COI.* FROM [dbo].[CommunicationMessagesRefurbishedOrderConfirmationItems] COI 
--                              INNER JOIN [dbo].[CommunicationMessagesRefurbishedOrderConfirmation]      COH
--                                  ON COI.[CMSOId] = COH.ID
--                              INNER JOIN [dbo].[CommunicationMessagesRefurbishedOrder]                 CMRO
--                                  ON COH.RefurbishedOrderID = CMRO.ID
--                              WHERE COI.[CMSOId] = @Id AND CMRO.StockId = 2   AND COH.Reconciliation = 0 AND COI.ItemVerKit=1
--               ) aa
--               INNER JOIN  (SELECT cKI.[ItemVerKit], cKI.[ItemOrKitId], cK.KitQualitiesId, cI.[MeasuresId], cKI.[ItemOrKitQuantity], cK.ID
--                                                       FROM [dbo].[cdlKitsItems]      cKI
--                                                       INNER JOIN [dbo].[cdlKits]     cK
--                                                           ON cKI.cdlKitsId = cK.ID
--                                                       INNER JOIN [dbo].[cdlItems]    cI
--                                                           ON cKI.ItemOrKitId = cI.ID
--                                                       WHERE cK.IsActive=1 AND cKI.[ItemVerKit] = 0  -- Items
--               ) bb
--               ON aa.[ItemOrKitId] = bb.[ID] 
--               ) cc
--               ON     CSI.ItemOrKitQuality = cc.KitQualitiesId AND CSI.ItemVerKit = cc.ItemVerKit 
--                  AND CSI.ItemOrKitUnitOfMeasureId = cc.MeasuresId AND CSI.ItemOrKitId=cc.ItemOrKitId

---- ============ 2014-10-23  END

               -- 1.
               UPDATE [dbo].[CommunicationMessagesRefurbishedOrderConfirmation] SET [Reconciliation]  = @Decision, [ModifyUserId] = @ModifyUserId WHERE [ID] = @Id
               UPDATE [dbo].[CommunicationMessagesRefurbishedOrder]             SET [MessageStatusId] = 7 WHERE [ID] = @myShipmentOrderID

							 --novinka 2015-11-04 start
							 DECLARE @FreeNumber AS [int]
							 SELECT @FreeNumber = [LastFreeNumber] FROM [dbo].[cdlMessageNumber]        WHERE [Code]=1 
               UPDATE [dbo].[cdlMessageNumber] SET [LastFreeNumber] = @FreeNumber + 1     WHERE [Code]=1

							 INSERT INTO [dbo].[CommunicationMessagesDeleteMessage]
													([MessageId], [MessageTypeId], [MessageTypeDescription], [MessageStatusId]
													,[DeleteId], [DeleteMessageId], [DeleteMessageTypeId], [DeleteMessageTypeDescription]
													,[Notice], [SentDate], [SentUserId]
													,[IsActive], [ModifyDate], [ModifyUserId])
										VALUES
													(@FreeNumber, 15, 'DeleteMessage', 1
													,@Id, @DeleteMessageId, @DeleteMessageTypeId, @DeleteMessageTypeDescription
													,NULL, NULL, NULL
													,1, getdate(), @ModifyUserId)							  
							 --novinka 2015-11-04 konec

               IF @@ERROR = 0 COMMIT TRAN 
               ELSE              
               BEGIN
                   ROLLBACK TRAN
                   SET @ReturnMessage = ISNULL(ERROR_MESSAGE(),'') + ISNULL(CAST(ERROR_NUMBER() AS VARCHAR(50)),'')
              END
 
     END   -- zamítnuto
     
     IF @Decision = 1
     BEGIN -- schváleno
         BEGIN TRAN
                -- 2.
               /* 
                  Na základě požadavku Dana ze dne 6.11.2014 se mění načtení z položky ItemOrKitReleasedForExpedition na [ItemOrKitFree]
                  SET [ItemOrKitUnConsilliation]    = ISNULL([ItemOrKitUnConsilliation],0)       - COI.ItemOrKitQuantity
                  , [ItemOrKitReleasedForExpedition]= ISNULL([ItemOrKitReleasedForExpedition],0) + COI.ItemOrKitQuantity
               */
               UPDATE [dbo].[CardStockItems] 
               SET [ItemOrKitUnConsilliation]    = ISNULL([ItemOrKitUnConsilliation],0)  - COI.ItemOrKitQuantity
                 , [ItemOrKitFree]               = ISNULL([ItemOrKitFree],0)             + COI.ItemOrKitQuantity
               FROM [dbo].[CardStockItems] CSI
               INNER JOIN [dbo].[CommunicationMessagesRefurbishedOrderConfirmationItems] COI 
                   ON      COI.ItemVerKit  = CSI.ItemVerKit 
                       AND COI.ItemOrKitId = CSI.ItemOrKitID 
                       AND COI.ItemOrKitQualityId       = CSI.ItemOrKitQuality 
                       AND COI.ItemOrKitUnitOfMeasureId = CSI.ItemOrKitUnitOfMeasureId
                       AND COI.ItemVerKit = 1   -- kit
               INNER JOIN [dbo].[CommunicationMessagesRefurbishedOrderConfirmation]      COH
                   ON COI.[CMSOId] = COH.ID
               INNER JOIN [dbo].[CommunicationMessagesRefurbishedOrder]                 CMRO
                   ON COH.RefurbishedOrderID = CMRO.ID
               WHERE COI.[CMSOId] = @Id AND CMRO.StockId = CSI.StockId   AND COH.Reconciliation = 0 AND COI.ItemVerKit = 1 AND COI.IsActive = 1

               SET @myError = @myError + @@ERROR
-- ============ 2014-10-23  START

               UPDATE [dbo].[CardStockItems] 
               SET [ItemOrKitUnConsilliation] = ISNULL([ItemOrKitUnConsilliation],0) - COI.ItemOrKitQuantity
                 , [ItemOrKitFree]            = ISNULL([ItemOrKitFree],0)            + COI.ItemOrKitQuantity
               FROM [dbo].[CardStockItems] CSI
               INNER JOIN [dbo].[CommunicationMessagesRefurbishedOrderConfirmationItems] COI 
                   ON      COI.ItemVerKit  = CSI.ItemVerKit 
                       AND COI.ItemOrKitId = CSI.ItemOrKitID 
                       AND COI.ItemOrKitQualityId = CSI.ItemOrKitQuality 
                       AND COI.ItemOrKitUnitOfMeasureId = CSI.ItemOrKitUnitOfMeasureId 
                       AND COI.ItemVerKit = 0   -- Item
               INNER JOIN [dbo].[CommunicationMessagesRefurbishedOrderConfirmation]      COH
                   ON COI.[CMSOId] = COH.ID
               INNER JOIN [dbo].[CommunicationMessagesRefurbishedOrder]                 CMRO
                   ON COH.RefurbishedOrderID = CMRO.ID
               WHERE COI.[CMSOId] = @Id AND CMRO.StockId = CSI.StockId   AND COH.Reconciliation = 0 AND COI.ItemVerKit = 0 AND COI.IsActive = 1
               SET @myError = @myError + @@ERROR
               /*
Zrušeno na základě informace od Anny Stodolové ze dne 20.11.2014--"Mimo K0 a K1 se itemy nehýbají !!!"

               -------- zpracovani itemu v Kitech
               ------UPDATE [dbo].[CardStockItems] 
               ------SET [ItemOrKitUnConsilliation] = ISNULL([ItemOrKitUnConsilliation],0) - cc.ItemOrKitQuantity*cc.COIItemOrKitQuantity
               ------   ,ItemOrKitReserved          = ISNULL([ItemOrKitReserved],0)        + cc.ItemOrKitQuantity*cc.COIItemOrKitQuantity
               ------FROM [dbo].[CardStockItems] CSI     --SELECT cc.ItemOrKitQuantity*cc.COIItemOrKitQuantity,* 
               ------INNER JOIN (
               ------SELECT bb.*,aa.ItemOrKitQuantity AS COIItemOrKitQuantity FROM (
               ------               SELECT COI.* FROM [dbo].[CommunicationMessagesRefurbishedOrderConfirmationItems] COI 
               ------               INNER JOIN [dbo].[CommunicationMessagesRefurbishedOrderConfirmation]      COH
               ------                   ON COI.[CMSOId] = COH.ID
               ------               INNER JOIN [dbo].[CommunicationMessagesRefurbishedOrder]                 CMRO
               ------                   ON COH.RefurbishedOrderID = CMRO.ID
               ------               WHERE COI.[CMSOId] = @Id AND CMRO.StockId = 2   AND COH.Reconciliation = 0 AND COI.ItemVerKit=1 AND COI.IsActive = 1
               ------) aa
               ------INNER JOIN  (SELECT cKI.[ItemVerKit], cKI.[ItemOrKitId], cK.KitQualitiesId, cI.[MeasuresId], cKI.[ItemOrKitQuantity], cK.ID
               ------                                        FROM [dbo].[cdlKitsItems]      cKI
               ------                                        INNER JOIN [dbo].[cdlKits]     cK
               ------                                            ON cKI.cdlKitsId = cK.ID
               ------                                        INNER JOIN [dbo].[cdlItems]    cI
               ------                                            ON cKI.ItemOrKitId = cI.ID
               ------                                        WHERE cK.IsActive=1 AND cKI.[ItemVerKit] = 0  -- Items
               ------) bb
               ------ON aa.[ItemOrKitId] = bb.[ID] 
               ------) cc
               ------ON     CSI.ItemOrKitQuality = cc.KitQualitiesId AND CSI.ItemVerKit = cc.ItemVerKit 
               ------   AND CSI.ItemOrKitUnitOfMeasureId = cc.MeasuresId AND CSI.ItemOrKitId=cc.ItemOrKitId
               */
-- ============ 2014-10-23  END
               -- 3
               UPDATE [dbo].[CommunicationMessagesRefurbishedOrderItems] 
                     SET [ItemOrKitQuantityDelivered]= ISNULL([ItemOrKitQuantityDelivered],0) +  CMROI.ItemOrKitQuantity
               FROM [dbo].[CommunicationMessagesRefurbishedOrderItems]         COI
               INNER JOIN [dbo].[CommunicationMessagesRefurbishedOrder]        COH
                  ON COI.[CMSOId] = COH.ID
               INNER JOIN [dbo].[CommunicationMessagesRefurbishedOrderConfirmation]                     CMRO
                   ON COH.ID = CMRO.RefurbishedOrderID
               INNER JOIN [dbo].[CommunicationMessagesRefurbishedOrderConfirmationItems]                CMROI
                   ON CMRO.ID = CMROI.[CMSOId]
               WHERE COI.ItemVerKit  = CMROI.ItemVerKit 
                 AND COI.ItemOrKitId = CMROI.ItemOrKitID
                 AND COI.ItemOrKitQualityId       = CMROI.ItemOrKitQualityId 
                 AND COI.IsActive = 1
                 AND COI.ItemOrKitUnitOfMeasureId = CMROI.ItemOrKitUnitOfMeasureId
                 AND COH.ID = @myShipmentOrderID 
                 AND CMRO.IsActive=1 
                 AND CMRO.Reconciliation = 0
              SET @myError = @myError + @@ERROR
              -- 1.
               UPDATE [dbo].[CommunicationMessagesRefurbishedOrderConfirmation] SET [Reconciliation]  = 1, [ModifyUserId] = @ModifyUserId WHERE [ID] = @Id
               SET @myError = @myError + @@ERROR

               -- 4

               DECLARE @myDecision AS Integer
               SELECT  @myDecision =  COUNT(*) FROM
               ( 
                 SELECT SUM(ISNULL([ItemOrKitQuantity],0) - ISNULL([ItemOrKitQuantityDelivered],0)) SUMA, [ItemVerKit],[ItemOrKitID],ItemOrKitQualityId
                 FROM [dbo].[CommunicationMessagesRefurbishedOrderItems] WHERE IsActive=1 AND [CMSOId]=@myShipmentOrderID 
                 GROUP BY [ItemVerKit],[ItemOrKitID], ItemOrKitQualityId) aa
                 WHERE SUMA<>0
 
               IF @myDecision=0 OR @myDecision IS NULL
               BEGIN
                   UPDATE [dbo].[CommunicationMessagesRefurbishedOrder] SET [MessageStatusId] = 6
                   WHERE ID = @myShipmentOrderID
                   SET @myError = @myError + @@ERROR
               END
               ELSE
               BEGIN
                   UPDATE [dbo].[CommunicationMessagesRefurbishedOrder] SET [MessageStatusId] = 8
                   WHERE ID = @myShipmentOrderID
                   SET @myError = @myError + @@ERROR
                   --SET @myError = @@ERROR  SELECT @myError '@myError3b'
               END
               IF @myError = 0 
               BEGIN
                  if @@TRANCOUNT>0  COMMIT TRAN 
               END
               ELSE 
               BEGIN
                    if @@TRANCOUNT>0  ROLLBACK TRAN
                    SET @ReturnValue = @myError
                    SET @ReturnMessage = ISNULL(ERROR_MESSAGE(),'') + ISNULL(CAST(ERROR_NUMBER() AS VARCHAR(50)),'')
               END
     END   -- schváleno

END TRY
BEGIN CATCH
      if @@TRANCOUNT>0  ROLLBACK TRAN
      SELECT @ReturnValue=1, @ReturnMessage='Chyba'
      SET @sub = 'FENIX - Refurbished Confirmation CHYBA' + ' Databáze: '+ISNULL(@myDatabaseName,'')
      SET @msg = 'Program prCMRCconsentRF; '  + ISNULL(ERROR_MESSAGE(),'') + ISNULL(CAST(ERROR_NUMBER() AS VARCHAR(50)),'') 
      EXEC @result = msdb.dbo.sp_send_dbmail
     		@profile_name = 'Automat', --@MailProfileName
     		@recipients = 'max.weczerek@upc.cz;michal.rezler@upc.cz',
     		@subject = @sub,
     		@body = @msg,
     		@body_format = 'HTML'
END CATCH


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[prCMRCconsentRF] TO [FenixW]
    AS [dbo];

