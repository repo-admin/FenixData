CREATE PROCEDURE [dbo].[prKiSHins] 
			@par1 as XML,
			@ModifyUserId         AS INT = 0,
			@ShipmentOrderSource  AS INT = 0,
			@VydejkyId            AS INT = 0,
			@Remark               AS nvarchar(4000) = null,
			@ReturnValue     int            = -1 OUTPUT,
			@ReturnMessage   nvarchar(2048) = null OUTPUT
 AS
BEGIN
-- ===============================================================================================
-- Created by   : Weczerek Max
-- Created date : 2014-08-27
-- Updated date : 2014-09-05,2014-09-09
--              : 2015-05-26 M. Rezler  .. přidán parametr a sloupec Remark 
-- Description  : 
-- ===============================================================================================
/*
Fáze S0 -  z Fenixu přijde XML s požadavkem na expedici

Kontroluje data
Aktualizuje karty

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
	          @myIncotermsId int,
	          @myIncoterms nvarchar(50),
	          @myPackageTypeId int,
	          @myPackageTypeCode nvarchar(50),
	          @myShipmentOrderSource int,
	          @myVydejkyId int,
	          @myRequiredDateOfShipment datetime,
	          @myStockId int,
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
             @myDateOfExpedition nvarchar(50),
             @myDestinationPlacesName nvarchar(150),
             @myDestinationPlacesContactsName nvarchar(150),
             @myToDay datetime,
             @myPackagingValue int,
             @mySingleOrMaster int,
             @myCMSOId  int,
             @myPackageValue int,
             @myOrderIdFromTable int


       DECLARE 
             @myKeyItemVerKit int,
	          @myKeyItemOrKitID int,
             @myKeyDestinationPlacesId int,
             @myKeyDestinationPlacesContactsId int,
             @myKeyDateOfExpedition  nvarchar(20),
             @myKeycdlStocksName  nvarchar(100)

       SET @myItemSNs=''
       SET @myToDay = GetDate()
       SET @mySingleOrMaster = 0
       SET @myShipmentOrderSource = @ShipmentOrderSource
       SET @myVydejkyId = @VydejkyId
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
      IF OBJECT_ID('tempdb..#TmpKiSH','table') IS NOT NULL DROP TABLE #TmpKiSH

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
            ,x.DateOfExpedition 
            ,x.IncotermsId
      INTO #TmpKiSH
      FROM OPENXML (@hndl, '/NewDataSet/Expedice',2)
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
      DateOfExpedition                nvarchar(50)  'DateOfExpedition',
      IncotermsId                     int           'IncotermsId'
      ) x
 

      EXEC sp_xml_removedocument @hndl

      SELECT * FROM #TmpKiSH ORDER BY cdlStocksName, ItemVerKit,  ItemOrKitID,  DestinationPlacesId, DestinationPlacesContactsId, DateOfExpedition

      BEGIN -- ============================ Zpracování ===============================
             SELECT @myMessageTypeId=6, @myMessageTypeDescription = 'ShipmentOrder'

             IF (SELECT CURSOR_STATUS('global','myCursor')) >= -1 BEGIN  DEALLOCATE myCursor  END
             SELECT @myError=0, @myIdentity = 0
             SELECT @myKeyItemVerKit = -1,  @myKeyItemOrKitID = -1,  @myKeyDestinationPlacesId = -1,  @myKeyDestinationPlacesContactsId = -1,
                    @myKeyDateOfExpedition = '-1', @myKeycdlStocksName = '-1'

         BEGIN TRAN

             SET @myError  = 0
             SET @myError2 = 0

             DECLARE myCursor CURSOR 
             FOR  SELECT x.ID ,x.ItemVerKit ,x.ItemOrKitID ,x.ItemOrKitCode ,x.DescriptionCzItemsOrKit ,x.ItemOrKitQuantity ,x.PackageTypeId ,x.cdlStocksName 
                        ,x.DestinationPlacesId ,x.DestinationPlacesName ,x.DestinationPlacesContactsId ,x.DestinationPlacesContactsName ,x.DateOfExpedition 
                        ,x.IncotermsId
                  FROM #TmpKiSH x ORDER BY x.cdlStocksName,  x.DestinationPlacesId, x.DestinationPlacesContactsId, x.ItemVerKit,  x.ItemOrKitID, x.DateOfExpedition
                                         , x.IncotermsId

             OPEN myCursor
             FETCH NEXT FROM myCursor INTO  @myID ,@myItemVerKit ,@myItemOrKitID ,@myItemOrKitCode ,@myDescriptionCzItemsOrKit ,@myItemOrKitQuantity 
                                           ,@myPackageTypeId ,@mycdlStocksName ,@myDestinationPlacesId ,@myDestinationPlacesName ,@myDestinationPlacesContactsId 
                                           ,@myDestinationPlacesContactsName ,@myDateOfExpedition , @myIncotermsId 

             WHILE @@FETCH_STATUS = 0
             BEGIN --@@FETCH_STATUS
--SELECT @myID ,@myItemVerKit ,@myItemOrKitID  ,@myItemOrKitQualityId   '@myItemOrKitQualityId -5' 
                 IF  @myKeyDestinationPlacesId <> @myDestinationPlacesId OR   
                     @myKeyDestinationPlacesContactsId <> @myDestinationPlacesContactsId OR @myKeyDateOfExpedition <> @myDateOfExpedition OR  @myKeycdlStocksName <> @mycdlStocksName
                 BEGIN   -- IF 
                     SELECT @myKeyItemVerKit = @myItemVerKit,  @myKeyItemOrKitID = @myItemOrKitID,  @myKeyDestinationPlacesId = @myDestinationPlacesId,  
                            @myKeyDestinationPlacesContactsId = @myDestinationPlacesContactsId,@myKeyDateOfExpedition = @myDateOfExpedition,
                            @myKeycdlStocksName = @mycdlStocksName
           
                     SELECT  @myCustomerID         = [ID]
                            ,@myCustomerName       = [CompanyName]
                            ,@myCustomerCity       = [City]
                            ,@myCustomerAddress1   = [StreetName]
                            ,@myCustomerAddress3   = [StreetOrientationNumber]
                            ,@myCustomerAddress2   = [StreetHouseNumber]
                            ,@myCustomerZipCode    = [ZipCode]
                            ,@myCustomerCountryISO = [CountryISO]
                     FROM [dbo].[cdlDestinationPlaces] WHERE IsActive = 1 AND id = @myKeyDestinationPlacesId  -- cdlDestinationPlaces
           
                     SELECT  @myContactID           = [ID]
                            ,@myContactPhoneNumber1 = [PhoneNumber]
                            ,@myContactFirstName    = [FirstName]
                            ,@myContactLastName     = [LastName]
                            ,@myContactTitle        = [Title]
                            ,@myContactEmail        = [ContactEmail]
                     FROM [dbo].[cdlDestinationPlacesContacts] WHERE [DestinationPlacesId] = @myCustomerID AND [IsActive] = 1 AND ID = @myKeyDestinationPlacesContactsId
--SELECT @myCustomerID, @myContactLastName, @myKeyDestinationPlacesContactsId           
                     SELECT @myStockId =  [StockId], @myItemOrKitQualityId = [ItemOrKitQuality] FROM [dbo].[CardStockItems] WHERE id = @myID
--SELECT @myID ,@myItemOrKitQualityId   '@myItemOrKitQualityId -4'  
                     SELECT @myMessageId = [LastFreeNumber]  FROM [dbo].[cdlMessageNumber] WHERE CODE = 1
                     UPDATE [dbo].[cdlMessageNumber] SET [LastFreeNumber] = [LastFreeNumber] + 1  WHERE CODE = 1

                    EXEC [dbo].[prGetOrderNumber] @HeliosOrderIdin = -1, @OrderNumberOut = @myOrderIdFromTable output                 
                    --SELECT @myOrderIdFromTable = [LastFreeNumber] FROM [dbo].[cdlOrderNumber]  WHERE [Code]='1'
                    --UPDATE [dbo].[cdlOrderNumber] SET [LastFreeNumber] = ISNULL(@myOrderIdFromTable,0)-1
--SELECT @myID ,@myItemOrKitQualityId   '@myItemOrKitQualityId -3'             
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
													 ,[Remark])
                     VALUES
                           ( @myMessageId               -- <MessageId, int,>
                           , @myMessageTypeId           -- <MessageTypeId, int,>
                           , @myMessageTypeDescription  -- <MessageDescription, nvarchar(200),>
                           , NULL                       -- <MessageDateOfShipment, datetime,>
                           , @myKeyDateOfExpedition     -- <RequiredDateOfShipment, datetime,>
                           , 1                          -- <MessageStatusId, int,>
                           , @myOrderIdFromTable        -- <HeliosOrderId, int,>
                           , @myCustomerID              -- <CustomerID, int,>
                           , @myCustomerName            -- <CustomerName, nvarchar(100),>
                           , @myCustomerAddress1        -- <CustomerAddress1, nvarchar(100),>
                           , @myCustomerAddress2        -- <CustomerAddress2, nvarchar(50),>
                           , ISNULL(@myCustomerAddress3,'')        -- <CustomerAddress3, nvarchar(50),>
                           , @myCustomerCity            -- <CustomerCity, nvarchar(150),>
                           , @myCustomerZipCode         -- <CustomerZipCode, nvarchar(10),>
                           , @myCustomerCountryISO      -- <CustomerCountryISO, char(3),>
                           , @myContactID               -- <ContactID, int,>
                           , @myContactTitle            -- <ContactTitle, char(1),>
                           , @myContactFirstName        -- <ContactFirstName, nvarchar(35),>
                           , @myContactLastName         -- <ContactLastName, nvarchar(35),>
                           , @myContactPhoneNumber1     -- <ContactPhoneNumber1, nvarchar(15),>
                           , NULL                       -- <ContactPhoneNumber2, nvarchar(15),>
                           , NULL                       -- <ContactFaxNumber, nvarchar(15),>
                           , @myContactEmail
                           , 1                          -- <IsManually, bit,>
                           , @myStockId                 -- <StockId, int,>
                           , 1                          -- <IsActive, bit,>
                           , @myToDay                   -- <ModifyDate, datetime,>
                           , @myModifyUserId            -- <ModifyUserId, int,>
													 , @Remark
                           )
                     SET @myError = @myError + @@ERROR
                     SET @myCMSOId = @@IDENTITY
           
                 END     -- IF 

                 -- *********************************************************************************************************************************************
--SELECT @myID ,@myItemOrKitQualityId '@myItemOrKitQualityId -2'
                 IF @myItemVerKit = 0
                 BEGIN  SELECT @myItemOrKitUnitOfMeasureId = [MeasuresId], @myPackagingValue = [Packaging], @myItemOrKitDescription = [DescriptionCz], @myItemType = [ItemType]  FROM [dbo].[cdlItems] WHERE Id = @myItemOrKitID END
                 ELSE
                 BEGIN  SELECT @myItemOrKitUnitOfMeasureId = [MeasuresId], @myPackagingValue = [Packaging], @myItemOrKitDescription = [DescriptionCz], @myItemType=''  FROM [dbo].[cdlKits] WHERE ID = @myItemOrKitID END

                 SELECT @myStockId =  [StockId], @myItemOrKitQualityId = [ItemOrKitQuality] FROM [dbo].[CardStockItems] WHERE id = @myID

                 SELECT @myItemOrKitUnitOfMeasure = [Code]  FROM [dbo].[cdlMeasures]     WHERE [ID] = @myItemOrKitUnitOfMeasureId
                 SELECT @myItemOrKitQualityCode = [Code]    FROM [dbo].[cdlQualities]    WHERE [ID] = @myItemOrKitQualityId 
                 SELECT @myIncoterms = [DescriptionCz]      FROM [dbo].[cdlIncoterms]    WHERE ID   = @myIncotermsId
                 SET @myItemOrKitDateOfDelivery = CAST(@myDateOfExpedition AS datetime)
--SELECT @myID ,@myItemOrKitQualityId '@myItemOrKitQualityId -1'
                 -- ===========================================
                 IF @myPackagingValue = 0 OR @myPackagingValue IS NULL   SET @myPackagingValue = 999999999     --  !!!!!!!!!!!!!!!!!!!!!!!!!! ==================
 
                 IF @myPackagingValue > @myItemOrKitQuantity
                 BEGIN
--SELECT @myID ,@myItemOrKitQualityId '@myItemOrKitQualityId 0'
                      SET @myError2=0
                      SET @mySingleOrMaster = 0
                      EXEC [dbo].[prCMSOIins]
                            @CMSOId                   = @myCMSOId                  
                           ,@SingleOrMaster           = @mySingleOrMaster          
                           ,@ItemVerKit               = @myItemVerKit              
                           ,@ItemOrKitID              = @myItemOrKitID             
                           ,@ItemOrKitDescription     = @myItemOrKitDescription    
                           ,@ItemOrKitQuantity        = @myItemOrKitQuantity       
                           ,@ItemOrKitUnitOfMeasureId = @myItemOrKitUnitOfMeasureId
                           ,@ItemOrKitUnitOfMeasure   = @myItemOrKitUnitOfMeasure  
                           ,@ItemOrKitQualityId       = @myItemOrKitQualityId      
                           ,@ItemOrKitQualityCode     = @myItemOrKitQualityCode    
                           ,@ItemOrKitDateOfDelivery  = @myItemOrKitDateOfDelivery 
                           ,@ItemType                 = @myItemType                
                           ,@IncotermsId              = @myIncotermsId             
                           ,@Incoterms                = @myIncoterms               
                           ,@PackageValue             = @myPackagingValue            
                           ,@ShipmentOrderSource      = @myShipmentOrderSource     
                           ,@VydejkyId                = @myVydejkyId               
                           ,@ModifyDate               = @myToDay              
                           ,@ModifyUserId             = @myModifyUserId  
                           ,@CardStockItemsId         = @myID          
                           ,@Error = @myError2 output
 
                           SET @myError = @myError + @myError2
 
                 END
                 ELSE
                 BEGIN
                      SET @mySingleOrMaster = 1
                      DECLARE @tempOrKitQuantity AS numeric(18,3)
                      SET @tempOrKitQuantity = 0


                      WHILE (@myItemOrKitQuantity - @tempOrKitQuantity >= @myPackagingValue   )
                      BEGIN
                         SET @tempOrKitQuantity = @myPackagingValue + @tempOrKitQuantity
                      END
                       
                      DECLARE @tempNumOrKitQuantity numeric(18,3)
                      SET @tempNumOrKitQuantity = CAST(@tempOrKitQuantity AS numeric(18,3))

--SELECT @myID ,@myItemOrKitQualityId '@myItemOrKitQualityId 1'
                      EXEC [dbo].[prCMSOIins]
                            @CMSOId                   = @myCMSOId
                           ,@SingleOrMaster           = @mySingleOrMaster          
                           ,@ItemVerKit               = @myItemVerKit              
                           ,@ItemOrKitID              = @myItemOrKitID             
                           ,@ItemOrKitDescription     = @myItemOrKitDescription    
                           ,@ItemOrKitQuantity        = @tempNumOrKitQuantity
                           ,@ItemOrKitUnitOfMeasureId = @myItemOrKitUnitOfMeasureId
                           ,@ItemOrKitUnitOfMeasure   = @myItemOrKitUnitOfMeasure  
                           ,@ItemOrKitQualityId       = @myItemOrKitQualityId      
                           ,@ItemOrKitQualityCode     = @myItemOrKitQualityCode    
                           ,@ItemOrKitDateOfDelivery  = @myItemOrKitDateOfDelivery
                           ,@ItemType                 = @myItemType                
                           ,@IncotermsId              = @myIncotermsId             
                           ,@Incoterms                = @myIncoterms               
                           ,@PackageValue             = @myPackagingValue            
                           ,@ShipmentOrderSource      = @myShipmentOrderSource     
                           ,@VydejkyId                = @myVydejkyId               
                           ,@ModifyDate               = @myToDay              
                           ,@ModifyUserId             = @myModifyUserId
                           ,@CardStockItemsId         = @myID             
                           ,@Error              = @myError2 output

                           SET @myError = @myError + @myError2
 
                           SET @tempNumOrKitQuantity = CAST(@myItemOrKitQuantity - @tempNumOrKitQuantity  AS numeric(18,3))
                           IF @tempNumOrKitQuantity > 0 
                           BEGIN
--SELECT @myID ,@myItemOrKitQualityId '@myItemOrKitQualityId 2' 
                               EXEC [dbo].[prCMSOIins]
                                     @CMSOId                   = @myCMSOId                  
                                    ,@SingleOrMaster           = 0          
                                    ,@ItemVerKit               = @myItemVerKit              
                                    ,@ItemOrKitID              = @myItemOrKitID             
                                    ,@ItemOrKitDescription     = @myItemOrKitDescription    
                                    ,@ItemOrKitQuantity        = @tempNumOrKitQuantity       
                                    ,@ItemOrKitUnitOfMeasureId = @myItemOrKitUnitOfMeasureId
                                    ,@ItemOrKitUnitOfMeasure   = @myItemOrKitUnitOfMeasure  
                                    ,@ItemOrKitQualityId       = @myItemOrKitQualityId      
                                    ,@ItemOrKitQualityCode     = @myItemOrKitQualityCode    
                                    ,@ItemOrKitDateOfDelivery  = @myItemOrKitDateOfDelivery
                                    ,@ItemType                 = @myItemType                
                                    ,@IncotermsId              = @myIncotermsId             
                                    ,@Incoterms                = @myIncoterms               
                                    ,@PackageValue             = @myPackagingValue            
                                    ,@ShipmentOrderSource      = @myShipmentOrderSource     
                                    ,@VydejkyId                = @myVydejkyId               
                                    ,@ModifyDate               = @myToDay              
                                    ,@ModifyUserId             = @myModifyUserId 
                                    ,@CardStockItemsId         = @myID            
                                    ,@Error              = @myError2 output
                           
                                SET @myError = @myError + @myError2
                           END
                 END   
                 FETCH NEXT FROM myCursor INTO  @myID ,@myItemVerKit ,@myItemOrKitID ,@myItemOrKitCode ,@myDescriptionCzItemsOrKit ,@myItemOrKitQuantity 
                                               ,@myPackageTypeId ,@mycdlStocksName ,@myDestinationPlacesId ,@myDestinationPlacesName ,@myDestinationPlacesContactsId 
                                               ,@myDestinationPlacesContactsName ,@myDateOfExpedition, @myIncotermsId  
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
      SET @sub = 'FENIX - S0  Shipment order' + ' Databáze: '+ISNULL(@myDatabaseName,'')
      SET @msg = 'Program prKiSHins; '  + ISNULL(ERROR_MESSAGE(),'') + ISNULL(CAST(ERROR_NUMBER() AS VARCHAR(50)),'') + 
                 ' --  @myCustomerID ='+ISNULL(CAST(@myCustomerID AS VARCHAR(50)),'')+' ,@myKeyDestinationPlacesContactsId='+ISNULL(CAST(@myKeyDestinationPlacesContactsId AS VARCHAR(150)),'')
                 +', @VydejkyId ='+ISNULL(CAST(@VydejkyId AS VARCHAR(50)),'')
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
    ON OBJECT::[dbo].[prKiSHins] TO [FenixW]
    AS [dbo];

