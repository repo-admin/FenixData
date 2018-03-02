CREATE PROCEDURE [dbo].[prKittingsOrderSetSent]
(
	@ReceptionOrderID int,
	@MessageStatusID int,	
	@ReturnValue int = -1 OUTPUT,
	@ReturnMessage nvarchar(2048) = NULL OUTPUT
)
AS
-- ===============================================================================================
-- Created by   : Rezler Michal
-- Created date : 2014-09-08
-- Description  : Kittings(Order) -> nastaveni datumu odeslani a statusu zpravy
-- Returns      : 0 je-li zapis uspesny, jinak cislo chyby
--               -1 = nespecifikovana chyba
-- Used by      : 
-- History		: 1.0.0											                     Rezler Michal
-- ===============================================================================================
SET NOCOUNT ON
--
SET @ReturnValue = -1
SET @ReturnMessage = ''
--
BEGIN TRY
	UPDATE [dbo].[CommunicationMessagesKittingsSent]
	   SET [MessageDateOfShipment] = getdate()
		  ,[MessageStatusId] = @MessageStatusID
	 WHERE ID = @ReceptionOrderID
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
--
RETURN @ReturnValue








GO
GRANT EXECUTE
    ON OBJECT::[dbo].[prKittingsOrderSetSent] TO [FenixW]
    AS [dbo];

