CREATE PROCEDURE [dbo].[prCheckShipmentOrderConfirmation]
		@parFindS1ID		 int,
		@parCheckValue   int            = -1   OUTPUT,		
		@ReturnValue     int            = -1   OUTPUT,
		@ReturnMessage   nvarchar(2048) = null OUTPUT
 AS
-- ===============================================================================================
-- Created by   : Rezler Michal
-- Created date : 2015-04-22
-- Description  : kontrola S1
--	                musí souhlasit počet itemů 
--                musí souhlasit množství objednané se skutečně dodaným množstvím,
--                musí souhlasit porovnání množství pro jednotlivých itemech
-- Returns      : @parCheckValue = 0 (není shoda S1 a S0)
--              : @parCheckValue = 1 (je shoda S1 a S0)
--              : @ReturnValue   = 0 (OK)  
-- Used by      : @ReturnValue  != 0 (chyba, popis v @ReturnMessage)
-- History		    : 1.0.0  2015-04-24                                                  Rezler Michal
-- ===============================================================================================

BEGIN

	BEGIN TRY

		DECLARE @FindS1ID int
		DECLARE @S0ID INT
		DECLARE @isOK INT	
		DECLARE @difference int
		DECLARE @S0ItemCount int
		DECLARE @S1ItemCount int
		DECLARE @ErrMsg varchar(max)

		SET @FindS1ID = @parFindS1ID
		SET @isOK = 0
		SET @ReturnValue = 0

		-- urceni S0 ID
		SELECT @S0ID = S1.[ShipmentOrderID]
		FROM [dbo].[CommunicationMessagesShipmentOrdersConfirmation] S1
		WHERE S1.[ID] = @FindS1ID
			
		-- pocty itemu
		SELECT @S0ItemCount = COUNT(S0Items.ID)
		FROM  [dbo].[CommunicationMessagesShipmentOrdersSentItems] S0Items
		WHERE S0Items.[CMSOId] = @S0ID
			AND S0Items.[IsActive] = 1

		SELECT @S1ItemCount = COUNT(S1Items.ID)
		FROM [dbo].[CommunicationMessagesShipmentOrdersConfirmationItems] S1Items
		WHERE S1Items.[CMSOId] = @FindS1ID
			AND S1Items.[IsActive] = 1

		IF @S0ItemCount = @S1ItemCount			
			SET @isOK = 1
		ELSE			
			SET @ReturnMessage = 'CHYBA - nesouhlasí počet itemů S0 a S1'
			
		-- sumy
		IF @isOK = 1
			BEGIN
				DECLARE @S0OrderedQuantity numeric(18,3)
				DECLARE @S1RealQuantity numeric(18,3)

				SELECT @S0OrderedQuantity = SUM(S0Items.ItemOrKitQuantity)
				FROM  [dbo].[CommunicationMessagesShipmentOrdersSentItems] S0Items
				WHERE S0Items.[CMSOId] = @S0ID
					AND S0Items.[IsActive] = 1

				SELECT @S1RealQuantity = SUM(S1Items.RealItemOrKitQuantity)
				FROM [dbo].[CommunicationMessagesShipmentOrdersConfirmationItems] S1Items
				WHERE S1Items.[CMSOId] = @FindS1ID
					AND S1Items.[IsActive] = 1

				IF @S0OrderedQuantity <> @S1RealQuantity
					BEGIN
						SET @isOK = 0
						SET @ReturnMessage = 'CHYBA - nesouhlasí sumy množství S0 a S1'
					END				
			END

		-- porovani item na item (mnozstvi na mnozstvi)
		IF @isOK = 1
			BEGIN			
				SELECT @difference = COUNT(*) 
				FROM
				( 
						SELECT S0Items.[ItemOrKitQuantity] - S1Items.[RealItemOrKitQuantity] as diff					       
									,S0Items.[CMSOId]
									,S0Items.[SingleOrMaster]
									,S0Items.[ItemVerKit]
									,S0Items.[ItemOrKitID]
									,S0Items.[ItemOrKitQuantity]
									,S1Items.[RealItemOrKitQuantity]
									,S0Items.[ItemOrKitUnitOfMeasureId]
									,S0Items.[ItemOrKitQualityId]
									,S0Items.[IsActive]
						FROM [dbo].[CommunicationMessagesShipmentOrdersSentItems] S0Items
						INNER JOIN [dbo].[CommunicationMessagesShipmentOrdersConfirmationItems] S1Items
							ON S0Items.ItemOrKitID = S1Items.ItemOrKitID AND
									S0Items.[SingleOrMaster] = S1Items.[SingleOrMaster] AND
									S0Items.[ItemVerKit] = S1Items.[ItemVerKit] AND
									S0Items.[ItemOrKitUnitOfMeasureId] = S1Items.[ItemOrKitUnitOfMeasureId]									
						WHERE S0Items.[CMSOId] = @S0ID
							AND S0Items.[IsActive] = 1
							AND S1Items.[CMSOId] = @FindS1ID
							AND S1Items.[IsActive] = 1
				) tabulka
				WHERE tabulka.diff <> 0
				IF @difference <> 0
					BEGIN
						SET @isOK = 0
						SET @ReturnMessage = 'CHYBA - nesouhlasí porovnání množství (item na item) S0 a S1'
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
    ON OBJECT::[dbo].[prCheckShipmentOrderConfirmation] TO [FenixW]
    AS [dbo];

