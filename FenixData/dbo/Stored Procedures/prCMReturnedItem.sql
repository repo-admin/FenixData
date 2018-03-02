


CREATE PROCEDURE [dbo].[prCMReturnedItem] 
      @par1 as XML,

	   @ReturnValue     int            = -1 OUTPUT,
	   @ReturnMessage   nvarchar(2048) = null OUTPUT
 AS
BEGIN
-- ===============================================================================================
-- Created by   : Weczerek Max
-- Created date : 2014-09-09
--                2014-09-30, 2014-10-08, 2014-10-20, 2014-10-23
-- Description  : 
-- ===============================================================================================
/*
Fáze VR2 -  z ND přijde MESSAGE, viz níže  (vrátka

nic nedělá, jen uloží data

*/
	SET NOCOUNT ON;
   DECLARE @myDatabaseName  nvarchar(100)
   BEGIN TRY
    
    SELECT @myDatabaseName = DB_NAME() 

   BEGIN --- DECLARACE
       DECLARE
	          @myID int,
             @myItemID int,
	          @myMessageId int,
	          @myMessageTypeId int,
	          @myMessageDescription nvarchar(200),
	          @myMessageDateOfShipment datetime,
	          @myMessageStatusId int,
	          @myOrderId int,
	          @myOrderDescription nvarchar(200),
             @myItemDescription nvarchar(200),
             @myHeliosOrderRecordID int,
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
             @myContactPhoneNumber2 nvarchar(15),
             @myContactFaxNumber nvarchar(15),
             @myContactFirstName nvarchar(100),
             @myContactLastName nvarchar(100),
             @myContactTitle char(1),
	          @myContactName nvarchar(200),
	          @myContactPhoneNumber varchar(200),
             @myContactEmail nvarchar(200),
	          @myItemVerKit bit,
	          @myItemOrKitID varchar(50),
	          @myItemOrKitDescription nvarchar(500),
	          @myItemOrKitQuantity numeric(18, 3),
             @myItemQuantity numeric(18, 3),
             @myItemOrKitUnitOfMeasureId  int,
             @myItemUnitOfMeasureID  int,
	          @myItemOrKitUnitOfMeasure varchar(50),
             @myItemUnitOfMeasure varchar(50),
	          @myItemOrKitQualityId int,
             @myItemQualityID int,
             @myItemOrKitQualityCode varchar(50),
             @myItemOrKitQuality varchar(50),
             @myItemQuality varchar(50),
	          @myItemOrKitDateOfDelivery datetime,
             @myMessageDateOfReceipt datetime,
	          @myItemType nvarchar(50),
	          @myIncotermsId int,
	          @myIncotermDescription nvarchar(50),
	          @myPackageTypeId int,
	          @myPackageTypeCode nvarchar(50),
             @myNDReceipt nvarchar(50),
	          @myShipmentOrderSource int,
             @myStatus int,
	          @myVydejkyId int,
	          @myRequiredDateOfShipment datetime,
             @myRealDateOfDelivery datetime,
             @myRealItemOrKitQuantity numeric(18,3),
             @myRealItemOrKitQualityID int, 
             @myRealItemOrKitQuality nvarchar(50),
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
             @myRequiredDateOfReceipt datetime,
             @myDestinationPlacesName nvarchar(150),
             @myDestinationPlacesContactsName nvarchar(150),
             @myToDay datetime,
             @myPackagingValue int,
             @mySingleOrMaster int,
             @myCMSOId  int,
             @myPackageValue int
             ,@myShipmentOrderID int
             ,@myHeliosOrderID int
             ,@myCardStockItemsId int
             ,@myReturnedFrom nvarchar(4000)
             ,@mySN1 nvarchar(150)
             ,@mySN2 nvarchar(150)
             , @myAnnouncement [nvarchar](max)

             SET @myAnnouncement = ''


      DECLARE 

             @myKeyMessageID int,
             @myKeyMessageTypeID int,
             @myKeyItemOrKitQualityID int,
             @myKeyReturnedFrom  nvarchar(4000),
             @myKeyItemOrKitQuality  nvarchar(150)

       SET @myItemSNs=''
       SET @myToDay = GetDate()
       SET @mySingleOrMaster = 0

       DECLARE
          @myPocet [int],
          @myError [int],   
          @myIdentity  [int],
          @myIdentityx  [int],
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
      IF OBJECT_ID('tempdb..#TmpCMReturnedItem','table') IS NOT NULL DROP TABLE #TmpCMReturnedItem
      IF OBJECT_ID('tempdb..#TmpCMReturnedItemItems','table') IS NOT NULL DROP TABLE #TmpCMReturnedItemItems
      IF OBJECT_ID('tempdb..#TmpCMReturnedItemItemsSN','table') IS NOT NULL DROP TABLE #TmpCMReturnedItemItemsSN

      EXEC sp_xml_preparedocument @hndl OUTPUT, @par1

      SELECT x.[ID], x.[MessageID], x.[MessageTypeID], x.[MessageTypeDescription], x.ItemID,x.ItemDescription, x.ItemQuantity,x.ItemUnitOfMeasureID,x.ItemUnitOfMeasure, x.[ItemQualityID], x.[ItemQuality],
             x.[ReturnedFrom]   -- , x.[SN] --, x.[SN2]
      INTO #TmpCMReturnedItem
      FROM OPENXML (@hndl, '/NewDataSet/CommunicationMessagesReturnedItem/items/item',2)
      WITH (
      ID                             int             '../../ID',
      MessageID                      int             '../../MessageID',
      MessageTypeID                  int             '../../MessageTypeID',
      MessageTypeDescription         nvarchar(150)   '../../MessageTypeDescription',
      ItemID                         int             'ItemID',
      ItemDescription                nvarchar(150)   'ItemDescription',
      ItemQuantity                   numeric (18,3)  'ItemQuantity',
      ItemUnitOfMeasureID            int             'ItemUnitOfMeasureID',
      ItemUnitOfMeasure              nvarchar(150)   'ItemUnitOfMeasure',
      ItemQualityID                  int             'ItemQualityID',
      ItemQuality                    nvarchar(150)   'ItemQuality',
      ReturnedFrom                   nvarchar(400)   'ReturnedFrom'
      ) x

      SELECT x.[ID], x.[MessageID], x.[MessageTypeID], x.[MessageTypeDescription], x.ItemID, x.ItemDescription,x.ItemQuantity, x.ItemUnitOfMeasureID, x.ItemUnitOfMeasure,  x.[ItemQualityID], x.[ItemQuality],
             x.[ReturnedFrom], x.[SN]
      INTO #TmpCMReturnedItemItemsSN
      FROM OPENXML (@hndl, '/NewDataSet/CommunicationMessagesReturnedItem/items/item/ItemSNs/ItemSN',2)
      WITH (
      ID                             int           '../../../../ID',
      MessageID                      int           '../../../../MessageID',
      MessageTypeID                  int           '../../../../MessageTypeID',
      MessageTypeDescription         nvarchar(150) '../../../../MessageTypeDescription',
      ItemID                         int           '../../ItemID',
      ItemDescription                nvarchar(150) '../../ItemDescription',
      ItemQuantity                   numeric (18,3)'../../ItemQuantity',
      ItemUnitOfMeasureID            int            '../../ItemUnitOfMeasureID',
      ItemUnitOfMeasure              nvarchar(150) '../../ItemUnitOfMeasure',
      ItemQualityID                  int           '../../ItemQualityID',
      ItemQuality                    nvarchar(150) '../../ItemQuality',
      ReturnedFrom                   nvarchar(4000)'../../ReturnedFrom',
      SN                            nvarchar(150)  '@SN'
      ) x

      SELECT x.[ID], x.[MessageID], x.[MessageTypeID], x.[MessageTypeDescription], x.ItemID, x.ItemDescription,x.ItemQuantity, x.ItemUnitOfMeasureID, x.ItemUnitOfMeasure,  x.[ItemQualityID], x.[ItemQuality],
             x.[ReturnedFrom]
      INTO #TmpCMReturnedItemItems
      FROM OPENXML (@hndl, '/NewDataSet/CommunicationMessagesReturnedItem/items/item',2)
      WITH (
      ID                             int           '../../ID',
      MessageID                      int           '../../MessageID',
      MessageTypeID                  int           '../../MessageTypeID',
      MessageTypeDescription         nvarchar(150) '../../MessageTypeDescription',
      ItemID                         int           'ItemID',
      ItemDescription                nvarchar(150) 'ItemDescription',
      ItemQuantity                   numeric (18,3)'ItemQuantity',
      ItemUnitOfMeasureID            int            'ItemUnitOfMeasureID',
      ItemUnitOfMeasure              nvarchar(150) 'ItemUnitOfMeasure',
      ItemQualityID                  int           'ItemQualityID',
      ItemQuality                    nvarchar(150) 'ItemQuality',
      ReturnedFrom                   nvarchar(4000)'ReturnedFrom'
      ) x

      EXEC sp_xml_removedocument @hndl

 
  

      SELECT @myMessageId              = CAST(a.MessageId AS VARCHAR(50)),
             @myMessageTypeId          = CAST(a.MessageTypeID AS VARCHAR(50)),
             @myMessageTypeDescription = a.MessageTypeDescription
       FROM (
             SELECT TOP 1 MessageId,MessageTypeID,MessageTypeDescription FROM #TmpCMReturnedItem Tmp
             ) a

