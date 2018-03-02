




CREATE VIEW [dbo].[vwItems]
AS

SELECT It.[ID]
      ,It.[Code]
      ,It.[DescriptionCz]
      ,It.[DescriptionEng]
      ,It.[IsActive]
      ,It.[ModifyDate]
      ,It.[ModifyUserId]
      ,It.[ItemType]
      --,Mea.[ID]               MeaID
      ,Mea.[Code]             MeaCode
      ,Mea.[DescriptionCz]    MeaDescriptionCz
      ,Mea.[DescriptionEng]   MeaDescriptionEng
      --,Pckg.[ID]              PckgID
      ,Pckg.[Code]            PckgCode
      ,Pckg.[DescriptionCz]   PckgDescriptionCz
      ,Pckg.[DescriptionEng]  PckgDescriptionEng
      ,Mea.[IsActive]         MeaIsActive
      ,Pckg.[IsActive]        PckgIsActive
      ,It.[MeasuresId]
      ,It.[ItemTypesId]
      ,It.[PackagingId]
      ,cIT.[Code]             cITCode
      ,cIT.[DescriptionCz]    cITDescriptionCz
      ,It.[GroupGoods]
  FROM [dbo].[cdlItems]                 It
  LEFT OUTER JOIN [dbo].[cdlMeasures]   Mea
  ON It.MeasuresId = Mea.ID
  LEFT OUTER JOIN [dbo].[cdlPackages]   Pckg
  ON Pckg.ID = It.[PackagingId]
  LEFT OUTER JOIN [dbo].[cdlItemTypes]       cIT
  ON It.[ItemTypesId] = cIT.Id


