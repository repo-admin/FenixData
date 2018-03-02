CREATE PROCEDURE [dbo].[prCMDeleteMessageK0]
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
		@K0DeleteID int, 
		@K0DeleteMessageID int,
		@ReturnValue int = -1 OUTPUT,
		@ReturnMessage nvarchar(2048) = NULL OUTPUT
)
AS
-- ===============================================================================================
-- Created by   : Rezler Michal
-- Created date : 2014-11-12
-- Description  : Zrušení message Kitting Order (K0)
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

		--================================================================================================================================================
		-- 1. a)zmeny na skladovych kartach
		--    b)zapis do internich dokladu
		DECLARE @kiKitId int, @kiKitQuantity decimal, @kiCardStockItemsId int, @kiKitQualityId int, @kiMeasuresID int,
		        @ItemOrKitId int, @ItemVerKit bit, @mySuma decimal, @ItemOrKitQuantity decimal,
						
						@csBeforeID int, @csBeforeItemVerKit bit, @csBeforeItemOrKitID int, @csBeforeItemOrKitUnitOfMeasureId int,
						@csBeforeItemOrKitQuantity decimal, @csBeforeItemOrKitQuality int, @csBeforeItemOrKitFree decimal,
						@csBeforeItemOrKitUnConsilliation decimal, @csBeforeItemOrKitReserved decimal, @csBeforeItemOrKitReleasedForExpedition decimal,
						@csBeforeItemOrKitExpedited decimal, @csBeforeStockId int, @csBeforeIsActive bit, @csBeforeModifyDate datetime,
						@csBeforeModifyUserId int, 
						@csAfterID int, @csAfterItemVerKit bit, @csAfterItemOrKitID int, @csAfterItemOrKitUnitOfMeasureId int,
						@csAfterItemOrKitQuantity decimal, @csAfterItemOrKitQuality int, @csAfterItemOrKitFree decimal,
						@csAfterItemOrKitUnConsilliation decimal, @csAfterItemOrKitReserved decimal,
						@csAfterItemOrKitReleasedForExpedition decimal, @csAfterItemOrKitExpedited decimal, @csAfterStockId int,
						@csAfterIsActive bit, @csAfterModifyDate datetime, @csAfterModifyUserId int
						
		SELECT @kiKitId = KitId, @kiKitQuantity = SI.KitQuantity, @kiCardStockItemsId = SI.CardStockItemsId, @kiKitQualityId = SI.KitQualityId,
		       @kiMeasuresID = SI.MeasuresID
		FROM  [dbo].[CommunicationMessagesKittingsSentItems] SI
		WHERE SI.CMSOId = @K0DeleteID

		IF (SELECT CURSOR_STATUS('global','ItemsCursor')) >= -1
			BEGIN
						DEALLOCATE ItemsCursor
			END
			
		DECLARE ItemsCursor CURSOR FOR 
		(      
				SELECT ItemOrKitId, ItemVerKit, ItemOrKitQuantity
				FROM dbo.cdlKitsItems cKI
				WHERE cKI.IsActive = 1 AND cdlKitsId = @kiKitId
		)
		FOR READ ONLY

		OPEN ItemsCursor

			FETCH NEXT FROM ItemsCursor INTO @ItemOrKitId, @ItemVerKit, @ItemOrKitQuantity
			WHILE @@FETCH_STATUS = 0
			BEGIN

				SET @mySuma = @kiKitQuantity * @ItemOrKitQuantity;

				-- stav skladove karty pred zmenami
				SELECT @csBeforeID = CS.ID, @csBeforeItemVerKit = CS.ItemVerKit, @csBeforeItemOrKitID = CS.ItemOrKitID, 
							 @csBeforeItemOrKitUnitOfMeasureId = CS.ItemOrKitUnitOfMeasureId, @csBeforeItemOrKitQuantity = CS.ItemOrKitQuantity,
							 @csBeforeItemOrKitQuality = CS.ItemOrKitQuality, @csBeforeItemOrKitFree = CS.ItemOrKitFree,
							 @csBeforeItemOrKitUnConsilliation = CS.ItemOrKitUnConsilliation, @csBeforeItemOrKitReserved = CS.ItemOrKitReserved,
						   @csBeforeItemOrKitReleasedForExpedition = CS.ItemOrKitReleasedForExpedition,
						   @csBeforeItemOrKitExpedited = CS.ItemOrKitExpedited, @csBeforeStockId = CS.StockId,
						   @csBeforeIsActive = CS.IsActive, @csBeforeModifyDate = CS.ModifyDate, @csBeforeModifyUserId = CS.ModifyUserId
				FROM [dbo].[CardStockItems] CS
				WHERE CS.StockId = @kiCardStockItemsId AND CS.ItemOrKitID = @ItemOrKitId
				      AND CS.ItemOrKitUnitOfMeasureId = @kiMeasuresID
							AND CS.ItemVerKit = @ItemVerKit AND CS.ItemOrKitQuality = @kiKitQualityId

				-- zmeny na skladove karte
				UPDATE [dbo].[CardStockItems] SET ItemOrKitFree = ItemOrKitFree + @mySuma, ItemOrKitReserved = ItemOrKitReserved - @mySuma
				WHERE StockId = @kiCardStockItemsId AND ItemOrKitID = @ItemOrKitId
							AND ItemOrKitUnitOfMeasureId = @kiMeasuresID
							AND ItemVerKit = @ItemVerKit AND ItemOrKitQuality = @kiKitQualityId

				-- stav skladove karty po zmenach
				SELECT @csAfterID = CS.ID, @csAfterItemVerKit = CS.ItemVerKit, @csAfterItemOrKitID = CS.ItemOrKitID, 
							 @csAfterItemOrKitUnitOfMeasureId = CS.ItemOrKitUnitOfMeasureId, @csAfterItemOrKitQuantity = CS.ItemOrKitQuantity,
							 @csAfterItemOrKitQuality = CS.ItemOrKitQuality, @csAfterItemOrKitFree = CS.ItemOrKitFree,
							 @csAfterItemOrKitUnConsilliation = CS.ItemOrKitUnConsilliation, @csAfterItemOrKitReserved = CS.ItemOrKitReserved,
						   @csAfterItemOrKitReleasedForExpedition = CS.ItemOrKitReleasedForExpedition,
						   @csAfterItemOrKitExpedited = CS.ItemOrKitExpedited, @csAfterStockId = CS.StockId,
						   @csAfterIsActive = CS.IsActive, @csAfterModifyDate = CS.ModifyDate, @csAfterModifyUserId = CS.ModifyUserId
				FROM [dbo].[CardStockItems] CS
				WHERE CS.StockId = @kiCardStockItemsId AND CS.ItemOrKitID = @ItemOrKitId
				      AND CS.ItemOrKitUnitOfMeasureId = @kiMeasuresID
							AND CS.ItemVerKit = @ItemVerKit AND CS.ItemOrKitQuality = @kiKitQualityId

				-- zapis do interniho dokladu
				INSERT INTO [dbo].[InternalDocuments]
									 ([ItemVerKit], [ItemOrKitID], [ItemOrKitUnitOfMeasureId], [ItemOrKitQualityId]
									 ,[ItemOrKitFreeBefore], [ItemOrKitFreeAfter], [ItemOrKitUnConsilliationBefore]
									 ,[ItemOrKitUnConsilliationAfter], [ItemOrKitReservedBefore], [ItemOrKitReservedAfter]
									 ,[ItemOrKitReleasedForExpeditionBefore], [ItemOrKitReleasedForExpeditionAfter]
									 ,[ItemOrKitExpeditedBefore], [ItemOrKitExpeditedAfter]
									 ,[StockId], [InternalDocumentsSourceId]
									 ,[IsActive], [ModifyDate], [ModifyUserId])
						 VALUES
									 (@csBeforeItemVerKit, @csBeforeItemOrKitID, @csBeforeItemOrKitUnitOfMeasureId, @csBeforeItemOrKitQuality
									 ,@csBeforeItemOrKitFree, @csAfterItemOrKitFree, @csBeforeItemOrKitUnConsilliation
									 ,@csAfterItemOrKitUnConsilliation, @csBeforeItemOrKitReserved, @csAfterItemOrKitReserved
									 ,@csBeforeItemOrKitReleasedForExpedition, @csAfterItemOrKitReleasedForExpedition
									 ,@csBeforeItemOrKitExpedited, @csAfterItemOrKitExpedited
									 ,@csBeforeStockId, 5
									 ,@csBeforeIsActive, getdate(), 0)
					 							
				FETCH NEXT FROM ItemsCursor INTO @ItemOrKitId, @ItemVerKit, @ItemOrKitQuantity
			END
		CLOSE ItemsCursor
		DEALLOCATE ItemsCursor
		--================================================================================================================================================

		-- 2.
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

		-- 3.
		UPDATE [dbo].[CommunicationMessagesDeleteMessage] SET [MessageStatusId] = 13 WHERE [Id] = @DeleteID AND [MessageId] = @DeleteMessageID
		SET @myError = @myError + @@ERROR

		-- 4.
		UPDATE [dbo].[CommunicationMessagesKittingsSent] SET [IsActive] = 0 WHERE [ID] = @K0DeleteID AND [MessageId] = @K0DeleteMessageID
		SET @myError = @myError + @@ERROR

		-- 5.
		UPDATE [dbo].[CommunicationMessagesKittingsSentItems] SET [IsActive] = 0 WHERE [CMSOId] = @K0DeleteID
		SET @myError = @myError + @@ERROR

    IF @myError = 0 
			BEGIN 
					COMMIT TRAN
					SET @sub = 'FENIX - DELETE MESSAGE K0 - Oznámení' + ' Databáze: ' + ISNULL(@myDatabaseName,'')
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
					SET @sub = 'FENIX - DELETE MESSAGE K0 - PROBLÉM !!!' + ' Databáze: ' + ISNULL(@myDatabaseName,'')
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
      SET @msg = 'Program prCMDeleteMessageK0; '  + ISNULL(ERROR_MESSAGE(),'') + ISNULL(CAST(ERROR_NUMBER() AS VARCHAR(50)),'') 
      EXEC  @result = msdb.dbo.sp_send_dbmail
     				@profile_name = 'Automat', --@MailProfileName
     				--@recipients = 'max.weczerek@upc.cz;michal.rezler@upc.cz',		-- TODO odremovat
						@recipients = 'michal.rezler@upc.cz',													-- TODO zaremovat	
     				@subject = @sub,
     				@body = @msg,
     				@body_format = 'HTML'

			--SELECT 399			-- TODO zaremovat
END CATCH
GO
GRANT EXECUTE
    ON OBJECT::[dbo].[prCMDeleteMessageK0] TO [FenixW]
    AS [dbo];

