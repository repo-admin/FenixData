
CREATE VIEW [dbo].[vwVR2Hd]
AS
  /*
-- ==========================================================================================================
-- Description  : zobrazuje Returned Item (VR2 - Vratky příslušenství)
-- Created by   : Weczerek Max
-- Created date : 2014-10-10
-- Edited date  : 2015-10-26  M. Rezler .. rozšíření ReconciliationAnoNe
--              : 2015-10-29  M. Rezler .. ReconciliationAnoNe určováno voláním funkce
-- ==========================================================================================================
  */
SELECT RI.[ID],RI.[MessageId],RI.[MessageTypeId],RI.[MessageDescription],RI.[MessageDateOfReceipt]
,RI.[Reconciliation]

,(SELECT [dbo].[fnReconciliationDescriptionUpper](RI.[Reconciliation])) AS ReconciliationAnoNe

--,CASE RI.[Reconciliation]				--2015-10-29
-- 	WHEN 0 THEN '?'								--2015-10-29, 2015-10-26
--	  WHEN 1 THEN 'ODSOUHLASENO'		--2015-10-29
--	  WHEN 2 THEN 'ZAMÍTNUTO'				--2015-10-29
--	  WHEN 3 THEN 'D0 odeslána'			--2015-10-29, 2015-10-26
--	--ELSE '?'												--2015-10-29, 2015-10-26
--END ReconciliationAnoNe					--2015-10-29

,RI.[IsActive],RI.[ModifyDate],RI.[ModifyUserId], cMT.DescriptionCz
FROM [dbo].[CommunicationMessagesReturnedItem]  RI
INNER JOIN [dbo].[cdlMessageTypes]   cMT
ON RI.MessageTypeId = cMT.ID

