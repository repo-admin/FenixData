

CREATE VIEW [dbo].[vwPOMOC] AS

SELECT 1 AS x
/*  28.7.2014

UPDATE [dbo].[cdlItems]
   SET [ItemTypesId] = 1
      ,[ItemType] = 'NW'
 WHERE [GroupGoods] IN ('010' ,'030','040','050','060','070','080','110','501','901')


 UPDATE [dbo].[cdlItems]
   SET [ItemTypesId] = 3
      ,[ItemType] = 'SPP'
 WHERE [GroupGoods] IN ('091' ,'092','590','692')


 
 UPDATE [dbo].[cdlItems]
   SET [ItemTypesId] = 3
      ,[ItemType] = 'CPE'
 WHERE [GroupGoods] IN ('591' ,'593','691')


  
 UPDATE [dbo].[cdlItems]
   SET [ItemTypesId] = 4
      ,[ItemType] = 'MKT'
 WHERE [GroupGoods] IN ('020')

 */


 /*
SELECT * FROM  [dbo].[CommunicationMessagesReceptionSent]
SELECT * FROM  [dbo].[CommunicationMessagesReceptionSentItems]
SELECT * FROM  [dbo].[CommunicationMessagesReceptionConfirmation]
SELECT * FROM  [dbo].[CommunicationMessagesReceptionConfirmationItems]
SELECT * FROM  [dbo].[CommunicationMessagesKittingsSentItems]
SELECT * FROM  [dbo].[CommunicationMessagesKittingsSent]
SELECT * FROM  [dbo].[CommunicationMessagesKittingsConfirmationItems]
SELECT * FROM  [dbo].[CommunicationMessagesKittingsConfirmation]
SELECT * FROM  [dbo].[CommunicationMessagesKittingsApproval]
SELECT * FROM  [dbo].[CardStockItems]
SELECT * FROM  [dbo].[CardStockItemsDetails]
SELECT * FROM  [dbo].[cdlKits]
SELECT * FROM  [dbo].[cdlKitsItems]


--USE [FenixW]
--GO

--ALTER TABLE [dbo].[CommunicationMessagesReceptionConfirmation] DROP CONSTRAINT [FK_CommunicationMessagesReceptionConfirmation_CommunicationMessagesReceptionSent]
--GO

ALTER TABLE [dbo].[CommunicationMessagesReceptionConfirmation]  WITH CHECK ADD  CONSTRAINT [FK_CommunicationMessagesReceptionConfirmation_CommunicationMessagesReceptionSent] FOREIGN KEY([CommunicationMessagesSentId])
REFERENCES [dbo].[CommunicationMessagesReceptionSent] ([ID])
GO

ALTER TABLE [dbo].[CommunicationMessagesReceptionConfirmation] CHECK CONSTRAINT [FK_CommunicationMessagesReceptionConfirmation_CommunicationMessagesReceptionSent]
GO
 */
 /*

USE [FenixW]
GO

INSERT INTO [dbo].[CardStockItems]
           ([ItemVerKit]
           ,[ItemOrKitId]
           ,[ItemOrKitUnitOfMeasureId]
           ,[ItemOrKitQuality]
           ,[ItemOrKitFree]
           ,[ItemOrKitUnConsilliation]
           ,[ItemOrKitReserved]
           ,[ItemOrKitReleasedForExpedition]
           ,[StockId]
           ,[IsActive]
)
SELECT 0,cdlI.ID,cdlI.MeasuresID,1,101,100,0,0,2,1 FROM  [dbo].[cdlItems] cdlI  INNER JOIN  [dbo].[cdlKitsItems]  cdlK ON cdlI.ID= cdlK.ItemOrKitId   WHERE cdlI.IsActive = 1 AND cdlK.IsActive = 1

  */


 /*

USE FenixW
GO


ALTER TABLE [dbo].[cdlDestinationPlacesContacts] DROP CONSTRAINT [FK_cdlDestinationPlacesContacts_cdlDestinationPlaces]
GO

ALTER TABLE [dbo].[CommunicationMessagesKittingsConfirmation] DROP CONSTRAINT [FK_CommunicationMessagesKittingsConfirmation_CommunicationMessagesReceptionSent]
GO

 DELETE FROM [dbo].[CommunicationMessagesReceptionConfirmationItems]
 GO
DBCC CHECKIDENT('CommunicationMessagesReceptionConfirmationItems',RESEED,0)
GO
 DELETE FROM [dbo].[CommunicationMessagesReceptionConfirmation]
 GO
DBCC CHECKIDENT('CommunicationMessagesReceptionConfirmation',RESEED,0)
GO

DELETE FROM [dbo].[CommunicationMessagesReceptionSentItems]
GO
DBCC CHECKIDENT('CommunicationMessagesReceptionSentItems',RESEED,0)
GO
DELETE FROM [dbo].[CommunicationMessagesReceptionSent]
GO
DBCC CHECKIDENT('CommunicationMessagesReceptionSent',RESEED,0)
GO
-- ******************
DELETE FROM [dbo].[CommunicationMessagesShipmentOrdersConfirmation]
GO
DBCC CHECKIDENT('CommunicationMessagesShipmentOrdersConfirmation',RESEED,0)
GO
DELETE FROM [dbo].[CommunicationMessagesShipmentOrdersSent]
GO
DBCC CHECKIDENT('CommunicationMessagesShipmentOrdersSent',RESEED,0)
GO
-- ******************
DELETE FROM [dbo].[CommunicationMessagesKittingsApprovalKitsSerNumSent]
GO
DBCC CHECKIDENT('CommunicationMessagesKittingsApprovalKitsSerNumSent',RESEED,0)
GO
DELETE FROM [dbo].[CommunicationMessagesKittingsApprovalKitsSent]
GO
DBCC CHECKIDENT('CommunicationMessagesKittingsApprovalKitsSent',RESEED,0)
GO
DELETE FROM [dbo].[CommunicationMessagesKittingsApprovalSent]
GO
DBCC CHECKIDENT('CommunicationMessagesKittingsApprovalSent',RESEED,0)
GO
-- ******************
DELETE  FROM  [dbo].[CommunicationMessagesKittingsConfirmationItems]
 GO
DBCC CHECKIDENT('CommunicationMessagesKittingsConfirmationItems',RESEED,0)
GO
DELETE  FROM  [dbo].[CommunicationMessagesKittingsConfirmation]
 GO
DBCC CHECKIDENT('CommunicationMessagesKittingsConfirmation',RESEED,0)
GO

DELETE  FROM  [dbo].[CommunicationMessagesKittingsSentItems]
 GO
DBCC CHECKIDENT('CommunicationMessagesKittingsSentItems',RESEED,0)
GO
DELETE  FROM  [dbo].[CommunicationMessagesKittingsSent]
 GO
DBCC CHECKIDENT('CommunicationMessagesKittingsSent',RESEED,0)
GO
 -- ********************
DELETE FROM  [dbo].[cdlKitsItems]
 GO
DBCC CHECKIDENT('cdlKitsItems',RESEED,0)
GO
DELETE  FROM  [dbo].[cdlKits]
 GO
DBCC CHECKIDENT('cdlKits',RESEED,6000000)
GO
 -- ********************
DELETE FROM  [dbo].[CardStockItems]
 GO
DBCC CHECKIDENT('CardStockItems',RESEED,0)
GO
DELETE  FROM  [dbo].[CardStockItemsDetails]
 GO
DBCC CHECKIDENT('CardStockItemsDetails',RESEED,0)
GO
 -- ********************
DELETE FROM  [dbo].[CommunicationMessagesShipmentOrdersSent]
 GO
DBCC CHECKIDENT('CommunicationMessagesShipmentOrdersSent',RESEED,0)
GO
DELETE  FROM [dbo].[CommunicationMessagesShipmentOrdersSentItems] 
 GO
DBCC CHECKIDENT('CommunicationMessagesShipmentOrdersSentItems',RESEED,0)
GO
DELETE  FROM [dbo].[CommunicationMessagesShipmentOrdersSent]
 GO
DBCC CHECKIDENT('CommunicationMessagesShipmentOrdersSentItems',RESEED,0)
GO
DELETE  FROM [dbo].[CommunicationMessagesShipmentOrdersSentItems]
GO
DELETE  FROM [dbo].[CommunicationMessagesShipmentOrdersConfirmation]
 GO
DBCC CHECKIDENT('CommunicationMessagesShipmentOrdersConfirmation',RESEED,0)
GO
DELETE  FROM [dbo].[CommunicationMessagesShipmentOrdersConfirmationItems]
 GO
DBCC CHECKIDENT('CommunicationMessagesShipmentOrdersConfirmationItems',RESEED,0)
GO 
truncate  table [dbo].[CommunicationMessagesReturnItemsSN]
GO 
truncate  table [dbo].[CommunicationMessagesReturnItems]
GO 
truncate table [dbo].[CommunicationMessagesReturn]
GO
 -- ********************
 ALTER TABLE [dbo].[CommunicationMessagesKittingsConfirmation]  WITH CHECK ADD  CONSTRAINT [FK_CommunicationMessagesKittingsConfirmation_CommunicationMessagesReceptionSent] FOREIGN KEY([KitOrderID])
REFERENCES [dbo].[CommunicationMessagesReceptionSent] ([ID])
GO

ALTER TABLE [dbo].[CommunicationMessagesKittingsConfirmation] CHECK CONSTRAINT [FK_CommunicationMessagesKittingsConfirmation_CommunicationMessagesReceptionSent]
GO
-- ======================

ALTER TABLE [dbo].[cdlDestinationPlacesContacts]  WITH CHECK ADD  CONSTRAINT [FK_cdlDestinationPlacesContacts_cdlDestinationPlaces] FOREIGN KEY([DestinationPlacesId])
REFERENCES [dbo].[cdlDestinationPlaces] ([ID])
GO

ALTER TABLE [dbo].[cdlDestinationPlacesContacts] CHECK CONSTRAINT [FK_cdlDestinationPlacesContacts_cdlDestinationPlaces]
GO

--

UPDATE [dbo].[cdlMessageNumber] SET LastFreeNumber = 1

UPDATE [dbo].[FenixHeliosObjHla] SET [Hit]=CAST(0 AS bit)

UPDATE [dbo].[cdlOrderNumber]SET LastFreeNumber = 0
 
 */




 /*
use fenix
go
SELECT CMKAS.[ID]
      ,CMKAS.[MessageId]
      ,CMKAS.[MessageTypeID]
      ,CMKAS.[MessageDescription]
      ,CMKAS.[MessageDateOfShipment]
      ,CMKAS.[RequiredReleaseDate]
      ,CMKAS.[MessageStatusID]
      ,CMKAS.[Released]
      ,CMKAS.[HeliosOrderID]
      ,CMKAS.[IsActive]
      ,CMKAS.[ModifyDate]
      ,CMKAS.[ModifyUserId]
      ,CMKAKS.[ID]
      ,CMKAKS.[ApprovalID]
      ,CMKAKS.[KitID]
      ,CMKAKS.[KitDescription]
      ,CMKAKS.[KitQuantity]
      ,CMKAKS.[KitUnitOfMeasureID]
      ,CMKAKS.[KitUnitOfMeasure]
      ,CMKAKS.[KitQualityId]
      ,CMKAKS.[KitQuality]
      ,CMKAKS.[IsActive]
      ,CMKAKS.[ModifyDate]
      ,CMKAKS.[ModifyUserId]
      ,CMKAKSN.[ID]
      ,CMKAKSN.[ApprovalKitsID]
      ,CMKAKSN.[SN1]
      ,CMKAKSN.[SN2]
      ,CMKAKSN.[IsActive]
      ,CMKAKSN.[ModifyDate]
      ,CMKAKSN.[ModifyUserId]
  FROM [dbo].[CommunicationMessagesKittingsApprovalSent]  CMKAS
  INNER JOIN [dbo].[CommunicationMessagesKittingsApprovalKitsSent] CMKAKS
      ON CMKAS.[ID] = CMKAKS.[ApprovalID]
  INNER JOIN [dbo].[CommunicationMessagesKittingsApprovalKitsSerNumSent] CMKAKSN
      ON CMKAKS.ID = CMKAKSN.[ApprovalKitsID]
  WHERE CMKAS.[IsActive] = 1 AND CMKAKS.[IsActive] = 1 AND CMKAKSN.[IsActive] = 1 
    AND RELEASED = 1 AND (CMKAS.[MessageStatusID] = 1 OR CMKAS.[MessageStatusID] = 2 )
 */
 /*
 USE [FenixW]
GO

DECLARE	@return_value int,
		@ReturnValue int,
		@ReturnMessage nvarchar(2048)

EXEC	@return_value = [dbo].[prKiSHins]
		@par1 = N'<NewDataSet><Expedice>
      <ID>4</ID>
      <ItemVerKit>1</ItemVerKit>
      <ItemOrKitID>3</ItemOrKitID>
      <ItemOrKitCode>KZP3</ItemOrKitCode>
      <DescriptionCzItemsOrKit>KZP3 591</DescriptionCzItemsOrKit>
      <ItemOrKitQuantity>10</ItemOrKitQuantity>
      <PackageTypeId>0</PackageTypeId>
      <cdlStocksName>ND</cdlStocksName>
      <DestinationPlacesId>1</DestinationPlacesId>
      <DestinationPlacesName>A03 UPC PRAHA</DestinationPlacesName>
      <DestinationPlacesContactsId>1</DestinationPlacesContactsId>
      <DestinationPlacesContactsName>Vávra</DestinationPlacesContactsName>
      <DateOfExpedition>20140907</DateOfExpedition>
      </Expedice><Expedice><ID>3</ID>
      <ItemVerKit>0</ItemVerKit>
      <ItemOrKitID>3438</ItemOrKitID>
      <ItemOrKitCode>370061</ItemOrKitCode>
      <DescriptionCzItemsOrKit>Dawn Gateway 120M HDD - DSH (D915 - DMC7000KLG)</DescriptionCzItemsOrKit>
      <ItemOrKitQuantity>1</ItemOrKitQuantity><PackageTypeId>0</PackageTypeId>
      <cdlStocksName>ND</cdlStocksName>
      <DestinationPlacesId>1</DestinationPlacesId>
      <DestinationPlacesName>A03 UPC PRAHA</DestinationPlacesName>
      <DestinationPlacesContactsId>1</DestinationPlacesContactsId>
      <DestinationPlacesContactsName>Vávra</DestinationPlacesContactsName>
      <DateOfExpedition>20140908</DateOfExpedition>
      </Expedice>
      </NewDataSet>',
		@ModifyUserId = 0,
		@ReturnValue = @ReturnValue OUTPUT,
		@ReturnMessage = @ReturnMessage OUTPUT

SELECT	@ReturnValue as N'@ReturnValue',
		@ReturnMessage as N'@ReturnMessage'

SELECT	'Return Value' = @return_value

GO


--=================================================

INSERT INTO [dbo].[cdlSuppliers]
           ([OrganisationNumber]
           ,[CompanyName]
           ,[City]
           ,[StreetName]
           ,[StreetOrientationNumber]
           ,[StreetHouseNumber]
           ,[ZipCode]
           ,[IdCountry]
           ,[ICO]
           ,[DIC]
           ,[IsSent]
           ,[SentDate]
           ,[IsActive]
           ,[ModifyDate]
           ,[ModifyUserId])
SELECT [cisloOrg]
      ,[nazev]
      ,[misto]
      ,[ulice]
      ,[orientCislo]
      ,[popisneCislo]
      ,[PSC]
      ,[idZeme]
      ,[ICO]
      ,[DIC]
,0,null,1,GetDate(),0  FROM [Ciselniky].[dbo].[tFenixOrganizace] WHERE [cisloOrg]='9393'



USE Fenix
GO


INSERT INTO [dbo].[cdlSuppliers]
           ([OrganisationNumber]
           ,[CompanyName]
           ,[City]
           ,[StreetName]
           ,[StreetOrientationNumber]
           ,[StreetHouseNumber]
           ,[ZipCode]
           ,[IdCountry]
           ,[ICO]
           ,[DIC]
           ,[IsSent]
           ,[SentDate]
           ,[IsActive]
           ,[ModifyDate]
           ,[ModifyUserId])
SELECT [cisloOrg]
      ,[nazev]
      ,[misto]
      ,[ulice]
      ,[orientCislo]
      ,[popisneCislo]
      ,[PSC]
      ,[idZeme]
      ,[ICO]
      ,[DIC]
,0,null,1,GetDate(),0  FROM [Ciselniky].[dbo].[tFenixOrganizace] WHERE [cisloOrg] NOT IN (SELECT [OrganisationNumber] FROM [dbo].[cdlSuppliers])
AND [jeDodavatel]=1


 */

 /*
USE Fenix
GO

SELECT T.ID
      ,[CMSOId]
      ,[SingleOrMaster]
      ,[HeliosOrderRecordID]
      ,[ItemVerKit]
      ,[ItemOrKitID]
      ,[ItemOrKitDescription]
      ,[ItemOrKitQuantity],[RealItemOrKitQuantity]
      ,[ItemOrKitUnitOfMeasureId]
      ,[ItemOrKitUnitOfMeasure]
      ,[ItemOrKitQualityId]
      ,[ItemOrKitQualityCode]
      ,[IncotermsId]
      ,[IncotermDescription]
      ,[RealDateOfDelivery]
      ,[RealItemOrKitQuantity]
      ,[RealItemOrKitQualityID]
      ,[RealItemOrKitQuality]
      ,[Status]
      ,[KitSNs]
      ,T.[IsActive]
      ,T.[ModifyDate]
      ,T.[ModifyUserId]
  FROM [Fenix].[dbo].[CommunicationMessagesShipmentOrdersConfirmationItems]  T
  INNER JOIN [Fenix].[dbo].[CommunicationMessagesShipmentOrdersConfirmation] H
      ON T.CMSOId = H.ID
INNER JOIN [Fenix].[dbo].[CommunicationMessagesShipmentOrdersSent] HS
ON H.ShipmentOrderID = HS.ID
  WHERE  [ItemOrKitQuantity]<>[RealItemOrKitQuantity]
  AND T.[IsActive] = 1
  AND H.[IsActive] = 1
  AND HS.[IsActive] = 1
  AND H.Reconciliation<>2
GO

SELECT TS.ID, TS.CMSOId,H.KitOrderID, TS.KitQuantity S0KitQuantity,T.KitQuantity S1KitQuantity,T.* FROM [dbo].[CommunicationMessagesKittingsConfirmationItems]   T
INNER JOIN [dbo].[CommunicationMessagesKittingsConfirmation]  H
      ON T.CMSOId = H.ID
INNER JOIN [dbo].[CommunicationMessagesKittingsSent]  HS
ON H.KitOrderID  = HS.ID
INNER JOIN [dbo].[CommunicationMessagesKittingsConfirmationItems] TS
ON HS.ID = TS.CMSOId
WHERE  
  T.[IsActive] = 1
  AND H.[IsActive] = 1
  AND HS.[IsActive] = 1
  AND H.Reconciliation<>2
  AND TS.[IsActive] = 1
  AND TS.KitQuantity <> T.KitQuantity
ORDER BY KitID


-- ===================
/****** Script for SelectTopNRows command from SSMS  ******/
SELECT S0I.[ID]                     S0IID
      ,S0I.[CMSOId]                 S0HID
      ,S0I.[SingleOrMaster]
      ,S0I.[ItemVerKit]
      ,S0I.[ItemOrKitID]
      ,S0I.[ItemOrKitDescription]
      ,S0I.[ItemOrKitQuantity]
      ,S0I.[ItemOrKitQuantityReal]
      ,S1I.ItemOrKitQuantity
      ,S0I.[ItemOrKitUnitOfMeasureId]
      ,S0I.[ItemOrKitUnitOfMeasure]
      ,S0I.[ItemOrKitQualityId]
      ,S0I.[ItemOrKitQualityCode]
      ,S0I.[ItemType]
      ,S0I.[IncotermsId]
      ,S0I.[Incoterms]
      ,S0I.[PackageValue]
      ,S0I.[ShipmentOrderSource]
      ,S0I.[VydejkyId]
      ,S0I.[CardStockItemsId]
      ,S0I.[HeliosOrderRecordId]
      ,S0I.[IsActive]
      ,S0I.[ModifyDate]
      ,S0I.[ModifyUserId]
      ,S0I.[IdRowReleaseNote]
  FROM [dbo].[CommunicationMessagesShipmentOrdersSentItems]      S0I
  INNER JOIN [dbo].[CommunicationMessagesShipmentOrdersSent]     S0H
       ON S0I.CMSOId = S0H.ID 
  INNER JOIN [dbo].[CommunicationMessagesShipmentOrdersConfirmation]  S1H
       ON S0H.ID = S1H.ShipmentOrderID
  INNER JOIN [dbo].[CommunicationMessagesShipmentOrdersConfirmationItems]  S1I
       ON S1H.ID = S1I.CMSOId AND S0I.ItemOrKitID=S1I.ItemOrKitID AND S0I.ItemOrKitQualityId=S1I.ItemOrKitQualityId AND S0I.ItemOrKitUnitOfMeasureId = S1I.ItemOrKitUnitOfMeasureId
  WHERE S1H.Reconciliation=1 
        AND  S0I.[IsActive]=1 
        AND  S0H.[IsActive]=1
        AND  S1H.[IsActive]=1
        AND  S1I.[IsActive]=1
        AND  S0I.[ItemOrKitQuantity]<>S0I.[ItemOrKitQuantityReal]
