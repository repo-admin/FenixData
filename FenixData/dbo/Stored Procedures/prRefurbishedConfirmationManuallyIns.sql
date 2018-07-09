
CREATE PROCEDURE [dbo].[prRefurbishedConfirmationManuallyIns]
      @par1         XML,
      @ModifyUserId INT = -1,
	   @ReturnValue     int            = -1 OUTPUT,
	   @ReturnMessage   nvarchar(2048) = null OUTPUT
 AS
-- ===============================================================================================
-- Created by   : Weczerek Max
-- Created date : 2014-09-29
--                2014-09-30, 2014-10-22            
-- Description  : 
-- ===============================================================================================
/*
ruční výrova RF1
*/
BEGIN
	SET NOCOUNT ON;
    DECLARE @myDatabaseName  nvarchar(100)
    SELECT @myDatabaseName = DB_NAME() 

   BEGIN --- DECLARACE
       DECLARE
	          @myID int,
	          @myMessageId int,
	          @myMessageTypeId int,
	          @myMessageDescription nvarchar(200),
	          @myMessageDateOfRefurbished datetime,
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
	          @myItemOrKitQualityId int,
             @myItemOrKitQualityCode varchar(50),
             @myItemOrKitQuality varchar(50),
	          @myItemOrKitDateOfDelivery datetime,
	          @myItemType nvarchar(50),
	          @myIncotermsId int,
	          @myIncotermDescription nvarchar(50),
	          @myPackageTypeId int,
	          @myPackageTypeCode nvarchar(50),
	          @myRefurbishedOrderSource int,
             @myStatus int,
	          @myVydejkyId int,
	          @myRequiredDateOfRefurbished datetime,
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
             ,@myRefurbishedOrderID int
             ,@myHeliosOrderID int
             ,@myCardStockItemsId int

      DECLARE 
             @myKeyRefurbishedOrderID int,
             @myKeyItemVerKit int,
	          @myKeyItemOrKitID int,
             @myKeyDestinationPlacesId int,
             @myKeyDestinationPlacesContactsId int,
             @myKeyDateOfExpedition  nvarchar(20),
             @myKeycdlStocksName  nvarchar(100)

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

   -- ==================================================================
      IF OBJECT_ID('tempdb..#RefurbishedConMan','table') IS NOT NULL DROP TABLE #RefurbishedConMan
      EXEC sp_xml_preparedocument @hndl OUTPUT, @par1
 
      SELECT x.[ID], x.[ItemQuantity], x.iMessageID, x.vwCMRSentID 
        INTO #RefurbishedConMan
      FROM OPENXML (@hndl, '/NewDataSet/item',2)
      WITH (
           ID                                int           'ID',              -- toto je ID řádku objednávky, ke kterému se bude vázat nově potvrzené množství
           ItemQuantity                      int           'ItemQuantity',    -- toto je potvrzené množství budoucí FR1
           iMessageID                        int           'iMessageID',      -- toto je budouci MessageID
           vwCMRSentID                       int           'vwCMRSentID'      -- toto je ID Refurbishedu Objednávky, ke které se vyrobí RF1
      ) x
      EXEC sp_xml_removedocument @hndl


SELECT @myID = vwCMRSentID, @myMessageId=iMessageID  FROM
(
SELECT TOP 1 vwCMRSentID,iMessageID   FROM #RefurbishedConMan
 )aa

--SELECT * FROM #RefurbishedConMan
--SELECT TOP 1 * FROM [dbo].[CommunicationMessagesRefurbishedOrdersConfirmation] WHERE [RefurbishedOrderID] = @myID
--SELECT * FROM vwCMRSent WHERE ID = @myID

SET @myError = 0
SELECT @ReturnValue=0, @ReturnMessage='OK'

  BEGIN TRY
  BEGIN TRAN
      INSERT INTO [dbo].[CommunicationMessagesRefurbishedOrderConfirmation]
                 ([MessageId]
                 ,[MessageTypeId]
                 ,[MessageDescription]
                 ,[DateOfShipment]
                 ,[RefurbishedOrderID]
                 ,[CustomerID]
                 ,[Reconciliation]
                 ,[IsActive]
                 ,[ModifyDate]
                 ,[ModifyUserId])
      SELECT TOP 1
                  @myMessageId
                 ,[MessageTypeId]
                 ,[MessageDescription]
                 ,[DateOfShipment]
                 ,[RefurbishedOrderID]
                 ,[CustomerID]
                 ,0
                 ,[IsActive]
                 ,@myToDay
                 ,@ModifyUserId
      FROM [dbo].[CommunicationMessagesRefurbishedOrderConfirmation] WHERE [RefurbishedOrderID] = @myID
      SET @myIdentity = @@IDENTITY
      SET @myError    = @@ERROR

      INSERT INTO [dbo].[CommunicationMessagesRefurbishedOrderConfirmationItems]
                   ([CMSOId]
                   ,[ItemVerKit]
                   ,[ItemOrKitID]
                   ,[ItemOrKitDescription]
                   ,[ItemOrKitQuantity]
                   ,[ItemOrKitUnitOfMeasureId]
                   ,[ItemOrKitUnitOfMeasure]
                   ,[ItemOrKitQualityId]
                   ,[ItemOrKitQualityCode]
                   ,[IncotermsId]
                   ,[IncotermDescription]
                   ,[NDReceipt]
                   ,[KitSNs]
                   ,[IsActive]
                   ,[ModifyDate]
                   ,[ModifyUserId])                 --
        SELECT 
               @myIdentity                          --
              ,[ItemVerKit]                         --
              ,[ItemOrKitID]                        --
              ,[ItemOrKitDescription]               --
              ,TMP.ItemQuantity                  --
              ,[ItemOrKitUnitOfMeasureId]           --
              ,[ItemOrKitUnitOfMeasure]             --
              ,[ItemOrKitQualityId]                 --
              ,[ItemOrKitQualityCode]               --
              ,-1 -- [IncotermsId]                        --
              ,'' -- [IncotermDescription]                         --
              ,''     
              ,''                                --
              ,1                                    --
              ,@myToDay                             --
              ,@ModifyUserId                        --
          FROM [dbo].[CommunicationMessagesRefurbishedOrderItems] OSI
          INNER JOIN #RefurbishedConMan                                TMP
          ON OSI.ID = TMP.ID
          SET @myError    = @myError + @@ERROR
