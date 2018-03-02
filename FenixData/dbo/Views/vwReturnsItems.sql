
CREATE VIEW [dbo].[vwReturnsItems]
AS
/*
-- ===================================================================================================================
-- Description  : zobrazuje část hlavičky VR1 - Vratky (returned equipment)
-- Created by   : Weczerek Max
-- Created date : 2014-09-09
-- Edited date  : 2015-02-23  M. Rezler  (celkova zmena - grupovani)
--              : 2015-10-23  M. Rezler   úprava ReconciliationAnoNe 
--              : 2015-10-29  M. Rezler   ReconciliationAnoNe určováno voláním funkce
-- ===================================================================================================================
*/

SELECT CMR.[MessageId]
      ,CMR.[MessageTypeId]
      ,CMR.[MessageDescription]
      ,CMR.[MessageDateOfReceipt]
      ,CMR.[Reconciliation]			
			
			,(SELECT [dbo].[fnReconciliationDescription](CMR.[Reconciliation])) AS [ReconciliationAnoNe]
						
    --,CASE CMR.[Reconciliation]			--2015-10-29
    -- WHEN 0 THEN '?'								--2015-10-29
		-- WHEN 1 THEN 'Schváleno'				--2015-10-29
    -- WHEN 2 THEN 'Zamítnuto'				--2015-10-29
		-- WHEN 3 THEN 'D0 odeslána'			--2015-10-29
    -- --ELSE '?'										--2015-10-29
    --END [ReconciliationAnoNe]			--2015-10-29

      ,CMR.[IsActive]
      ,CMR.[ModifyDate]
      ,CMR.[ModifyUserId]
FROM [dbo].[CommunicationMessagesReturn] CMR
GROUP BY CMR.[MessageId], CMR.[MessageTypeId], CMR.[MessageDescription], CMR.[MessageDateOfReceipt], CMR.[Reconciliation], 
         CMR.[IsActive], CMR.[ModifyDate], CMR.[ModifyUserId]

			--SELECT RI.[ID]
			--      ,RI.[CMSOId]
			--      ,RI.[ItemOrKitQualityId]
			--      ,RI.[ItemOrKitQuality]
			--      ,RI.[KitSNs]
			--      ,RI.[IsActive]
			--      ,RI.[ModifyDate]
			--      ,RI.[ModifyUserId]
			--      ,R.MessageId
			--      ,R.[MessageDescription]
			--      ,R.[Reconciliation]
			--      ,CASE R.[Reconciliation]
			--       WHEN 1 THEN 'Schváleno'
			--       WHEN 2 THEN 'Zamítnuto'
			--       ELSE '?'
			--       END [ReconciliationAnoNe]
			--      ,R.[MessageDateOfReceipt]
			--      ,R.[IsActive] RIsActive
			--  FROM       [dbo].[CommunicationMessagesReturnItemsSN]  RI
			--  INNER JOIN [dbo].[CommunicationMessagesReturn]       R
			--  ON RI.[CMSOId] = R.ID