ORDER BY S0HID,S0I.ItemOrKitID

/****** Script for SelectTopNRows command from SSMS  ******/
SELECT RF0I.[ID]
      ,RF0I.[CMSOId]
      ,RF0I.[ItemVerKit]
      ,RF0I.[ItemOrKitID]
      ,RF0I.[ItemOrKitDescription]
      ,RF1I.ItemOrKitDescription
      ,RF0I.[ItemOrKitQuantity]
      ,RF0I.[ItemOrKitQuantityDelivered]
      ,RF1I.ItemOrKitQuantity
      ,RF0I.[ItemOrKitUnitOfMeasureId]
      ,RF0I.[ItemOrKitUnitOfMeasure]
      ,RF0I.[ItemOrKitQualityId]
      ,RF0I.[ItemOrKitQualityCode]
      ,RF0I.[IsActive]
      ,RF0I.[ModifyDate]
      ,RF0I.[ModifyUserId]
  FROM [dbo].[CommunicationMessagesRefurbishedOrderItems]     RF0I
  INNER JOIN [dbo].[CommunicationMessagesRefurbishedOrder]    RF0H
       ON RF0I.[CMSOId] = RF0H.ID
  INNER JOIN [dbo].[CommunicationMessagesRefurbishedOrderConfirmation]  RF1H
       ON RF0H.ID = RF1H.RefurbishedOrderID 
  INNER JOIN [dbo].[CommunicationMessagesRefurbishedOrderConfirmationItems] RF1I
       ON RF1H.ID = RF1I.CMSOId  AND RF0I.ItemOrKitID=RF1I.ItemOrKitID AND RF0I.ItemOrKitQualityId=RF1I.ItemOrKitQualityId AND RF0I.ItemOrKitUnitOfMeasureId = RF1I.ItemOrKitUnitOfMeasureId
  WHERE RF1H.Reconciliation=1 
        AND  RF0I.[IsActive]=1 
        AND  RF0H.[IsActive]=1
        AND  RF1H.[IsActive]=1
        AND  RF1I.[IsActive]=1
        AND  RF0I.[ItemOrKitQuantity]<>RF0I.[ItemOrKitQuantityDelivered]
