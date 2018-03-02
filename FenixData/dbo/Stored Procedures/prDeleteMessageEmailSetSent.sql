CREATE PROCEDURE [dbo].[prDeleteMessageEmailSetSent]
(
	@DeleteMessageID  int,
	@MessageStatusID  int,
	@UserID           int = 0,	
	@ReturnValue      int = -1 OUTPUT,
	@ReturnMessage    nvarchar(2048) = NULL OUTPUT
)
AS
-- ======================================================================================================
-- Created by   : Rezler Michal
-- Created date : 2015-08-20
-- Description  : DeleteMessage(Email) -> nastaveni datumu odeslani, uzivatele co odeslal a statusu emailu 
-- Returns      : 0 je-li zapis uspesny, jinak cislo chyby
--               -1 = nespecifikovana chyba
-- Used by      : 
-- History		    : 1.0.0                                                                     Rezler Michal
-- ======================================================================================================
SET NOCOUNT ON

SET @ReturnValue = -1
SET @ReturnMessage = ''

BEGIN TRY
	UPDATE [dbo].[DeleteMessageSent]
	   SET [SentDate] = getdate()
		    ,[SentUserId] = @UserID
				,[MessageStatusId] = @MessageStatusID			
				,[ReceivedDate] = NULL
				,[ReceivedUserId] = NULL
	 WHERE ID = @DeleteMessageID
   --
   SET @ReturnValue = 0
END TRY
BEGIN CATCH
   DECLARE @errTask nvarchar (126), @errLine int, @errNumb int
   SET @errTask = ERROR_PROCEDURE()
   SET @errLine = ERROR_LINE()
   SET @errNumb = ERROR_NUMBER()
   SET @ReturnMessage  = ERROR_MESSAGE()
   SET @ReturnValue = CASE WHEN ISNULL(@errNumb,-1) > 0 THEN @errNumb ELSE -1 END
END CATCH

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[prDeleteMessageEmailSetSent] TO [FenixW]
    AS [dbo];

