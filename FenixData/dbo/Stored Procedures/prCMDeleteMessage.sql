CREATE PROCEDURE [dbo].[prCMDeleteMessage]
(
			@par1 as XML,
			@ReturnValue     int            = -1 OUTPUT,
			@ReturnMessage   nvarchar(2048) = null OUTPUT
)
AS
-- ===============================================================================================
-- Created by   : Rezler Michal
-- Created date : 2014-11-18
-- Description  : Zrušení message - hlavní procedura (z ní jsou volány další)
-- Returns      : 0 je-li zrušení úspěšné, jinak číslo chyby
--               -1 = nespecifikovaná chyba
-- Used by      : 
-- History				: 1.0.0	Rezler Michal
-- ===============================================================================================
SET NOCOUNT ON

DECLARE @myDatabaseName  nvarchar(100)
BEGIN TRY
	BEGIN
			SELECT @myDatabaseName = DB_NAME() 			
			DECLARE @hndl int, @ID int, @MessageID int, @MessageTypeID int, @MessageTypeDescription nvarchar(200),
              @SentDate date, @DeleteID int, @DeleteMessageID int, @DeleteMessageTypeID int, @DeleteMessageTypeDescription nvarchar(200),
							@msg varchar(max), @MailTo varchar(150), @MailBB varchar(150), @sub varchar(1000), @Result int, @myOK bit,
							@myAdresaLogistika  varchar(500),  @myAdresaProgramator  varchar(500), @myPocet int, @myDeleteMessageTypeId int, 
							@myMessage nvarchar (max), @myReturnValue int, @myReturnMessage nvarchar(2048),
							@myDeleteID int, @myDeleteMessageID int
       
			SET @myAdresaLogistika   = [dbo].[fnHomeAdresses] (4)
      SET @myAdresaProgramator = [dbo].[fnHomeAdresses] (2)

      SET @msg = ''
      SELECT @ReturnValue=0,  @ReturnMessage='OK', @myOK = 1
							
			EXEC sp_xml_preparedocument @hndl OUTPUT, @par1
      SELECT  @ID = x.[ID], @MessageID = x.[MessageID], @MessageTypeID = x.[MessageTypeID], @MessageTypeDescription = x.[MessageTypeDescription] 
             ,@SentDate = x.SentDate, @DeleteID = x.DeleteID, @DeleteMessageID = x.DeleteMessageID, @DeleteMessageTypeID = x.DeleteMessageTypeID 
						 ,@DeleteMessageTypeDescription = x.DeleteMessageTypeDescription
      FROM OPENXML (@hndl, '/NewDataSet/CommunicationMessagesDeleteMessageConfirmation',2)
      WITH (
							ID															int							'ID',
							MessageID												int							'MessageID',
							MessageTypeID										int							'MessageTypeID',
							MessageTypeDescription					nvarchar(200)		'MessageTypeDescription',
							SentDate												date						'SentDate',
							DeleteID												int							'DeleteID',
							DeleteMessageID									int							'DeleteMessageID', 
							DeleteMessageTypeID							int							'DeleteMessageTypeID',
							DeleteMessageTypeDescription		nvarchar(200)		'DeleteMessageTypeDescription'
					) x

			EXEC sp_xml_removedocument @hndl

			--SELECT 10
			--SELECT  @ID AS ID, @MessageID AS MessageID, @MessageTypeID AS MessageTypeID, @MessageTypeDescription AS MessageTypeDescription,
			--        @SentDate AS SentDate, @DeleteID AS DeleteID, @DeleteMessageID AS DeleteMessageID, 
			--					@DeleteMessageTypeID AS DeleteMessageTypeID, @DeleteMessageTypeDescription AS DeleteMessageTypeDescription

			--========================================================================================================================================================================================
			-- Kontrola vyplněnosti všech XML elementů
			--========================================================================================================================================================================================
			IF @ID = 0 OR @ID IS NULL OR @MessageID = 0 OR @MessageID IS NULL OR @MessageTypeID = 0 OR @MessageTypeID IS NULL
				 OR @MessageTypeDescription IS NULL OR @MessageTypeDescription = ''
			   OR CONVERT(VARCHAR(10),@SentDate,112) = '19000101' OR @SentDate IS NULL 
				 OR @DeleteID = 0 OR @DeleteID IS NULL OR @DeleteMessageID = 0 OR @DeleteMessageID IS NULL
				 OR @DeleteMessageTypeID = 0 OR @DeleteMessageTypeID IS NULL
				 OR @DeleteMessageTypeDescription IS NULL OR @DeleteMessageTypeDescription = ''
        BEGIN
					SET @myOK = 0
					SET @msg = 'Alespoň jeden XML element je nevyplněn'

					EXEC [dbo].[prAppLogWriteNew] @Type='ERROR', @Message =  @msg, @XmlMessage = '', @XmlDeclaration = '', @UserId = 0, @Source = 'prCMDeleteMessage'
                                       ,@ReturnValue = @myReturnValue, @ReturnMessage = @myReturnMessage

					SET @sub = 'FENIX - Kontrola DELETE MESSAGE CONFIRMATION  - kontrola vyplněnosti XML elementů' + ' Databáze: '+ ISNULL(@myDatabaseName,'')
					EXEC @result = msdb.dbo.sp_send_dbmail
							@profile_name = 'Automat', 
							@recipients = @myAdresaLogistika,
							@copy_recipients = @myAdresaProgramator,
							@subject = @sub,
							@body = @msg,
							@body_format = 'HTML'

					SET @ReturnValue = 1
					--SELECT 11			-- TODO zaremovat
        END

			--========================================================================================================================================================================================
			-- Kontrola existence záznamu pro ID a MessageID
			--========================================================================================================================================================================================
			IF @myOK = 1
				BEGIN
					SELECT @myPocet = COUNT(*) 
					FROM [dbo].[CommunicationMessagesDeleteMessage] WHERE [ID] = @DeleteID AND [MessageId] = @DeleteMessageID
					IF @myPocet = 1
						BEGIN
							SELECT @myDeleteMessageTypeId = [DeleteMessageTypeId], @myDeleteID = DeleteID, @myDeleteMessageID = DeleteMessageID 
							FROM [dbo].[CommunicationMessagesDeleteMessage] WHERE [ID] = @DeleteID AND [MessageId] = @DeleteMessageID
