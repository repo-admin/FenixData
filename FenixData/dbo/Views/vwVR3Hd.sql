
CREATE VIEW [dbo].[vwVR3Hd]
AS
-- ==========================================================================================================
-- Description  : zobrazuje VR3 - Expedice do TRR 
-- Created by   : Weczerek Max
-- Created date : 2014-10-10
-- Edited date  : 2015-10-26  M.Rezler  .. rozšíření ReconciliationAnoNe
--              : 2015-10-29  M. Rezler .. ReconciliationAnoNe určováno voláním funkce
-- ==========================================================================================================
SELECT RI.[ID],RI.[MessageId],RI.[MessageTypeId],RI.[MessageDescription]
,RI.[Reconciliation]

,(SELECT [dbo].[fnReconciliationDescriptionUpper](RI.[Reconciliation])) AS ReconciliationAnoNe

--,CASE RI.[Reconciliation]				--2015-10-29
--		WHEN 0 THEN '?'								--2015-10-29, 2015-10-26
--		WHEN 1 THEN 'ODSOUHLASENO'		--2015-10-29
--		WHEN 2 THEN 'ZAMÍTNUTO'				--2015-10-29
--		WHEN 3 THEN 'D0 odeslána'			--2015-10-29, 2015-10-26
--	--ELSE '?'												--2015-10-29, 2015-10-26
--END ReconciliationAnoNe					--2015-10-29

,RI.[IsActive],RI.[ModifyDate],RI.[ModifyUserId], cMT.DescriptionCz
,cDP.CompanyName,cDPC.ContactName
FROM [dbo].[CommunicationMessagesReturnedShipment] RI
INNER JOIN [dbo].[cdlMessageTypes]   cMT
ON RI.MessageTypeId = cMT.ID
LEFT OUTER JOIN [dbo].[cdlDestinationPlaces]  cDP
ON RI.CustomerID = cDP.ID
LEFT OUTER JOIN [dbo].[cdlDestinationPlacesContacts]  cDPC
ON RI.ContactID = cDPC.ID





