CREATE PROCEDURE [dbo].[prCMReturn]
      @par1 as XML,
	   @ReturnValue     int            = -1 OUTPUT,
	   @ReturnMessage   nvarchar(2048) = null OUTPUT
 AS
BEGIN
-- ===============================================================================================
-- Created by   : Weczerek Max
-- Created date : 2014-09-09
--                2014-09-30, 2014-10-08, 2014-11-03, 2014-11-05, 2014-11-14, 2015-06-08, 2015-10-14
-- Description  : 
-- ===============================================================================================
/*
Fáze VR1 -  z ND přijde MESSAGE, viz níže  (vratka

nic nedělá, jen uloží data

*/
	SET NOCOUNT ON;

   DECLARE @myDatabaseName  nvarchar(100)
   DECLARE @msg    varchar(max)
   DECLARE @MailTo varchar(150)
   DECLARE @MailBB varchar(150)
   DECLARE @sub    varchar(1000) 
   DECLARE @Result int
   SET @msg = ''

   DECLARE  @myMessage [nvarchar] (max), @myReturnValue [int],@myReturnMessage nvarchar(2048)
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
             @myItemID int,
             @myItemDescription nvarchar(100),
	          @myItemOrKitQualityId int,
             @myItemOrKitQualityCode varchar(50),
             @myItemOrKitQuality varchar(50),
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
             ,@myReturnedFrom nvarchar(400)
             ,@mySN1 nvarchar(150)
             ,@mySN2 nvarchar(150)
             , @myAnnouncement [nvarchar](max)

             SET @myAnnouncement = ''


      DECLARE 

             @myKeyMessageID int,
             @myKeyMessageTypeID int,
             @myKeyItemOrKitQualityID int,
             @myKeyReturnedFrom  nvarchar(400),
             @myKeyItemOrKitQuality  nvarchar(150),
             @myKeyItemID int

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
       
       DECLARE  @myPocetPolozekCelkem [int], @myPocetPolozekPomooc[int], @mOK [bit]
       SET @mOK = 1 
       -- ---

       SELECT 	   @ReturnValue=0,  @ReturnMessage='OK'

   END --- DECLARACE
   -- ---
   -- =======================================================================
   -- Nacteni xml souboru do tabulky
   -- =======================================================================
      IF OBJECT_ID('tempdb..#TmpCMReturn','table') IS NOT NULL DROP TABLE #TmpCMReturn
      IF OBJECT_ID('tempdb..#TmpCMReturnItems','table') IS NOT NULL DROP TABLE #TmpCMReturnItems

      EXEC sp_xml_preparedocument @hndl OUTPUT, @par1

      SELECT x.[ID], x.[MessageID], x.[MessageTypeID], x.[MessageTypeDescription]
             ,x.ItemID, x.ItemDescription
             ,x.[ItemOrKitQualityID], x.[ItemOrKitQuality],
              x.[ReturnedFrom] -- , x.[SN1], x.[SN2]
      INTO #TmpCMReturn
      FROM OPENXML (@hndl, '/NewDataSet/CommunicationMessagesReturnedEquipment/itemsOrKits/itemOrKit',2)
      WITH (
      ID                             int           '../../ID',
      MessageID                      int           '../../MessageID',
      MessageTypeID                  int           '../../MessageTypeID',
      MessageTypeDescription         nvarchar(150) '../../MessageTypeDescription',
      ItemID                         int           'ItemID',          -- 2015-06-08
      ItemDescription                nvarchar(100) 'ItemDescription', -- 2015-06-08
      ItemOrKitQualityID             int           'ItemOrKitQualityID',
      ItemOrKitQuality               nvarchar(150) 'ItemOrKitQuality',
      ReturnedFrom                   nvarchar(400) 'ReturnedFrom'
      ) x

      SELECT x.[ID], x.[MessageID], x.[MessageTypeID], x.[MessageTypeDescription]
             ,x.ItemID, x.ItemDescription
             ,x.[ItemOrKitQualityID], x.[ItemOrKitQuality],
              x.[ReturnedFrom], x.[SN1], x.[SN2]
      INTO #TmpCMReturnItems
      FROM OPENXML (@hndl, '/NewDataSet/CommunicationMessagesReturnedEquipment/itemsOrKits/itemOrKit/ItemSNs/ItemSN',2)
      WITH (
      ID                             int           '../../../../ID',
      MessageID                      int           '../../../../MessageID',
      MessageTypeID                  int           '../../../../MessageTypeID',
      MessageTypeDescription         nvarchar(150) '../../../../MessageTypeDescription',
      ItemID                         int           '../../ItemID',          -- 2015-06-08
      ItemDescription                nvarchar(100) '../../ItemDescription', -- 2015-06-08
      ItemOrKitQualityID             int           '../../ItemOrKitQualityID',
      ItemOrKitQuality               nvarchar(150) '../../ItemOrKitQuality',
      ReturnedFrom                   nvarchar(400)'../../ReturnedFrom',
      SN1                            nvarchar(150) '@SN1',
      SN2                            nvarchar(150) '@SN2'
      ) x


      EXEC sp_xml_removedocument @hndl
			
      SELECT @myMessageId              = CAST(a.MessageId AS VARCHAR(50)),
             @myMessageTypeId          = CAST(a.MessageTypeID AS VARCHAR(50)),
             @myMessageTypeDescription = a.MessageTypeDescription
       FROM (
             SELECT TOP 1 MessageId,MessageTypeID,MessageTypeDescription FROM #TmpCMReturn Tmp
             ) a

