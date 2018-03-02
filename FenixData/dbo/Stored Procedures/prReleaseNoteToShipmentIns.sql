
CREATE PROCEDURE [dbo].[prReleaseNoteToShipmentIns] 
	   @ReturnValue     int            = -1 OUTPUT,
	   @ReturnMessage   nvarchar(2048) = null OUTPUT
AS
BEGIN
-- ===============================================================================================
-- Created by   : Weczerek Max
-- Created date : 2014-10-01
-- Updated date : 2014-10-02, 2014-11-03, 2015-01-27, 2015-04-09
-- Description  : 
-- ===============================================================================================
/*
Načítá data z tabulky [dbo].[VydejkySprWrhMaterials] z view [dbo].[vwVydejkySprWrhMaterials] a vyrábí S0 a aktualizuje karty

*/
SET NOCOUNT ON;
DECLARE @myDatabaseName  nvarchar(100)
BEGIN TRY

   SELECT @myDatabaseName = DB_NAME() 

   BEGIN --- DECLARACE
       DECLARE
          @myID [int],
          @myMessageId [int],
          @myMessageType [int],
          @myMessageDescription [nvarchar](200),
          @myMessageDateOfShipment [datetime],
          @myIssueType [int],
          @myType  [nvarchar](200), -- [int],
          @myIsSent [int],
          @myDone  [bit] ,
          @mySentDate [nvarchar](20),
          @myOrderDescription [nvarchar](200),
          @myCustomerId [int],
          @myCustomerName [nvarchar](200),
          @myCustomerCity [nvarchar](200),
          @myCustomerAddress [nvarchar](200),
          @myStreetName [nvarchar](200),
          @myCustomerZipCode [nvarchar](200),
          @myCustomerCountry [nvarchar](200),
          @myCustomerPhoneNumber [nvarchar](200),
          @myCustomerStreetOrientationNumber [nvarchar](200),
          @myStreetHouseNumber [nvarchar](200),
          @myICO [nvarchar](20),
          @myDIC [nvarchar](20),
          @myItemVerKit [bit],
          @myItemOrKitID [nvarchar](50),
          @myItemOrKitDescription [nvarchar](500),
          @myItemOrKitQuantity [numeric](18, 3),
          @mySuppliedQuantities [numeric](18, 3),
          @myItemOrKitUnitOfMeasureId  [int],
          @myItemOrKitQuality [int],
          @myItemOrKitDateOfDelivery [datetime],
          @myItemTypesId [int],
          @myPackagingId [int],
          @myPackaging [nvarchar](50),
          @myItemType [nvarchar](50),
          @myIncoterms [nvarchar](50),
          @myPackageType [nvarchar](50),
          @myPC [nvarchar](50),
          @myIsActive [bit],
          @myModifyDate [datetime],
          @myModifyUserId [int] ,
          @myCardStockItemsId [int] ,
          @myHit [bit] ,
          @myKeyItemOrKitDateOfDelivery [datetime] ,
          @myDate [datetime],
          @myDateStamp [datetime],
          @mycdlItemsSentDate [datetime],
          @hIdent [int],
          @mySourceId [int],@myHeliosOrderId [int]
          ,@myKeyIdWf [int],@myKeySubscribers  [int]
          ,@mySubscribers  [nvarchar](200)
          ,@myIdWf  [int]
          ,@mycdlDestinationPlacesID  [int]
          ,@myOrganisationNumber  [int]
          ,@myCountryISO  [nvarchar](50)
          ,@mycdlDestinationPlacesContactsID  [int]
          ,@myDestinationPlacesId  [int]
          ,@myPhoneNumber  [nvarchar](50)
          ,@myFirstName  [nvarchar](100)
          ,@myLastName  [nvarchar](100)
          ,@myTitle  [int]
          ,@myTitleText  [nvarchar](100)
          ,@myContactName  [nvarchar](100)
          ,@myContactEmail  [nvarchar](150)
          ,@myCustomerIdType  [nvarchar](150)
          ,@myCustomerIdIsSent  [int]
          ,@mycdlItemsIsSent  [int]
          ,@myCustomerIdSentDate [datetime]
          ,@mycdlItemsID  [int]
          ,@myGroupGoods  [nvarchar](50)
          ,@myCode  [nvarchar](50)
          ,@myDescriptionCz  [nvarchar](150)
          ,@myDescriptionEng [nvarchar](150)
          ,@myItemTypeDesc1 [nvarchar](150)
          ,@myItemTypeDesc2 [nvarchar](150)
          ,@mycdlMeasuresCode [nvarchar](150)
          ,@mycdlMeasuresDescriptionCz [nvarchar](150)
          ,@myHeliosOrderIDx AS INT
          ,@myPackagingValue int
          ,@mySingleOrMaster int
          ,@myErrorDescription AS nvarchar(max)

          SET @myErrorDescription = ''

       SELECT @myKeySubscribers = -1 , @myKeyIdWf = null,  @myDate = GetDate()
       
       DECLARE @myIdentity [int], @FreeNumber [int], @MessageDescription  [nvarchar] (500), @myOrderIdFromTable [int]
       
       DECLARE
          @myPocet [int],
          @myError [int],
          @mytxt   [nvarchar] (max)
          SET @myError = 0
       DECLARE 
          @hndl int
       
    DECLARE  @myAdresaLogistika  varchar(500),@myAdresaProgramator  varchar(500) 
    SET @myAdresaLogistika   = [dbo].[fnHomeAdresses] (4)
    SET @myAdresaProgramator = [dbo].[fnHomeAdresses] (2)
      
       DECLARE @errTask nvarchar (126), @errLine int, @errNumb int
     
       DECLARE  @myMessage [nvarchar] (max), @myReturnValue [int],@myReturnMessage nvarchar(2048)
       
       DECLARE  @myPocetPolozekCelkem [int], @myPocetPolozekPomooc[int], @mOK [bit]
       SET @mOK = 1 
       -- ---
       DECLARE @msg    varchar(max)
       DECLARE @MailTo varchar(150)
       DECLARE @MailBB varchar(150)
       DECLARE @sub    varchar(1000) 
       DECLARE @Result int
       SET @msg = ''
   END --- DECLARACE
 
 --  ========================================================
 -- 2014-11-03
   DECLARE @IdWfFilter1 AS VARCHAR(100)
   BEGIN  -- Kontrola, že k požadovaným materiálům existují karty
       SELECT @IdWfFilter1 = LEFT(r.ResourceName , LEN(r.ResourceName)-1)
       FROM (
              SELECT CAST(IdWf AS VARCHAR(50)) + ' - '+CAST([MaterialCode] AS VARCHAR(50)) + ', '   FROM  
                                  (
                                    select IdWf, [MaterialCode] from [VydejkySprWrhMaterials]   
                                    WHERE [MaterialCode] NOT IN (SELECT [ItemOrKitID]       FROM [dbo].[CardStockItems] 
                                                                 WHERE [ItemOrKitQuality]=1 AND [IsActive] = 1)
                                          AND IsActive=1 AND (Hit IS NULL  OR HIT = 0)                            
                           ) A   FOR XML PATH('')
             ) r (ResourceName)
              
       IF NOT (@IdWfFilter1 IS NULL OR RTRIM(@IdWfFilter1)='')
       BEGIN
           SET @mOK = 0
           SET @myErrorDescription = @myErrorDescription + '<br />Nejsou karty pro výdejky:' + @IdWfFilter1
       END
   END

   BEGIN  -- Kontrola volného množství na kartách pro výdejky
       SET @IdWfFilter1 = ''
       SELECT @IdWfFilter1 = LEFT(r.ResourceName , LEN(r.ResourceName)-1)
       FROM (
              SELECT CAST(IdWf AS VARCHAR(50)) + ';  MaterialCode = '+CAST(ItemOrKitID AS VARCHAR(50)) + ' - MJ = '+CAST(ItemOrKitUnitOfMeasureId AS VARCHAR(50)) + ', '   FROM  
                                  (
                                    select IdWf,[ItemOrKitID],[ItemOrKitUnitOfMeasureId] from [VydejkySprWrhMaterials]   
                                    INNER JOIN (SELECT [ItemOrKitID],[ItemOrKitFree],[ItemOrKitUnitOfMeasureId] 
                                                FROM [dbo].[CardStockItems] 
                                                WHERE [ItemOrKitQuality]=1 AND [IsActive] = 1 AND [ItemVerKit] = 0)  xa
                                    ON  [MaterialCode] = xa.[ItemOrKitID]
                                    WHERE [RequiredQuantities] > [ItemOrKitFree]
                                          AND IsActive=1 AND (Hit IS NULL  OR HIT = 0)                     
                           ) A   FOR XML PATH('')
             ) r (ResourceName)
      
       IF NOT (@IdWfFilter1 IS NULL OR RTRIM(@IdWfFilter1)='')
       BEGIN
           SET @mOK = 0
           SET @myErrorDescription = @myErrorDescription + '<br />Není volné množství na kartách pro výdejky:' + @IdWfFilter1
       END
   END

   IF @mOK = 1
   BEGIN  -- @mOK

