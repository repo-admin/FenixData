CREATE PROCEDURE [dbo].[prGetShipmentOrderConfirmationCount]
		@parFindS1ID		 int            =  0,
		@parCountS1      int            = -1   OUTPUT,		
		@ReturnValue     int            = -1   OUTPUT,
		@ReturnMessage   nvarchar(2048) = null OUTPUT
 AS
-- ===============================================================================================
-- Created by   : Rezler Michal
-- Created date : 2015-04-22
-- Description  : počet nezamítnutých S1 k S0 (minimální počet = 1)
-- Returns      : @parCountS1 >= 1
--              : @ReturnValue   = 0 (OK)  
--              : @ReturnValue  != 0 (chyba, popis v @ReturnMessage)
-- Used by
-- History		    : 1.0.0  2015-04-24                                                  Rezler Michal
-- ===============================================================================================

BEGIN

	BEGIN TRY
			
		DECLARE @S0ID INT
		DECLARE @ErrMsg varchar(max)

		-- urceni S0 ID
		SELECT @S0ID = S1.[ShipmentOrderID]
		FROM [dbo].[CommunicationMessagesShipmentOrdersConfirmation] S1
		WHERE S1.[ID] = @parFindS1ID
			
		-- počet S0 k S1
		SELECT @parCountS1 = COUNT(ShipmentOrderID)
		FROM [dbo].[CommunicationMessagesShipmentOrdersConfirmation] S11
		WHERE S11.ShipmentOrderID = @S0ID AND S11.Reconciliation <> 2

		SET @ReturnValue = 0
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
    ON OBJECT::[dbo].[prGetShipmentOrderConfirmationCount] TO [FenixW]
    AS [dbo];

