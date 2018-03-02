

CREATE PROCEDURE [dbo].[sp_SelectPage]
(
   @PageNum int,                    -- Cislo pozadovane stranky
   @PageSize int,                   -- Pocet zaznamu na strance
	@ItemCount bigint output,        -- Celkovy pocet zaznamu dle filtrovaci podminky
   @TableName nvarchar(128),        -- Tabulka nebo View
   @ColumnList varchar(max) = null, -- Seznam pozadovanych sloupcu, ne-li uveden, tak vsechny
   @OrderBy varchar(max),           -- Nutne alespon jedno kriterium
   @WhereClause varchar(max) = null -- Filtrovaci podminka, ne-li uvedena, tak vsechny zaznamy
)
AS
-- ===============================================================================================
-- Created by   : Konecny Stanislav
-- Created date : 2008-05-05
-- Used by      : 
-- Description  : Procedura pro vyber zaznamu zadane stranky v gridu
-- History :
-- ===============================================================================================
SET NOCOUNT ON
BEGIN
DECLARE @lowNum nvarchar(10)
DECLARE @highNum nvarchar(10)
DECLARE @sqlCmd nvarchar(4000)
DECLARE @prmDef nvarchar(1000)
DECLARE @isWhere bit SET @isWhere = CASE WHEN LEN(LTRIM(ISNULL(@WhereClause,''))) > 0 THEN 1 ELSE 0 END

SET @prmDef = N'@cntOut bigint OUTPUT';
SET @sqlCmd = 'SELECT @cntOut = COUNT_BIG(*) FROM ' + @TableName +
   CASE WHEN @isWhere = 1 THEN ' WHERE ' + @WhereClause ELSE '' END
EXECUTE dbo.sp_executesql @sqlCmd, @prmDef, @cntOut = @ItemCount OUTPUT;

SET @lowNum = convert(nvarchar(10), (@PageSize * (@PageNum - 1)))
SET @highNum = convert(nvarchar(10), (@PageSize * @PageNum))

SET @sqlCmd = 'SELECT ' + CASE WHEN LTRIM(ISNULL(@ColumnList,'')) = '' THEN '*' ELSE @ColumnList END + ' FROM (' +
'SELECT ROW_NUMBER() OVER (ORDER BY ' + @OrderBy + ') AS RowNum, ' + CASE WHEN LTRIM(ISNULL(@ColumnList,'')) = '' THEN '*' ELSE @ColumnList END + ' ' +
'FROM ' + @TableName +
CASE WHEN @isWhere = 1 THEN ' WHERE ' + @WhereClause ELSE '' END +
') a WHERE a.RowNum > ' + @lowNum + ' AND a.rownum <= ' + @highNum

-- Execute the SQL query
EXEC sp_executesql @sqlCmd
--
END











GO
GRANT EXECUTE
    ON OBJECT::[dbo].[sp_SelectPage] TO [FenixR]
    AS [dbo];