---- ===========
      SELECT * FROM #TmpCMReturnedItem
      SELECT * FROM #TmpCMReturnedItemItems
      SELECT * FROM #TmpCMReturnedItemItemsSN
 ---- ===========   

      BEGIN -- ============================ Zpracování ===============================

      UPDATE #TmpCMReturnedItemItems SET ItemUnitOfMeasureID = cI.MeasuresId, ItemUnitOfMeasure =cM.[Code]
      FROM #TmpCMReturnedItemItems      Tmp
      INNER JOIN [dbo].[cdlItems]       cI
      ON Tmp.ItemID = cI.Id
      INNER JOIN [dbo].[cdlMeasures]    cM
      ON cI.MeasuresId = cM.ID

      UPDATE #TmpCMReturnedItemItemsSN SET ItemUnitOfMeasureID = cI.MeasuresId, ItemUnitOfMeasure =cM.[Code]
      FROM #TmpCMReturnedItemItemsSN      Tmp
      INNER JOIN [dbo].[cdlItems]       cI
      ON Tmp.ItemID = cI.Id
      INNER JOIN [dbo].[cdlMeasures]    cM
      ON cI.MeasuresId = cM.ID
            
         SELECT  @myPocet = COUNT(*) 
         FROM [dbo].[CommunicationMessagesReturnedItem]
         WHERE [MessageId] = @myMessageId AND [MessageTypeId] = @myMessageTypeId AND  MessageDescription = @myMessageTypeDescription
   
         IF @myPocet = 0 OR  @myPocet IS NULL
         BEGIN  -- @mOK=1

            IF (SELECT CURSOR_STATUS('global','myCursor')) >= -1
             BEGIN
                      DEALLOCATE myCursor
             END
             SET @myError=0 
             SET @myIdentity = 0
             SET @myItemSNs = ''

             BEGIN TRAN
             DECLARE myCursor CURSOR 
             FOR  
             SELECT DISTINCT x.[ID], x.[MessageID], x.[MessageTypeID], x.[MessageTypeDescription]
                FROM #TmpCMReturnedItem x ORDER BY MessageID, MessageTypeID

             OPEN myCursor
             FETCH NEXT FROM myCursor INTO   @myID, @myMessageID, @myMessageTypeID, @myMessageTypeDescription
                   -- ,@myReturnedFrom, @mySN1, @mySN2

             SELECT @myKeyMessageID = -1, @myKeyMessageTypeID = -1

             WHILE @@FETCH_STATUS = 0
             BEGIN  -- @@FETCH_STATUS    
                   IF @myKeyMessageID <> @myMessageID  OR @myKeyMessageTypeID <> @myMessageTypeID
                    BEGIN
                       SELECT @myKeyMessageID = @myMessageID, @myKeyMessageTypeID = @myMessageTypeID
                       INSERT INTO [dbo].[CommunicationMessagesReturnedItem]
                                  ([MessageId]
                                  ,[MessageTypeId]
                                  ,[MessageDescription]
                                  ,[MessageDateOfReceipt]
                                  ,[Reconciliation]
                                  ,[IsActive]
                                  ,[ModifyDate]
                                  ,[ModifyUserId])
                            VALUES
                                  (@myMessageId              -- <MessageId, int,>
                                  ,@myMessageTypeId          -- <MessageTypeId, int,>
                                  ,@myMessageTypeDescription -- <MessageDescription, nvarchar(200),>
                                  ,NULL                      -- <MessageDateOfReceipt, datetime,>
                                  ,0
                                  ,1                         -- <IsActive, bit,>
                                  ,@myToDay                  -- <ModifyDate, datetime,>
                                  ,0                         -- <ModifyUserId, int,>
                                  )    
                                                      
                        SET @myError = @myError + @@ERROR
                        SET @myIdentity = @@IDENTITY 
                        SET @myAnnouncement = @myAnnouncement + CAST(@myIdentity AS VARCHAR(50))+','