------ ===========
      --SELECT * FROM #TmpCMReturn
      --SELECT * FROM #TmpCMReturnItems
------ ===========   
 
      BEGIN -- ============================ Zpracování ===============================
            
         SELECT  @myPocet = COUNT(*) 
         FROM [dbo].[CommunicationMessagesReturn]
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
                            ,x.ItemID, x.ItemDescription  -- 2015-06-08
                            ,x.[ItemOrKitQualityID], x.[ItemOrKitQuality], x.ReturnedFrom
                FROM #TmpCMReturn x ORDER BY MessageID, MessageTypeID, ItemOrKitQualityID, ItemID, ItemOrKitQuality, ReturnedFrom

             OPEN myCursor
             FETCH NEXT FROM myCursor INTO   @myID, @myMessageID, @myMessageTypeID, @myMessageTypeDescription
                   ,@myItemID,@myItemDescription
                   ,@myItemOrKitQualityID, @myItemOrKitQuality
                   ,@myReturnedFrom  --, @mySN1, @mySN2

             SELECT @myKeyMessageID = -1, @myKeyMessageTypeID = -1, @myKeyItemOrKitQualityID = -1, @myKeyReturnedFrom = '*', @myKeyItemOrKitQuality='*'
             , @myKeyItemID = -1  -- 2015-06-08

             WHILE @@FETCH_STATUS = 0
             BEGIN  -- @@FETCH_STATUS   
--SELECT  @myKeyMessageID,@myMessageID,@myKeyMessageTypeID,@myMessageTypeID,@myKeyReturnedFrom,@myReturnedFrom, @myKeyItemOrKitQuality,@myItemOrKitQuality
--       ,@myKeyItemID
                   IF @myKeyMessageID <> @myMessageID  OR @myKeyMessageTypeID <> @myMessageTypeID OR @myKeyReturnedFrom <> @myReturnedFrom OR @myKeyItemOrKitQuality <> @myItemOrKitQuality
                      OR @myKeyItemID <> @myItemID  -- 2015-06-08
                    BEGIN

                       SELECT @myKeyMessageID = @myMessageID, @myKeyMessageTypeID = @myMessageTypeID,  @myKeyItemOrKitQualityID = @myItemOrKitQualityId , @myKeyItemOrKitQuality = @myItemOrKitQuality,  @myKeyReturnedFrom = @myReturnedFrom
                              , @myKeyItemID = @myItemID  -- 2015-06-08
                       INSERT INTO [dbo].[CommunicationMessagesReturn]
                                  ([MessageId]
                                  ,[MessageTypeId]
                                  ,[MessageDescription]
                                  ,[MessageDateOfReceipt]
                                  ,[Reconciliation]
                                  ,[IsActive]
                                  ,[ModifyDate]
                                  ,[ModifyUserId])
                            VALUES
                                  (@myMessageId                                        -- <MessageId, int,>
                                  ,9                                                   -- @myMessageTypeId     20151014 2015-10-14  -- <MessageTypeId, int,>
                                  ,@myMessageTypeDescription                           -- <MessageDescription, nvarchar(200),>
                                  ,@myToDay                                            -- <MessageDateOfReceipt, datetime,>
                                  ,0
                                  ,1                                                   -- <IsActive, bit,>
                                  ,@myToDay                                            -- <ModifyDate, datetime,>
                                  ,0                                                   -- <ModifyUserId, int,>
                                  )    
                                                      
                        SET @myError = @myError + @@ERROR
                        SET @myIdentity = @@IDENTITY 
                        SET @myAnnouncement = @myAnnouncement + CAST(@myIdentity AS VARCHAR(50))+','
