
CREATE PROCEDURE [dbo].[prInternalMovementSave] 
		@ItemVerKit											int,
		@ItemOrKitID										int,		 
		@ItemOrKitQuailityID						int,
		@InternalMovementTypeID					int,
		@IternalMovementQuantity        numeric(18,3),
		@Remark		                      nvarchar(512) = null,
		@MovementAddSubBaseID           int, 
		@ModifyUserId										int							= 0,
		@ReturnValue										int							= -1 OUTPUT,
		@ReturnMessage									nvarchar(2048)	= null OUTPUT
AS

-- ===================================================================================================================
-- Created by   : Rezler Michal
-- Created date : 2015-05-15
-- Description  : uložení údajů nového interního pohybu
--                
-- Returns      : 0 = OK
--                1 = chyba (se specifikací)
--               -1 = nespecifikovana chyba
-- Used by      : 
-- History				: 1.0.0       Rezler Michal
-- Edit         : 2015-05-20  Rezler Michal
--                            přidán parametr Remark
--              : 2015-07-30  Rezler Michal
--                            přidán parametr MovementAddSubBaseID (přičítá/odečítá se od Volné/uvolněné, Rezervované)
-- ===================================================================================================================

DECLARE @myDatabaseName  nvarchar(100)

SET NOCOUNT ON;
BEGIN TRY
			SELECT @myDatabaseName = DB_NAME() 
       
			DECLARE @errTask nvarchar (126), @errLine int, @errNumb int     
			DECLARE @myMessage [nvarchar] (max), @myReturnValue [int], @myReturnMessage nvarchar(2048)       
			DECLARE @decision [int] 
			DECLARE @mOK [bit]						
			DECLARE @msg    varchar(max)						
			DECLARE @sub    varchar(1000)
			DECLARE @ItemOrKitDescription    varchar(1000)
			DECLARE @foundedItemOrKitID int 
			DECLARE @Result int
						
			SELECT  @mOK = 1, @msg = '', @ReturnValue = 0,  @ReturnMessage = 'OK', @decision = 0 -- BEZ ROZHODNUTÍ
			
			-- dohledání ID skladové karty 
			DECLARE @cardStockItemID int, @cardStockItemCount int, @measureID int
			SELECT  @cardStockItemID = [ID] 
			FROM		[dbo].[CardStockItems] 
			WHERE   [ItemVerKit] = @ItemVerKit AND [ItemOrKitID] = @ItemOrKitID AND  [ItemOrKitQuality] = @ItemOrKitQuailityID

			-- zjištění počtu skladových karet (musí být = 1)
			SELECT  @cardStockItemCount = count([ItemOrKitID]) 
			FROM		[dbo].[CardStockItems] 
			WHERE   [ItemVerKit] = @ItemVerKit AND [ItemOrKitID] = @ItemOrKitID AND  [ItemOrKitQuality] = @ItemOrKitQuailityID

			IF @cardStockItemID IS NULL
				BEGIN
					SELECT @ReturnValue = 1, @ReturnMessage = 'Nenalezena skladová karta'
					SET @mOK = 0
				END
			ELSE
				BEGIN
					IF @cardStockItemCount <> 1
						BEGIN
							SELECT @ReturnValue = 1, @ReturnMessage = 'Počet nalezených skladových karet > 1'
							SET @mOK = 0
						END
				END
		
			IF @mOK = 1
				BEGIN												
						-- dohledání jednotky měření
						SELECT @foundedItemOrKitID = [ItemOrKitID], @measureID = [ItemOrKitUnitOfMeasureId] 
						FROM   [dbo].[CardStockItems] 
						WHERE  ID = @cardStockItemID

						-- dohledání popisu itemu/kitu
						IF @ItemVerKit = 0
							BEGIN 
								SELECT @ItemOrKitDescription = [DescriptionCz] FROM [dbo].[cdlItems] WHERE ID = @foundedItemOrKitID
							END
						ELSE
							BEGIN
								SELECT @ItemOrKitDescription = [DescriptionCz] FROM [dbo].[cdlKits] WHERE ID = @foundedItemOrKitID
							END

						INSERT INTO [dbo].[InternalMovements]
						([ItemVerKit] ,[ItemOrKitID], [ItemOrKitDescription], [IternalMovementQuantity], [ItemOrKitUnitOfMeasureId], [ItemOrKitQuality], 
						 [CardStockItemID], [MovementsTypeID], [MovementsDecisionID], [CreatedDate], [CreatedUserId], [IsActive], [ModifyDate], [ModifyUserId], 
						 [Remark], [MovementsAddSubBaseID])
						VALUES
						(@ItemVerKit , @ItemOrKitID, @ItemOrKitDescription, @IternalMovementQuantity, @measureID, @ItemOrKitQuailityID, 
						 @cardStockItemID, @InternalMovementTypeID, @decision, getdate(), @ModifyUserId, 1, getdate(), @ModifyUserId, 
						 @Remark, @MovementAddSubBaseID)

						IF @@ERROR = 0 
							SET @ReturnValue = 0
						ELSE 
							SET @ReturnValue = 2
				END										
END TRY
BEGIN CATCH
      IF @@TRANCOUNT > 0 ROLLBACK TRAN
      SELECT @ReturnValue = 1, @ReturnMessage = 'Chyba'
      SET @sub = 'FENIX - Internal Movement Save CHYBA' + ' Databáze: '+ISNULL(@myDatabaseName,'')
      SET @msg = 'Program prInternalMovementSave; '  + ISNULL(ERROR_MESSAGE(),'') + ISNULL(CAST(ERROR_NUMBER() AS VARCHAR(50)),'') 
      EXEC	@result = msdb.dbo.sp_send_dbmail
     				@profile_name = 'Automat', 
     				@recipients = 'michal.rezler@upc.cz',
     				@subject = @sub,
     				@body = @msg,
     				@body_format = 'HTML'
END CATCH

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[prInternalMovementSave] TO [FenixW]
    AS [dbo];

