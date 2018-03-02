CREATE PROCEDURE [dbo].[prCPESerialNumbersSetExportedFlag]
(
	@ID int,
	@Flag int,	
	@ReturnValue int = -1 OUTPUT,
	@ReturnMessage nvarchar(2048) = NULL OUTPUT
)
AS
-- ===========================================================================================================
-- Created by   : Rezler Michal
-- Created date : 2015-05-22
-- Description  : Sériová čísla CPE -> nastaveni příznaku a datumu exportu do procesu BIS -> korporát(M. Ertl)
-- Returns      : 0 je-li zapis uspesny, jinak cislo chyby
--               -1 = nespecifikovana chyba
-- Used by      : 
-- History		    : 1.0.0  Rezler Michal
-- ===========================================================================================================
SET NOCOUNT ON
--
SET @ReturnValue = -1
SET @ReturnMessage = ''
--
BEGIN TRY
	DECLARE @ExportedDate datetime

	IF @Flag <> 0
		BEGIN
			SET @ExportedDate = getdate()
		END

	UPDATE [dbo].[CommunicationMessagesReceptionConfirmationItems]		
		 SET [SNExportedFlag] = @Flag
			  ,[SNExportedDate] = @ExportedDate
	 WHERE ID = @ID
   --
   SET @ReturnValue = 0
	 SET @ReturnMessage = 'OK'
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
    ON OBJECT::[dbo].[prCPESerialNumbersSetExportedFlag] TO [mis]
    AS [dbo];

