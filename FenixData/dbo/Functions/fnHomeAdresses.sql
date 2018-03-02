-- =============================================
-- Author:		 Weczerek Max
-- Create date: 2014-07-14
-- Description: vrací adresy z tabulky cdlInformationAddresses
-- =============================================
CREATE FUNCTION [dbo].[fnHomeAdresses]
(
	@Code INT = -1
)
RETURNS varchar(500)
AS
BEGIN
	-- Declare the return variable here
	DECLARE  @myAdresa  varchar(500)

   SELECT   @myAdresa = LEFT(r.ResourceName , LEN(r.ResourceName)-1)
   FROM (
          SELECT Item + '; '   FROM  
                 (
                 SELECT [Email] AS Item FROM [dbo].[cdlInformationAddresses]
                 WHERE [Code]=@Code AND IsActive=1
                 ) A   FOR XML PATH('')
        ) r (ResourceName) 	-- Return the result of the function
	RETURN ISNULL(@myAdresa,'')

END

