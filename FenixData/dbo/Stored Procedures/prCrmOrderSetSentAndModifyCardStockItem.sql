CREATE PROCEDURE [dbo].[prCrmOrderSetSentAndModifyCardStockItem]
(
	@CrmOrderID int,
	@StatusOK int,
	@MessageStatusID int,		
	@ReturnValue int = -1 OUTPUT,
	@ReturnMessage nvarchar(2048) = NULL OUTPUT
)
AS
-- =====================================================================================================================
-- Created by   : Rezler Michal
-- Created date : 2017-03-18
-- Description  : CRM objednavka (CrmOrder)
--                1. nastaveni datumu odeslani a statusu zpravy (tabulka CommunicationMessagesCrmOrder)
--                2. zmena mnozstvi na skladovych kartach (tabulka CardStockItems)
--
-- Returns      : 0 je-li zapis uspesny, jinak cislo chyby
--               -1 = nespecifikovana chyba
-- Used by      : 
-- History		    : 1.0.0                                                                                    Rezler Michal
-- =====================================================================================================================
SET NOCOUNT ON
--
SET @ReturnValue = -1
SET @ReturnMessage = 'Chyba'

BEGIN TRY

			DECLARE @myDatabaseName  nvarchar(100)
			DECLARE @msg varchar(max), @MailTo varchar(150), @MailBB varchar(150), @sub varchar(1000), @Result int, @myOK bit,
							@myAdresaLogistika  varchar(500),  @myAdresaProgramator  varchar(500), @myPocet int, 
							@myError int, @myMessage nvarchar (max), @myReturnValue int, @myReturnMessage nvarchar(2048),
							@kiKitId int, @kiKitQuantity decimal, @kiCardStockItemsId int, @kiKitQualityId int, @kiMeasuresID int,		        
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
								
		SELECT @myDatabaseName = DB_NAME() 			

		BEGIN TRAN t
			SET @myError = 0

			SET @myAdresaLogistika   = [dbo].[fnHomeAdresses] (4)
			SET @myAdresaProgramator = [dbo].[fnHomeAdresses] (2)
				
			-- nastaveni datumu odeslani a statusu zpravy (vysledek odeslani XML do XPO)
			UPDATE [dbo].[CommunicationMessagesCrmOrder]
				 SET [MessageDateOfShipment] = getdate()
					  ,[MessageStatusID] = @MessageStatusID
			WHERE ID = @CrmOrderID

			-- zmeny na skaladovych kartach se provadeji pouze v pripade, ze vysledek odeslani XML zpravy do XPO byl OK
			IF @MessageStatusID = @StatusOK
				BEGIN
					
							IF (SELECT CURSOR_STATUS('global','ShipmentOrderItemsCursor')) >= -1
								BEGIN
											DEALLOCATE ShipmentOrderItemsCursor
								END
									
							DECLARE ShipmentOrderItemsCursor CURSOR FOR 
							(      
									SELECT L_ITEM_OR_KIT_ID, L_ITEM_VER_KIT, L_ITEM_OR_KIT_QUALITY_ID, L_ITEM_OR_KIT_MEASURE_ID, L_ITEM_OR_KIT_QUANTITY
									FROM [dbo].[CommunicationMessagesCrmOrderItems] cKI
									WHERE cKI.IsActive = 1 AND cKI.CommunicationMessageID = @CrmOrderID
							)
							FOR READ ONLY

							OPEN ShipmentOrderItemsCursor

								FETCH NEXT FROM ShipmentOrderItemsCursor INTO @ItemOrKitId, @ItemVerKit, @ItemOrKitQualityId, @ItemOrKitUnitOfMeasureId, @ItemOrKitQuantity 
								WHILE @@FETCH_STATUS = 0
								BEGIN
							
										IF (SELECT CURSOR_STATUS('global','CardStockItemsCursor')) >= -1
											BEGIN
														DEALLOCATE CardStockItemsCursor
											END

										DECLARE CardStockItemsCursor CURSOR FOR 
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

										OPEN CardStockItemsCursor

										FETCH NEXT FROM CardStockItemsCursor INTO @csBeforeID, @csBeforeItemVerKit, @csBeforeItemOrKitID, @csBeforeItemOrKitUnitOfMeasureId,
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
														SET @myItemOrKitFree = ISNULL(@csBeforeItemOrKitFree, 0) - @ItemOrKitQuantity
														SET @myItemOrKitReserved = ISNULL(@csBeforeItemOrKitReserved, 0) + @ItemOrKitQuantity
									
														UPDATE [dbo].[CardStockItems] SET ItemOrKitFree = @myItemOrKitFree, ItemOrKitReserved = @myItemOrKitReserved
														WHERE IsActive = 1 AND ItemOrKitID = @ItemOrKitID
																	AND ItemOrKitQuality = @ItemOrKitQualityId AND ItemVerKit = @ItemVerKit
																	AND ItemOrKitUnitOfMeasureId = @ItemOrKitUnitOfMeasureId
													END
												ELSE
													BEGIN
														SET @myItemOrKitReleasedForExpedition = ISNULL(@csBeforeItemOrKitReleasedForExpedition, 0) - @ItemOrKitQuantity
														SET @myItemOrKitReserved = ISNULL(@csBeforeItemOrKitReserved, 0) + @ItemOrKitQuantity

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

												FETCH NEXT FROM CardStockItemsCursor INTO @csBeforeID, @csBeforeItemVerKit, @csBeforeItemOrKitID, @csBeforeItemOrKitUnitOfMeasureId,
													@csBeforeItemOrKitQuantity, @csBeforeItemOrKitQuality, @csBeforeItemOrKitFree,
													@csBeforeItemOrKitUnConsilliation, @csBeforeItemOrKitReserved, @csBeforeItemOrKitReleasedForExpedition,
													@csBeforeItemOrKitExpedited, @csBeforeStockId, @csBeforeIsActive, @csBeforeModifyDate,
													@csBeforeModifyUserId
										END
					
										CLOSE CardStockItemsCursor
										DEALLOCATE CardStockItemsCursor				

									FETCH NEXT FROM ShipmentOrderItemsCursor INTO @ItemOrKitId, @ItemVerKit, @ItemOrKitQualityId, @ItemOrKitUnitOfMeasureId, @ItemOrKitQuantity 
								END

							CLOSE ShipmentOrderItemsCursor
							DEALLOCATE ShipmentOrderItemsCursor					
				END

			IF @myError = 0 
				BEGIN 
						COMMIT TRAN t
						SET @ReturnMessage = 'OK'
						SET @ReturnValue = 0
				END   
			ELSE
				BEGIN 
						IF @@TRANCOUNT > 0 ROLLBACK TRAN t
						SET @sub = 'FENIX - prCrmOrderSetSentAndModifyCardStockItem - CHYBA !!!' + ' Databáze: ' + ISNULL(@myDatabaseName,'')
						SET @msg = 'Nebyla zpracována následující C0 CrmOrder ID: '  + ISNULL(CAST(@CrmOrderID AS VARCHAR(50)),'')
						
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
   --DECLARE @errTask nvarchar (126), @errLine int, @errNumb int
   --SET @errTask = ERROR_PROCEDURE()
   --SET @errLine = ERROR_LINE()
   --SET @errNumb = ERROR_NUMBER()
   --SET @ReturnMessage  = ERROR_MESSAGE()
   --SET @ReturnValue = CASE WHEN ISNULL(@errNumb,-1) > 0 THEN @errNumb ELSE -1 END

    SELECT @ReturnValue = 1, @ReturnMessage = 'CHYBA'
    SET @sub = 'FENIX - CRM order C0 - CHYBA !!!' + ' Databáze: '+ ISNULL(@myDatabaseName,'')
    SET @msg = 'Program prCrmOrderSetSentAndModifyCardStockItem; '  + ISNULL(ERROR_MESSAGE(),'') + ISNULL(CAST(ERROR_NUMBER() AS VARCHAR(50)),'') 
    EXEC  @result = msdb.dbo.sp_send_dbmail
     			@profile_name = 'Automat',     				
					@recipients = @myAdresaProgramator,
     			@subject = @sub,
     			@body = @msg,
     			@body_format = 'HTML'
END CATCH