CREATE PROCEDURE [dbo].[prCheckRefurbishedOrderConfirmation]
		@parFindRF1ID		 int,
		@parCheckValue   int            = -1   OUTPUT,		
		@ReturnValue     int            = -1   OUTPUT,
		@ReturnMessage   nvarchar(2048) = null OUTPUT
 AS
-- ===============================================================================================
-- Created by   : Rezler Michal
-- Created date : 2015-06-03
-- Description  : kontrola RF1
--	                musí souhlasit počet itemů 
--                musí souhlasit množství objednané s dodaným množstvím
--                musí souhlasit porovnání množství pro jednotlivé itemy
-- Returns      : @parCheckValue = 0 (není shoda RF1 a RF0)
--              : @parCheckValue = 1 (je shoda RF1 a RF0)
--              : @ReturnValue   = 0 (OK)  
-- Used by      : @ReturnValue  != 0 (chyba, popis v @ReturnMessage)
-- History		    : 1.0.0  2015-06-03                                                  Rezler Michal
-- ===============================================================================================

BEGIN

	BEGIN TRY

		DECLARE @FindRF1ID int
		DECLARE @RF0ID INT
		DECLARE @isOK INT	
		DECLARE @difference int
		DECLARE @RF0ItemCount int
		DECLARE @RF1ItemCount int
		DECLARE @ErrMsg varchar(max)

		SET @FindRF1ID = @parFindRF1ID
		SET @isOK = 0
		SET @ReturnValue = 0

		-- urceni RF0 ID
		SELECT @RF0ID = RF1.[RefurbishedOrderID]
		FROM [dbo].[CommunicationMessagesRefurbishedOrderConfirmation] RF1
		WHERE RF1.[ID] = @FindRF1ID
			
		-- pocty itemu
		SELECT @RF0ItemCount = COUNT(RF0Items.ID)
		FROM  [dbo].[CommunicationMessagesRefurbishedOrderItems] RF0Items
		WHERE RF0Items.[CMSOId] = @RF0ID
			AND RF0Items.[IsActive] = 1

		SELECT @RF1ItemCount = COUNT(RF1Items.ID)
		FROM [dbo].[CommunicationMessagesRefurbishedOrderConfirmationItems] RF1Items
		WHERE RF1Items.[CMSOId] = @FindRF1ID
			AND RF1Items.[IsActive] = 1

		IF @RF0ItemCount = @RF1ItemCount			
			SET @isOK = 1
		ELSE			
			SET @ReturnMessage = 'CHYBA - nesouhlasí počet itemů RF0 a RF1'
			
		-- sumy
		IF @isOK = 1
			BEGIN
				DECLARE @RF0OrderedQuantity numeric(18,3)
				DECLARE @RF1RealQuantity numeric(18,3)

				SELECT @RF0OrderedQuantity = SUM(RF0Items.[ItemOrKitQuantity])
				FROM  [dbo].[CommunicationMessagesRefurbishedOrderItems] RF0Items
				WHERE RF0Items.[CMSOId] = @RF0ID
					AND RF0Items.[IsActive] = 1

				SELECT @RF1RealQuantity = SUM(RF1Items.ItemOrKitQuantity)
				FROM [dbo].[CommunicationMessagesRefurbishedOrderConfirmationItems] RF1Items
				WHERE RF1Items.[CMSOId] = @FindRF1ID
					AND RF1Items.[IsActive] = 1

				IF @RF0OrderedQuantity <> @RF1RealQuantity
					BEGIN
						SET @isOK = 0
						SET @ReturnMessage = 'CHYBA - nesouhlasí sumy množství RF0 a RF1'
					END				
			END

		-- porovani item na item (mnozstvi na mnozstvi)
		IF @isOK = 1
			BEGIN			
				SELECT @difference = COUNT(*) 
				FROM
				( 
						SELECT RF0Items.[ItemOrKitQuantity] - RF1Items.[ItemOrKitQuantity] as diff					       
									,RF0Items.[CMSOId]
									,RF0Items.[ID]
									,RF0Items.[ItemOrKitQuantity]  as RF0ItemQuantity
									,RF1Items.[ItemOrKitQuantity]  as RF1ItemQuantity
									,RF0Items.[ItemOrKitUnitOfMeasureId]
									,RF0Items.[ItemOrKitQualityId]
									,RF0Items.[IsActive]
						FROM [dbo].[CommunicationMessagesRefurbishedOrderItems] RF0Items
						LEFT OUTER JOIN [dbo].[CommunicationMessagesRefurbishedOrderConfirmationItems] RF1Items
							ON RF0Items.ItemOrKitID = RF1Items.ItemOrKitID AND
							        RF0Items.[ItemVerKit] = RF1Items.[ItemVerKit]  
									AND RF0Items.[ItemOrKitUnitOfMeasureId] = RF1Items.[ItemOrKitUnitOfMeasureId] 
									AND RF0Items.[ItemOrKitQualityId] = RF1Items.[ItemOrKitQualityId]
						WHERE RF0Items.[CMSOId] = @RF0ID
							AND RF0Items.[IsActive] = 1
							AND RF1Items.[CMSOId] = @FindRF1ID
							AND RF1Items.[IsActive] = 1
				) tabulka
				WHERE tabulka.diff <> 0
				IF @difference <> 0
					BEGIN
						SET @isOK = 0
						SET @ReturnMessage = 'CHYBA - nesouhlasí porovnání množství (item na item) RF0 a RF1'
					END
			END

		SET @parCheckValue = @isOK

		IF @isOK = 1				
			SET @ReturnMessage = ''			
			
	END TRY
	BEGIN CATCH				
				SELECT @ReturnValue = 1				
				SET @ErrMsg = ISNULL(ERROR_MESSAGE(),'') + ISNULL(CAST(ERROR_NUMBER() AS VARCHAR(50)),'') 
				SET @ReturnMessage = SUBSTRING (@ErrMsg, 1, 2048)
	END CATCH

END	

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[prCheckRefurbishedOrderConfirmation] TO [FenixW]
    AS [dbo];