-- ======= 20141022
          INSERT INTO [dbo].[CardStockItems] 
                     ([ItemVerKit]
                     ,[ItemOrKitId]
                     ,[ItemOrKitUnitOfMeasureId]
                     ,[ItemOrKitQuality]
                     ,[ItemOrKitFree]
                     ,[ItemOrKitUnConsilliation]
                     ,[ItemOrKitReserved]
                     ,[ItemOrKitReleasedForExpedition]
                     ,[ItemOrKitExpedited]
                     ,[StockId]
                     ,[IsActive]
                     ,[ModifyDate]
                     ,[ModifyUserId])
          SELECT      [ItemVerKit]                         --
                     ,[ItemOrKitID]
                     ,[ItemOrKitUnitOfMeasureId]
                     ,[ItemOrKitQualityId] 
                     ,0,0,0,0,0
                     ,2,1                       --
                     ,@myToDay                             --
                     ,@ModifyUserId                        --
                    FROM [dbo].[CommunicationMessagesRefurbishedOrderItems] OSI
                    INNER JOIN #RefurbishedConMan                                TMP
                          ON OSI.ID = TMP.ID
          WHERE  CAST([ItemVerKit] AS CHAR(50))+ CAST([ItemOrKitID] AS CHAR(50))+ CAST([ItemOrKitUnitOfMeasureId] AS CHAR(50))+
                 CAST([ItemOrKitQualityId] AS CHAR(50)) 
                 NOT IN (SELECT CAST([ItemVerKit] AS CHAR(50))+ CAST([ItemOrKitID] AS CHAR(50))+ CAST([ItemOrKitUnitOfMeasureId] AS CHAR(50))+
                 CAST([ItemOrKitQuality] AS CHAR(50)) FROM [dbo].[CardStockItems] WHERE IsActive=1)
          SET @myError    = @myError + @@ERROR
          --
          UPDATE [dbo].[CardStockItems] SET [ItemOrKitUnConsilliation] = aa.ItemQuantity
          FROM [dbo].[CardStockItems]  CSI
          INNER JOIN (SELECT [ItemVerKit],[ItemOrKitID],[ItemOrKitUnitOfMeasureId], [ItemOrKitQualityId],
                        TMP.ItemQuantity                  --
                    FROM [dbo].[CommunicationMessagesRefurbishedOrderItems] OSI
                    INNER JOIN #RefurbishedConMan                                TMP
                    ON OSI.ID = TMP.ID
                    ) aa
             ON CSI.[ItemVerKit]=aa.[ItemVerKit] AND CSI.[ItemOrKitID]=aa.[ItemOrKitID] 
                AND CSI.[ItemOrKitUnitOfMeasureId]=aa.[ItemOrKitUnitOfMeasureId] AND CSI.[ItemOrKitQuality]=aa.[ItemOrKitQualityId]
-- =======
         SET @myError    = @myError + @@ERROR
SELECT @myError
         IF @myError = 0 
         BEGIN
             COMMIT TRAN
         END
         ELSE
         BEGIN
             IF @@TRANCOUNT > 0 ROLLBACK TRAN

             SELECT @ReturnValue=1, @ReturnMessage='Chyba'
             SET @sub = 'FENIX - RF1  Refurbished Confirmation ruční - Záznam neuložen !!!' + ' Databáze: '+ISNULL(@myDatabaseName,'')
             SET @msg = 'Program prRefurbishedConfirmationManuallyIns; '  + ISNULL(ERROR_MESSAGE(),'') + ISNULL(CAST(ERROR_NUMBER() AS VARCHAR(50)),'') 
             EXEC @result = msdb.dbo.sp_send_dbmail
            		@profile_name = 'Automat', --@MailProfileName
            		@recipients = 'max.weczerek@upc.cz',
            		@subject = @sub,
            		@body = @msg,
            		@body_format = 'HTML'
         END


  END TRY
  BEGIN CATCH
      IF @@TRANCOUNT > 0 ROLLBACK TRAN
      SELECT @ReturnValue=1, @ReturnMessage='Chyba'
      SET @sub = 'FENIX - RF1  Refurbished Confirmation ruční' + ' Databáze: '+ISNULL(@myDatabaseName,'')
      SET @msg = 'Program prRefurbishedConfirmationManuallyIns; '  + ISNULL(ERROR_MESSAGE(),'') + ISNULL(CAST(ERROR_NUMBER() AS VARCHAR(50)),'') 
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
    ON OBJECT::[dbo].[prRefurbishedConfirmationManuallyIns] TO [FenixW]
    AS [dbo];

