﻿CREATE PROCEDURE [dbo].[prCMDeleteMessageRF0]                       
(
		@ID int, 
		@MessageID int, 
		@MessageTypeID int, 
		@MessageTypeDescription nvarchar(200),
		@SentDate date, 
		@DeleteID int, 
		@DeleteMessageID int, 
		@DeleteMessageTypeID int, 
		@DeleteMessageTypeDescription nvarchar(200),
		@RF0DeleteID int, 
		@RF0DeleteMessageID int,
		@ReturnValue int = -1 OUTPUT,
		@ReturnMessage nvarchar(2048) = NULL OUTPUT
)
AS
-- ===============================================================================================
-- Created by   : Rezler Michal
-- Created date : 2014-11-10
-- Description  : Zrušení message Refurbished Order (RF0)
-- Returns      : 0 je-li zrušení úspěšné, jinak číslo chyby
--               -1 = nespecifikovaná chyba
-- Used by      : 
-- History				: 1.0.0	Rezler Michal
-- ===============================================================================================
SET NOCOUNT ON
--
SET @ReturnValue = -1
SET @ReturnMessage = 'Chyba'

DECLARE @myDatabaseName  nvarchar(100)
BEGIN TRY
	
	SELECT @myDatabaseName = DB_NAME() 				          
	DECLARE @msg varchar(max), @MailTo varchar(150), @MailBB varchar(150), @sub varchar(1000), @Result int, @myOK bit,
					@myAdresaLogistika  varchar(500),  @myAdresaProgramator  varchar(500), @myPocet int, @myDeleteMessageTypeId int, 
					@myError int, @myMessage nvarchar (max), @myReturnValue int, @myReturnMessage nvarchar(2048)

	BEGIN TRAN
		SET @myError = 0

		SET @myAdresaLogistika   = [dbo].[fnHomeAdresses] (4)
    SET @myAdresaProgramator = [dbo].[fnHomeAdresses] (2)

		-- 1.
		INSERT INTO [dbo].[CommunicationMessagesDeleteMessageConfirmation]
							 ([StockID]
							 ,[MessageId]
							 ,[MessageTypeId]
							 ,[MessageTypeDescription]
							 ,[DeleteId]
							 ,[DeleteMessageId]
							 ,[DeleteMessageTypeId]
							 ,[DeleteMessageTypeDescription]
							 ,[DeleteMessageDate]
							 ,[Notice]
							 ,[SentDate]
							 ,[IsActive]
							 ,[ModifyDate]
							 ,[ModifyUserId])
				 VALUES
							 (@ID
							 ,@MessageID
							 ,@MessageTypeID
							 ,@MessageTypeDescription
							 ,@DeleteID
							 ,@DeleteMessageID
							 ,@DeleteMessageTypeID
							 ,@DeleteMessageTypeDescription
							 ,getdate()
							 ,''
							 ,@SentDate
							 ,1
							 ,getdate()
							 ,0)
		SET @myError = @myError + @@ERROR

		-- 2.
		UPDATE [dbo].[CommunicationMessagesDeleteMessage] SET [MessageStatusId] = 13 WHERE [Id] = @DeleteID AND [MessageId] = @DeleteMessageID
		SET @myError = @myError + @@ERROR

		-- 3.
		UPDATE [dbo].[CommunicationMessagesRefurbishedOrder] SET [IsActive] = 0 WHERE [ID] = @RF0DeleteID AND [MessageId] = @RF0DeleteMessageID
		SET @myError = @myError + @@ERROR

		-- 4.
		UPDATE [dbo].[CommunicationMessagesRefurbishedOrderItems] SET [IsActive] = 0 WHERE [CMSOId] = @RF0DeleteID
		SET @myError = @myError + @@ERROR

    IF @myError = 0 
			BEGIN 
					COMMIT TRAN
					SET @sub = 'FENIX - DELETE MESSAGE RF0 - Oznámení' + ' Databáze: ' + ISNULL(@myDatabaseName,'')
					SET @msg = 'Byla zrušena následující message ID: '  + ISNULL(CAST(@DeleteID AS VARCHAR(50)),'')
					EXEC	@result = msdb.dbo.sp_send_dbmail
								@profile_name = 'Automat', 
								@recipients = @myAdresaLogistika,
								@copy_recipients = @myAdresaProgramator,
								@subject = @sub,
								@body = @msg,
								@body_format = 'HTML'
					SET @ReturnMessage = 'OK'
					SET @ReturnValue = 0
			END   
		ELSE
			BEGIN 
					IF @@TRANCOUNT > 0 ROLLBACK TRAN
					SET @sub = 'FENIX - DELETE MESSAGE RF0 - PROBLÉM !!!' + ' Databáze: ' + ISNULL(@myDatabaseName,'')
					SET @msg = 'Nebyla zpracována následující message ID: '  + ISNULL(CAST(@DeleteID AS VARCHAR(50)),'') + '<br />' + 'errror no: ' + @myError
					EXEC	@result = msdb.dbo.sp_send_dbmail
								@profile_name = 'Automat', 
								@recipients = @myAdresaLogistika,
								@copy_recipients = @myAdresaProgramator,
								@subject = @sub,
								@body = @msg,
								@body_format = 'HTML'
					SET @ReturnMessage = 'Chyba'
					SET @ReturnValue = @myError
			END 

END TRY
BEGIN CATCH
      IF @@TRANCOUNT > 0 ROLLBACK TRAN

      SELECT @ReturnValue = 1, @ReturnMessage = 'Chyba'
      SET @sub = 'FENIX - Delete Message CHYBA' + ' Databáze: '+ ISNULL(@myDatabaseName,'')
      SET @msg = 'Program prCMDeleteMessageRF0; '  + ISNULL(ERROR_MESSAGE(),'') + ISNULL(CAST(ERROR_NUMBER() AS VARCHAR(50)),'') 
      EXEC  @result = msdb.dbo.sp_send_dbmail
     				@profile_name = 'Automat', --@MailProfileName
     				--@recipients = 'max.weczerek@upc.cz;michal.rezler@upc.cz',		-- TODO odremovat
						@recipients = 'michal.rezler@upc.cz',													-- TODO zaremovat	
     				@subject = @sub,
     				@body = @msg,
     				@body_format = 'HTML'

			--SELECT 1299			-- TODO zaremovat
END CATCH
GO
GRANT EXECUTE
    ON OBJECT::[dbo].[prCMDeleteMessageRF0] TO [FenixW]
    AS [dbo];

