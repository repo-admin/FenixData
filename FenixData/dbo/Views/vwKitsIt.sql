




CREATE VIEW [dbo].[vwKitsIt]

-- 2014-09-22
AS
-- 0...Item, 1...Kit

SELECT Kit.[ID]                  cdlKitsItemsID
      ,Kit.[cdlKitsID]
      ,Kit.[ItemVerKit]
      ,Case Kit.[ItemVerKit] 
          WHEN 1 THEN 'K'
          ELSE 'M'
       END ItemVerKitText
      ,Kit.[ItemOrKitID]
      ,Kit.[ItemCode]
      ,KitSH.[DescriptionCz]     DescriptionCzKit
      ,COALESCE(it.[DescriptionCz],KitSHx.[DescriptionCz])  DescriptionCzItemsOrKit
      ,Kit.[ItemOrKitQuantity]
      ,CAST(Kit.[ItemOrKitQuantity] AS int) ItemOrKitQuantityInt
      ,Kit.[PackageType]
      ,Kit.[IsActive]
      --,Kit.[Comment]
      ,Kit.[ModifyDate]
      ,Kit.[ModifyUserId]
FROM [dbo].[cdlKitsItems]             Kit
LEFT OUTER JOIN [dbo].[cdlItems]      It
  ON Kit.[ItemVerKit] = 0 AND Kit.[ItemOrKitID] = It.ID
LEFT OUTER JOIN [dbo].[cdlKitsItems]  KitS
  ON Kit.[ItemVerKit] = 1  AND Kit.[ItemOrKitID] = KitS.ID
LEFT OUTER JOIN [dbo].[cdlKits]            KitSHx
  ON Kits.[cdlKitsID] = KitSHx.ID
LEFT OUTER JOIN [dbo].[cdlKits]            KitSH
  ON Kit.[cdlKitsID] = KitSH.ID
WHERE Kit.[IsActive] = 1 AND KitSH.[IsActive]=1