BEGIN  -- =====================ZP==========================
     IF (SELECT CURSOR_STATUS('global','crVydejkySprWrhMaterials')) >= -1
     BEGIN
          DEALLOCATE crVydejkySprWrhMaterials
     END

     DECLARE crVydejkySprWrhMaterials CURSOR 
     FOR SELECT 
       [Id]
      ,[RequiredQuantities]
      ,[SuppliedQuantities]
      ,[IssueType]
      ,[IdWf]
      ,[MaterialCode]
      ,[Subscribers]
      ,[SubscribersContact]
      ,[Done]
      ,[DateStamp]
      ,[cdlDestinationPlacesID]
      ,[OrganisationNumber]
      ,[CompanyName]
      ,[City]
      ,[StreetName]
      ,[StreetOrientationNumber]
      ,[StreetHouseNumber]
      ,[ZipCode]
      ,[IdCountry]
      ,[ICO]
      ,[DIC]
      ,[Type]
      ,[IsSent]
      ,[SentDate]
      ,[CountryISO]
      ,[cdlDestinationPlacesContactsID]
      ,[DestinationPlacesId]
      ,[PhoneNumber]
      ,[FirstName]
      ,[LastName]
      ,[Title]
      ,[TitleText]
      ,[ContactName]
      ,[ContactEmail]
      ,[SubscribersContactType]
      ,[SubscribersContactIsSent]
      ,[SubscribersContactSentDate]
      ,[cdlItemsID]
      ,[GroupGoods]
      ,[Code]
      ,[DescriptionCz]
      ,[DescriptionEng]
      ,[MeasuresId]
      ,[ItemTypesId]
      ,[PackagingId]
      ,[ItemType]
      ,[PC]
      ,[Packaging]
      ,[cdlItemsIsSent]
      ,[cdlItemsSentDate]
      ,[ItemTypeDesc1]
      ,[ItemTypeDesc2]
      ,[cdlMeasuresCode]
      ,[cdlMeasuresDescriptionCz]
      ,Hit  
      ,[DeliveryDate]   
    FROM [dbo].[vwVydejkySprWrhMaterials]
    WHERE (Hit IS NULL OR Hit = 0) AND [IsActive] = 1    -- přibylo AND [IsActive] = 1      2015-04-09
    ORDER BY [IdWf],[Subscribers],[Id] 

     OPEN crVydejkySprWrhMaterials
     FETCH NEXT FROM crVydejkySprWrhMaterials 
     INTO
       @myId        ,@myItemOrKitQuantity      ,@mySuppliedQuantities    ,@myIssueType       ,@myIdWf          ,@myItemOrKitID    ,@mySubscribers    ,@myCustomerId      ,@myDone
      ,@myDateStamp ,@mycdlDestinationPlacesID ,@myOrganisationNumber    ,@myCustomerName    ,@myCustomerCity  ,@myStreetName     ,@myCustomerStreetOrientationNumber
      ,@myStreetHouseNumber                    ,@myCustomerZipCode       ,@myCustomerCountry ,@myICO           ,@myDIC            ,@myType           ,@myIsSent
      ,@mySentDate  ,@myCountryISO             ,@mycdlDestinationPlacesContactsID            ,@myDestinationPlacesId              ,@myPhoneNumber    ,@myFirstName
      ,@myLastName  ,@myTitle                  ,@myTitleText             ,@myContactName     ,@myContactEmail
      ,@myCustomerIdType                       ,@myCustomerIdIsSent      ,@myCustomerIdSentDate                  ,@mycdlItemsID   ,@myGroupGoods      ,@myCode        ,@myDescriptionCz
      ,@myDescriptionEng                       ,@myItemOrKitUnitOfMeasureId                  ,@myItemTypesId     ,@myPackagingId  ,@myItemType        ,@myPC 
      ,@myPackaging ,@mycdlItemsIsSent         ,@mycdlItemsSentDate      ,@myItemTypeDesc1   ,@myItemTypeDesc2   ,@mycdlMeasuresCode
      ,@mycdlMeasuresDescriptionCz             ,@myHit                   ,@myItemOrKitDateOfDelivery
 
       SELECT @myKeyIdWf = -1 ,@myKeySubscribers = -1       --
       BEGIN TRAN
       WHILE @@FETCH_STATUS = 0 AND @myError = 0 
       BEGIN ---- @@FETCH_STATUS
          IF @myKeyIdWf<>@myIdWf  OR @myKeySubscribers<>@mySubscribers                  -- pokud se změnilo číslo výdejky nebo došlo ke změně dodavatele
          BEGIN  -- IF @myKeyIdWf<>@myIdWf  OR @myKeySubscribers<>@mySubscribers
             SELECT @myKeyIdWf = @myIdWf, @myKeySubscribers = @mySubscribers
             -- ***************************
             -- nutno založit hlavičku S0
             -- získání MessageID, ...
             -- ***************************
             SELECT @FreeNumber = [LastFreeNumber] FROM [dbo].[cdlMessageNumber]        WHERE [Code]=1 
             UPDATE [dbo].[cdlMessageNumber] SET [LastFreeNumber] = @FreeNumber + 1     WHERE [Code]=1
             SELECT @MessageDescription = [DescriptionEng] FROM [dbo].[cdlMessageTypes] WHERE [ID]  =1
             EXEC [dbo].[prGetOrderNumber] @HeliosOrderIdin = @myHeliosOrderID, @OrderNumberOut = @myHeliosOrderIDx   output
             -- ****************************
             -- Tato cast se jiz neuplatňuje
             -- vyrazeno ze hry  2015-02-16
             -- ****************************
             -- SELECT @myCardStockItemsId = [ID] FROM [dbo].[CardStockItems] 
             -- WHERE [ItemVerKit]=0 AND [ItemOrKitId] = @mycdlItemsID AND [StockId] = 2 AND [ItemOrKitQuality] = 1 AND [ItemOrKitUnitOfMeasureId] = @myItemOrKitUnitOfMeasureId
             -- ******************************
             -- Zalozeni hlavičky a získání ID
             -- ******************************
             INSERT INTO [dbo].[CommunicationMessagesShipmentOrdersSent]
                        ([MessageId]
                        ,[MessageTypeId]
                        ,[MessageDescription]
                        ,[MessageDateOfShipment]
                        ,[RequiredDateOfShipment]
                        ,[MessageStatusId]
                        ,[HeliosOrderId]
                        ,[CustomerID]
                        ,[CustomerName]
                        ,[CustomerAddress1]
                        ,[CustomerAddress2]
                        ,[CustomerAddress3]
                        ,[CustomerCity]
                        ,[CustomerZipCode]
                        ,[CustomerCountryISO]
                        ,[ContactID]
                        ,[ContactTitle]
                        ,[ContactFirstName]
                        ,[ContactLastName]
                        ,[ContactPhoneNumber1]
                        ,[ContactPhoneNumber2]
                        ,[ContactFaxNumber]
                        ,[ContactEmail]
                        ,[IsManually]
                        ,[StockId]
                        ,[IsActive]
                        ,[ModifyDate]
                        ,[ModifyUserId]
                        ,[IdWf])
                  VALUES
                        (@FreeNumber                           --  !!!    <MessageId, int,>
                        ,6                                     -- <MessageTypeId, int,>
                        ,'ShipmentOrder'                       --<MessageDescription, nvarchar(200),>
                        ,NULL                                  --<MessageDateOfShipment, datetime,>
                        ,@myItemOrKitDateOfDelivery                 --  !!!    <RequiredDateOfShipment, datetime,>
                        ,1                                     -- <MessageStatusId, int,>
                        ,@myHeliosOrderIDx                     --  !!!    <HeliosOrderId, int,>
                        ,@myKeySubscribers                     -- <CustomerID, int,>
                        ,@myCustomerName                       -- <CustomerName, nvarchar(100),>
                        ,@myStreetName                         -- <CustomerAddress1, nvarchar(100),>
                        ,@myStreetHouseNumber                  -- <CustomerAddress2, nvarchar(50),>
                        ,@myCustomerStreetOrientationNumber    -- <CustomerAddress3, nvarchar(50),>
                        ,@myCustomerCity                       -- <CustomerCity, nvarchar(150),>
                        ,@myCustomerZipCode                    -- <CustomerZipCode, nvarchar(10),>
                        ,@myCountryISO                         -- <CustomerCountryISO, char(3),>
                        ,@mycdlDestinationPlacesContactsID     -- <ContactID, int,>
                        ,@myTitle                              -- <ContactTitle, char(1),>
                        ,@myFirstName                          --  <ContactFirstName, nvarchar(35),>
                        ,@myLastName                           -- <ContactLastName, nvarchar(35),>
                        ,@myPhoneNumber                        -- <ContactPhoneNumber1, nvarchar(15),>
                        ,NULL                                  -- <ContactPhoneNumber2, nvarchar(15),>
                        ,NULL                                  -- <ContactFaxNumber, nvarchar(15),>
                        ,@myContactEmail                       -- <ContactEmail, nvarchar(150),>
                        ,0                                     -- <IsManually, bit,>
                        ,2                                     -- <StockId, int,>
                        ,1                                     -- <IsActive, bit,>
                        ,@myDate                               -- <ModifyDate, datetime,>
                        ,0                                     -- <ModifyUserId, int,>
                        ,@myKeyIdWf
                        )
             SET @hIdent  = @@IDENTITY   -- hlavicka
             SET @myError = @@ERROR
          END    -- IF @myKeyIdWf<>@myIdWf  OR @myKeySubscribers<>@mySubscribers

          IF @myError = 0 AND @hIdent>0
          BEGIN   -- @myError = 0 AND @hIdent>0
             -- *******************************
             -- získání údajů z číselníku Items
             -- merná jednotka, packaging, ...
             -- *******************************
             BEGIN  
                    SELECT @myItemOrKitUnitOfMeasureId = [MeasuresId], @myPackagingValue = [Packaging], @myItemOrKitDescription = [DescriptionCz], @myItemType = [ItemType]  
                    FROM [dbo].[cdlItems] WHERE Id = @myItemOrKitID 
             END
             IF @myPackagingValue IS NULL OR @myPackagingValue<2  SET @myPackagingValue = 9999999
             -- není packaging nebo je jedna, díváme se na to, jako že je packaging ohromně velký = 9 999 999, a proto bude vždy áznam single 
             
             IF @myPackagingValue > @myItemOrKitQuantity
                 -- *******************************
                 -- je single
                 -- *******************************
                 INSERT INTO [dbo].[CommunicationMessagesShipmentOrdersSentItems]
                            ([CMSOId]
                            ,[SingleOrMaster]
                            ,[ItemVerKit]
                            ,[ItemOrKitID]
                            ,[ItemOrKitDescription]
                            ,[ItemOrKitQuantity]
                            ,[ItemOrKitQuantityReal]
                            ,[ItemOrKitUnitOfMeasureId]
                            ,[ItemOrKitUnitOfMeasure]
                            ,[ItemOrKitQualityId]
                            ,[ItemOrKitQualityCode]
                            ,[ItemType]
                            ,[IncotermsId]
                            ,[Incoterms]
                            ,[PackageValue]
                            ,[ShipmentOrderSource]
                            ,[VydejkyId]
                            ,[CardStockItemsId]
                            ,[HeliosOrderRecordId]
                            ,[IsActive]
                            ,[ModifyDate]
                            ,[ModifyUserId]
                            ,[IdRowReleaseNote]
                            )
                      VALUES
                            (@hIdent                     -- <CMSOId, int,>
                            ,0                           -- <SingleOrMaster, int,>
                            ,0                           -- <ItemVerKit, int,>
                            ,@mycdlItemsID               -- <ItemOrKitID, int,>
                            ,@myDescriptionCz            -- <ItemOrKitDescription, nvarchar(100),>
                            ,@myItemOrKitQuantity        -- <ItemOrKitQuantity, numeric(18,3),>
                            ,0                           -- <ItemOrKitQuantityReal, numeric(18,3),>
                            ,@myItemOrKitUnitOfMeasureId -- <ItemOrKitUnitOfMeasureId, int,>
                            ,@mycdlMeasuresCode          -- <ItemOrKitUnitOfMeasure, nvarchar(50),>
                            ,1                           -- <ItemOrKitQualityId, int,>
                            ,'NEW'                       -- <ItemOrKitQualityCode, nvarchar(50),>
                            ,@myItemType                 -- <ItemType, nvarchar(50),>
                            ,2                           -- <IncotermsId, int,>
                            ,'DAP'                       -- <Incoterms, nvarchar(50),>
                            ,NULL                        -- <PackageValue, int,>
                            ,0                           -- <ShipmentOrderSource, int,>
                            ,@myKeyIdWf                  -- <VydejkyId, int,>
                            ,NULL                        -- <CardStockItemsId, int,>
                            ,@myHeliosOrderIDx           -- <HeliosOrderRecordId, int,>
                            ,1                           -- <IsActive, bit,>
                            ,@myDate                     -- <ModifyDate, datetime,>
                            ,0                           -- <ModifyUserId, int,>
                            ,@myId)
             ELSE
             BEGIN
                 -- *******************************
                 -- je určitě master a možná i single
                 -- *******************************

                   SET @mySingleOrMaster = 1
                   DECLARE @tempOrKitQuantity AS numeric(18,3)   -- sem se sbírá množství obsažené v master
                   SET @tempOrKitQuantity = 0

                   WHILE (@myItemOrKitQuantity - @tempOrKitQuantity >= @myPackagingValue   )
                   BEGIN
                      SET @tempOrKitQuantity = @myPackagingValue + @tempOrKitQuantity    -- mnozstvi - cele "baliky", palety,....; mnozstvi je v MeJe např KS, M,... 
                   END
                    
                   DECLARE @tempNumOrKitQuantity numeric(18,3)
                   SET @tempNumOrKitQuantity = CAST(@tempOrKitQuantity AS numeric(18,3))  -- pro jistotu převod na numeric(18,3)  RANA JISTOTY

                   -- =======Master========
             INSERT INTO [dbo].[CommunicationMessagesShipmentOrdersSentItems]
                        ([CMSOId]
                        ,[SingleOrMaster]
                        ,[ItemVerKit]
                        ,[ItemOrKitID]
                        ,[ItemOrKitDescription]
                        ,[ItemOrKitQuantity]
                        ,[ItemOrKitQuantityReal]
                        ,[ItemOrKitUnitOfMeasureId]
                        ,[ItemOrKitUnitOfMeasure]
                        ,[ItemOrKitQualityId]
                        ,[ItemOrKitQualityCode]
                        ,[ItemType]
                        ,[IncotermsId]
                        ,[Incoterms]
                        ,[PackageValue]
                        ,[ShipmentOrderSource]
                        ,[VydejkyId]
                        ,[CardStockItemsId]
                        ,[HeliosOrderRecordId]
                        ,[IsActive]
                        ,[ModifyDate]
                        ,[ModifyUserId]
                        ,[IdRowReleaseNote]
                        )
                  VALUES
                        (@hIdent                     -- <CMSOId, int,>
                        ,1                           -- <SingleOrMaster, int,>
                        ,0                           -- <ItemVerKit, int,>
                        ,@mycdlItemsID               -- <ItemOrKitID, int,>
                        ,@myDescriptionCz            -- <ItemOrKitDescription, nvarchar(100),>
                        ,@tempNumOrKitQuantity        -- <ItemOrKitQuantity, numeric(18,3),> 
                        ,0                           -- <ItemOrKitQuantityReal, numeric(18,3),>
                        ,@myItemOrKitUnitOfMeasureId -- <ItemOrKitUnitOfMeasureId, int,>
                        ,@mycdlMeasuresCode          -- <ItemOrKitUnitOfMeasure, nvarchar(50),>
                        ,1                           -- <ItemOrKitQualityId, int,>
                        ,'NEW'                       -- <ItemOrKitQualityCode, nvarchar(50),>
                        ,@myItemType                 -- <ItemType, nvarchar(50),>
                        ,2                           -- <IncotermsId, int,>
                        ,'DAP'                       -- <Incoterms, nvarchar(50),>
                        ,NULL                        -- <PackageValue, int,>
                        ,0                           -- <ShipmentOrderSource, int,>
                        ,@myKeyIdWf                  -- <VydejkyId, int,>
                        ,NULL                        -- <CardStockItemsId, int,>
                        ,@myHeliosOrderIDx           -- <HeliosOrderRecordId, int,>
                        ,1                           -- <IsActive, bit,>
                        ,@myDate                     -- <ModifyDate, datetime,>
                        ,0                           -- <ModifyUserId, int,>
                        ,@myId)

                   -- =======Single========
                   SET @tempNumOrKitQuantity = CAST(@myItemOrKitQuantity - @tempNumOrKitQuantity  AS numeric(18,3))
                   IF @tempNumOrKitQuantity>0
                   INSERT INTO [dbo].[CommunicationMessagesShipmentOrdersSentItems]
                               ([CMSOId]
                               ,[SingleOrMaster]
                               ,[ItemVerKit]
                               ,[ItemOrKitID]
                               ,[ItemOrKitDescription]
                               ,[ItemOrKitQuantity]
                               ,[ItemOrKitQuantityReal]
                               ,[ItemOrKitUnitOfMeasureId]
                               ,[ItemOrKitUnitOfMeasure]
                               ,[ItemOrKitQualityId]
                               ,[ItemOrKitQualityCode]
                               ,[ItemType]
                               ,[IncotermsId]
                               ,[Incoterms]
                               ,[PackageValue]
                               ,[ShipmentOrderSource]
                               ,[VydejkyId]
                               ,[CardStockItemsId]
                               ,[HeliosOrderRecordId]
                               ,[IsActive]
                               ,[ModifyDate]
                               ,[ModifyUserId]
                               ,[IdRowReleaseNote]
                               )
                         VALUES
                               (@hIdent                     -- <CMSOId, int,>
                               ,0                           -- <SingleOrMaster, int,>
                               ,0                           -- <ItemVerKit, int,>
                               ,@mycdlItemsID               -- <ItemOrKitID, int,>
                               ,@myDescriptionCz            -- <ItemOrKitDescription, nvarchar(100),>
                               ,@tempNumOrKitQuantity        -- <ItemOrKitQuantity, numeric(18,3),>
                               ,0                           -- <ItemOrKitQuantityReal, numeric(18,3),>
                               ,@myItemOrKitUnitOfMeasureId -- <ItemOrKitUnitOfMeasureId, int,>
                               ,@mycdlMeasuresCode          -- <ItemOrKitUnitOfMeasure, nvarchar(50),>
                               ,1                           -- <ItemOrKitQualityId, int,>
                               ,'NEW'                       -- <ItemOrKitQualityCode, nvarchar(50),>
                               ,@myItemType                 -- <ItemType, nvarchar(50),>
                               ,2                           -- <IncotermsId, int,>
                               ,'DAP'                       -- <Incoterms, nvarchar(50),>
                               ,NULL                        -- <PackageValue, int,>
                               ,0                           -- <ShipmentOrderSource, int,>
                               ,@myKeyIdWf                  -- <VydejkyId, int,>
                               ,NULL                        -- <CardStockItemsId, int,>
                               ,@myHeliosOrderIDx           -- <HeliosOrderRecordId, int,>
                               ,1                           -- <IsActive, bit,>
                               ,@myDate                     -- <ModifyDate, datetime,>
                               ,0                           -- <ModifyUserId, int,>
                               ,@myId)

             -- =======
             END
             SET @myError = @myError + @@ERROR
 
            /*  aktualizace karty  2015-01-27 (kdysi bylo, pak bylo zrušeno a nyni znovu oziveno) */
            UPDATE [dbo].[CardStockItems]
               SET [ItemOrKitFree]     = ISNULL(ItemOrKitFree,0)     - @myItemOrKitQuantity
                  ,[ItemOrKitReserved] = ISNULL(ItemOrKitReserved,0) + @myItemOrKitQuantity
               WHERE ItemOrKitID = @mycdlItemsID AND [ItemOrKitQuality] = 1 AND ItemOrKitUnitOfMeasureId = @myItemOrKitUnitOfMeasureId
            -- WHERE id = @myCardStockItemsId        oprava 2015-02-16
            SET @myError = @myError + @@ERROR

            IF @myError = 0  UPDATE VydejkySprWrhMaterials SET HIT = 1, MessageId = @FreeNumber, S0Id=@hIdent  WHERE ID=@myId

            SET @myError = @myError + @@ERROR 
          END     -- @myError = 0 AND @hIdent>0

          FETCH NEXT FROM crVydejkySprWrhMaterials 
           INTO
              @myId,@myItemOrKitQuantity,@mySuppliedQuantities,@myIssueType,@myIdWf, @myItemOrKitID,@mySubscribers,@myCustomerId
             ,@myDone,@myDateStamp,@mycdlDestinationPlacesID,@myOrganisationNumber,@myCustomerName,@myCustomerCity,@myStreetName,@myCustomerStreetOrientationNumber
             ,@myStreetHouseNumber,@myCustomerZipCode,@myCustomerCountry,@myICO,@myDIC,@myType,@myIsSent,@mySentDate,@myCountryISO,@mycdlDestinationPlacesContactsID
             ,@myDestinationPlacesId,@myPhoneNumber,@myFirstName,@myLastName,@myTitle,@myTitleText,@myContactName,@myContactEmail,@myCustomerIdType
             ,@myCustomerIdIsSent,@myCustomerIdSentDate,@mycdlItemsID,@myGroupGoods,@myCode,@myDescriptionCz,@myDescriptionEng,@myItemOrKitUnitOfMeasureId
             ,@myItemTypesId,@myPackagingId,@myItemType,@myPC,@myPackaging,@mycdlItemsIsSent,@mycdlItemsSentDate,@myItemTypeDesc1,@myItemTypeDesc2
             ,@mycdlMeasuresCode,@mycdlMeasuresDescriptionCz,@myHit,@myItemOrKitDateOfDelivery  
       END   ---- @@FETCH_STATUS

       CLOSE crVydejkySprWrhMaterials
       DEALLOCATE crVydejkySprWrhMaterials
 
       IF @myError=0 
            IF @@TRANCOUNT>0  COMMIT TRAN
       ELSE
       BEGIN
            IF @@TRANCOUNT>0 ROLLBACK TRAN
            SET @sub = 'FENIX - načtení výdejek a tvorba S0 CHYBA' + ' Databáze: '+ISNULL(@myDatabaseName,'')
            SET @msg = 'Program prReleaseNoteToShipmentIns <br/>' + 'Zkontrolujte tabulku [dbo].[VydejkySprWrhMaterials]'
            EXEC @result = msdb.dbo.sp_send_dbmail
           	     @profile_name = 'Automat', --@MailProfileName
           	     @recipients = 'jaroslav.tajbl@upc.cz;michal.rezler@upc.cz',
           	     @subject = @sub,
           	     @body = @msg,
           	     @body_format = 'HTML'

       END
