
CREATE VIEW [dbo].[vwShipmentConfirmationHd]
AS
  /*
-- ===================================================================================================================
-- Description  : zobrazuje shipment Confirmation + hlavicka z tabulky [dbo].[CommunicationMessagesShipmentOrdersSent]
-- Created by   : Weczerek Max
-- Created date : 2014-08-31
-- Edited date  : 2014-09-17, 2014-10-03. 2014-10-20 - vše M. Weczerek
--                2015-02-23  M. Rezler .. přidány sloupce: City
--                                                          OrderTypeID {CPE = 1, MAT = 2}  
--                                                          OrderTypeDescription {'Objednávka CPE', 'Objednávka MAT'}
--                                                          ModifyUserId, ModifyUserLastName, ModifyUserFirstName 
--                2015-05-05  M. Rezler .. zrusena chybna absolutni reference pro tab. [dbo].[cdlDestinationPlaces]  
--									2015-10-26  M.Rezler  .. rozšíření ReconciliationYesNo 
--                2015-10-30  M. Rezler .. ReconciliationYesNo určováno voláním funkce
-- ===================================================================================================================
  */
SELECT CMRC.[ID]
      ,CMRC.[MessageId]
      ,CMRC.[MessageTypeId]
      ,CMRC.[MessageDescription]
      ,CMRC.[MessageDateOfReceipt]
      ,CMRC.ShipmentOrderID
      ,CMRC.[Reconciliation]

			,(SELECT [dbo].[fnReconciliationDescriptionUpper](CMRC.[Reconciliation])) AS ReconciliationYesNo

    --,CASE CMRC.[Reconciliation]				--2015-10-30
		--		WHEN 0 THEN '?'									--2015-10-30, 2015-10-26
    --  WHEN 1 THEN 'SCHVÁLENO'  ---ANO	--2015-10-30
    --  WHEN 2 THEN 'ZAMÍTNUTO'  -- Ne		--2015-10-30
		--		WHEN 3 THEN 'D0 ODESLÁNA'				--2015-10-30, 2015-10-26
    ----Else '?'													--2015-10-30, 2015-10-26
    --END ReconciliationYesNo						--2015-10-30
      
			,CMRS.MessageDateOfShipment
      ,CMRS.[RequiredDateOfShipment]
      --,COALESCE(CAST(CMKSI.HeliosOrderID AS VARCHAR(50)),'') AS HeliosObj
      ,CMRC.IsActive
      ,CMRC.ModifyDate
      --,CMRS.Notice
      --,CMRS.HeliosOrderId
      ,cDP.CompanyName
	    ,cDP.ID CompanyID
	    ,cDP.City 
	    ,CASE WHEN CMRS.IdWf IS NULL THEN 1 ELSE 2 END as 'OrderTypeID'
	    ,CASE WHEN CMRS.IdWf IS NULL THEN N'Objednávka CPE' ELSE N'Objednávka MAT' END as 'OrderTypeDescription'
	    ,CMRS.ModifyUserId
	    ,CASE WHEN zicUser.ZC_ID IS NULL THEN ' ' ELSE zicUser.LAST_NAME END as 'ModifyUserLastName'
	    ,CASE WHEN zicUser.ZC_ID IS NULL THEN ' ' ELSE zicUser.FIRST_NAME END as 'ModifyUserFirstName'
FROM [dbo].[CommunicationMessagesShipmentOrdersConfirmation]  CMRC
INNER JOIN [dbo].[CommunicationMessagesShipmentOrdersSent]    CMRS
      ON CMRC.ShipmentOrderID = CMRS.Id
INNER JOIN [dbo].[cdlDestinationPlaces] cDP
      ON CMRC.CustomerId = cDP.ID  
LEFT OUTER JOIN (SELECT [ZC_ID], [LAST_NAME], [FIRST_NAME] FROM zicyz.dbo.VW_EMPLOYEES) zicUser
	    ON CMRS.ModifyUserId = zicUser.ZC_ID
WHERE CMRC.IsActive = 1 AND CMRS.IsActive = 1 

  -- AND CMRC.Reconciliation = 0 
  
