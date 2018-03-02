CREATE VIEW [dbo].[vwCMSOsent]
/*
2014-09-25
2014-10-02
2015-01-08
2015-02-13  M. Rezler     přidány 2 sloupce OrderTypeID {CPE = 1, MAT = 2}  
                                            OrderTypeDescription {'Objednávka CPE', 'Objednávka MAT'}
2015-02-23  M. Rezler     přidány 2 sloupce ModifyUserLastName  
                                            ModifyUserFirstName  
2015-05-26  M. Rezler     přidán sloupec Remark  
*/
AS
SELECT CMSOS.[ID]
      ,CMSOS.[MessageId]
      ,CMSOS.[MessageTypeId]
      ,CMSOS.[MessageDescription]
      ,CMSOS.[MessageDateOfShipment]
      ,CMSOS.[RequiredDateOfShipment]
      ,CMSOS.[MessageStatusId]
      ,CMSOS.[HeliosOrderId]
      ,CMSOS.[CustomerID]
      ,CMSOS.[CustomerName]
      ,CMSOS.[CustomerAddress1]
      ,CMSOS.[CustomerAddress2]
      ,CMSOS.[CustomerAddress3]
      ,CMSOS.[CustomerCity]
      ,CMSOS.[CustomerZipCode]
      ,CMSOS.[CustomerCountryISO]
      ,CMSOS.[ContactID]
      ,CMSOS.[ContactTitle]
      ,CMSOS.[ContactFirstName]
      ,CMSOS.[ContactLastName]
      ,CMSOS.[ContactPhoneNumber1]
      ,CMSOS.[ContactPhoneNumber2]
      ,CMSOS.[ContactFaxNumber]
      ,CMSOS.[ContactEmail]
      ,CMSOS.[IsManually]
      ,CMSOS.[StockId]
      ,CMSOS.[IsActive]
      ,ISNULL(x.IssueTypeText,'')+'  '+ ISNULL(CAST(CMSOS.IdWf AS VARCHAR(50)),'') IdWf
      ,CMSOS.[ModifyDate]
      ,CMSOS.[ModifyUserId]
	  ,cS.Name
      ,cDP.CompanyName
      ,cSt.[Code]
      ,cSt.DescriptionCz
      ,ISNULL(CMRC.Reconciliation,-1) Reconciliation
	  ,CASE WHEN CMSOS.IdWf IS NULL THEN 1 ELSE 2 END as 'OrderTypeID'
	  ,CASE WHEN CMSOS.IdWf IS NULL THEN N'Objednávka CPE' ELSE N'Objednávka MAT' END as 'OrderTypeDescription'
	  ,CASE WHEN zicUser.ZC_ID IS NULL THEN ' ' ELSE zicUser.LAST_NAME END as 'ModifyUserLastName'
	  ,CASE WHEN zicUser.ZC_ID IS NULL THEN ' ' ELSE zicUser.FIRST_NAME END as 'ModifyUserFirstName'
		,CMSOS.Remark as 'Remark'
  FROM [dbo].[CommunicationMessagesShipmentOrdersSent] CMSOS
  INNER JOIN [dbo].[cdlStocks]  cS
  ON CMSOS.[StockId] = cS.ID
  INNER JOIN [dbo].[cdlDestinationPlaces]  cDP
  ON CMSOS.[CustomerId] = cDP.ID
  LEFT OUTER JOIN [dbo].[cdlDestinationPlacesContacts] cDPC
  ON CMSOS.[ContactId] = cDPC.ID
    INNER JOIN [dbo].[cdlStatuses]   cSt
  ON CMSOS.[MessageStatusId] = cSt.ID
LEFT OUTER JOIN (SELECT DISTINCT Reconciliation, [ShipmentOrderID]  FROM [dbo].[CommunicationMessagesShipmentOrdersConfirmation] WHERE [Reconciliation] = 2)  CMRC
  ON CMSOS.ID = CMRC.[ShipmentOrderID]
LEFT OUTER JOIN (SELECT DISTINCT CASE [IssueType] WHEN 0 THEN 'V ' WHEN 1 THEN 'L ' ELSE '' END IssueTypeText, [IdWf], [Subscribers] FROM [dbo].[VydejkySprWrhMaterials] ) x
  ON CMSOS.IdWf = x.IdWf
LEFT OUTER JOIN (SELECT [ZC_ID], [LAST_NAME], [FIRST_NAME] FROM zicyz.dbo.VW_EMPLOYEES) zicUser
  ON CMSOS.ModifyUserId = zicUser.ZC_ID
where CMSOS.[CustomerID] = x.Subscribers OR CMSOS.IdWf IS NULL


/*  20150108  8.1.2015
SELECT CMSOS.[ID]
      ,CMSOS.[MessageId]
      ,CMSOS.[MessageTypeId]
      ,CMSOS.[MessageDescription]
      ,CMSOS.[MessageDateOfShipment]
      ,CMSOS.[RequiredDateOfShipment]
      ,CMSOS.[MessageStatusId]
      ,CMSOS.[HeliosOrderId]
      ,CMSOS.[CustomerID]
      ,CMSOS.[CustomerName]
      ,CMSOS.[CustomerAddress1]
      ,CMSOS.[CustomerAddress2]
      ,CMSOS.[CustomerAddress3]
      ,CMSOS.[CustomerCity]
      ,CMSOS.[CustomerZipCode]
      ,CMSOS.[CustomerCountryISO]
      ,CMSOS.[ContactID]
      ,CMSOS.[ContactTitle]
      ,CMSOS.[ContactFirstName]
      ,CMSOS.[ContactLastName]
      ,CMSOS.[ContactPhoneNumber1]
      ,CMSOS.[ContactPhoneNumber2]
      ,CMSOS.[ContactFaxNumber]
      ,CMSOS.[ContactEmail]
      ,CMSOS.[IsManually]
      ,CMSOS.[StockId]
      ,CMSOS.[IsActive]
      ,ISNULL(x.IssueTypeText,'')+'  '+ ISNULL(CAST(CMSOS.IdWf AS VARCHAR(50)),'') IdWf
      ,CMSOS.[ModifyDate]
      ,CMSOS.[ModifyUserId]      ,cS.Name
      ,cDP.CompanyName
      ,cSt.[Code]
      ,cSt.DescriptionCz
      ,ISNULL(CMRC.Reconciliation,-1) Reconciliation
  FROM [dbo].[CommunicationMessagesShipmentOrdersSent] CMSOS
  INNER JOIN [dbo].[cdlStocks]  cS
  ON CMSOS.[StockId] = cS.ID
  INNER JOIN [dbo].[cdlDestinationPlaces]  cDP
  ON CMSOS.[CustomerId] = cDP.ID
  LEFT OUTER JOIN [dbo].[cdlDestinationPlacesContacts] cDPC
  ON CMSOS.[ContactId] = cDPC.ID
    INNER JOIN [dbo].[cdlStatuses]   cSt
  ON CMSOS.[MessageStatusId] = cSt.ID
 LEFT OUTER JOIN (SELECT DISTINCT Reconciliation, [ShipmentOrderID]  FROM [dbo].[CommunicationMessagesShipmentOrdersConfirmation] WHERE [Reconciliation] = 2)  CMRC
  ON CMSOS.ID = CMRC.[ShipmentOrderID]
LEFT OUTER JOIN (SELECT DISTINCT CASE [IssueType] WHEN 0 THEN 'V ' WHEN 1 THEN 'L ' ELSE '' END IssueTypeText, [IdWf] FROM [dbo].[VydejkySprWrhMaterials] ) x
  ON CMSOS.IdWf = x.IdWf


  */



