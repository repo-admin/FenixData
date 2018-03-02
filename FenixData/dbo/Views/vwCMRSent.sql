





CREATE VIEW [dbo].[vwCMRSent]
AS
/*

*/
SELECT DISTINCT RS.[ID]
      ,RS.[MessageId]
      ,RS.[MessageType]
      ,RS.[MessageDescription]
      ,RS.[MessageDateOfShipment]
      ,RS.[MessageStatusId]
      ,RS.[HeliosOrderId]
      ,RS.[ItemSupplierId]
      ,RS.[ItemSupplierDescription]
      ,RS.[ItemDateOfDelivery]
      ,RS.[IsManually]
      ,RS.[Notice]
      ,RS.[IsActive]
      ,RS.[ModifyDate]
      ,RS.[ModifyUserId]
      ,cS.DescriptionCz
      ,ISNULL(CAST(FHOH.RadaDokladu AS VARCHAR(50)) +' '+CAST(FHOH.PoradoveCislo AS VARCHAR(50)),'') AS HeliosObj
      ,RS.[RadaDokladu]
      ,RS.[PoradoveCislo]
      ,ISNULL(CMRC.[Reconciliation],-1)  Reconciliation
  FROM [dbo].[CommunicationMessagesReceptionSent] RS
  INNER JOIN [dbo].[cdlStatuses]                  cS
  ON RS.[MessageStatusId] = cS.Id
  LEFT OUTER JOIN [dbo].[FenixHeliosObjHla]                 FHOH
  ON RS.[RadaDokladu] = FHOH.RadaDokladu COLLATE SQL_Czech_CP1250_CI_AS AND RS.[PoradoveCislo] = FHOH.PoradoveCislo
  LEFT OUTER JOIN (SELECT DISTINCT Reconciliation, CommunicationMessagesSentId  FROM [dbo].[CommunicationMessagesReceptionConfirmation] WHERE [Reconciliation] = 2)  CMRC
  ON RS.ID = CMRC.[CommunicationMessagesSentId]
 --LEFT OUTER JOIN [dbo].[CommunicationMessagesReceptionConfirmation] CMRC
  --ON RS.ID = CMRC.CommunicationMessagesSentId












