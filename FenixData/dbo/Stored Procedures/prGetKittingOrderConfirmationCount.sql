CREATE PROCEDURE [dbo].[prGetKittingOrderConfirmationCount]
		@parFindK1ID		 int            =  0,
		@parCountK1      int            = -1   OUTPUT,		
		@ReturnValue     int            = -1   OUTPUT,
		@ReturnMessage   nvarchar(2048) = null OUTPUT
 AS
-- ===============================================================================================
-- Created by   : Rezler Michal
-- Created date : 2015-06-03
-- Description  : počet nezamítnutých K1 k K0 (minimální počet = 1)
-- Returns      : @parCountK1 >= 1
--              : @ReturnValue   = 0 (OK)  
--              : @ReturnValue  != 0 (chyba, popis v @ReturnMessage)
-- Used by
-- History		    : 1.0.0  2015-06-03                                                  Rezler Michal
-- ===============================================================================================

BEGIN

	BEGIN TRY
			
		DECLARE @K0ID INT
		DECLARE @ErrMsg varchar(max)

		-- urceni K0 ID
		SELECT @K0ID = K1.[KitOrderID]
		FROM [dbo].[CommunicationMessagesKittingsConfirmation] K1
		WHERE K1.[ID] = @parFindK1ID
			
		-- počet K0 k K1
		SELECT @parCountK1 = COUNT([KitOrderID])
		FROM [dbo].[CommunicationMessagesKittingsConfirmation] K11
		WHERE K11.[KitOrderID] = @K0ID AND K11.Reconciliation <> 2

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
    ON OBJECT::[dbo].[prGetKittingOrderConfirmationCount] TO [FenixW]
    AS [dbo];

