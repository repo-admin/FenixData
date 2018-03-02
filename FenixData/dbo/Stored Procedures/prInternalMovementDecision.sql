
CREATE PROCEDURE [dbo].[prInternalMovementDecision] 
		@InternalMovementID							int,		 
		@DecisionID			                int,
		@MovementAddSubBaseID           int,
		@ModifyUserID							      int							= 0,
		@ReturnValue							      int							= -1 OUTPUT,
		@ReturnMessage						      nvarchar(2048)	= null OUTPUT
AS

-- ===========================================================================================================================
-- Created by   : Rezler Michal
-- Created date : 2015-05-19
-- Description  : uložení rozhodnutí interního pohybu (schvaluji/zamítám)
--                
-- Returns      : 0 = OK
--                1 = chyba (se specifikací)
--               -1 = nespecifikovana chyba
-- Used by      : 
-- History				: 1.0.0																							Rezler Michal
-- Edit         : 2015-07-31  Rezler Michal
--                            přidán parametr MovementAddSubBaseID (přičítá/odečítá se od Volné/uvolněné resp. od Rezervované)
-- ===========================================================================================================================

DECLARE @myDatabaseName  nvarchar(100)

SET NOCOUNT ON;
BEGIN TRY
			SELECT @myDatabaseName = DB_NAME() 
       
			DECLARE @errTask nvarchar (126), @errLine int, @errNumb int     
			DECLARE @myMessage [nvarchar] (max), @myReturnValue [int], @myReturnMessage nvarchar(2048)       			
			DECLARE @mOK [bit]						
			DECLARE @msg    varchar(max)						
			DECLARE @sub    varchar(1000)						
			DECLARE @Result int
			DECLARE @ItemVerKit bit, @ItemOrKitID int, @IternalMovementQuantity numeric(21, 3), @CardStockItemID int
			DECLARE @ItemOrKitUnitOfMeasureId int, @ItemOrKitQuality int, @MovementsTypeID int

			DECLARE @quantityFreeBefore numeric(21, 3), @quantityFreeAfter numeric(21, 3)
			DECLARE @quantityReservedBefore numeric(21, 3), @quantityReservedAfter numeric(21, 3)
			DECLARE @quantityReleasedForExpeditionBefore numeric(21, 3), @quantityReleasedForExpeditionAfter numeric(21, 3)
									
			SELECT  @mOK = 1, @msg = '', @ReturnValue = 0,  @ReturnMessage = 'OK'
			SELECT @quantityFreeBefore = 0, @quantityFreeAfter = 0, @quantityReservedBefore = 0, @quantityReservedAfter = 0
			
			IF @DecisionID = 1	/*schvaluji*/
				BEGIN
					-- dohledání potřebných údajů
					SELECT  @ItemVerKit = [ItemVerKit], @ItemOrKitID = [ItemOrKitID], @IternalMovementQuantity = [IternalMovementQuantity], 
									@CardStockItemID = [CardStockItemID], @ItemOrKitUnitOfMeasureId = [ItemOrKitUnitOfMeasureId], 
									@ItemOrKitQuality = [ItemOrKitQuality], @MovementsTypeID = [MovementsTypeID]
					FROM		[dbo].[InternalMovements]
					WHERE   [ID] = @InternalMovementID

					IF @ItemVerKit = 0
						BEGIN	
							-------------------------------------------------------------------------------------------		
							-- ITEM (dohledani @quantityFreeBefore, @quantityReservedBefore)
							-------------------------------------------------------------------------------------------		

							SELECT @quantityFreeBefore = [ItemOrKitFree], @quantityReservedBefore = [ItemOrKitReserved],
							       @quantityReleasedForExpeditionBefore = [ItemOrKitReleasedForExpedition]
							FROM  [dbo].[CardStockItems]
							WHERE [ID] = @CardStockItemID

							SET @quantityReleasedForExpeditionAfter = @quantityReleasedForExpeditionBefore
																					
							IF @MovementAddSubBaseID = 1	
								/* pracuje se s mnozstvim volnym*/
								BEGIN
									IF @MovementsTypeID = 1 /* MANKO se odečítá*/
										BEGIN									
											SET @quantityFreeAfter = @quantityFreeBefore - @IternalMovementQuantity
											SET @quantityReservedAfter = @quantityReservedBefore
										END
									ELSE              /* PREBYTEK se přičítá*/
										BEGIN									
											SET @quantityFreeAfter = @quantityFreeBefore + @IternalMovementQuantity
											SET @quantityReservedAfter = @quantityReservedBefore
										END	
								END
							ELSE                          
								/* pracuje se s mnozstvim rezervovanym*/
								BEGIN
									IF @MovementsTypeID = 1 /* MANKO se odečítá*/
										BEGIN									
											SET @quantityFreeAfter = @quantityFreeBefore;
											SET @quantityReservedAfter = @quantityReservedBefore - @IternalMovementQuantity
										END
									ELSE              /* PREBYTEK se přičítá*/
										BEGIN									
											SET @quantityFreeAfter = @quantityFreeBefore;
											SET @quantityReservedAfter = @quantityReservedBefore + @IternalMovementQuantity
										END	
								END																
						END
					ELSE
						BEGIN 					
							-------------------------------------------------------------------------------------------		
							-- KIT (dohledani @quantityReleasedForExpeditionBefore, @quantityReservedBefore)
							-------------------------------------------------------------------------------------------		
							
							SELECT @quantityReleasedForExpeditionBefore = [ItemOrKitReleasedForExpedition], @quantityReservedBefore = [ItemOrKitReserved],
							       @quantityFreeBefore = [ItemOrKitFree]
							FROM  [dbo].[CardStockItems]
							WHERE [ID] = @CardStockItemID

							SET @quantityFreeAfter = @quantityFreeBefore

							IF @MovementAddSubBaseID = 1	
								/* pracuje se s mnozstvim uvolneno k expedici*/
								BEGIN
									IF @MovementsTypeID = 1 /* MANKO se odečítá*/
										BEGIN
											SET @quantityReleasedForExpeditionAfter = @quantityReleasedForExpeditionBefore - @IternalMovementQuantity
											SET @quantityReservedAfter = @quantityReservedBefore
										END
									ELSE              /* PREBYTEK se přičítá*/
										BEGIN
											SET @quantityReleasedForExpeditionAfter = @quantityReleasedForExpeditionBefore + @IternalMovementQuantity
											SET @quantityReservedAfter = @quantityReservedBefore
										END	
								END
							ELSE
								/* pracuje se s mnozstvim rezervovanym*/
								BEGIN
									IF @MovementsTypeID = 1 /* MANKO se odečítá*/
										BEGIN
											SET @quantityReservedAfter = @quantityReservedBefore - @IternalMovementQuantity
											SET @quantityReleasedForExpeditionAfter = @quantityReleasedForExpeditionBefore											
										END
									ELSE              /* PREBYTEK se přičítá*/
										BEGIN
											SET @quantityReservedAfter = @quantityReservedBefore + @IternalMovementQuantity
											SET @quantityReleasedForExpeditionAfter = @quantityReleasedForExpeditionBefore											
										END	
								END
						END
					BEGIN

						BEGIN TRAN
					
							-- zápis rozhodnuti
							UPDATE [dbo].[InternalMovements] SET [MovementsDecisionID] = @DecisionID, [ModifyDate] = GETDATE(), [ModifyUserId] = @ModifyUserID
							WHERE [ID] = @InternalMovementID
					
							IF @ItemVerKit = 0
								BEGIN						
									-- update na kartě
									UPDATE[dbo].[CardStockItems] SET [ItemOrKitFree] = @quantityFreeAfter, [ItemOrKitReserved] = @quantityReservedAfter
									WHERE [ID] = @CardStockItemID								
									-- zápis do tabulky s historií
									INSERT INTO [dbo].[InternalMovementsHistory]
														 ([InternalMovementsID], [ItemVerKit], [ItemOrKitID], [IternalMovementQuantity], [ItemOrKitUnitOfMeasureId], [ItemOrKitQuality]
														 ,[ItemOrKitFreeBefore], [ItemOrKitFreeAfter], [ItemOrKitReleasedForExpeditionBefore],[ItemOrKitReleasedForExpeditionAfter]
														 ,[ItemOrKitReservedBefore], [ItemOrKitReservedAfter], [AddSubBase], [ModifyUserId])
											 VALUES
														 (@InternalMovementID, @ItemVerKit, @ItemOrKitID, @IternalMovementQuantity, @ItemOrKitUnitOfMeasureId, @ItemOrKitQuality,
															@quantityFreeBefore, @quantityFreeAfter, @quantityReleasedForExpeditionBefore, @quantityReleasedForExpeditionAfter,
															@quantityReservedBefore, @quantityReservedAfter, @MovementAddSubBaseID, @ModifyUserID)															
								END
							ELSE
								BEGIN
									-- update na kartě
									UPDATE[dbo].[CardStockItems] SET [ItemOrKitReleasedForExpedition] = @quantityReleasedForExpeditionAfter,
									                                 [ItemOrKitReserved] = @quantityReservedAfter
									WHERE [ID] = @CardStockItemID								
									-- zápis do tabulky s historií
									INSERT INTO [dbo].[InternalMovementsHistory]
														 ([InternalMovementsID], [ItemVerKit], [ItemOrKitID], [IternalMovementQuantity], [ItemOrKitUnitOfMeasureId], [ItemOrKitQuality]
														 ,[ItemOrKitFreeBefore], [ItemOrKitFreeAfter], [ItemOrKitReleasedForExpeditionBefore],[ItemOrKitReleasedForExpeditionAfter]
														 ,[ItemOrKitReservedBefore], [ItemOrKitReservedAfter], [AddSubBase], [ModifyUserId])
											 VALUES 
														 (@InternalMovementID, @ItemVerKit, @ItemOrKitID, @IternalMovementQuantity, @ItemOrKitUnitOfMeasureId, @ItemOrKitQuality,
															@quantityFreeBefore, @quantityFreeAfter, @quantityReleasedForExpeditionBefore, @quantityReleasedForExpeditionAfter, 
															@quantityReservedBefore, @quantityReservedAfter, @MovementAddSubBaseID, @ModifyUserID)
								END
						
							IF @@ERROR = 0 
								COMMIT TRAN 
							ELSE 
								BEGIN
									ROLLBACK TRAN
									SELECT @ReturnValue = 2,  @ReturnMessage = ISNULL(ERROR_MESSAGE(),'') + ISNULL(CAST(ERROR_NUMBER() AS VARCHAR(50)),'')
								END
					END
				END
			ELSE		/*zamítám*/
				BEGIN
						-- zápis rozhodnuti
						UPDATE [dbo].[InternalMovements] SET [MovementsDecisionID] = @DecisionID, [ModifyDate] = GETDATE(), [ModifyUserId] = @ModifyUserID
						WHERE [ID] = @InternalMovementID
				END
END TRY
BEGIN CATCH
      IF @@TRANCOUNT > 0 ROLLBACK TRAN
      SELECT @ReturnValue = 1, @ReturnMessage = 'Chyba'
      SET @sub = 'FENIX - Internal Movement Decision CHYBA' + ' Databáze: '+ISNULL(@myDatabaseName,'')
      SET @msg = 'Program prInternalMovementDecision; '  + ISNULL(ERROR_MESSAGE(),'') + ISNULL(CAST(ERROR_NUMBER() AS VARCHAR(50)),'') 
      EXEC	@result = msdb.dbo.sp_send_dbmail
     				@profile_name = 'Automat', 
     				@recipients = 'michal.rezler@upc.cz',
     				@subject = @sub,
     				@body = @msg,
     				@body_format = 'HTML'
END CATCH

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[prInternalMovementDecision] TO [FenixW]
    AS [dbo];

