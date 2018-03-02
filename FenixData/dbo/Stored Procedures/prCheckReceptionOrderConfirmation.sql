CREATE PROCEDURE [dbo].[prCheckReceptionOrderConfirmation]
		@parFindR1ID		 int,
		@parCheckValue   int            = -1   OUTPUT,		
		@ReturnValue     int            = -1   OUTPUT,
		@ReturnMessage   nvarchar(2048) = null OUTPUT
 AS
-- ===============================================================================================
-- Created by   : Rezler Michal
-- Created date : 2015-06-02
-- Description  : kontrola R1
--	                musí souhlasit počet itemů 
--                musí souhlasit množství objednané s dodaným množstvím
--                musí souhlasit porovnání množství pro jednotlivé itemy
-- Returns      : @parCheckValue = 0 (není shoda R1 a R0)
--              : @parCheckValue = 1 (je shoda R1 a R0)
--              : @ReturnValue   = 0 (OK)  
-- Used by      : @ReturnValue  != 0 (chyba, popis v @ReturnMessage)
-- History		    : 1.0.0  2015-06-02                                                  Rezler Michal
-- ===============================================================================================

BEGIN

	BEGIN TRY

		DECLARE @FindR1ID int
		DECLARE @R0ID INT
		DECLARE @isOK INT	
		DECLARE @difference int
		DECLARE @R0ItemCount int
		DECLARE @R1ItemCount int
		DECLARE @ErrMsg varchar(max)

		SET @FindR1ID = @parFindR1ID
		SET @isOK = 0
		SET @ReturnValue = 0

		-- urceni R0 ID
		SELECT @R0ID = R1.[CommunicationMessagesSentId]
		FROM [dbo].[CommunicationMessagesReceptionConfirmation] R1
		WHERE R1.[ID] = @FindR1ID
			
		-- pocty itemu
		SELECT @R0ItemCount = COUNT(R0Items.ID)
		FROM  [dbo].[CommunicationMessagesReceptionSentItems] R0Items
		WHERE R0Items.[CMSOId] = @R0ID
			AND R0Items.[IsActive] = 1

		SELECT @R1ItemCount = COUNT(R1Items.ID)
		FROM [dbo].[CommunicationMessagesReceptionConfirmationItems] R1Items
		WHERE R1Items.[CMSOId] = @FindR1ID
			AND R1Items.[IsActive] = 1

		IF @R0ItemCount = @R1ItemCount			
			SET @isOK = 1
		ELSE			
			SET @ReturnMessage = 'CHYBA - nesouhlasí počet itemů R0 a R1'
			
		-- sumy
		IF @isOK = 1
			BEGIN
				DECLARE @R0OrderedQuantity numeric(18,3)
				DECLARE @R1RealQuantity numeric(18,3)

				SELECT @R0OrderedQuantity = SUM(R0Items.[ItemQuantity])
				FROM  [dbo].[CommunicationMessagesReceptionSentItems] R0Items
				WHERE R0Items.[CMSOId] = @R0ID
					AND R0Items.[IsActive] = 1

				SELECT @R1RealQuantity = SUM(R1Items.ItemQuantity)
				FROM [dbo].[CommunicationMessagesReceptionConfirmationItems] R1Items
				WHERE R1Items.[CMSOId] = @FindR1ID
					AND R1Items.[IsActive] = 1

				IF @R0OrderedQuantity <> @R1RealQuantity
					BEGIN
						SET @isOK = 0
						SET @ReturnMessage = 'CHYBA - nesouhlasí sumy množství R0 a R1'
					END				
			END

		-- porovani item na item (mnozstvi na mnozstvi)
		IF @isOK = 1
			BEGIN			
				SELECT @difference = COUNT(*) 
				FROM
				( 
						SELECT R0Items.[ItemQuantity] - R1Items.[ItemQuantity] as diff					       
									,R0Items.[CMSOId]
									,R0Items.[ID]
									,R0Items.[ItemQuantity]  as R0ItemQuantity
									,R1Items.[ItemQuantity]  as R1ItemQuantity
									,R0Items.[ItemUnitOfMeasure]
									,R0Items.[ItemQualityId]
									,R0Items.[IsActive]
						FROM [dbo].[CommunicationMessagesReceptionSentItems] R0Items
						LEFT OUTER JOIN [dbo].[CommunicationMessagesReceptionConfirmationItems] R1Items
							ON R0Items.ItemID = R1Items.ItemID 
									AND R0Items.[ItemUnitOfMeasure] = R1Items.[ItemUnitOfMeasure] 
									AND R0Items.[ItemQualityId] = R1Items.[ItemQualityId]
						WHERE R0Items.[CMSOId] = @R0ID
							AND R0Items.[IsActive] = 1
							AND R1Items.[CMSOId] = @FindR1ID
							AND R1Items.[IsActive] = 1
				) tabulka
				WHERE tabulka.diff <> 0
				IF @difference <> 0
					BEGIN
						SET @isOK = 0
						SET @ReturnMessage = 'CHYBA - nesouhlasí porovnání množství (item na item) R0 a R1'
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
    ON OBJECT::[dbo].[prCheckReceptionOrderConfirmation] TO [FenixW]
    AS [dbo];

