






/****** Script for SelectTopNRows command from SSMS  ******/
CREATE VIEW [dbo].[vwVydejkySprWrhMaterials]
AS
/*
2014-09-30
2014-10-02
*/
SELECT VSWM.[Id]
      ,VSWM.[RequiredQuantities]
      ,VSWM.[SuppliedQuantities]
      ,VSWM.[IssueType]
      ,VSWM.[IdWf]
      ,VSWM.[MaterialCode]
      ,VSWM.[Subscribers]
      ,VSWM.[SubscribersContact]
      ,VSWM.[Done]
      ,CASE VSWM.[Done]
      WHEN 0 THEN 'N'
      WHEN 1 THEN 'A'
      END DoneCase
      ,VSWM.[DateStamp]
      ,VSWM.[Hit]
      ,VSWM.[DeliveryDate]
      ,VSWM.[MessageId]
      ,VSWM.IsActive
      ,cDp.[ID]                      cdlDestinationPlacesID
      ,cDp.[OrganisationNumber]
      ,cDp.[CompanyName]
      ,cDp.[City]
      ,cDp.[StreetName]
      ,cDp.[StreetOrientationNumber]
      ,cDp.[StreetHouseNumber]
      ,cDp.[ZipCode]
      ,cDp.[IdCountry]
      ,cDp.[ICO]
      ,cDp.[DIC]
      ,cDp.[Type]
      ,cDp.[IsSent]
      ,cDp.[SentDate]
      ,cDp.[CountryISO]
      --,cDp.[IsActive]
      --,cDp.[ModifyDate]
      --,cDp.[ModifyUserId]
      ,cDPC.[ID]                     cdlDestinationPlacesContactsID
      ,cDPC.[DestinationPlacesId]
      ,cDPC.[PhoneNumber]
      ,cDPC.[FirstName]
      ,cDPC.[LastName]
      ,cDPC.[Title]
      ,CASE cDPC.[Title]
       WHEN 1 THEN 'Pan'
       WHEN 2 THEN 'Paní'
       ELSE ''
       END TitleText
      ,cDPC.[ContactName]
      ,cDPC.[ContactEmail]
      ,cDPC.[Type]                   SubscribersContactType
      ,cDPC.[IsSent]                 SubscribersContactIsSent
      ,cDPC.[SentDate]               SubscribersContactSentDate
      --,cDPC.[IsActive]
      --,cDPC.[ModifyDate]
      --,cDPC.[ModifyUserId]
      ,cdlItems.[ID]                 cdlItemsID
      ,cdlItems.[GroupGoods]
      ,cdlItems.[Code]
      ,cdlItems.[DescriptionCz]
      ,cdlItems.[DescriptionEng]
      ,cdlItems.[MeasuresId]
      ,cdlItems.[ItemTypesId]
      ,cdlItems.[PackagingId]
      ,cdlItems.[ItemType]
      ,cdlItems.[PC]
      ,cdlItems.[Packaging]
      ,cdlItems.[IsSent]             cdlItemsIsSent
      ,cdlItems.[SentDate]           cdlItemsSentDate
      --,cdlItems.[IsActive]
      --,cdlItems.[ModifyDate]
      --,cdlItems.[ModifyUserId]
      ,cdlItems.[ItemTypeDesc1]
      ,cdlItems.[ItemTypeDesc2]
      ,cdlMeasures.Code              cdlMeasuresCode
      ,cdlMeasures.DescriptionCz     cdlMeasuresDescriptionCz
      
  FROM [dbo].[VydejkySprWrhMaterials]              VSWM
  INNER JOIN cdlDestinationPlaces                   cDp  ON VSWM.[Subscribers]        = cDp.ID
  INNER JOIN [dbo].[cdlDestinationPlacesContacts]  cDPC  ON VSWM.[SubscribersContact] = cDPC.ID
  INNER JOIN [dbo].[cdlItems]                            ON VSWM.[MaterialCode]       = cdlItems.ID
  INNER JOIN [dbo].[cdlMeasures]                         ON cdlItems.MeasuresId       = cdlMeasures.ID
  