--SELECT @myIdentity '@myIdentity', @myError '@myError'
                    END

                    IF @myError=0 AND @myIdentity>0
                    BEGIN  -- 1
                    -- *******************************************
                       IF (SELECT CURSOR_STATUS('global','myCursorItems')) >= -1
                       BEGIN
                          DEALLOCATE myCursorItems
                       END

                       DECLARE myCursorItems CURSOR 
                       FOR  
                       SELECT DISTINCT x.[ID], x.[MessageID], x.[MessageTypeID], x.[MessageTypeDescription],  x.ItemID, x.ItemDescription
                                     , x.ItemQuantity, x.ItemUnitOfMeasureID, x.ItemUnitOfMeasure,  x.[ItemQualityID], x.[ItemQuality]
                                     , x.[ReturnedFrom] FROM #TmpCMReturnedItemItems x WHERE x.[MessageID] = @myKeyMessageID AND x.[MessageTypeID] = @myKeyMessageTypeID 
                                     ORDER BY x.ItemID,  x.[ItemQualityID], x.[ReturnedFrom]

                       OPEN myCursorItems
                       FETCH NEXT FROM myCursorItems INTO   @myID, @myMessageID, @myMessageTypeID, @myMessageTypeDescription
                                     , @myItemID, @myItemDescription,@myItemQuantity, @myItemUnitOfMeasureID, @myItemUnitOfMeasure,  @myItemQualityID, @myItemQuality
                                     , @myReturnedFrom

                       WHILE @@FETCH_STATUS = 0
                       BEGIN  -- myCursorItems 
                           SET @myItemSNs = ''   
                           SELECT @myItemSNs = @myItemSNs + SN+','+ReturnedFrom+';' 
                           FROM #TmpCMReturnedItemItemsSN WHERE 
                                  @myKeyMessageID = MessageID AND @myKeyMessageTypeID = MessageTypeID
                                  AND @myItemID = ItemID AND @myItemQuantity = ItemQuantity
                                  AND @myItemUnitOfMeasureID = ItemUnitOfMeasureID  AND  @myItemQualityID = ItemQualityID
                                  AND  @myReturnedFrom = ReturnedFrom

                                  IF LEN(@myItemSNs)>2
                                  SET @myItemSNs = LEFT(@myItemSNs, LEN(@myItemSNs)-1)
                                  ELSE
                                  SET @myItemSNs = ''

                                  INSERT INTO [dbo].[CommunicationMessagesReturnedItemItems]
                                             ([CMSOId]
                                             ,[ItemId]
                                             ,[ItemDescription]
                                             ,[ItemQuantity]
                                             ,[ItemOrKitQualityId]
                                             ,[ItemOrKitQuality]
                                             ,[ItemUnitOfMeasureId]
                                             ,[ItemUnitOfMeasure]
                                             ,[SN]
                                             ,[NDReceipt]
                                             ,[ReturnedFrom]
                                             ,[IsActive]
                                             ,[ModifyDate]
                                             ,[ModifyUserId])
                                       VALUES
                                             (@myIdentity                           -- <CMSOId, int,>
                                             ,@myItemID                             -- <ItemId, int,>
                                             ,@myItemDescription                    -- <ItemDescription, nvarchar(50),>
                                             ,@myItemQuantity
                                             ,@myItemQualityID                      -- <ItemOrKitQualityId, int,>
                                             ,@myItemQuality                        -- <ItemOrKitQuality, nvarchar(50),>
                                             ,@myItemUnitOfMeasureID                -- <ItemUnitOfMeasureId, int,>
                                             ,@myItemUnitOfMeasure                  -- <ItemUnitOfMeasure, nvarchar(50),>
                                             ,@myItemSNs                            -- <SN, nvarchar(max),>
                                             ,NULL                                  -- <NDReceipt, nvarchar(100),>
                                             ,@myReturnedFrom                       -- <ReturnedFrom, nvarchar(max),>
                                             ,1                                     -- <IsActive, bit,>
                                             ,@myToDay                              -- <ModifyDate, datetime,>
                                             ,0                                     -- <ModifyUserId, int,>
                                             )
                                             
                           SET @myError = @myError + @@ERROR
                           SET @myIdentityx = @@IDENTITY 
