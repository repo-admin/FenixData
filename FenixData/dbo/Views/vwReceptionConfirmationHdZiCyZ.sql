

CREATE VIEW [dbo].[vwReceptionConfirmationHdZiCyZ]
AS
  /*
  -- ============================================================================================================
-- Created by   : Weczerek Max
-- Created date : 2016-05-25
-- Description  : zobrazuje Reception Confirmation + hlavicka z tabulky [dbo].[CommunicationMessagesReceptionSent]
-- Parameters   :
-- Edited       :  
--              : 
-- Notice       : musí se nejprve odzkoušet; zatím se v aplikaci nepoužívá    2016-05-25
-- ===============================================================================================================
  */
SELECT CMRC.[ID]
      ,CMRC.[MessageId]
      ,CMRC.[MessageTypeId]
      ,CMRC.[MessageDescription]
      ,CMRC.[MessageDateOfReceipt]
      ,CMRC.[CommunicationMessagesSentId]
      ,CMRC.[ItemSupplierId]
      ,CMRC.[ItemSupplierDescription]
      ,CMRC.[Reconciliation]
      ,CASE CMRC.[Reconciliation]
			 WHEN 0 THEN '?'			
          WHEN 1 THEN 'Ano'
          WHEN 2 THEN 'Ne'
			 WHEN 3 THEN 'Ne'			
          Else '???'						
       END ReconciliationYesNo
      ,CMRS.MessageDateOfShipment
      ,CMRS.ItemDateOfDelivery
      ,ISNULL(CAST(FHOH.RadaDokladu AS VARCHAR(50)) + ' ' + CAST(FHOH.PoradoveCislo AS VARCHAR(50)),'') AS HeliosObj
      ,CMRC.IsActive
      ,CMRS.Notice
      ,CMRS.HeliosOrderId
      ,zc.FULL_NAME
  FROM [dbo].[CommunicationMessagesReceptionConfirmation]   CMRC
  INNER JOIN [dbo].[vwCMRSent]                              CMRS -- [dbo].[CommunicationMessagesReceptionSent]     CMRS
      ON CMRC.CommunicationMessagesSentId = CMRS.Id
  LEFT OUTER JOIN [dbo].[FenixHeliosObjHla]                 FHOH
      ON CMRS.HeliosOrderId = FHOH.ID
  LEFT OUTER JOIN ZiCyZ.[dbo].[VW_EMPLOYEES]    zc
      ON CMRC.ModifyUserId = zc.ZC_ID
  WHERE CMRC.IsActive = 1 AND CMRS.IsActive = 1 
