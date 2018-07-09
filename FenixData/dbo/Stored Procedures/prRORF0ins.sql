


CREATE PROCEDURE [dbo].[prRORF0ins] 
      @par1 as XML,
      @ModifyUserId         AS INT = 0,
	   @ReturnValue     int            = -1 OUTPUT,
	   @ReturnMessage   nvarchar(2048) = null OUTPUT
 AS
BEGIN
-- ===============================================================================================
-- Created by   : Weczerek Max
-- Created date : 2014-09-23
-- Updated date : 
-- Description  : 
-- ===============================================================================================
/*
Fáze RF0 -  z Fenixu přijde XML s požadavkem na expedici

Kontroluje data


*/
	SET NOCOUNT ON;
DECLARE @myDatabaseName  nvarchar(100)
   BEGIN TRY

    SELECT @myDatabaseName = DB_NAME() 

   BEGIN --- DECLARACE
       DECLARE
	          @myID int,
	          @myMessageId int,
	          @myMessageTypeId int,
	          @myMessageDescription nvarchar(200),
	          @myMessageDateOfShipment datetime,
	          @myMessageStatusId int,
	          @myOrderId int,
	          @myOrderDescription nvarchar(200),
	          @myCustomerId int,
             @myCustomerName nvarchar(100),
             @myCustomerCity nvarchar(100),
             @myCustomerAddress1 nvarchar(100),
             @myCustomerAddress3 nvarchar(100),
             @myCustomerAddress2 nvarchar(100),
             @myCustomerZipCode  nvarchar(50),
             @myCustomerCountryISO nvarchar(10),
	          @myContactId int,
             @myContactPhoneNumber1 nvarchar(15),
             @myContactFirstName nvarchar(100),
             @myContactLastName nvarchar(100),
             @myContactTitle char(1),
	          @myContactName nvarchar(200),
	          @myContactPhoneNumber varchar(200),
             @myContactEmail  nvarchar(150),
	          @myItemVerKit bit,
	          @myItemOrKitID varchar(50),
	          @myItemOrKitDescription nvarchar(500),
	          @myItemOrKitQuantity numeric(18, 3),
             @myItemOrKitUnitOfMeasureId  int,
	          @myItemOrKitUnitOfMeasure varchar(50),
	          @myItemOrKitQualityId int,
             @myItemOrKitQualityCode varchar(50),
	          @myItemOrKitDateOfDelivery datetime,
	          @myItemType nvarchar(50),
	          @myStockId int,
	          @myIncoterms nvarchar(50),
	          @myPackageTypeId int,
	          @myPackageTypeCode nvarchar(50),
	          @myShipmentOrderSource int,
	          @myVydejkyId int,
	          @myRequiredDateOfShipment datetime,
	          @myIsActive bit,
	          @myModifyDate datetime,
	          @myModifyUserId int,
             @myItemSNs  nvarchar(max),
             @myMessageTypeDescription nvarchar(200),
             @myItemOrKitCode nvarchar(50),
             @myDestinationPlacesId int,
             @myDestinationPlacesContactsId int,
             @myDescriptionCzItemsOrKit nvarchar(150),
             @mycdlStocksName nvarchar(150),
             @myDateOfDelivery nvarchar(50),
             @myDestinationPlacesName nvarchar(150),
             @myDestinationPlacesContactsName nvarchar(150),
             @myToDay datetime,
             @myPackagingValue int,
             @mySingleOrMaster int,
             @myCMSOId  int,
             @myPackageValue int,
             @myOrderIdFromTable int,
             @myQualityText nvarchar(100)


       DECLARE 
             @myKeyItemVerKit int,
	          @myKeyItemOrKitID int,
             @myKeyDestinationPlacesId int,
             @myKeyDestinationPlacesContactsId int,
             @myKeyDateOfDelivery  nvarchar(20),
             @myKeycdlStocksName  nvarchar(100)

       SET @myItemSNs=''
       SET @myToDay = GetDate()
       SET @mySingleOrMaster = 0
       SET @myModifyUserId = @ModifyUserId

       DECLARE
             @myPocet [int],
             @myError [int],
             @myError2  [int],
             @myIdentity [int],
             @mytxt   [nvarchar] (max)
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

       SELECT 	   @ReturnValue=0,  @ReturnMessage='OK'

   END --- DECLARACE
   -- ---
   -- =======================================================================
   -- Nacteni xml souboru do tabulky
   -- =======================================================================
      IF OBJECT_ID('tempdb..#TmpRF0','table') IS NOT NULL DROP TABLE #TmpRF0

      EXEC sp_xml_preparedocument @hndl OUTPUT, @par1
      SELECT x.ID                            
            ,x.ItemVerKit                    
            ,x.ItemOrKitID                   
            ,x.ItemOrKitCode                 
            ,x.DescriptionCzItemsOrKit       
            ,x.ItemOrKitQuantity             
            ,x.PackageTypeId                 
            ,x.cdlStocksName                 
            ,x.DestinationPlacesId           
            ,x.DestinationPlacesName         
            ,x.DestinationPlacesContactsId   
            ,x.DestinationPlacesContactsName 
            ,x.DateOfDelivery 
            ,x.StockId
            ,x.QualityId   
            ,x.QualityText 
      INTO #TmpRF0
      FROM OPENXML (@hndl, '/NewDataSet/RF0',2)
      WITH (
      ID                              int           'ID',           -- toto je ID z tabulky    [dbo].[CardStockItems]              
      ItemVerKit                      int           'ItemVerKit',
      ItemOrKitID                     int           'ItemOrKitID',
      ItemOrKitCode                   nvarchar(50)  'ItemOrKitCode',
      DescriptionCzItemsOrKit         nvarchar(150) 'DescriptionCzItemsOrKit',
      ItemOrKitQuantity               numeric  (18, 3)  'ItemOrKitQuantity',
      PackageTypeId                   int           'PackageTypeId',
      cdlStocksName                   nvarchar(100) 'cdlStocksName',
      DestinationPlacesId             int           'DestinationPlacesId',
      DestinationPlacesName           nvarchar(150) 'DestinationPlacesName',
      DestinationPlacesContactsId     int           'DestinationPlacesContactsId',
      DestinationPlacesContactsName   nvarchar(50)  'DestinationPlacesContactsName',
      DateOfDelivery                  nvarchar(50)  'DateOfDelivery',
      StockId                         int           'StockId',
      QualityId                       int           'QualityId',
      QualityText                     nvarchar(100) 'QualityText'
      ) x
 
       EXEC sp_xml_removedocument @hndl

      SELECT * FROM #TmpRF0 ORDER BY DestinationPlacesId, DateOfDelivery, ItemVerKit,  ItemOrKitID

      -- =====================================
      UPDATE  #TmpRF0 SET DestinationPlacesName = REPLACE(DestinationPlacesName,'&lt;','<'),DescriptionCzItemsOrKit = REPLACE(DescriptionCzItemsOrKit,'&lt;','<')
      UPDATE  #TmpRF0 SET DestinationPlacesName = REPLACE(DestinationPlacesName,'&gt;','>'),DescriptionCzItemsOrKit = REPLACE(DescriptionCzItemsOrKit,'&gt;','>')

      BEGIN -- ============================ Zpracování ===============================
             SELECT @myMessageTypeId=12, @myMessageTypeDescription = 'RefurbishedOrder'

             IF (SELECT CURSOR_STATUS('global','myCursor')) >= -1 BEGIN  DEALLOCATE myCursor  END
             SELECT @myError=0, @myIdentity = 0
             SELECT @myKeyItemVerKit = -1,  @myKeyItemOrKitID = -1,  @myKeyDestinationPlacesId = -1,  @myKeyDestinationPlacesContactsId = -1,
                    @myKeyDateOfDelivery = '-1', @myKeycdlStocksName = '-1'

         BEGIN TRAN

             SET @myError  = 0
             SET @myError2 = 0

             DECLARE myCursor CURSOR 
             FOR  SELECT x.ID ,x.ItemVerKit ,x.ItemOrKitID ,x.ItemOrKitCode ,x.DescriptionCzItemsOrKit ,x.ItemOrKitQuantity ,x.PackageTypeId ,x.cdlStocksName 
                        ,x.DestinationPlacesId ,x.DestinationPlacesName ,x.DestinationPlacesContactsId ,x.DestinationPlacesContactsName ,x.DateOfDelivery 
                        ,x.StockId ,x.QualityId  ,x.QualityText 

                  FROM #TmpRF0 x ORDER BY x.DestinationPlacesId, x.DateOfDelivery, x.StockId, x.ItemVerKit,  x.ItemOrKitID
                                         

             OPEN myCursor
             FETCH NEXT FROM myCursor INTO  @myID ,@myItemVerKit ,@myItemOrKitID ,@myItemOrKitCode ,@myDescriptionCzItemsOrKit ,@myItemOrKitQuantity 
                                           ,@myPackageTypeId ,@mycdlStocksName ,@myDestinationPlacesId ,@myDestinationPlacesName ,@myDestinationPlacesContactsId 
                                           ,@myDestinationPlacesContactsName ,@myDateOfDelivery , @myStockId , @myItemOrKitQualityId, @myQualityText

             WHILE @@FETCH_STATUS = 0
             BEGIN --@@FETCH_STATUS
   
                 IF  @myKeyDestinationPlacesId <> @myDestinationPlacesId OR   
                     @myKeyDateOfDelivery <> @myDateOfDelivery OR  @myKeycdlStocksName <> @mycdlStocksName
                 BEGIN   -- IF 
                     SELECT @myKeyDestinationPlacesId = @myDestinationPlacesId,  
                            @myKeyDateOfDelivery = @myDateOfDelivery, @myKeycdlStocksName = @mycdlStocksName
           
                     SELECT  @myCustomerID         = [ID]
                            ,@myCustomerName       = [CompanyName]
                            ,@myCustomerCity       = [City]
                            ,@myCustomerAddress1   = [StreetName]
                            ,@myCustomerAddress3   = [StreetOrientationNumber]
                            ,@myCustomerAddress2   = [StreetHouseNumber]
                            ,@myCustomerZipCode    = [ZipCode]
                            ,@myCustomerCountryISO = [CountryISO]
                     FROM [dbo].[cdlDestinationPlaces] WHERE IsActive = 1 AND id = @myKeyDestinationPlacesId  -- cdlDestinationPlaces
     
                     SELECT @myMessageId = [LastFreeNumber]  FROM [dbo].[cdlMessageNumber] WHERE CODE = 1
                     UPDATE [dbo].[cdlMessageNumber] SET [LastFreeNumber] = [LastFreeNumber] + 1  WHERE CODE = 1

                    --EXEC [dbo].[prGetOrderNumber] @HeliosOrderIdin = -1, @OrderNumberOut = @myOrderIdFromTable output                 
            
                     INSERT INTO [dbo].[CommunicationMessagesRefurbishedOrder]
                               ([MessageId]
                               ,[MessageTypeId]
                               ,[MessageDescription]
                               ,[MessageDateOfShipment]
                               ,[MessageStatusId]
                               ,[CustomerID]
                               ,[CustomerDescription]
                               ,[DateOfDelivery]
                               ,[IsManually]
                               ,[StockId]
                               ,[Notice]
                               ,[IsActive]
                               ,[ModifyDate]
                               ,[ModifyUserId])
                         VALUES
                               (@myMessageId                   -- <MessageId, int,>                    [MessageId]
                               ,@myMessageTypeId               -- <MessageTypeId, int,>                [MessageTypeId]
                               ,@myMessageTypeDescription      -- <MessageDescription, nvarchar(200),> [MessageDescription]
                               ,NULL                           -- <MessageDateOfShipment, datetime,>   [MessageDateOfShipment]
                               ,1                              -- <MessageStatusId, int,>              [MessageStatusId]
                               ,@myCustomerID                  -- <CustomerID, int,>                   [CustomerID]
                               ,@myCustomerName                -- <CustomerDescription, nvarchar(500),>[CustomerDescription]
                               ,@myKeyDateOfDelivery           -- <DateOfDelivery, datetime,>          [DateOfDelivery]
                               ,1                              -- <IsManually, bit,>                   [IsManually]
                               ,@myStockId                     -- <StockId, int,>                      [StockId]
                               ,NULL                           -- <Notice, nvarchar(max),>             [Notice]
                               ,1                              -- <IsActive, bit,>                     [IsActive]
                               ,@myToDay                       -- <ModifyDate, datetime,>              [ModifyDate]
                               ,@myModifyUserId                -- <ModifyUserId, int,>                 [ModifyUserId])
                               )
                      SET @myError = @myError + @@ERROR
                      SET @myCMSOId = @@IDENTITY
           
                 END     -- IF 

                 -- *********************************************************************************************************************************************