--SELECT @myIdentityx '@myIdentityx', @myError '@myError'
                           IF @myError = 0 AND @myIdentityx>0
                           BEGIN
                                INSERT INTO [dbo].[CommunicationMessagesReturnedItemsSerNum]
                                           ([RefurbishedItemsOrKitsID]
                                           ,[SN]
                                           ,[IsActive]
                                           ,[ModifyDate]
                                           ,[ModifyUserId])
                                SELECT @myIdentityx, [SN], 1, @myToDay, 0 FROM #TmpCMReturnedItemItemsSN 
                                WHERE 
                                    @myKeyMessageID = MessageID AND @myKeyMessageTypeID = MessageTypeID
                                    AND @myItemID = ItemID AND @myItemQuantity = ItemQuantity
                                    AND @myItemUnitOfMeasureID = ItemUnitOfMeasureID  AND  @myItemQualityID = ItemQualityID
                                    AND  @myReturnedFrom = ReturnedFrom

                                 SET @myError = @myError + @@ERROR
                           END

                        FETCH NEXT FROM myCursorItems INTO   @myID, @myMessageID, @myMessageTypeID, @myMessageTypeDescription
                                     , @myItemID, @myItemDescription,@myItemQuantity, @myItemUnitOfMeasureID, @myItemUnitOfMeasure,  @myItemQualityID, @myItemQuality
                                     , @myReturnedFrom
                       END  -- myCursorItems    
                       CLOSE myCursorItems;
                       DEALLOCATE myCursorItems;

                    -- *******************************************
                    END  -- 1

                   FETCH NEXT FROM myCursor INTO   @myID, @myMessageID, @myMessageTypeID, @myMessageTypeDescription

             END    -- @@FETCH_STATUS
             CLOSE myCursor;
             DEALLOCATE myCursor;
               
             IF @myError = 0 
             BEGIN   
                 IF @@TRANCOUNT > 0 COMMIT TRAN
                 SET @sub = 'FENIX - VR2 - Oznámení' + ' Databáze: '+ISNULL(@myDatabaseName,'')
                 SET @msg = 'Vrátky typu VR2 - Byly obdrženy následující message(ID = ) <br />'  + @myAnnouncement +''
		 	        EXEC @result = msdb.dbo.sp_send_dbmail
		 	             @profile_name = 'Automat', --@MailProfileName
		 	             @recipients = @myAdresaLogistika,
                      @copy_recipients = @myAdresaProgramator,
		 	             @subject = @sub,
		 	             @body = @msg,
    	 	             @body_format = 'HTML'
             END
             ELSE
             BEGIN   
                 IF @@TRANCOUNT > 0 ROLLBACK TRAN
                 SELECT @ReturnValue=@myError, @ReturnMessage='Chyba'
             END

         END    -- @mOK=1
         ELSE
         BEGIN
             IF @myPocet>0
             BEGIN 
                   IF @@TRANCOUNT > 0 ROLLBACK TRAN
                   SELECT @ReturnValue=1, @ReturnMessage='CInfo'
                   SET @sub = 'Fenix - VR2' + ' Databáze: '+ISNULL(@myDatabaseName,'')
                   SET @msg = 'Program [dbo].[prCMReturnedItem]; Záznam MessageId=' + ISNULL(CAST(@myMessageId AS VARCHAR(50)),'') + ', MessageTypeId = '+ ISNULL(CAST(@myMessageTypeId AS VARCHAR(50)),'') + ' byl již jednou naveden !'
                   EXEC @result = msdb.dbo.sp_send_dbmail
               		@profile_name = 'Automat', --@MailProfileName
               		@recipients = 'jaroslav.tajbl@upc.cz;michal.rezler@upc.cz',
               		@subject = @sub, 
               		@body = @msg,
               		@body_format = 'HTML'
              END
         END
        END-- ============================ Zpracování ===============================


END TRY
BEGIN CATCH
       IF @@TRANCOUNT > 0 ROLLBACK TRAN
    
       SELECT @ReturnValue=1, @ReturnMessage='Chyba'
       SET @sub = 'Fenix - VR2 CHYBA' + ' Databáze: '+ISNULL(@myDatabaseName,'')
       SET @msg = 'Program [dbo].[prCMReturnedItem]; '  + ISNULL(ERROR_MESSAGE(),'') + ISNULL(CAST(ERROR_NUMBER() AS VARCHAR(50)),'') 
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
    ON OBJECT::[dbo].[prCMReturnedItem] TO [FenixW]
    AS [dbo];

