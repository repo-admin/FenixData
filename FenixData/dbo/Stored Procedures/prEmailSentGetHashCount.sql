CREATE PROCEDURE [dbo].[prEmailSentGetHashCount]
(
	@EmailMessageHash [varchar] (128),
	@HashCount int = 0 OUTPUT,
	@ReturnValue int = -1 OUTPUT,
	@ReturnMessage nvarchar(2048) = null OUTPUT
)
AS
-- ===============================================================================================
-- Created by   : Rezler Michal
-- Created date : 2014-12-04
-- Description  : Pocet emailu s hashem odpovidajicimu @EmailMessageHash
-- Returns      : 0 je-li zapis uspesny, jinak cislo chyby ( > 0 )
--               -1 = nespecifikovana chyba
-- Used by      : 
-- History		: 1.0.0                                Rezler Michal
-- ===============================================================================================
SET NOCOUNT ON
--
SET @ReturnValue = -1
SET @ReturnMessage = ''
--
BEGIN TRY

	SELECT @HashCount = COUNT(ID) 
	FROM [dbo].[EmailSent]
	WHERE [EmailMessageHash] = @EmailMessageHash
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
    ON OBJECT::[dbo].[prEmailSentGetHashCount] TO [FenixW]
    AS [dbo];

