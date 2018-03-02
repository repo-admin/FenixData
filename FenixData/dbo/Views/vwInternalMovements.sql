CREATE VIEW [dbo].[vwInternalMovements]
AS

/*
-- =============================================================================================================
-- Description  : zobrazuje Internal Movements (Interní pohyby)
-- Created by   : Rezler Michal
-- Created date : 2015-05-06
-- Edited date  : 2015-05-20  Rezler Michal
--                            přidány sloupce Remark, ModifyUserLastName, ModifyUserFirstName 
--                2015-07-30  Rezler Michal
--                            přidány sloupce MovementsAddSubBaseID, MovementsAddSubBaseAbbrev
-- =============================================================================================================
*/

SELECT IM.[ID]																			AS [ID]
			,IM.[ItemOrKitID]													    AS [ItemOrKitID]
      ,IM.[ItemVerKit]													    AS [ItemVerKit]
      ,CASE IM.[ItemVerKit] 
          WHEN 0 THEN 'Mater/zb'
          WHEN 1 THEN 'Kit'
          ELSE '???'
       END																					AS [ItemVerKitDescription]           
      ,IM.[ItemOrKitUnitOfMeasureId]								AS [ItemOrKitUnitOfMeasureId]
			,COALESCE(cM.Code,'')													AS [MeasureCode]
			,IM.[IternalMovementQuantity]                 AS [IternalMovementQuantity]
      ,CAST(IM.[IternalMovementQuantity] AS INT)    AS [IternalMovementQuantityInteger]
      ,IM.[ItemOrKitQuality]												AS [QualityID]
      ,cQ.Code																			AS [QualityCode]						
      ,COALESCE(IM.[ItemOrKitDescription],'')				AS [Description]			  
      ,IM.[MovementsTypeID]													AS [MovementsTypeID]
			,IMT.[Description]														AS [MovementTypeDescription]
      ,IM.[MovementsDecisionID]											AS [MovementsDecisionID]
			,IMD.[Description]														AS [MovementsDecisionDescription]
			,IM.[CreatedDate]															AS [CreatedDate]
			,IM.[CreatedUserId]														AS [CreatedUserId]
      ,IM.[IsActive]																AS [IsActive]
      ,IM.[ModifyDate]															AS [ModifyDate]
      ,IM.[ModifyUserId]														AS [ModifyUserId]
			,CASE WHEN zicUser.ZC_ID IS NULL THEN ' ' ELSE zicUser.LAST_NAME END	as 'CreatedUserLastName'
			,CASE WHEN zicUser.ZC_ID IS NULL THEN ' ' ELSE zicUser.FIRST_NAME END as 'CreatedUserFirstName'
			,IM.[Remark]                                  AS [Remark]
			,IMB.[ID]                                     AS [MovementsAddSubBaseID]
			,IMB.[Abbreviation]                           AS [MovementsAddSubBaseAbbrev]
  FROM [dbo].[InternalMovements]   IM
  LEFT OUTER JOIN [dbo].[cdlItems]   cI
      ON IM.[ItemOrKitID] = cI.[ID] 
  LEFT OUTER JOIN [dbo].[cdlMeasures] cM
      ON IM.[ItemOrKitUnitOfMeasureId] = cM.[ID]
  LEFT OUTER JOIN [dbo].[cdlQualities] cQ
      ON IM.[ItemOrKitQuality] = cQ.[ID]
	LEFT OUTER JOIN [dbo].[InternalMovementsTypes] IMT
			ON IM.[MovementsTypeID] = IMT.[ID]
	LEFT OUTER JOIN [dbo].[InternalMovementsDecisions] IMD
			ON IM.[MovementsDecisionID] = IMD.[ID]
	LEFT OUTER JOIN [dbo].[InternalMovementsAddSubBase] IMB
			ON IM.MovementsAddSubBaseID = IMB.ID
	LEFT OUTER JOIN (SELECT [ZC_ID], [LAST_NAME], [FIRST_NAME] FROM zicyz.dbo.VW_EMPLOYEES) zicUser
			ON IM.[CreatedUserId] = zicUser.ZC_ID

