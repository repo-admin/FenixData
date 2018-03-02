CREATE PROCEDURE [dbo].[prCMDeleteMessageS0]
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
		@S0DeleteID int, 
		@S0DeleteMessageID int,
		@ReturnValue int = -1 OUTPUT,
		@ReturnMessage nvarchar(2048) = NULL OUTPUT
)
AS
-- ===============================================================================================
-- Created by   : Rezler Michal
-- Created date : 2014-11-12
-- Description  : Zrušení message Shipment Order (S0)
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
		--				item : Free = Free + itemQuantity 
		--				kit  : ReleasedForExpedition = ReleasedForExpedition + itemQuantity
		--				Reserved = Reserved - itemQuantity
		--    b)zapis do internich dokladu
		DECLARE @kiKitId int, @kiKitQuantity decimal, @kiCardStockItemsId int, @kiKitQualityId int, @kiMeasuresID int,
		        
						@ItemOrKitId int, @ItemVerKit bit, @ItemOrKitQualityId int, @ItemOrKitUnitOfMeasureId int, @ItemOrKitQuantity decimal,
						
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

		IF (SELECT CURSOR_STATUS('global','ShipmentOrderItemsCursor')) >= -1
			BEGIN
						DEALLOCATE ShipmentOrderItemsCursor
			END
									
		DECLARE ShipmentOrderItemsCursor CURSOR FOR 
		(      
				SELECT ItemOrKitId, ItemVerKit, ItemOrKitQualityId, ItemOrKitUnitOfMeasureId, ItemOrKitQuantity
				FROM dbo.CommunicationMessagesShipmentOrdersSentItems cKI
				WHERE cKI.IsActive = 1 AND cKI.CMSOId = @S0DeleteID
		)
		FOR READ ONLY

		OPEN ShipmentOrderItemsCursor

			FETCH NEXT FROM ShipmentOrderItemsCursor INTO @ItemOrKitId, @ItemVerKit, @ItemOrKitQualityId, @ItemOrKitUnitOfMeasureId, @ItemOrKitQuantity 
			WHILE @@FETCH_STATUS = 0
			BEGIN
							
					IF (SELECT CURSOR_STATUS('global','cardStockItemsCursor')) >= -1
						BEGIN
									DEALLOCATE cardStockItemsCursor
						END

					DECLARE cardStockItemsCursor CURSOR FOR 
					(      
							SELECT	c.ID, c.ItemVerKit, c.ItemOrKitID, c.ItemOrKitUnitOfMeasureId,
											c.ItemOrKitQuantity, c.ItemOrKitQuality, c.ItemOrKitFree,
											c.ItemOrKitUnConsilliation, c.ItemOrKitReserved, c.ItemOrKitReleasedForExpedition,
											c.ItemOrKitExpedited, c.StockId, c.IsActive, c.ModifyDate, 
											c.ModifyUserId 
							FROM dbo.CardStockItems c
							WHERE c.IsActive = 1 AND c.ItemOrKitID = @ItemOrKitID
										AND c.ItemOrKitQuality = @ItemOrKitQualityId AND c.ItemVerKit = @ItemVerKit
										AND c.ItemOrKitUnitOfMeasureId = @ItemOrKitUnitOfMeasureId					
					)
					FOR READ ONLY

					OPEN cardStockItemsCursor

					FETCH NEXT FROM cardStockItemsCursor INTO @csBeforeID, @csBeforeItemVerKit, @csBeforeItemOrKitID, @csBeforeItemOrKitUnitOfMeasureId,
													@csBeforeItemOrKitQuantity, @csBeforeItemOrKitQuality, @csBeforeItemOrKitFree,
													@csBeforeItemOrKitUnConsilliation, @csBeforeItemOrKitReserved, @csBeforeItemOrKitReleasedForExpedition,
													@csBeforeItemOrKitExpedited, @csBeforeStockId, @csBeforeIsActive, @csBeforeModifyDate,
													@csBeforeModifyUserId
					WHILE @@FETCH_STATUS = 0
					BEGIN

							-- zmena na skladove karte (rozlisuje se item, resp. kit)							
							DECLARE @myItemOrKitFree decimal, @myItemOrKitReleasedForExpedition decimal, @myItemOrKitReserved decimal 
							IF @ItemVerKit = 0
								BEGIN									
									SET @myItemOrKitFree = ISNULL(@csBeforeItemOrKitFree, 0) + @ItemOrKitQuantity
									SET @myItemOrKitReserved = ISNULL(@csBeforeItemOrKitReserved, 0) - @ItemOrKitQuantity
									
									UPDATE [dbo].[CardStockItems] SET ItemOrKitFree = @myItemOrKitFree, ItemOrKitReserved = @myItemOrKitReserved
									WHERE IsActive = 1 AND ItemOrKitID = @ItemOrKitID
												AND ItemOrKitQuality = @ItemOrKitQualityId AND ItemVerKit = @ItemVerKit
												AND ItemOrKitUnitOfMeasureId = @ItemOrKitUnitOfMeasureId
								END
							ELSE
								BEGIN
									SET @myItemOrKitReleasedForExpedition = ISNULL(@csBeforeItemOrKitReleasedForExpedition, 0) + @ItemOrKitQuantity
									SET @myItemOrKitReserved = ISNULL(@csBeforeItemOrKitReserved, 0) - @ItemOrKitQuantity

									UPDATE [dbo].[CardStockItems] SET ItemOrKitReleasedForExpedition = @myItemOrKitReleasedForExpedition, ItemOrKitReserved = @myItemOrKitReserved
									WHERE IsActive = 1 AND ItemOrKitID = @ItemOrKitID
												AND ItemOrKitQuality = @ItemOrKitQualityId AND ItemVerKit = @ItemVerKit
												AND ItemOrKitUnitOfMeasureId = @ItemOrKitUnitOfMeasureId
								END

							-- stav skladove karty po zmene
							SELECT @csAfterID = CS.ID, @csAfterItemVerKit = CS.ItemVerKit, @csAfterItemOrKitID = CS.ItemOrKitID, 
										 @csAfterItemOrKitUnitOfMeasureId = CS.ItemOrKitUnitOfMeasureId, @csAfterItemOrKitQuantity = CS.ItemOrKitQuantity,
										 @csAfterItemOrKitQuality = CS.ItemOrKitQuality, @csAfterItemOrKitFree = CS.ItemOrKitFree,
										 @csAfterItemOrKitUnConsilliation = CS.ItemOrKitUnConsilliation, @csAfterItemOrKitReserved = CS.ItemOrKitReserved,
										 @csAfterItemOrKitReleasedForExpedition = CS.ItemOrKitReleasedForExpedition,
										 @csAfterItemOrKitExpedited = CS.ItemOrKitExpedited, @csAfterStockId = CS.StockId,
										 @csAfterIsActive = CS.IsActive, @csAfterModifyDate = CS.ModifyDate, @csAfterModifyUserId = CS.ModifyUserId
							FROM [dbo].[CardStockItems] CS
							WHERE CS.IsActive = 1 AND CS.ItemOrKitID = @ItemOrKitID
										AND CS.ItemOrKitQuality = @ItemOrKitQualityId AND CS.ItemVerKit = @ItemVerKit
										AND CS.ItemOrKitUnitOfMeasureId = @ItemOrKitUnitOfMeasureId

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

							FETCH NEXT FROM cardStockItemsCursor INTO @csBeforeID, @csBeforeItemVerKit, @csBeforeItemOrKitID, @csBeforeItemOrKitUnitOfMeasureId,
								@csBeforeItemOrKitQuantity, @csBeforeItemOrKitQuality, @csBeforeItemOrKitFree,
								@csBeforeItemOrKitUnConsilliation, @csBeforeItemOrKitReserved, @csBeforeItemOrKitReleasedForExpedition,
								@csBeforeItemOrKitExpedited, @csBeforeStockId, @csBeforeIsActive, @csBeforeModifyDate,
								@csBeforeModifyUserId
					END
					
					CLOSE cardStockItemsCursor
          DEALLOCATE cardStockItemsCursor				

				FETCH NEXT FROM ShipmentOrderItemsCursor INTO @ItemOrKitId, @ItemVerKit, @ItemOrKitQualityId, @ItemOrKitUnitOfMeasureId, @ItemOrKitQuantity 
			END

		CLOSE ShipmentOrderItemsCursor
		DEALLOCATE ShipmentOrderItemsCursor
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
		UPDATE [dbo].[CommunicationMessagesShipmentOrdersSent] SET [IsActive] = 0 WHERE [ID] = @S0DeleteID AND [MessageId] = @S0DeleteMessageID
		SET @myError = @myError + @@ERROR

		-- 5.
		UPDATE [dbo].[CommunicationMessagesShipmentOrdersSentItems] SET [IsActive] = 0 WHERE [CMSOId] = @S0DeleteID
		SET @myError = @myError + @@ERROR

    IF @myError = 0 
			BEGIN 
					COMMIT TRAN
					SET @sub = 'FENIX - DELETE MESSAGE S0 - Oznámení' + ' Databáze: ' + ISNULL(@myDatabaseName,'')
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
					SET @sub = 'FENIX - DELETE MESSAGE S0 - PROBLÉM !!!' + ' Databáze: ' + ISNULL(@myDatabaseName,'')
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
      SET @sub = 'FENIX - Delete Message S0 CHYBA' + ' Databáze: '+ ISNULL(@myDatabaseName,'')
      SET @msg = 'Program prCMDeleteMessageS0; '  + ISNULL(ERROR_MESSAGE(),'') + ISNULL(CAST(ERROR_NUMBER() AS VARCHAR(50)),'') 
      EXEC  @result = msdb.dbo.sp_send_dbmail
     				@profile_name = 'Automat', --@MailProfileName
     				--@recipients = 'max.weczerek@upc.cz;michal.rezler@upc.cz',		-- TODO odremovat
						@recipients = 'michal.rezler@upc.cz',													-- TODO zaremovat	
     				@subject = @sub,
     				@body = @msg,
     				@body_format = 'HTML'

			--SELECT 699			-- TODO zaremovat
END CATCH
GO
GRANT EXECUTE
    ON OBJECT::[dbo].[prCMDeleteMessageS0] TO [FenixW]
    AS [dbo];

