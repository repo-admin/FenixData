
CREATE PROCEDURE [dbo].[prCMRCconsentVR3]
			@Decision											AS Int,						-- 3... zamítám, 1... schvaluji
			@Id														AS Int,						-- Id v tabulce [dbo].[CommunicationMessagesReturnedShipment]			     
			@DeleteMessageId							AS Int,						-- MessageID záznamu z tabulky [dbo].[CommunicationMessagesReturnedShipment]
			@DeleteMessageTypeId					AS Int,						-- z tabulky [dbo].[cdlMessageTypes]
			@DeleteMessageTypeDescription AS nvarchar(200),	-- z tabulky [dbo].[cdlMessageTypes]
			@ModifyUserId									AS Int = 0,
			@ReturnValue										 int = -1 OUTPUT,
			@ReturnMessage        nvarchar(2048) = null OUTPUT
AS

SET NOCOUNT ON;
    DECLARE @myDatabaseName  nvarchar(100)
BEGIN TRY
/*    
		2015-11-05  M.Rezler
*/
	BEGIN

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
	END

        BEGIN TRAN
              -- 1.
						  UPDATE [dbo].[CommunicationMessagesReturnedShipment] SET [Reconciliation] = @Decision, [ModifyUserId] = @ModifyUserId WHERE [ID] = @Id
							
							IF @Decision = 3
								BEGIN
									-- 2. start
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
									-- 2. konec
								END

              IF @@ERROR = 0 
                  COMMIT TRAN 
              ELSE              
              BEGIN
                  ROLLBACK TRAN
                  SET @ReturnMessage = ISNULL(ERROR_MESSAGE(),'') + ISNULL(CAST(ERROR_NUMBER() AS VARCHAR(50)),'')
            END

END TRY
BEGIN CATCH
      if @@TRANCOUNT>0  ROLLBACK TRAN
      SELECT @ReturnValue=1, @ReturnMessage='Chyba'
      SET @sub = 'FENIX - Returned Shipment CHYBA' + ' Databáze: '+ISNULL(@myDatabaseName,'')
      SET @msg = 'Program prCMRCconsentVR3; '  + ISNULL(ERROR_MESSAGE(),'') + ISNULL(CAST(ERROR_NUMBER() AS VARCHAR(50)),'') 
      EXEC @result = msdb.dbo.sp_send_dbmail
     		@profile_name = 'Automat', --@MailProfileName
     		@recipients = 'jaroslav.tajbl@upc.cz;michal.rezler@upc.cz',
     		@subject = @sub,
     		@body = @msg,
     		@body_format = 'HTML'
END CATCH


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[prCMRCconsentVR3] TO [FenixW]
    AS [dbo];

