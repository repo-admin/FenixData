
CREATE PROCEDURE [dbo].[prInternalMovementStockCardQuantity] 
		@ItemVerKit											int,
		@ItemOrKitID										int,	
		@ItemOrKitQuailityID            int,			 
		@MovementAddSubBaseID           int, 
		@StockCardQuantity              numeric(18,3)   =  0 OUTPUT,
		@ReturnValue										int							= -1 OUTPUT,
		@ReturnMessage									nvarchar(2048)	= null OUTPUT
AS

-- ===================================================================================================================
-- Created by   : Rezler Michal
-- Created date : 2015-07-31
-- Description  : vraci disponibilní množství ze skladovhé karty (volné/uvolněné k expedici, nebo rezervované) 
--                
-- Returns      : 0 = OK
--                1 = chyba (se specifikací)
--                2 = nespecifikovana chyba
-- Used by      : 
-- History				: 1.0.0       Rezler Michal
-- ===================================================================================================================

DECLARE @myDatabaseName  nvarchar(100)

SET NOCOUNT ON;
BEGIN TRY
			SELECT @myDatabaseName = DB_NAME() 
      			
			DECLARE @msg varchar(max), @sub varchar(1000), @Result int
			DECLARE @quantityFree numeric(18, 3), @quantityReleasedForExpedition numeric(18, 3), @quantityReserved numeric(18, 3)
									
			SELECT  @quantityFree = [ItemOrKitFree], @quantityReleasedForExpedition = [ItemOrKitReleasedForExpedition], 
			        @quantityReserved = [ItemOrKitReserved]
			FROM		[dbo].[CardStockItems] 
			WHERE   [ItemVerKit] = @ItemVerKit AND [ItemOrKitID] = @ItemOrKitID AND  [ItemOrKitQuality] = @ItemOrKitQuailityID

			IF @MovementAddSubBaseID = 1
				/* mnozstvi volne/uvolene k expedici */
				BEGIN
					IF @ItemVerKit = 0
					  -- item
						BEGIN 
							SET @StockCardQuantity = @quantityFree
						END
					ELSE
						-- kit
						BEGIN 
							SET @StockCardQuantity = @quantityReleasedForExpedition
						END
				END
			ELSE
				/* mnozstvi rezervovane */
				BEGIN
					/* zde se nerozlisuje item, nebo kit*/
					SET @StockCardQuantity = @quantityReserved
				END

			IF @@ERROR = 0 
				SET @ReturnValue = 0
			ELSE 
				SET @ReturnValue = 2
				
END TRY
BEGIN CATCH
      IF @@TRANCOUNT > 0 ROLLBACK TRAN
      SELECT @ReturnValue = 1, @ReturnMessage = 'Chyba'
      SET @sub = 'FENIX - Internal Movement Stock Card Quantity CHYBA' + ' Databáze: '+ISNULL(@myDatabaseName,'')
      SET @msg = 'Program prInternalMovementStockCardQuantity; '  + ISNULL(ERROR_MESSAGE(),'') + ISNULL(CAST(ERROR_NUMBER() AS VARCHAR(50)),'') 
      EXEC	@result = msdb.dbo.sp_send_dbmail
     				@profile_name = 'Automat', 
     				@recipients = 'michal.rezler@upc.cz',
     				@subject = @sub,
     				@body = @msg,
     				@body_format = 'HTML'
END CATCH

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[prInternalMovementStockCardQuantity] TO [FenixW]
    AS [dbo];

