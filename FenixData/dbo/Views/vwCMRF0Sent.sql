
CREATE VIEW [dbo].[vwCMRF0Sent]
AS
/*
-- =============================================================================================================
-- Description  : zobrazuje Refurbished Order (RF0 --- Objednávka závozu odněkud na ND, jakost Repasované, Nové)
-- Created by   : Weczerek Max
-- Created date : 
-- Edited date  : 2014-09-23  M. Weczerek
--				  2014-09-24  M. Weczerek
--                2015-03-06  M. Rezler .. přidány sloupce: ModifyUserLastName, ModifyUserFirstName
-- =============================================================================================================
*/
SELECT RF0.[ID]
      ,RF0.[MessageId]
      ,RF0.[MessageTypeId]
      ,RF0.[MessageDescription]
      ,RF0.[MessageDateOfShipment]
      ,RF0.[CustomerID]
      ,RF0.[MessageStatusId]
      ,RF0.[CustomerDescription]
      ,RF0.[DateOfDelivery]
      ,RF0.[IsManually]
      ,RF0.[StockId]
      ,RF0.[Notice]
      ,RF0.[IsActive]
      ,RF0.[ModifyDate]
      ,RF0.[ModifyUserId]
      ,DP.[OrganisationNumber]
      ,DP.[CompanyName]
      ,DP.[City] CustomerCity
      ,DP.[StreetName]
      ,DP.[StreetOrientationNumber]
      ,DP.[StreetHouseNumber]
      ,DP.[ZipCode]
      ,DP.[IdCountry]
      ,DP.[ICO]
      ,DP.[DIC]
      ,DP.[Type]
      ,DP.[IsSent]
      ,DP.[SentDate]
      ,DP.[CountryISO]
      ,DP.[IsActive]     [DpIsActive]
      ,DP.[ModifyDate]   [DpModifyDate]
      ,DP.[ModifyUserId] [DpModifyUserId]
      ,ST.DescriptionCz
      ,ISNULL(CMRC.[Reconciliation],-1)  Reconciliation
	  ,CASE WHEN zicUser.ZC_ID IS NULL THEN ' ' ELSE zicUser.LAST_NAME  END as 'ModifyUserLastName'
	  ,CASE WHEN zicUser.ZC_ID IS NULL THEN ' ' ELSE zicUser.FIRST_NAME END as 'ModifyUserFirstName'
  FROM [dbo].[CommunicationMessagesRefurbishedOrder]     RF0
  INNER JOIN [dbo].[cdlDestinationPlaces]                DP
     ON RF0.[CustomerID] = DP.[ID]
  INNER JOIN [dbo].[cdlStatuses]                         ST
     ON RF0.[MessageStatusId] = ST.Code
  LEFT OUTER JOIN (SELECT DISTINCT Reconciliation,[RefurbishedOrderID]  FROM [dbo].[CommunicationMessagesRefurbishedOrderConfirmation] WHERE [Reconciliation] = 2)  CMRC
     ON RF0.ID = CMRC.[RefurbishedOrderID]
  LEFT OUTER JOIN (SELECT [ZC_ID], [LAST_NAME], [FIRST_NAME] FROM zicyz.dbo.VW_EMPLOYEES) zicUser
     ON RF0.ModifyUserId = zicUser.ZC_ID