ORDER BY RF0H.ID,RF0I.ItemOrKitID



--SELECT S0I.[ID]       S0IID
--      ,S0I.[CMSOId]   S0HID
--      ,S0I.[SingleOrMaster]
--      ,S0I.[ItemVerKit]
--      ,S0I.[ItemOrKitID]
--      ,S0I.[ItemOrKitDescription]
--      ,S0I.[ItemOrKitQuantity]
--      ,S0I.[ItemOrKitQuantityReal]
--      ,S0I.[ItemOrKitUnitOfMeasureId]
--      ,S0I.[ItemOrKitUnitOfMeasure]
--      ,S0I.[ItemOrKitQualityId]
--      ,S0I.[ItemOrKitQualityCode]
--      ,S0I.[ItemType]
--      ,S0I.[IncotermsId]
--      ,S0I.[Incoterms]
--      ,S0I.[PackageValue]
--      ,S0I.[ShipmentOrderSource]
--      ,S0I.[VydejkyId]
--      ,S0I.[CardStockItemsId]
--      ,S0I.[HeliosOrderRecordId]
--      ,S0I.[IsActive]
--      ,S0I.[ModifyDate]
--      ,S0I.[ModifyUserId]
--      ,S0I.[IdRowReleaseNote]
--  FROM [dbo].[CommunicationMessagesShipmentOrdersSentItems]     S0I
--  INNER JOIN [dbo].[CommunicationMessagesShipmentOrdersSent]     S0H
--       ON S0I.CMSOId = S0H.ID 
-- WHERE S0I.[CMSOId] = 36