SELECT @myItemOrKitID, @myItemVerKit
                 IF @myItemVerKit = 0
                 BEGIN  SELECT @myItemOrKitUnitOfMeasureId = [MeasuresId], @myPackagingValue = [Packaging], @myItemOrKitDescription = [DescriptionCz], @myItemType = [ItemType] FROM [dbo].[cdlItems] WHERE Id = @myItemOrKitID END
                 ELSE
                 BEGIN  SELECT @myItemOrKitUnitOfMeasureId = [MeasuresId], @myPackagingValue = [Packaging], @myItemOrKitDescription = [DescriptionCz], @myItemType='' FROM [dbo].[cdlKits] WHERE ID = @myItemOrKitID END
                 --
                 SELECT @myItemOrKitUnitOfMeasure = [Code]  FROM [dbo].[cdlMeasures]     WHERE [ID] = @myItemOrKitUnitOfMeasureId
                 SELECT @myItemOrKitQualityCode = [Code]    FROM [dbo].[cdlQualities]    WHERE [ID] = @myItemOrKitQualityId 
                 SELECT @myIncoterms = [DescriptionCz]      FROM [dbo].[cdlIncoterms]    WHERE [ID] = @myStockId
                 SET @myItemOrKitDateOfDelivery = CAST(@myDateOfDelivery AS datetime)

                 -- ===========================================
                 IF @myError=0 AND @myCMSOId > 0
                 BEGIN
                 INSERT INTO [dbo].[CommunicationMessagesRefurbishedOrderItems]
                             ([CMSOId]
                             ,[ItemVerKit]
                             ,[ItemOrKitID]
                             ,[ItemOrKitDescription]
                             ,[ItemOrKitQuantity]
                             ,[ItemOrKitQuantityDelivered]
                             ,[ItemOrKitUnitOfMeasureId]
                             ,[ItemOrKitUnitOfMeasure]
                             ,[ItemOrKitQualityId]
                             ,[ItemOrKitQualityCode]
                             ,[IsActive]
                             ,[ModifyDate]
                             ,[ModifyUserId])
                       VALUES
                             ( @myCMSOId                   -- <CMSOId, int,>                              [CMSOId]
                             , @myItemVerKit               -- <ItemVerKit, int,>                          [ItemVerKit]
                             , @myItemOrKitID              -- <ItemOrKitID, int,>                         [ItemOrKitID]
                             , @myItemOrKitDescription     -- <ItemOrKitDescription, nvarchar(100),>      [ItemOrKitDesc
                             , @myItemOrKitQuantity        -- <ItemOrKitQuantity, numeric(18,3),>         [ItemOrKitQuan
                             , 0 -- <ItemOrKitQuantityDelivered, numeric(18,3),>                          [ItemOrKitQuan
                             , @myItemOrKitUnitOfMeasureId  -- <ItemOrKitUnitOfMeasureId, int,>           [ItemOrKitUnit
                             , @myItemOrKitUnitOfMeasure    -- <ItemOrKitUnitOfMeasure, nvarchar(50),>    [ItemOrKitUnit
                             , @myItemOrKitQualityId        -- <ItemOrKitQualityId, int,>                 [ItemOrKitQual
                             , @myItemOrKitQualityCode     -- <ItemOrKitQualityCode, nvarchar(50),>       [ItemOrKitQual
                             ,1                            -- <IsActive, bit,>                            [IsActive]
                             ,@myToDay                     -- <ModifyDate, datetime,>                     [ModifyDate]
                             ,@ModifyUserId                -- <ModifyUserId, int,>                        [ModifyUserId]
                             )
                      SET @myError = @myError + @@ERROR
                 END

                 FETCH NEXT FROM myCursor INTO  @myID ,@myItemVerKit ,@myItemOrKitID ,@myItemOrKitCode ,@myDescriptionCzItemsOrKit ,@myItemOrKitQuantity 
                                               ,@myPackageTypeId ,@mycdlStocksName ,@myDestinationPlacesId ,@myDestinationPlacesName ,@myDestinationPlacesContactsId 
                                               ,@myDestinationPlacesContactsName ,@myDateOfDelivery, @myStockId  , @myItemOrKitQualityId, @myQualityText
             END  -- @@FETCH_STATUS
             CLOSE myCursor;
             DEALLOCATE myCursor;

        IF @myError = 0 
        COMMIT TRAN 
        ELSE 
        ROLLBACK TRAN

     END

END TRY
BEGIN CATCH
      IF @@TRANCOUNT > 0 ROLLBACK TRAN
      SELECT @ReturnValue=1, @ReturnMessage='Chyba'
      SET @sub = 'Fenix - RF0  Refurbished Order' + ' Databáze: '+ISNULL(@myDatabaseName,'')
      SET @msg = 'Program prRORF0ins; '  + ISNULL(ERROR_MESSAGE(),'') + ISNULL(CAST(ERROR_NUMBER() AS VARCHAR(50)),'') 
      EXEC @result = msdb.dbo.sp_send_dbmail
     		@profile_name = 'Automat', --@MailProfileName
     		@recipients = 'max.weczerek@upc.cz',
     		@subject = @sub,
     		@body = @msg,
     		@body_format = 'HTML'
END CATCH

END




GO
GRANT EXECUTE
    ON OBJECT::[dbo].[prRORF0ins] TO [FenixW]
    AS [dbo];

