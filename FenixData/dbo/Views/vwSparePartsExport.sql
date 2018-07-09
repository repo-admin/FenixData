CREATE VIEW [dbo].[vwSparePartsExport]
AS
/*
-- ==========================================================================================================
-- Created by   : Rezler Michal
-- Created date : 2015-07-17
-- Used by      : 
-- Description  : SPP pro export do korporátu 
-- Parameters   : 
-- History      :
-- ==========================================================================================================
*/

SELECT csi.[ItemOrKitID] AS 'item_code'
			,'CZ' AS 'location'
			,0 as 'depl'
			,0 as 'undepl'
			,0 as 'blocked'
			,csi.[ItemOrKitFree] as 'new'
			,0 as 'used'
			,0 as 'channel_new'
			,0 as 'channel_used'
			,0 as 'bto'
FROM [dbo].[vwCardStockItemsWMUN] csi
WHERE csi.[ItemOrKitID] IN
		(SELECT [ItemOrKitID]
		 FROM [dbo].[SparePartsExport]
		 WHERE IsActive = 1)



GO
GRANT SELECT
    ON OBJECT::[dbo].[vwSparePartsExport] TO [mis]
    AS [dbo];