--SELECT @myDeleteMessageTypeId , @myDeleteID , @myDeleteMessageID -- TODO zaremovat
						END
					ELSE
						BEGIN 
							SET @myOK = 0
							SET @msg = 'Nebylo nalezeno ID/MessageID: ' + ISNULL(CAST(@DeleteID AS VARCHAR(50)),'')  + '/' + ISNULL(CAST(@DeleteMessageID AS VARCHAR(50)),'') 

							EXEC [dbo].[prAppLogWriteNew] @Type='ERROR', @Message =  @msg, @XmlMessage = '', @XmlDeclaration = '', @UserId = 0, @Source = 'prCMDeleteMessage'
																					 ,@ReturnValue = @myReturnValue, @ReturnMessage = @myReturnMessage

							SET @sub = 'FENIX - Kontrola DELETE MESSAGE CONFIRMATION  - nebylo nalezeno ID/MessageID' + ' Databáze: '+ ISNULL(@myDatabaseName,'')
							EXEC @result = msdb.dbo.sp_send_dbmail
									@profile_name = 'Automat', 
									@recipients = @myAdresaLogistika,
									@copy_recipients = @myAdresaProgramator,
									@subject = @sub,
									@body = @msg,
									@body_format = 'HTML'

							SET @ReturnValue = 1
							--SELECT 21		-- TODO zaremovat
						END
				END

			--========================================================================================================================================================================================
			-- Podle typu v nalezeném záznamu se zavolá příslušná SP
			--========================================================================================================================================================================================
			IF @myOK = 1
				BEGIN
					IF @myDeleteMessageTypeId = 1 -- Reception Order
						BEGIN														 
							EXEC [dbo].[prCMDeleteMessageR0] @ID, @MessageID, @MessageTypeID, @MessageTypeDescription, @SentDate, 
		                                           @DeleteID, @DeleteMessageID, @DeleteMessageTypeID, @DeleteMessageTypeDescription,
																							 @myDeleteID, @myDeleteMessageID, @ReturnValue, @ReturnMessage
						END	
					IF @myDeleteMessageTypeId = 2 -- Reception Confirmation
						BEGIN														 
							EXEC [dbo].[prCMDeleteMessageR1] @ID, @MessageID, @MessageTypeID, @MessageTypeDescription, @SentDate, 
		                                           @DeleteID, @DeleteMessageID, @DeleteMessageTypeID, @DeleteMessageTypeDescription,
																							 @myDeleteID, @myDeleteMessageID, @ReturnValue, @ReturnMessage
						END	
											
					IF @myDeleteMessageTypeId = 3 -- Kitting Order
						BEGIN														 
							EXEC [dbo].[prCMDeleteMessageK0] @ID, @MessageID, @MessageTypeID, @MessageTypeDescription, @SentDate, 
		                                           @DeleteID, @DeleteMessageID, @DeleteMessageTypeID, @DeleteMessageTypeDescription,
																							 @myDeleteID, @myDeleteMessageID, @ReturnValue, @ReturnMessage
						END
					
					IF @myDeleteMessageTypeId = 4	-- Kitting Confirmation 
						BEGIN														 
							EXEC [dbo].[prCMDeleteMessageK1] @ID, @MessageID, @MessageTypeID, @MessageTypeDescription, @SentDate, 
		                                           @DeleteID, @DeleteMessageID, @DeleteMessageTypeID, @DeleteMessageTypeDescription,
																							 @myDeleteID, @myDeleteMessageID, @ReturnValue, @ReturnMessage
						END
										
					IF @myDeleteMessageTypeId = 6 -- Shipment Order
						BEGIN														 
							EXEC [dbo].[prCMDeleteMessageS0] @ID, @MessageID, @MessageTypeID, @MessageTypeDescription, @SentDate, 
		                                           @DeleteID, @DeleteMessageID, @DeleteMessageTypeID, @DeleteMessageTypeDescription,
																							 @myDeleteID, @myDeleteMessageID, @ReturnValue, @ReturnMessage
						END
										
					IF @myDeleteMessageTypeId = 7 -- Shipment Confirmation
						BEGIN														 
							EXEC [dbo].[prCMDeleteMessageS1] @ID, @MessageID, @MessageTypeID, @MessageTypeDescription, @SentDate, 
		                                           @DeleteID, @DeleteMessageID, @DeleteMessageTypeID, @DeleteMessageTypeDescription,
																							 @myDeleteID, @myDeleteMessageID, @ReturnValue, @ReturnMessage
						END

					IF @myDeleteMessageTypeId = 9 -- Returned Equipment
						BEGIN														 
							EXEC [dbo].[prCMDeleteMessageVR1] @ID, @MessageID, @MessageTypeID, @MessageTypeDescription, @SentDate, 
		                                           @DeleteID, @DeleteMessageID, @DeleteMessageTypeID, @DeleteMessageTypeDescription,
																							 @myDeleteID, @myDeleteMessageID, @ReturnValue, @ReturnMessage
						END
											
					IF @myDeleteMessageTypeId = 10 -- Returned Item
						BEGIN														 
							EXEC [dbo].[prCMDeleteMessageVR2] @ID, @MessageID, @MessageTypeID, @MessageTypeDescription, @SentDate, 
		                                           @DeleteID, @DeleteMessageID, @DeleteMessageTypeID, @DeleteMessageTypeDescription,
																							 @myDeleteID, @myDeleteMessageID, @ReturnValue, @ReturnMessage
						END
					
					IF @myDeleteMessageTypeId = 11  -- Returned Shipment
						BEGIN														 
							EXEC [dbo].[prCMDeleteMessageVR3] @ID, @MessageID, @MessageTypeID, @MessageTypeDescription, @SentDate, 
		                                           @DeleteID, @DeleteMessageID, @DeleteMessageTypeID, @DeleteMessageTypeDescription,
																							 @myDeleteID, @myDeleteMessageID, @ReturnValue, @ReturnMessage
						END

					IF @myDeleteMessageTypeId = 12  -- Refurbished Order 
						BEGIN														 
							EXEC [dbo].[prCMDeleteMessageRF0] @ID, @MessageID, @MessageTypeID, @MessageTypeDescription, @SentDate, 
		                                           @DeleteID, @DeleteMessageID, @DeleteMessageTypeID, @DeleteMessageTypeDescription,
																							 @myDeleteID, @myDeleteMessageID, @ReturnValue, @ReturnMessage
						END
											
					IF @myDeleteMessageTypeId = 13  -- Refurbished Confirmation
						BEGIN														 
							EXEC [dbo].[prCMDeleteMessageRF1] @ID, @MessageID, @MessageTypeID, @MessageTypeDescription, @SentDate, 
		                                           @DeleteID, @DeleteMessageID, @DeleteMessageTypeID, @DeleteMessageTypeDescription,
																							 @myDeleteID, @myDeleteMessageID, @ReturnValue, @ReturnMessage
						END

				END
	END
END TRY
BEGIN CATCH
      IF @@TRANCOUNT>0 ROLLBACK TRAN

      SELECT @ReturnValue = 1, @ReturnMessage = 'Chyba'
      SET @sub = 'FENIX - Delete Message CHYBA' + ' Databáze: '+ ISNULL(@myDatabaseName,'')
      SET @msg = 'Program prCMDeleteMessage; '  + ISNULL(ERROR_MESSAGE(),'') + ISNULL(CAST(ERROR_NUMBER() AS VARCHAR(50)),'') 
      EXEC  @result = msdb.dbo.sp_send_dbmail
     				@profile_name = 'Automat', --@MailProfileName
     				--@recipients = 'max.weczerek@upc.cz;michal.rezler@upc.cz',		-- TODO odremovat
						@recipients = 'michal.rezler@upc.cz',													-- TODO zaremovat	
     				@subject = @sub,
     				@body = @msg,
     				@body_format = 'HTML'

			--SELECT 99			-- TODO zaremovat
END CATCH

		
GO
GRANT EXECUTE
    ON OBJECT::[dbo].[prCMDeleteMessage] TO [FenixW]
    AS [dbo];

