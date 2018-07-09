
CREATE PROCEDURE [dbo].[prCMRCconsentVR2]
			@Decision  AS Int, -- 3... zamítám, 1... schvaluji  2015-11-05 hodnota 2 se už nepoužívá
			@Id        AS Int, -- ID záznamu z tabulky [dbo].[CommunicationMessagesReturnedItem]

			@DeleteMessageId AS Int,													--2015-11-05 MessageId záznamu z tabulky [dbo].[CommunicationMessagesReturnedItem]
			@DeleteMessageTypeId AS Int,											--2015-11-05 z tabulky [dbo].[cdlMessageTypes]
			@DeleteMessageTypeDescription AS nvarchar(200),		--2015-11-05 z tabulky [dbo].[cdlMessageTypes]

			@ModifyUserId        AS Int = 0,
			@ReturnValue     int            = -1 OUTPUT,
			@ReturnMessage   nvarchar(2048) = null OUTPUT
AS

SET NOCOUNT ON;
    DECLARE @myDatabaseName  nvarchar(100)
BEGIN TRY
/*
2014-10-10, 2014-11-03 M.Weczerek
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

 

     IF @Decision = 3		--2  2015-11-05
     BEGIN -- zamítnuto 
         BEGIN TRAN
               -- 1.
               UPDATE [dbo].[CommunicationMessagesReturnedItem] SET [Reconciliation]  = @Decision, [ModifyUserId] = @ModifyUserId WHERE [ID] = @Id

							 --novinka 2015-11-05 start
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
							 --novinka 2015-11-05 konec

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
         INSERT INTO [dbo].[CardStockItems]
                    ([ItemVerKit]
                    ,[ItemOrKitId]
                    ,[ItemOrKitUnitOfMeasureId]
                    ,[ItemOrKitQuality]
                    ,[ItemOrKitFree]
                    ,[ItemOrKitUnConsilliation]
                    ,[ItemOrKitReserved]
                    ,[ItemOrKitReleasedForExpedition]
                    ,[ItemOrKitExpedited]
                    ,[StockId]
                    ,[IsActive]
                    ,[ModifyDate]
                    ,[ModifyUserId])
         SELECT 0,ItemId,ItemUnitOfMeasureId,ItemOrKitQualityId,0,0,0,0,0,2,1,Getdate(),0
         FROM [dbo].[CommunicationMessagesReturnedItemItems]    RII
         WHERE CAST(RII.ItemOrKitQualityId AS CHAR(20)) + CAST(RII.ItemUnitOfMeasureId AS CHAR(20)) +  CAST(RII.ItemId AS CHAR(50))  
         NOT IN (SELECT CAST(ItemOrKitQuality AS CHAR(20)) + CAST([ItemOrKitUnitOfMeasureId] AS CHAR(20)) +  CAST(ItemOrKitId AS CHAR(50)) FROM CardStockItems WHERE StockId=2 AND ItemVerKit=0)  
         AND RII.[CMSOId] = @Id  
         SET @myError = @myError + @@ERROR


         UPDATE [dbo].[CardStockItems] SET ItemOrKitFree = ISNULL([ItemOrKitFree],0) + ISNULL(RII.ItemQuantity,0)
         FROM [dbo].[CardStockItems]  cSI
         INNER JOIN [dbo].[CommunicationMessagesReturnedItemItems] RII
           ON     cSI.ItemOrKitQuality         = RII.ItemOrKitQualityId 
              AND cSI.ItemOrKitUnitOfMeasureId = RII.ItemUnitOfMeasureId 
              AND cSI.ItemOrKitId              = RII.ItemId
         INNER JOIN [dbo].[CommunicationMessagesReturnedItem] RI
           ON RII.[CMSOId] = RI.ID
         WHERE cSI.StockId=2 AND cSI.ItemVerKit=0 AND RII.[CMSOId] = @Id AND RI.Reconciliation = 0
         SET @myError = @myError + @@ERROR

          UPDATE [dbo].CommunicationMessagesReturnedItem SET [Reconciliation] = 1, [ModifyUserId] = @ModifyUserId WHERE [ID] = @Id
          SET @myError = @myError + @@ERROR

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
      SET @sub = 'FENIX - VR2 CHYBA' + ' Databáze: '+ISNULL(@myDatabaseName,'')
      SET @msg = 'Program prCMRCconsentVR2; '  + ISNULL(ERROR_MESSAGE(),'') + ISNULL(CAST(ERROR_NUMBER() AS VARCHAR(50)),'') 
      EXEC @result = msdb.dbo.sp_send_dbmail
     		@profile_name = 'Automat', --@MailProfileName
     		@recipients = 'max.weczerek@upc.cz;michal.rezler@upc.cz',
     		@subject = @sub,
     		@body = @msg,
     		@body_format = 'HTML'
END CATCH








GO
GRANT EXECUTE
    ON OBJECT::[dbo].[prCMRCconsentVR2] TO [FenixW]
    AS [dbo];

