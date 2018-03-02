
CREATE PROCEDURE [dbo].[prCMReturnedShipment] 
      @par1 as XML,

	   @ReturnValue     int            = -1 OUTPUT,
	   @ReturnMessage   nvarchar(2048) = null OUTPUT
 AS
BEGIN
-- ===============================================================================================
-- Created by   : Weczerek Max
-- Created date : 2014-10-14,  
--                2014-11-06
-- Description  : 
-- ===============================================================================================
/*
Fáze VR3 -  z ND přijde MESSAGE, viz níže

Ukládá data

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
             @myItemOrKitUnitOfMeasureId  int,
	          @myItemOrKitUnitOfMeasure varchar(50),
	          @myItemQualityID int,
             @myItemQualityCode varchar(50),
             @myItemQuality varchar(50),
	          @myItemOrKitDateOfDelivery datetime,
	          @myItemType nvarchar(50),
	          @myIncotermsId int,
	          @myIncotermDescription nvarchar(50),
	          @myPackageTypeId int,
	          @myPackageTypeCode nvarchar(50),
	          @myShipmentOrderSource int,
             @myStatus int,
	          @myVydejkyId int,
	          @myRequiredDateOfShipment datetime,
             @myRealDateOfDelivery datetime,
             @myRealItemOrKitQuantity numeric(18,3),
             @myRealItemQualityID int, 
             @myRealItemQuality nvarchar(50),
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
             ,@myAnnouncement [nvarchar](max)
             ,@myIncotermID int

             SET @myAnnouncement = ''
      DECLARE 
             @myKeyShipmentOrderID int,
             @myKeyCustomerID int,
	          @myKeyContactID int,
             @myKeyItemQualityID int,
             @myKeyIncotermID int,
             @myIdentityx AS INT

       SET @myItemSNs=''
       SET @myToDay = GetDate()
       SET @mySingleOrMaster = 0

       DECLARE
          @myPocet [int],
          @myError [int],
          @myIdentity  [int],
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
      IF OBJECT_ID('tempdb..#TmpCMRSVr3hd','table') IS NOT NULL DROP TABLE #TmpCMRSVr3hd
      IF OBJECT_ID('tempdb..#TmpCMRSVr3sn','table') IS NOT NULL DROP TABLE #TmpCMRSVr3sn

      EXEC sp_xml_preparedocument @hndl OUTPUT, @par1
      SELECT x.[ID], x.[MessageID], x.[MessageTypeID], x.[MessageTypeDescription]
             ,x.[CustomerID], x.[CustomerName], x.[CustomerAddress1], x.[CustomerAddress2], x.[CustomerAddress3], x.[CustomerCity], x.[CustomerZipCode]
             ,x.[CustomerCountryISO], x.[ContactID], x.[ContactTitle], x.[ContactFirstName], x.[ContactLastName], x.[ContactPhoneNumber1], x.[ContactPhoneNumber2]
             ,x.[ContactFaxNumber], x.[ContactEmail]
      INTO #TmpCMRSVr3hd
      FROM OPENXML (@hndl, '/NewDataSet/CommunicationMessagesReturnedShipment',2)
      WITH (
      ID                             int           'ID',
      MessageID                      int           'MessageID',
      MessageTypeID                  int           'MessageTypeID',
      MessageTypeDescription         nvarchar(150) 'MessageTypeDescription',
      CustomerID                     int           'CustomerID',
      CustomerName                   nvarchar(150) 'CustomerName',
      CustomerAddress1               nvarchar(150) 'CustomerAddress1',
      CustomerAddress2               nvarchar(150) 'CustomerAddress2',
      CustomerAddress3               nvarchar(150) 'CustomerAddress3',
      CustomerCity                   nvarchar(150) 'CustomerCity',
      CustomerZipCode                nvarchar(150) 'CustomerZipCode',
      CustomerCountryISO             nvarchar(150) 'CustomerCountryISO',
      ContactID                      int           'ContactID',
      ContactTitle                   nvarchar(150) 'ContactTitle',
      ContactFirstName               nvarchar(150) 'ContactFirstName',
      ContactLastName                nvarchar(150) 'ContactLastName',
      ContactPhoneNumber1            nvarchar(150) 'ContactPhoneNumber1',
      ContactPhoneNumber2            nvarchar(150) 'ContactPhoneNumber2',
      ContactFaxNumber               nvarchar(150) 'ContactFaxNumber',
      ContactEmail                   nvarchar(150) 'ContactEmail'

      ) x
      ----
      SELECT  y.ItemQualityID, y.ItemQuality, y.[IncotermID], y.[IncotermDescription], y.[SN1], y.[SN2]
      INTO #TmpCMRSVr3sn
      FROM OPENXML (@hndl, '/NewDataSet/CommunicationMessagesReturnedShipment/items/item/ItemSNs/ItemSN',2)
      WITH (
            ItemQualityID                  int           '../../ItemQualityID',
            ItemQuality                    nvarchar(150) '../../ItemQuality',
            IncotermID                     int           '../../IncotermID',
            IncotermDescription            nvarchar(150) '../../IncotermDescription',
            SN1                 nvarchar(150) '@SN1',
            SN2                 nvarchar(150) '@SN2'
            ) y
      EXEC sp_xml_removedocument @hndl

 
  

      SELECT @myMessageId              = CAST(a.MessageId AS VARCHAR(50)),
             @myMessageTypeId          = CAST(a.MessageTypeID AS VARCHAR(50)),
             @myMessageTypeDescription = a.MessageTypeDescription
       FROM (
             SELECT TOP 1 MessageId,MessageTypeID,MessageTypeDescription FROM #TmpCMRSVr3hd Tmp
             ) a

      IF OBJECT_ID('tempdb..#TmpCMRSVr3snDistinct','table') IS NOT NULL DROP TABLE #TmpCMRSVr3snDistinct
      SELECT DISTINCT ItemQualityID,IncotermID,ItemQuality,IncotermDescription  INTO #TmpCMRSVr3snDistinct FROM  #TmpCMRSVr3sn  

---- ===========
      --SELECT * FROM #TmpCMRSVr3hd
      --SELECT * FROM #TmpCMRSVr3sn
      --SELECT * FROM #TmpCMRSVr3snDistinct
---- ===========   

      --BEGIN -- ============================ Zpracování ===============================
         SELECT  @myPocet = COUNT(*) 
         FROM [dbo].[CommunicationMessagesReturnedShipment]
         WHERE [MessageId]=@myMessageId AND [MessageTypeId] = @myMessageTypeId AND  MessageDescription = @myMessageTypeDescription
   
 

         IF @mOK=1 AND  (@myPocet = 0 OR  @myPocet IS NULL)
         BEGIN  -- @mOK=1
            IF (SELECT CURSOR_STATUS('global','myCursorCMSOChd')) >= -1
             BEGIN
                      DEALLOCATE myCursorCMSOChd
             END
             SET @myError=0 
             SET @myIdentity = 0

             --BEGIN TRAN
             DECLARE myCursorCMSOChd CURSOR 
             FOR  
             SELECT x.[ID], x.[MessageID], x.[MessageTypeID], x.[MessageTypeDescription]
                   ,x.[CustomerID], x.[CustomerName], x.[CustomerAddress1], x.[CustomerAddress2], x.[CustomerAddress3], x.[CustomerCity], x.[CustomerZipCode]
                   ,x.[CustomerCountryISO], x.[ContactID], x.[ContactTitle], x.[ContactFirstName], x.[ContactLastName], x.[ContactPhoneNumber1], x.[ContactPhoneNumber2]
                   ,x.[ContactFaxNumber], x.[ContactEmail]
             FROM #TmpCMRSVr3hd x ORDER BY MessageID, MessageTypeID, CustomerID, ContactID

             OPEN myCursorCMSOChd
             FETCH NEXT FROM myCursorCMSOChd INTO   @myID, @myMessageID, @myMessageTypeID, @myMessageTypeDescription
                   ,@myCustomerID, @myCustomerName, @myCustomerAddress1, @myCustomerAddress2, @myCustomerAddress3, @myCustomerCity, @myCustomerZipCode
                   ,@myCustomerCountryISO, @myContactID, @myContactTitle, @myContactFirstName, @myContactLastName, @myContactPhoneNumber1, @myContactPhoneNumber2
                   ,@myContactFaxNumber, @myContactEmail

             SELECT @myKeyCustomerID = -1, @myKeyContactID = -1, @myKeyItemQualityID = -1, @myKeyIncotermID = -1
             WHILE @@FETCH_STATUS = 0
             BEGIN  -- @@FETCH_STATUS   
                  IF @myKeyCustomerID <> @myCustomerID  OR  @myKeyContactID <> @myContactID
                  BEGIN
                      SELECT @myKeyCustomerID = @myCustomerID, @myKeyContactID =  @myContactID
                      INSERT INTO [dbo].[CommunicationMessagesReturnedShipment]
                                ([MessageId]
                                ,[MessageTypeId]
                                ,[MessageDescription]
                                ,[CustomerID]
                                ,[ContactID]
                                ,[Reconciliation]
                                ,[IsActive]
                                ,[ModifyDate]
                                ,[ModifyUserId])
                            VALUES
                                  (@myMessageId -- <MessageId, int,>
                                  ,@myMessageTypeId -- <MessageTypeId, int,>
                                  ,@myMessageTypeDescription -- <MessageDescription, nvarchar(200),>
                                  ,@myCustomerID -- <CustomerID, int,>
                                  ,@myContactID -- <ContactID, int,>
                                  ,0
                                  ,1 -- <IsActive, bit,>
                                  ,@myToDay -- <ModifyDate, datetime,>
                                  ,0 -- <ModifyUserId, int,>
                                  )    
                                                      
                      SET @myError = @myError + @@ERROR
                      SET @myIdentity = @@IDENTITY  
                      SET @myAnnouncement = @myAnnouncement + CAST(@myIdentity AS VARCHAR(50))+','

--SELECT  @myIdentity '@myIdentity',   @myAnnouncement '@myAnnouncement'

                  END
                  IF @myError=0 AND @myIdentity>0
                  BEGIN  -- 1
                     IF (SELECT CURSOR_STATUS('global','myCMRSVr3snDistinct')) >= -1
                     BEGIN
                              DEALLOCATE myCMRSVr3snDistinct
                     END
 
                     DECLARE myCMRSVr3snDistinct CURSOR 
                     FOR  SELECT ItemQualityID, IncotermID, ItemQuality,IncotermDescription FROM #TmpCMRSVr3snDistinct

                     OPEN myCMRSVr3snDistinct
                     FETCH NEXT FROM myCMRSVr3snDistinct INTO   @myItemQualityID, @myIncotermID, @myItemQuality ,@myIncotermDescription

                     WHILE @@FETCH_STATUS = 0
                     BEGIN  -- @@FETCH_STATUS  2   
                       IF @myKeyItemQualityID <> @myItemQualityID  OR @myKeyIncotermID <>  @myIncotermID
                       BEGIN
                          SELECT @myKeyItemQualityID = @myItemQualityID, @myKeyIncotermID = @myIncotermID
                          SET @myItemSNs=''
                          SELECT @myItemSNs = SN FROM (
                          SELECT DISTINCT LEFT(r.ResourceName , LEN(r.ResourceName)-1) [SN], A.[ItemQualityID],A.[IncotermID]
                          FROM #TmpCMRSVr3sn A
                           CROSS APPLY (SELECT CAST([SN1] AS VARCHAR(50))+ ', ' + CAST([SN2] AS VARCHAR(50))+ '; '   FROM #TmpCMRSVr3sn  B
                               WHERE A.[ItemQualityID] = B.[ItemQualityID] AND ISNULL(A.[IncotermID],-1) =  ISNULL(B.[IncotermID],-1) 
                                 AND A.[ItemQualityID] = @myItemQualityID  AND ISNULL(A.[IncotermID],-1) = ISNULL(@myIncotermID,-1)
                                 AND B.[ItemQualityID] = @myItemQualityID  AND ISNULL(B.[IncotermID],-1) = ISNULL(@myIncotermID,-1)
                               FOR XML PATH('')
                               ) r (ResourceName) 
                               ) AA 
                               WHERE  AA.[ItemQualityID] = @myItemQualityID AND ISNULL(AA.[IncotermID],-1) = ISNULL(@myIncotermID,-1)


                               INSERT INTO [dbo].[CommunicationMessagesReturnedShipmentItems]
                                          ([CMSOId]
                                          ,[ItemOrKitQualityId]
                                          ,[ItemOrKitQualityCode]
                                          ,[IncotermsId]
                                          ,[IncotermDescription]
                                          ,[KitSNs]
                                          ,[IsActive]
                                          ,[ModifyDate]
                                          ,[ModifyUserId])
                                    VALUES
                                          (@myIdentity                       -- <CMSOId, int,>
                                          ,@myItemQualityID                       -- <ItemOrKitQualityId, int,>
                                          ,@myItemQuality                       -- <ItemOrKitQualityCode, nvarchar(50),>
                                          ,@myIncotermID                       -- <IncotermsId, int,>
                                          ,@myIncotermDescription                    -- <IncotermDescription, nvarchar(50),>
                                          ,@myItemSNs                       -- <KitSNs, varchar(max),>
                                          ,1 -- <IsActive, bit,>
                                          ,@myToDay -- <ModifyDate, datetime,>
                                          ,0 -- <ModifyUserId, int,>
                                          )
                               SET @myError = @myError + @@ERROR
                               SET @myIdentityx = @@IDENTITY


                          
                               IF @myError = 0 AND  @myIdentityx > 0
                               BEGIN
                                    INSERT INTO [dbo].[CommunicationMessagesReturnedShipmentItemsSerNum]
                                               ([ReturnedShipmentItemsID]
                                               ,[SN1]
                                               ,[SN2]
                                               ,[IsActive]
                                               ,[ModifyDate]
                                               ,[ModifyUserId])
                                     SELECT @myIdentityx, SN1, SN2, 1,@myToDay,0 FROM #TmpCMRSVr3sn A 
                                     WHERE 
                                     A.[ItemQualityID] = @myItemQualityID  AND ISNULL(A.[IncotermID],-1) = ISNULL(@myIncotermID,-1)
                                     SET @myError = @myError + @@ERROR
--SELECT  @myError '@myError  3'
                               END

                       END

                       FETCH NEXT FROM myCMRSVr3snDistinct INTO   @myItemQualityID, @myIncotermID, @myItemQuality ,@myIncotermDescription
                     END    -- @@FETCH_STATUS 2
                     CLOSE myCMRSVr3snDistinct;
                     DEALLOCATE myCMRSVr3snDistinct;
                  END  -- 1

                  FETCH NEXT FROM myCursorCMSOChd INTO   @myID, @myMessageID, @myMessageTypeID, @myMessageTypeDescription
                        ,@myCustomerID, @myCustomerName, @myCustomerAddress1, @myCustomerAddress2, @myCustomerAddress3, @myCustomerCity, @myCustomerZipCode
                        ,@myCustomerCountryISO, @myContactID, @myContactTitle, @myContactFirstName, @myContactLastName, @myContactPhoneNumber1, @myContactPhoneNumber2
                        ,@myContactFaxNumber, @myContactEmail

             END    -- @@FETCH_STATUS
             CLOSE myCursorCMSOChd;
             DEALLOCATE myCursorCMSOChd;

             IF @myError = 0
             BEGIN
                IF @@TRANCOUNT > 0 COMMIT TRAN
                SELECT @ReturnValue=0, @ReturnMessage='OK'
                 SET @sub = 'FENIX - VR3 - Oznámení' + ' Databáze: '+ISNULL(@myDatabaseName,'')
                 SET @msg = 'Vrátky typu VR3 - Byly obdrženy následující message(ID = ) <br />'  + @myAnnouncement +''

                --SET @sub = 'FENIX - VR3 úspěch' + ' Databáze: '+ISNULL(@myDatabaseName,'')
                --SET @msg = 'Program [dbo].[prCMReturnedShipment]; Byly vloženy VR3: '  + @myAnnouncement
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
                SELECT @ReturnValue=1, @ReturnMessage='Chyba ' + ISNULL(CAST(ERROR_NUMBER() AS VARCHAR(50)),'') + ' Databáze: '+ISNULL(@myDatabaseName,'')
                SET @sub = 'FENIX - VR3 CHYBA' + ' Databáze: '+ISNULL(@myDatabaseName,'')
                SET @msg = 'Program [dbo].[prCMReturnedShipment]; '  + ISNULL(ERROR_MESSAGE(),'') + ISNULL(CAST(ERROR_NUMBER() AS VARCHAR(50)),'') 
                EXEC @result = msdb.dbo.sp_send_dbmail
                		@profile_name = 'Automat', --@MailProfileName
                		@recipients = @myAdresaLogistika,
                     @copy_recipients = @myAdresaProgramator,
                		@subject = @sub,
                		@body = @msg,
                		@body_format = 'HTML'

             END

      END

END TRY
BEGIN CATCH
       IF @@TRANCOUNT > 0 ROLLBACK TRAN
    
       SELECT @ReturnValue=1, @ReturnMessage='Chyba'
       SET @sub = 'FENIX - VR3 CHYBA' + ' Databáze: '+ISNULL(@myDatabaseName,'')
       SET @msg = 'Program [dbo].[prCMReturnedShipment]; '  + ISNULL(ERROR_MESSAGE(),'') + ISNULL(CAST(ERROR_NUMBER() AS VARCHAR(50)),'') 
       EXEC @result = msdb.dbo.sp_send_dbmail
      		@profile_name = 'Automat', --@MailProfileName
      		@recipients = @myAdresaProgramator,
      		@subject = @sub,
      		@body = @msg,
      		@body_format = 'HTML'
END CATCH
END






GO
GRANT EXECUTE
    ON OBJECT::[dbo].[prCMReturnedShipment] TO [FenixW]
    AS [dbo];

