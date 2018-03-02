
CREATE VIEW [dbo].[vwReceptionConfirmationHd]
AS
  /*
  -- ============================================================================================================
-- Created by   : Weczerek Max
-- Created date : 2014-07-23, 2015-10-20
-- Description  : zobrazuje Reception Confirmation + hlavicka z tabulky [dbo].[CommunicationMessagesReceptionSent]
-- Parameters   :
-- Edited       : 2015-10-20 M.Rezler rozšíření ReconciliationYesNo 
--              : 2015-10-27 M.Rezler zúžení ReconciliationYesNo
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
			 WHEN 0 THEN '?'			-- 2015-10-20 
       WHEN 1 THEN 'Ano'
       WHEN 2 THEN 'Ne'
			 WHEN 3 THEN 'Ne'			-- 2015-10-20 
			 --WHEN 4 THEN 'Ne'   -- 2015-10-27 
       --Else '?'						-- 2015-10-20 
       END ReconciliationYesNo
      ,CMRS.MessageDateOfShipment
      ,CMRS.ItemDateOfDelivery
      ,ISNULL(CAST(FHOH.RadaDokladu AS VARCHAR(50)) + ' ' + CAST(FHOH.PoradoveCislo AS VARCHAR(50)),'') AS HeliosObj
      ,CMRC.IsActive
      ,CMRS.Notice
      ,CMRS.HeliosOrderId
  FROM [dbo].[CommunicationMessagesReceptionConfirmation]   CMRC
  INNER JOIN [dbo].[vwCMRSent]                              CMRS -- [dbo].[CommunicationMessagesReceptionSent]     CMRS
      ON CMRC.CommunicationMessagesSentId = CMRS.Id
  LEFT OUTER JOIN [dbo].[FenixHeliosObjHla]                 FHOH
      ON CMRS.HeliosOrderId = FHOH.ID
  WHERE CMRC.IsActive = 1 AND CMRS.IsActive = 1 

  -- AND CMRC.Reconciliation = 0 