-- SELECT * FROM [dbo].[CommunicationMessagesShipmentOrdersConfirmation]  S1H WHERE S1H.ShipmentOrderID=36

 */



 /*
 
 -- 2015-03-30
 --
SELECT * FROM
(
SELECT COUNT(*) POCET, [MaterialCode],[IdWf]
  FROM [Fenix].[dbo].[VydejkySprWrhMaterials] GROUP BY [MaterialCode],[IdWf]
  ) aa
  WHERE  POCET >1



--Kontroluje, zda v jedné S1 neníx krát stejný materiál => byl by pak i v S0
--2015-03-30

SELECT * FROM
(
SELECT 
COUNT(*) Pocet,
  [CMSOId], [SingleOrMaster], [ItemVerKit], [ItemOrKitID], [ItemOrKitUnitOfMeasureId], [RealItemOrKitQualityId]
  FROM [Fenix].[dbo].[CommunicationMessagesShipmentOrdersConfirmationItems]
  WHERE IsActive = 1 
  GROUP BY [CMSOId], [SingleOrMaster], [ItemVerKit], [ItemOrKitID], [ItemOrKitUnitOfMeasureId], [RealItemOrKitQualityId]
)  aa
WHERE Pocet>1
 */
 /*
 USE [Fenix]
GO

SELECT 
       DISTINCT
       SOCI.[ID]
      ,SOCI.[CMSOId]
      ,SOCI.[SingleOrMaster]
      ,SOCI.[HeliosOrderRecordID]
      ,SOCI.[ItemVerKit]
      ,SOCI.[ItemOrKitID]
      ,SOCI.[ItemOrKitDescription]
      ,SOCI.[ItemOrKitQuantity]      ,SOCI.[RealItemOrKitQuantity], SOI.ItemOrKitQuantity, SOI.ItemOrKitQuantityReal, SOC.Reconciliation
      ,SOCI.[ItemOrKitUnitOfMeasureId]
      ,SOCI.[ItemOrKitUnitOfMeasure]
      ,SOCI.[ItemOrKitQualityId]
      ,SOCI.[ItemOrKitQualityCode]
      ,SOCI.[IncotermsId]
      ,SOCI.[IncotermDescription]
      ,SOCI.[RealDateOfDelivery]
      ,SOCI.[RealItemOrKitQualityID]
      ,SOCI.[RealItemOrKitQuality]
      ,SOCI.[Status]
      ,SOCI.[KitSNs]
      ,SOCI.[IsActive]
      ,SOCI.[ModifyDate]
      ,SOCI.[ModifyUserId]
  FROM       [dbo].[CommunicationMessagesShipmentOrdersConfirmationItems]  SOCI
  INNER JOIN [dbo].[CommunicationMessagesShipmentOrdersConfirmation]       SOC
        ON SOCI.CMSOId=SOC.ID
  INNER JOIN [dbo].[CommunicationMessagesShipmentOrdersSent]               SO
        ON SOC.[ShipmentOrderID]=SO.ID
  INNER JOIN [dbo].[CommunicationMessagesShipmentOrdersSentItems]          SOI
        ON     SO.ID                         = SOI.CMSOId 
           AND SOCI.ItemOrKitID              = SOI.ItemOrKitID 
           AND SOCI.ItemOrKitQualityId       = SOI.ItemOrKitQualityId 
           AND SOCI.ItemOrKitUnitOfMeasureId = SOI.ItemOrKitUnitOfMeasureId
           AND SOCI.[SingleOrMaster]         = SOI.SingleOrMaster
  WHERE     SOC.IsActive  = 1
        AND SOCI.IsActive = 1
        AND SO.IsActive   = 1
        AND SOI.IsActive  = 1
        AND SOC.Reconciliation <> 2
        --AND SOI.ItemOrKitQuantityReal IS NULL
ORDER BY SOCI.[ItemOrKitID], SOCI.[SingleOrMaster]
GO

SELECT KCI.[ID]
      ,KCI.[CMSOId]
      ,KCI.[KitID]
      ,KCI.[KitDescription]
      ,KCI.[KitQuantity],KSI.[KitQuantity],KSI.[KitQuantityDelivered]
      ,KCI.[KitUnitOfMeasure]
      ,KCI.[KitQualityId]
      ,KCI.[KitSNs]
      ,KCI.[IsActive]
      ,KCI.[ModifyDate]
      ,KCI.[ModifyUserId]
  FROM [dbo].[CommunicationMessagesKittingsConfirmationItems]   KCI
  INNER JOIN [dbo].[CommunicationMessagesKittingsConfirmation]   KC
  ON KCI.CMSOId = KC.ID
  INNER JOIN [dbo].[CommunicationMessagesKittingsSent]   KS
  ON KC.KitOrderID = KS.ID
    INNER JOIN [dbo].[CommunicationMessagesKittingsSentItems]   KSI
  ON KS.ID = KSI.CMSOId
  WHERE     KCI.IsActive  = 1
        AND KC.IsActive = 1
        AND KS.IsActive   = 1
        AND KSI.IsActive  = 1
        AND KC.Reconciliation <> 2

 */















