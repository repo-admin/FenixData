CREATE PROCEDURE [dbo].[prAppLogWrite]
(
	@Type [nvarchar] (20),
    @Message [nvarchar] (max),
    @XmlMessage [nvarchar] (max), 
	@UserId int,
	@Source [nvarchar] (200) = null,
	@ReturnValue int = -1 OUTPUT,
	@ReturnMessage nvarchar(2048) = null OUTPUT
)
AS
-- ===============================================================================================
-- Created by   : Rezler Michal
-- Created date : 2014-06-20
-- Description  : Vlozeni zpravy do logu
-- Returns      : 0 je-li zapis uspesny, jinak cislo chyby
--               -1 = nespecifikovana chyba
-- Used by      : 
-- History		: 1.0.0                                Rezler Michal
--                1.0.1 (přidán parametr @Source)      Rezler Michal
-- ===============================================================================================
SET NOCOUNT ON
--
SET @ReturnValue = -1
SET @ReturnMessage = ''
--
BEGIN TRY
	INSERT INTO [dbo].[AppLog] ([Type], [Message], [XmlMessage],[ModifyUserId], [Source])
		 VALUES (@Type, @Message, @XmlMessage, @UserId, @Source)
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
    ON OBJECT::[dbo].[prAppLogWrite] TO [FenixW]
    AS [dbo];

