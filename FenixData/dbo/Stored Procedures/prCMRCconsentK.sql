

CREATE PROCEDURE [dbo].[prCMRCconsentK]
			@Decision  AS Int, -- 3... zamítám, 1... schvaluji  2015-11-04 hodnota 2 se už nepoužívá
			@Id        AS Int, -- ID záznamu z tabulky [dbo].[CommunicationMessagesKittingsConfirmation]

			@DeleteMessageId AS Int,													--2015-11-04 MessageID záznamu z tabulky [dbo].[CommunicationMessagesKittingsConfirmation]
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
2014-11-03, 2014-11-10, 2014-12-01, 2014-12-03  M.Weczerek
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

       SELECT 	   @ReturnValue=0,  @ReturnMessage='OK'
       DECLARE @myError AS INT
       SET @myError = 0

       DECLARE @myKitOrderID  AS Integer
       SELECT  @myKitOrderID = [KitOrderID] FROM [dbo].[CommunicationMessagesKittingsConfirmation] WHERE id = @Id


     IF @Decision = 3		--2  2015-11-04
     BEGIN -- zamítnuto 
         BEGIN TRAN
               -- 1.
               UPDATE [dbo].[CommunicationMessagesKittingsConfirmation] SET [Reconciliation] = @Decision, [ModifyUserId] = @ModifyUserId WHERE [ID] = @Id
               -- 2.
               UPDATE [dbo].[CardStockItems] SET [ItemOrKitUnConsilliation] = ISNULL([ItemOrKitUnConsilliation],0) - CMRCI.[KitQuantity]
               FROM   [dbo].[CardStockItems] CSI
               INNER JOIN [dbo].[CommunicationMessagesKittingsConfirmationItems]  CMRCI
                     ON CSI.ItemOrKitID = CMRCI.[KitID] 
               WHERE CMRCI.[CMSOId] = @Id

               -- 3.
               UPDATE [dbo].[CommunicationMessagesKittingsSentItems] SET [KitQuantityDelivered]= ISNULL([KitQuantityDelivered],0) -  CMRCI.[KitQuantity]
              FROM [dbo].[CommunicationMessagesKittingsSentItems]                CMRSI
               INNER JOIN CommunicationMessagesKittingsSent                      CMKS
               ON CMRSI.CMSOId = CMKS.ID
               INNER JOIN [dbo].[CommunicationMessagesKittingsConfirmation]      CMRC
                 ON CMKS.ID = CMRC.KitOrderID
               INNER JOIN [dbo].[CommunicationMessagesKittingsConfirmationItems] CMRCI
                 ON CMRC.ID = CMRCI.CMSOId AND CMRSI.KitId=CMRCI.KitID
               WHERE CMRC.ID = @Id 
                AND CMRSI.KitId = CMRCI.KitID

 
               ---- 4.
               UPDATE [dbo].[CommunicationMessagesKittingsSent] SET [MessageStatusId] = 7
               WHERE ID = @myKitOrderID  -- NE!!! toto se týká pouze oznámení o naskladnění; KDY se uzavře objednávka?

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
                -- 1
--SELECT 'a'
               UPDATE [dbo].[CardStockItems] 
               SET     [ItemOrKitUnConsilliation]       = ISNULL([ItemOrKitUnConsilliation],0)       - CMRCI.[KitQuantity]
                      ,[ItemOrKitReleasedForExpedition] = ISNULL([ItemOrKitReleasedForExpedition],0) + CMRCI.[KitQuantity]
               FROM   [dbo].[CardStockItems] CSI
               INNER JOIN [dbo].[CommunicationMessagesKittingsConfirmationItems]  CMRCI
                     ON CSI.ItemOrKitID = CMRCI.[KitID]
               INNER JOIN [dbo].[CommunicationMessagesKittingsConfirmation]    CMKC
               ON CMRCI.CMSOId = CMKC.ID
               WHERE CMRCI.[CMSOId] = @Id AND (CMKC.Reconciliation=0 OR CMKC.Reconciliation IS NULL)

               SET @myError = @myError + @@ERROR

--SELECT @myError as 'b',@Id AS '@Id',@ModifyUserId AS '@ModifyUserId'
              -- 2.
               UPDATE [dbo].[CommunicationMessagesKittingsConfirmation] SET [Reconciliation] = 1, [ModifyUserId] = @ModifyUserId WHERE [ID] = @Id
               SET @myError = @myError + @@ERROR
