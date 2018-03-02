
CREATE FUNCTION [dbo].[fnKitCpeCount]
(
    @cdlKitId int
)
RETURNS int AS
-- ===============================================================================================
-- Created by   : Rezler Michal
-- Created date : 2015-08-06
-- Used by      : 
-- Description  : pro zadané cdlKitId  vrací počet CPE
-- Parameters   : 
-- History      : 1.0.0       Rezler Michal
--              : 2015-08-12  Rezler Michal   pridan sloupec Multiplayer (nasobi pocet CPE v kitu)
-- ===============================================================================================
BEGIN

    DECLARE @RowCount int, @FoundedID int, @sumaItems numeric(18,3), @Multiplayer int
    
    SELECT @sumaItems = SUM(cdlK.[ItemOrKitQuantity])
    FROM [dbo].[cdlKitsItems] cdlK
    LEFT OUTER JOIN [dbo].[cdlItems] cdlI
    	ON cdlI.ID = cdlK.ItemOrKitId
		LEFT OUTER JOIN [dbo].cdlKits K
			ON cdlK.cdlKitsId = K.ID
    WHERE cdlK.cdlKitsId = @cdlKitId
    			AND cdlI.ItemType = 'CPE'

		SELECT @Multiplayer = K.Multiplayer
		FROM [dbo].cdlKits K
		WHERE K.ID = @cdlKitId
    
    IF @sumaItems IS NOT NULL
    	SET @RowCount = @sumaItems * @Multiplayer
    ELSE
    	SET @RowCount = 0
    
    RETURN @RowCount

END


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[fnKitCpeCount] TO [FenixW]
    AS [dbo];

