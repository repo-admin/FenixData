
CREATE VIEW [dbo].[vwInternalDocuments]
AS

/*
-- =============================================================================================================
-- Description  : zobrazuje Internal Documents (Interní doklady)
-- Created by   : Rezler Michal
-- Created date : 2015-11-30
-- Edited date  : 
-- =============================================================================================================
*/

SELECT ID.[ID]
      --,ID.[ItemVerKit]
			,CASE ID.[ItemVerKit]  WHEN 0 THEN 'Item' WHEN 1 THEN 'Kit' ELSE '' END ItemVerKitText
      ,ID.[ItemOrKitID]
      --,ID.[ItemOrKitUnitOfMeasureId]
			,CM.Code as [MeasureCode]
      --,ID.[ItemOrKitQualityId]
			,CQ.Code as [QualityCode]
      ,ID.[ItemOrKitQuantityBefore]
      ,ID.[ItemOrKitQuantityAfter]
      ,ID.[ItemOrKitFreeBefore]
      ,ID.[ItemOrKitFreeAfter]
      ,ID.[ItemOrKitUnConsilliationBefore]
      ,ID.[ItemOrKitUnConsilliationAfter]
      ,ID.[ItemOrKitReservedBefore]
      ,ID.[ItemOrKitReservedAfter]
      ,ID.[ItemOrKitReleasedForExpeditionBefore]
      ,ID.[ItemOrKitReleasedForExpeditionAfter]
      ,ID.[ItemOrKitExpeditedBefore]
      ,ID.[ItemOrKitExpeditedAfter]
      --,ID.[StockId]
			,CS.[Name] AS [StockName]
      ,ID.[InternalDocumentsSourceId]
      ,ID.[IsActive]
      ,ID.[ModifyDate]
      ,ID.[ModifyUserId]
FROM [dbo].[InternalDocuments] ID
INNER JOIN [dbo].[cdlMeasures] CM
	ON CM.ID = ID.[ItemOrKitUnitOfMeasureId]
INNER JOIN [dbo].[cdlQualities] CQ
	ON CQ.ID = ID.[ItemOrKitQualityId]
INNER JOIN [dbo].[cdlStocks] CS
	ON CS.ID = ID.StockId