--SELECT @myIdentity AS '@myIdentity', @myAnnouncement AS '@myAnnouncement'

                    END

                    IF @myError=0 AND @myIdentity>0
                    BEGIN  -- 1
                         SET @myItemSNs = ''
                         SELECT @myItemSNs = @myItemSNs + ISNULL(SN1,'')+','+ISNULL(SN2,'')+','+ISNULL(ReturnedFrom,'')+';' 
                         FROM #TmpCMReturnItems WHERE 
                                @myKeyMessageID = MessageID AND @myKeyMessageTypeID = MessageTypeID
                                AND  @myKeyItemID = ItemID  -- 2015-06-08
                                AND  @myKeyItemOrKitQualityID = ItemOrKitQualityId  AND  @myKeyItemOrKitQuality = ItemOrKitQuality
                                AND  @myKeyReturnedFrom = ReturnedFrom
 
                          IF LEN(@myItemSNs)>1
                            SET @myItemSNs = LEFT(@myItemSNs, LEN(@myItemSNs)-1)
                         ELSE
                            SET @myItemSNs = ''

                         INSERT INTO [dbo].[CommunicationMessagesReturnItemsSN]
                            ([CMSOId]
                            ,[ItemOrKitQualityId]
                            ,[ItemOrKitQuality]
                            ,[KitSNs]
                            ,[IsActive]
                            ,[ModifyDate]
                            ,[ModifyUserId])
                         VALUES
                            ( @myIdentity                --<CMSOId, int,>
                            , @myKeyItemOrKitQualityID   --<ItemOrKitQualityId, int,>
                            , @myKeyItemOrKitQuality     --<ItemOrKitQuality, varchar(50),>
                            , @myItemSNs                 --<KitSNs, varchar(max),>
                            , 1                          --<IsActive, bit,>
                            , @myToDay                   --<ModifyDate, datetime,>
                            , 0   --<ModifyUserId, int,>
                            )
--SELECT @@ROWCOUNT AS 'A'
                            SET @myError = @myError + @@ERROR
                            SET @myItemSNs =''

                            INSERT INTO [dbo].[CommunicationMessagesReturnItems]
                                      ([CMSOId]
                                      ,[ItemOrKitQualityId]
                                      ,[ItemOrKitQuality]
                                      ,[SN1]
                                      ,[SN2]
                                      ,NDReceipt
                                      ,[ReturnedFrom]
                                      ,[IsActive]
                                      ,[ModifyDate]
                                      ,[ModifyUserId]
                                      ,ItemID
                                      ,ItemDescription
                                      )                         
                            SELECT     @myIdentity
                                      ,[ItemOrKitQualityId]
                                      ,[ItemOrKitQuality]
                                      ,[SN1]
                                      ,[SN2]
                                      ,NULL
                                      ,[ReturnedFrom]
                                      ,1
                                      ,@myToDay
                                      ,0
                                      ,@myItemID
                                      ,@myItemDescription
                            FROM #TmpCMReturnItems WHERE 
                                @myKeyMessageID = MessageID AND @myKeyMessageTypeID = MessageTypeID 
                                AND  @myKeyItemOrKitQualityID = ItemOrKitQualityId  AND  @myKeyItemOrKitQuality = ItemOrKitQuality
                                AND  @myKeyReturnedFrom = ReturnedFrom
                                AND  @myKeyItemID = ItemID  -- 2015-06-08
