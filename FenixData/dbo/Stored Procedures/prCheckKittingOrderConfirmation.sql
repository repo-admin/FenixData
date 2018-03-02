CREATE PROCEDURE [dbo].[prCheckKittingOrderConfirmation]
		@parFindK1ID		 int,
		@parCheckValue   int            = -1   OUTPUT,		
		@ReturnValue     int            = -1   OUTPUT,
		@ReturnMessage   nvarchar(2048) = null OUTPUT
 AS
-- ===============================================================================================
-- Created by   : Rezler Michal
-- Created date : 2015-06-03
-- Description  : kontrola K1
--	                musí souhlasit počet itemů 
--                musí souhlasit množství objednané se skutečně dodaným množstvím,
--                musí souhlasit porovnání množství pro jednotlivých itemech
-- Returns      : @parCheckValue = 0 (není shoda K1 a K0)
--              : @parCheckValue = 1 (je shoda K1 a K0)
--              : @ReturnValue   = 0 (OK)  
-- Used by      : @ReturnValue  != 0 (chyba, popis v @ReturnMessage)
--
-- History		    : 1.0.0  2015-06-03                                                  Rezler Michal
-- ===============================================================================================

BEGIN

	BEGIN TRY

		DECLARE @FindK1ID int
		DECLARE @K0ID INT
		DECLARE @isOK INT	
		DECLARE @difference int
		DECLARE @K0ItemCount int
		DECLARE @K1ItemCount int
		DECLARE @ErrMsg varchar(max)

		SET @FindK1ID = @parFindK1ID
		SET @isOK = 0
		SET @ReturnValue = 0

		-- urceni K0 ID
		SELECT @K0ID = K1.[KitOrderID]
		FROM [dbo].[CommunicationMessagesKittingsConfirmation] K1
		WHERE K1.[ID] = @FindK1ID
			
		-- pocty itemu
		SELECT @K0ItemCount = COUNT(K0Items.ID)
		FROM  [dbo].[CommunicationMessagesKittingsSentItems] K0Items
		WHERE K0Items.[CMSOId] = @K0ID
			AND K0Items.[IsActive] = 1

		SELECT @K1ItemCount = COUNT(K1Items.ID)
		FROM [dbo].[CommunicationMessagesKittingsConfirmationItems] K1Items
		WHERE K1Items.[CMSOId] = @FindK1ID
			AND K1Items.[IsActive] = 1

		IF @K0ItemCount = @K1ItemCount			
			SET @isOK = 1
		ELSE			
			SET @ReturnMessage = 'CHYBA - nesouhlasí počet itemů K0 a K1'
			
		-- sumy
		IF @isOK = 1
			BEGIN
				DECLARE @K0OrderedQuantity numeric(18,3)
				DECLARE @K1RealQuantity numeric(18,3)

				SELECT @K0OrderedQuantity = SUM(K0Items.[KitQuantity])
				FROM  [dbo].[CommunicationMessagesKittingsSentItems] K0Items
				WHERE K0Items.[CMSOId] = @K0ID
					AND K0Items.[IsActive] = 1

				SELECT @K1RealQuantity = SUM(K1Items.[KitQuantity])
				FROM [dbo].[CommunicationMessagesKittingsConfirmationItems] K1Items
				WHERE K1Items.[CMSOId] = @FindK1ID
					AND K1Items.[IsActive] = 1

				IF @K0OrderedQuantity <> @K1RealQuantity
					BEGIN
						SET @isOK = 0
						SET @ReturnMessage = 'CHYBA - nesouhlasí sumy množství K0 a K1'
					END				
			END

		-- porovani item na item (mnozstvi na mnozstvi)
		IF @isOK = 1
			BEGIN			
				SELECT @difference = COUNT(*) 
				FROM
				( 
						SELECT K0Items.[KitQuantity] - K1Items.[KitQuantity] as diff					       
									,K0Items.[CMSOId]
									,K0Items.[KitID]
									,K0Items.[KitQuantity]  as K0KitQuantity
									,K1Items.[KitQuantity]  as K1KitQuantity 
									,K0Items.[MeasuresID]
									,K0Items.[KitQualityID]
									,K0Items.[IsActive]      as K0IsActive
									,K1Items.[IsActive]      as K1IsActive
						FROM [dbo].[CommunicationMessagesKittingsSentItems] K0Items
						INNER JOIN [dbo].[CommunicationMessagesKittingsConfirmationItems] K1Items
							ON K0Items.KitID = K1Items.KitID AND
									K0Items.[KitQualityId] = K1Items.[KitQualityId] 									
						WHERE K0Items.[CMSOId] = @K0ID
							AND K0Items.[IsActive] = 1
							AND K1Items.[CMSOId] = @FindK1ID
							AND K1Items.[IsActive] = 1
				) tabulka
				WHERE tabulka.diff <> 0
				IF @difference <> 0
					BEGIN
						SET @isOK = 0
						SET @ReturnMessage = 'CHYBA - nesouhlasí porovnání množství (item na item) K0 a K1'
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
    ON OBJECT::[dbo].[prCheckKittingOrderConfirmation] TO [FenixW]
    AS [dbo];

