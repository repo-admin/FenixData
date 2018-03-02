CREATE FUNCTION [dbo].[fnItemIsCpe]
(
    @ItemID int
)
RETURNS int AS
-- ===============================================================================================
-- Created by   : Rezler Michal
-- Created date : 2015-08-06
-- Used by      : 
-- Description  : pro zadané item id  1 .. je to CPE
--                                    0 .. není to CPE
-- Parameters   : 
-- History :
-- ===============================================================================================
BEGIN

    DECLARE @RowCount int 
    DECLARE @FoundedID int
    
    SELECT @FoundedID = I.ID 
    FROM [dbo].[cdlItems] I				
    WHERE I.[IsActive] = 1
    			AND I.[ID] = @ItemID
    			AND (I.[ItemType] = 'CPE' OR I.[ItemType] = 'CPV')
    
    IF @FoundedID IS NOT NULL
    	SET @RowCount = 1
    ELSE
    	SET @RowCount = 0
    
    RETURN @RowCount

END


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnItemIsCpe] TO [FenixW]
    AS [dbo];