--SELECT @@ROWCOUNT AS 'B'
--SELECT * FROM #TmpCMReturnItems WHERE 
--                                @myKeyMessageID = MessageID AND @myKeyMessageTypeID = MessageTypeID 
--                                AND  @myKeyItemOrKitQualityID = ItemOrKitQualityId  AND  @myKeyItemOrKitQuality = ItemOrKitQuality
--                                AND  @myKeyReturnedFrom = ReturnedFrom
                            SET @myError = @myError + @@ERROR
                          
                    END  -- 1

                    FETCH NEXT FROM myCursor INTO   @myID, @myMessageID, @myMessageTypeID, @myMessageTypeDescription
                      ,@myItemID, @myItemDescription                    
                      ,@myItemOrKitQualityID, @myItemOrKitQuality, @myReturnedFrom


             END    -- @@FETCH_STATUS
             CLOSE myCursor;
             DEALLOCATE myCursor;
               
             IF @myError = 0 
             BEGIN   
                 IF @@TRANCOUNT > 0 COMMIT TRAN
                 SET @sub = 'FENIX - VR1 - Oznámení' + ' Databáze: '+ISNULL(@myDatabaseName,'')
                 SET @msg = 'Vratky typu VR1 - Byly obdrženy následující message(ID = ): <br />'  + @myAnnouncement
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
                   SELECT @ReturnValue=1, @ReturnMessage='CInfo'
                   SET @sub = 'Fenix - VR1' + ' Databáze: '+ISNULL(@myDatabaseName,'')
                   SET @msg = 'Program [dbo].[prCMReturn]; Záznam MessageId=' + ISNULL(CAST(@myMessageId AS VARCHAR(50)),'') + ', MessageTypeId = '+ ISNULL(CAST(@myMessageTypeId AS VARCHAR(50)),'') + ' byl již jednou naveden !'
                   EXEC @result = msdb.dbo.sp_send_dbmail
               		@profile_name = 'Automat', --@MailProfileName
               		@recipients = 'jaroslav.tajbl@upc.cz;michal.rezler@upc.cz',
               		@subject = @sub, 
               		@body = @msg,
               		@body_format = 'HTML'

                     EXEC [dbo].[prAppLogWriteNew] @Type='INFO', @Message =  @msg, @XmlMessage = NULL, @UserId = 0,@Source = 'prCMReturn'
                                               , @ReturnValue = @myReturnValue,@ReturnMessage=@myReturnMessage

              END
         END
        END-- ============================ Zpracování ===============================
 

END TRY
BEGIN CATCH
       IF @@TRANCOUNT > 0 ROLLBACK TRAN
    
       SELECT @ReturnValue=1, @ReturnMessage='Chyba'
       SET @sub = 'Fenix - VR1 CHYBA' + ' Databáze: '+ISNULL(@myDatabaseName,'')
       SET @msg = 'Program [dbo].[prCMReturn]; '  + ISNULL(ERROR_MESSAGE(),'') + ISNULL(CAST(ERROR_NUMBER() AS VARCHAR(50)),'') 
       EXEC @result = msdb.dbo.sp_send_dbmail
      		@profile_name = 'Automat', --@MailProfileName
      		@recipients = 'jaroslav.tajbl@upc.cz;michal.rezler@upc.cz',
      		@subject = @sub,
      		@body = @msg,
      		@body_format = 'HTML'

       EXEC [dbo].[prAppLogWriteNew] @Type='ERROR', @Message =  @msg, @XmlMessage = NULL, @UserId = 0,@Source = 'prCMReturn'
                                               , @ReturnValue = @myReturnValue,@ReturnMessage=@myReturnMessage

END CATCH
END


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[prCMReturn] TO [FenixW]
    AS [dbo];

