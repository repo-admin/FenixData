CREATE PROCEDURE [dbo].[prGetRefurbishedOrderConfirmationCount]
		@parFindRF1ID		 int            =  0,
		@parCountRF1     int            = -1   OUTPUT,		
		@ReturnValue     int            = -1   OUTPUT,
		@ReturnMessage   nvarchar(2048) = null OUTPUT
 AS
-- ===============================================================================================
-- Created by   : Rezler Michal
-- Created date : 2015-06-03
-- Description  : počet nezamítnutých RF1 k RF0 (minimální počet = 1)
-- Returns      : @parCountRF1 >= 1
--              : @ReturnValue   = 0 (OK)  
--              : @ReturnValue  != 0 (chyba, popis v @ReturnMessage)
-- Used by
-- History		    : 1.0.0  2015-06-03                                                  Rezler Michal
-- ===============================================================================================

BEGIN

	BEGIN TRY
			
		DECLARE @RF0ID INT
		DECLARE @ErrMsg varchar(max)

		-- urceni RF0 ID
		SELECT @RF0ID = R1.[RefurbishedOrderID]
		FROM [dbo].[CommunicationMessagesRefurbishedOrderConfirmation] R1
		WHERE R1.[ID] = @parFindRF1ID
			
		-- počet R0 k R1
		SELECT @parCountRF1 = COUNT([RefurbishedOrderID])
		FROM [dbo].[CommunicationMessagesRefurbishedOrderConfirmation] R11
		WHERE R11.[RefurbishedOrderID] = @RF0ID AND R11.Reconciliation <> 2

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
    ON OBJECT::[dbo].[prGetRefurbishedOrderConfirmationCount] TO [FenixW]
    AS [dbo];

