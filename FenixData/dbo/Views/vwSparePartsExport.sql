
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


Bylo změněno dne 2016-05-17 na žádost paní Terezy Gubrické;
původní view :[dbo].[vwSparePartsExport_PUVODNI_20160517]
Změnu provedl: Max Weczerek
*/

SELECT csi.[ItemOrKitID] AS 'item_code'
			,'CZ' AS 'location'
			,csi.[ItemOrKitFree] as 'depl'
			,0 as 'undepl'
			,0 as 'blocked'
			,0 as 'new'
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

