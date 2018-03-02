CREATE PROCEDURE [dbo].[prGetReceptionOrderConfirmationCount]
		@parFindR1ID		 int            =  0,
		@parCountR1      int            = -1   OUTPUT,		
		@ReturnValue     int            = -1   OUTPUT,
		@ReturnMessage   nvarchar(2048) = null OUTPUT
 AS
-- ===============================================================================================
-- Created by   : Rezler Michal
-- Created date : 2015-06-02
-- Description  : počet nezamítnutých R1 k R0 (minimální počet = 1)
-- Returns      : @parCountR1 >= 1
--              : @ReturnValue   = 0 (OK)  
--              : @ReturnValue  != 0 (chyba, popis v @ReturnMessage)
-- Used by
-- History		    : 1.0.0  2015-06-02                                                  Rezler Michal
-- ===============================================================================================

BEGIN

	BEGIN TRY
			
		DECLARE @R0ID INT
		DECLARE @ErrMsg varchar(max)

		-- urceni R0 ID
		SELECT @R0ID = R1.[CommunicationMessagesSentId]
		FROM [dbo].[CommunicationMessagesReceptionConfirmation] R1
		WHERE R1.[ID] = @parFindR1ID
			
		-- počet R0 k R1
		SELECT @parCountR1 = COUNT([CommunicationMessagesSentId])
		FROM [dbo].[CommunicationMessagesReceptionConfirmation] R11
		WHERE R11.[CommunicationMessagesSentId] = @R0ID AND R11.Reconciliation <> 2

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
    ON OBJECT::[dbo].[prGetReceptionOrderConfirmationCount] TO [FenixW]
    AS [dbo];

