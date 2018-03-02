CREATE PROCEDURE [dbo].[prGetAutomatStatus]
(
	@ReturnValue int = -1 OUTPUT,
	@ReturnMessage nvarchar(2048) = NULL OUTPUT
)
AS
-- ===================================================================================================
-- Created by   : Rezler Michal
-- Created date : 2014-10-06
-- Description  : vraci pocet zaznamu tabulky [dbo].[AppLogNew] a aktualni datum + cas
--                (kazda cela hodina musi obsahovat zaznam zacinajici 'Počet CDLItems'
-- Returns      : Automat Rows : nnnn  |   DateTime : yyyy-mm-dd hh:mi:ss.mmm
--               -1 = nespecifikovana chyba
-- Used by      : 
-- History		: 1.0.0  2014-10-06                                                      Rezler Michal
--                1.1.0  2014-10-08  pridan try catch blok, parametr @ReturnValue        Rezler Michal
-- ===================================================================================================
SET NOCOUNT ON
--
DECLARE @numRows bigint
DECLARE @dateTimeStart varchar(17)
DECLARE @dateTimeEnd varchar(17)

SET @ReturnValue = -1
SET @ReturnMessage = ''
SET @numRows = 0
SET @dateTimeStart = convert(varchar(14), getdate(), 121) + '00'
SET @dateTimeEnd = convert(varchar(14), getdate(), 121) + '09'

--
BEGIN TRY
	SELECT @numRows = count(ID) FROM [dbo].[AppLogNew] 
	WHERE (convert(varchar(17), [ModifyDate], 121) >= @dateTimeStart AND convert(varchar(17), [ModifyDate], 121) <= @dateTimeEnd)
	AND SUBSTRING([Message] , 1 , 14) = 'Počet CDLItems'	
	SET @ReturnMessage = 'Automat Rows : ' + cast(@numRows as varchar(20)) + '  |   DateTime : ' + convert(varchar(30), getdate(), 121)
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
    ON OBJECT::[dbo].[prGetAutomatStatus] TO [FenixW]
    AS [dbo];

