





/****** Script for SelectTopNRows command from SSMS  ******/
CREATE VIEW [dbo].[vwKitsHd]
AS
SELECT K.[ID]
      ,K.Code
      ,K.[DescriptionCz]
      ,K.[DescriptionEng]
      ,K.[MeasuresId]
      ,K.[MeasuresCode]
      ,K.[KitQualitiesId]
      ,K.[KitQualitiesCode]
      ,K.[IsSent]
      ,K.[SentDate]
      ,K.Packaging
      ,K.[IsActive]
      ,K.[ModifyDate]
      ,K.[ModifyUserId]
      ,G.[Code] AS GroupsCode
      ,K.[GroupsId]
  FROM [dbo].[cdlKits]    K
  LEFT OUTER JOIN [dbo].[cdlKitGroups]     G
  ON K.[GroupsId] = G.Id










