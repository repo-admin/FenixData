
CREATE PROCEDURE [dbo].[prCMRCconsent]
			@Decision  AS Int, -- 3... zamítám, 1... schvaluji  2015-11-03 hodnota 2 se už nepoužívá
			@Id        AS Int, -- ID záznamu z tabulky [dbo].[CommunicationMessagesReceptionConfirmation]

			@DeleteMessageId AS Int,													--2015-11-03 MessageID záznamu z tabulky [dbo].[CommunicationMessagesReceptionConfirmation]
			@DeleteMessageTypeId AS Int,											--2015-11-03 z tabulky [dbo].[cdlMessageTypes]
			@DeleteMessageTypeDescription AS nvarchar(200),		--2015-11-03 z tabulky [dbo].[cdlMessageTypes]

			@ModifyUserId        AS Int = 0,
			@ReturnValue     int            = -1 OUTPUT,
			@ReturnMessage   nvarchar(2048) = null OUTPUT
AS

/*
2014-11-03, 2014-11-19,2014-12-01  M.Weczerek
2015-11-03  M.Rezler  Decision: přidána hodnota 3  (D0 odeslána),  hodnota 2 se nepoužívá 
*/
DECLARE @myDatabaseName  nvarchar(100)

SET NOCOUNT ON;
BEGIN TRY
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

       DECLARE @myCMSOid  AS Integer
       SELECT  @myCMSOid = [CommunicationMessagesSentId] FROM [dbo].[vwReceptionConfirmationHd] WHERE id = @Id


     IF @Decision = 3		--2  2015-11-03
     BEGIN -- zamítnuto 
         BEGIN TRAN
               -- 1.
               --UPDATE [dbo].[CommunicationMessagesReceptionConfirmation] SET [Reconciliation] = 2, [ModifyUserId] = @ModifyUserId WHERE [ID] = @Id --2015-11-03
							 UPDATE [dbo].[CommunicationMessagesReceptionConfirmation] SET [Reconciliation] = @Decision, [ModifyUserId] = @ModifyUserId WHERE [ID] = @Id
               -- 2.
               UPDATE [dbo].[CardStockItems] SET [ItemOrKitUnConsilliation] = ISNULL([ItemOrKitUnConsilliation],0) - CMRCI.[ItemQuantity]
               FROM   [dbo].[CardStockItems] CSI
               INNER JOIN [dbo].[CommunicationMessagesReceptionConfirmationItems]  CMRCI
                     ON CSI.ItemOrKitID = CMRCI.[ItemID] 
               WHERE CMRCI.[CMSOId] = @Id
               -- 3.
               UPDATE [dbo].[CommunicationMessagesReceptionSentItems] SET [ItemQuantityDelivered]= ISNULL([ItemQuantityDelivered],0)-  CMRCI.[ItemQuantity]
               FROM [dbo].[CommunicationMessagesReceptionSentItems]               CMRSI
               INNER JOIN [dbo].[CommunicationMessagesReceptionConfirmationItems] CMRCI
                 ON CMRCI.[ItemID] = CMRSI.[ItemId]
               INNER JOIN [dbo].[vwReceptionConfirmationHd]                       Hd
                 ON CMRCI.[CMSOId] = Hd.Id
               WHERE CMRCI.[CMSOId] = @Id
               ---- 4.
               UPDATE [dbo].[CommunicationMessagesReceptionSent] SET [MessageStatusId] = 7
               WHERE ID = @myCMSOid  -- NE!!! toto se týká pouze oznámení o naskladnění; KDY se uzavře objednávka?

							 --novinka 2015-11-03 start
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
							 --novinka 2015-11-03 konec

               IF @@ERROR = 0 COMMIT TRAN ELSE ROLLBACK TRAN
     END   -- zamítnuto
     
     IF @Decision = 1
     BEGIN -- schváleno
         BEGIN TRAN
               -- 1.
               UPDATE [dbo].[CommunicationMessagesReceptionConfirmation] SET [Reconciliation] = 1, [ModifyUserId] = @ModifyUserId WHERE [ID] = @Id
               -- 2.
               UPDATE [dbo].[CardStockItems] SET [ItemOrKitUnConsilliation] = ISNULL([ItemOrKitUnConsilliation],0) - CMRCI.[ItemQuantity]
                      ,[ItemOrKitFree] = ISNULL([ItemOrKitFree],0) + CMRCI.[ItemQuantity]
               FROM   [dbo].[CardStockItems] CSI
               INNER JOIN [dbo].[CommunicationMessagesReceptionConfirmationItems]  CMRCI
                     ON CSI.ItemOrKitID = CMRCI.[ItemID] AND CSI.ItemOrKitQuality = CMRCI.ItemQualityId -- AND CSI.ItemOrKitUnitOfMeasureId=CMRCI.ItemUnitOfMeasure
               WHERE CMRCI.[CMSOId] = @Id
               -- 3

               DECLARE @myDecision AS Integer
               
               SELECT  @myDecision =  COUNT(*) FROM
               ( SELECT SUM(ISNULL([ItemQuantity],0) - ISNULL([ItemQuantityDelivered],0)) SUMA, ItemId
                 FROM [dbo].[CommunicationMessagesReceptionSentItems] WHERE IsActive=1 AND CMSOId=@myCMSOid 
                 GROUP BY ItemId ) aa
                 WHERE SUMA<>0

               IF @myDecision=0 OR @myDecision IS NULL
               UPDATE [dbo].[CommunicationMessagesReceptionSent] SET [MessageStatusId] = 6
               WHERE ID = @myCMSOid
               ELSE
               UPDATE [dbo].[CommunicationMessagesReceptionSent] SET [MessageStatusId] = 8
               WHERE ID = @myCMSOid
                            
              IF @@ERROR = 0 COMMIT TRAN ELSE ROLLBACK TRAN
     END   -- schváleno

END TRY
BEGIN CATCH
      IF @@TRANCOUNT>0 ROLLBACK TRAN
      SELECT @ReturnValue=1, @ReturnMessage='Chyba'
      SET @sub = 'FENIX - Reception Confirmation CHYBA' + ' Databáze: '+ISNULL(@myDatabaseName,'')
      SET @msg = 'Program prCMRCins; '  + ISNULL(ERROR_MESSAGE(),'') + ISNULL(CAST(ERROR_NUMBER() AS VARCHAR(50)),'') 
      EXEC @result = msdb.dbo.sp_send_dbmail
     		@profile_name = 'Automat', --@MailProfileName
     		@recipients = 'jaroslav.tajbl@upc.cz;michal.rezler@upc.cz',
     		@subject = @sub,
     		@body = @msg,
     		@body_format = 'HTML'
END CATCH






GO
GRANT EXECUTE
    ON OBJECT::[dbo].[prCMRCconsent] TO [FenixW]
    AS [dbo];