END    -- =====================ZP==========================

   END    -- @mOK
   ELSE
   BEGIN  -- @mOK
            IF @@TRANCOUNT>0 ROLLBACK TRAN
            SET @sub = 'FENIX - načtení výdejek a tvorba S0 CHYBA' + ' Databáze: '+ISNULL(@myDatabaseName,'')
            SET @msg = 'Program prReleaseNoteToShipmentIns <br/>' + 'Zkontrolujte tabulku [dbo].[VydejkySprWrhMaterials] '+ @myErrorDescription
            EXEC @result = msdb.dbo.sp_send_dbmail
           	     @profile_name = 'Automat', --@MailProfileName
           	     @recipients = 'jaroslav.tajbl@upc.cz;michal.rezler@upc.cz',    -- ;jaroslav.tajbl@upc.cz
           	     @subject = @sub,
           	     @body = @msg,
           	     @body_format = 'HTML'

   END    -- @mOK

END TRY

BEGIN CATCH
      IF @@TRANCOUNT>0 ROLLBACK TRAN

      SET @ReturnValue=1
      SET @sub = 'FENIX - načtení výdejek a tvorba S0 CHYBA' + ' Databáze: '+ISNULL(@myDatabaseName,'')
      SET @msg = 'Program prReleaseNoteToShipmentIns' + ISNULL(ERROR_MESSAGE(),'') + ISNULL(CAST(ERROR_NUMBER() AS VARCHAR(50)),'')
      EXEC @result = msdb.dbo.sp_send_dbmail
     		@profile_name = 'Automat', --@MailProfileName
     		@recipients = 'jaroslav.tajbl@upc.cz;michal.rezler@upc.cz',
     		@subject = @sub,
     		@body = @msg,
     		@body_format = 'HTML'


END CATCH

END


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[prReleaseNoteToShipmentIns] TO [FenixW]
    AS [dbo];