--SELECT @myError as 'b1'
               DECLARE @myDecision AS Integer
               
               SELECT  @myDecision =  COUNT(*) FROM
               ( SELECT SUM(ISNULL([KitQuantity],0) - ISNULL([KitQuantityDelivered],0)) SUMA, KitID
                 FROM [dbo].[CommunicationMessagesKittingsSentItems] WHERE IsActive=1 AND CMSOId=@myKitOrderID 
                 GROUP BY KitID ) aa
                 WHERE SUMA<>0
--SELECT @myDecision as 'c'

               IF @myDecision=0 OR @myDecision IS NULL
               BEGIN
               UPDATE [dbo].[CommunicationMessagesKittingsSent] SET [MessageStatusId] = 6
               WHERE ID = @myKitOrderID
               SET @myError = @myError + @@ERROR
               --SET @myError = @@ERROR  SELECT @myError '@myError3a'
--SELECT @myError as 'd'
               END
               ELSE
               BEGIN
               UPDATE [dbo].[CommunicationMessagesKittingsSent] SET [MessageStatusId] = 8
               WHERE ID = @myKitOrderID
               SET @myError = @myError + @@ERROR
               --SET @myError = @@ERROR  SELECT @myError '@myError3b'
--SELECT @myError as 'e'
               END

               -- 4  2014-12-03
               UPDATE [dbo].[CardStockItems] SET [ItemOrKitReserved]= ISNULL([ItemOrKitReserved],0) - aa.[QUANTITY]
               FROM [dbo].[CardStockItems]  CSI
               INNER JOIN (
               SELECT cI.ID, CMRCI.[KitID], CMRCI.[KitQuantity] * cKI.ItemOrKitQuantity QUANTITY,cK.[KitQualitiesId] 
               FROM [dbo].[CommunicationMessagesKittingsConfirmationItems]  CMRCI
               INNER JOIN [dbo].[cdlKits]      cK  ON CMRCI.[KitID]   = cK.[ID]
               INNER JOIN [dbo].[cdlKitsItems] cKI ON cK.[ID]         = cKI.cdlKitsId
               INNER JOIN [dbo].[cdlItems]     cI  ON cKI.ItemOrKitId = cI.ID
               WHERE CMRCI.[CMSOId] = @Id
               ) aa
               ON CSI.ItemOrKitId = aa.ID AND CSI.ItemOrKitQuality = aa.KitQualitiesId  AND CSI.[StockId]=2 AND CSI.IsActive=1 -- AND CSI.[ItemVerKit] = 1
               SET @myError = @myError + @@ERROR
                            
               IF @myError = 0 
               BEGIN
                  --SELECT @myError '@myError2 prCMAKconsentx',@myKitOrderID '@myKitOrderID'
                  EXEC [dbo].[prCMAKconsent] @myKitOrderID= @Id , @Error = @myError
                  --EXEC [dbo].[prCMAKconsent] @myKitOrderID= @myKitOrderID, @Error = @myError
                  --SELECT @myError '@myError2 prCMAKconsenty',@myKitOrderID '@myKitOrderID'
--SELECT @myError as 'f'
                  IF @myError = 0
                      if @@TRANCOUNT>0  COMMIT TRAN 
                  ELSE 
                   BEGIN
                        if @@TRANCOUNT>0  ROLLBACK TRAN
                        SET @ReturnMessage = ISNULL(ERROR_MESSAGE(),'') + ISNULL(CAST(ERROR_NUMBER() AS VARCHAR(50)),'')
                   END
               
               END
               ELSE 
               BEGIN
                    if @@TRANCOUNT>0  ROLLBACK TRAN
                    SET @ReturnValue = @myError
                    SET @ReturnMessage = ISNULL(ERROR_MESSAGE(),'') + ISNULL(CAST(ERROR_NUMBER() AS VARCHAR(50)),'')
--SELECT @myError as 'g'
               END
     END   -- schváleno

END TRY
BEGIN CATCH
      if @@TRANCOUNT>0  ROLLBACK TRAN
      SELECT @ReturnValue=1, @ReturnMessage='Chyba'
      SET @sub = 'FENIX - Kit Confirmation CHYBA' + ' Databáze: '+ISNULL(@myDatabaseName,'')
      SET @msg = 'Program prCMRCconsentK]; '  + ISNULL(ERROR_MESSAGE(),'') + ISNULL(CAST(ERROR_NUMBER() AS VARCHAR(50)),'') 
      EXEC @result = msdb.dbo.sp_send_dbmail
     		@profile_name = 'Automat', --@MailProfileName
     		@recipients = 'max.weczerek@upc.cz',
     		@subject = @sub,
     		@body = @msg,
     		@body_format = 'HTML'
END CATCH






GO
GRANT EXECUTE
    ON OBJECT::[dbo].[prCMRCconsentK] TO [FenixW]
    AS [dbo];

