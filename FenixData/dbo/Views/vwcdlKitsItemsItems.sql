CREATE VIEW vwcdlKitsItemsItems
AS
/*
toto jsou jen itemy, které jsou součástí kitů  !!
2014-10-10
*/
select cKI.[ID]
      ,cKI.[cdlKitsId]
      ,cKI.[ItemVerKit]
      ,cKI.[ItemOrKitId]
      ,cKI.[ItemGroupGoods]
      ,cKI.[ItemCode]
      ,cKI.[ItemOrKitQuantity]
      ,cKI.[PackageType]
      ,cKI.[IsActive]
      ,cKI.[ModifyDate]
      ,cKI.[ModifyUserId]
      ,cKI.[IsSent]
      ,cKI.[SentDate]
      ,cK.[ID]                 cKID
      ,cK.[Code]               cKCode
      ,cK.[DescriptionCz]      cKDescriptionCz
      ,cK.[DescriptionEng]     cKDescriptionEng
      ,cK.[MeasuresId]         cKMeasuresId
      ,cK.[MeasuresCode]       cKMeasuresCode
      ,cK.[KitQualitiesId]     cKKitQualitiesId
      ,cK.[KitQualitiesCode]   cKKitQualitiesCode
      ,cK.[IsSent]             cKIsSent
      ,cK.[SentDate]           cKSentDate
      ,cK.[GroupsId]           cKGroupsId
      ,cK.[Packaging]          cKPackaging
      ,cK.[IsActive]           cKIsActive
      ,cK.[ModifyDate]         cKModifyDate
      ,cK.[ModifyUserId]       cKModifyUserId
      ,cIt.[ID]                cItID
      ,cIt.[GroupGoods]        cItGroupGoods
      ,cIt.[Code]              cItCode
      ,cIt.[DescriptionCz]     cItDescriptionCz
      ,cIt.[DescriptionEng]    cItDescriptionEng
      ,cIt.[MeasuresId]        cItMeasuresId
      ,cIt.[ItemTypesId]       cItItemTypesId
      ,cIt.[PackagingId]       cItPackagingId
      ,cIt.[GroupsId]          cItGroupsId
      ,cIt.[ItemType]          cItItemType
      ,cIt.[PC]                cItPC
      ,cIt.[Packaging]         cItPackaging
      ,cIt.[IsSent]            cItIsSent
      ,cIt.[SentDate]          cItSentDate
      ,cIt.[ItemTypeDesc1]     cItItemTypeDesc1
      ,cIt.[ItemTypeDesc2]     cItItemTypeDesc2
      ,cIt.[IsActive]          cItIsActive
      ,cIt.[ModifyDate]        cItModifyDate
      ,cIt.[ModifyUserId]      cItModifyUserId
from [dbo].[cdlKitsItems]         cKI
INNER JOIN [dbo].[cdlKits]        cK
    ON cKI.cdlKitsId = cK.ID
LEFT OUTER JOIN cdlItems          cIt
    ON cKI.ItemOrKitId = cIt.ID AND cKI.ItemVerKit=0

