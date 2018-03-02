CREATE FUNCTION [dbo].[fnAppLogRowsCount]()
RETURNS int AS
-- ===============================================================================================
-- Created by   : Rezler Michal
-- Created date : 2014-07-15
-- Used by      : 
-- Description  : Pocet zaznamu tabulky [dbo].[AppLog]
-- Parameters   : 
-- History :
-- ===============================================================================================
BEGIN
--
DECLARE @RowCount int 

--
SELECT @RowCount = COUNT(ID)
FROM [dbo].[AppLog]

RETURN @RowCount
END

