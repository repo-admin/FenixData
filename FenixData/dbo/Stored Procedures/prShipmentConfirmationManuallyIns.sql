CREATE PROCEDURE [dbo].[prShipmentConfirmationManuallyIns]
      @par1         XML,
      @ModifyUserId INT = -1,
	   @ReturnValue     int            = -1 OUTPUT,
	   @ReturnMessage   nvarchar(2048) = null OUTPUT
 AS
-- ===============================================================================================
-- Created by   : Weczerek Max
-- Created date : 2014-09-26
--                 
-- Description  : 
-- ===============================================================================================
/*
ruční výrova S1
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

      DECLARE 
             @myKeyShipmentOrderID int,
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
      IF OBJECT_ID('tempdb..#ShipmentConMan','table') IS NOT NULL DROP TABLE #ShipmentConMan
      EXEC sp_xml_preparedocument @hndl OUTPUT, @par1
 
      SELECT x.[ID], x.[ItemQuantity], x.iMessageID, x.vwCMRSentID 
        INTO #ShipmentConMan
      FROM OPENXML (@hndl, '/NewDataSet/item',2)
      WITH (
           ID                                int           'ID',              -- toto je ID řádku objednávky, ke kterému se bude vázat nově potvrzené množství
           ItemQuantity                      int           'ItemQuantity',    -- toto je potvrzené množství budou cí S1
           iMessageID                        int           'iMessageID',      -- toto je budouci MessageID
           vwCMRSentID                       int           'vwCMRSentID'      -- toto je ID Shipmentu Objednávky, ke které se vyrobí S1
      ) x
      EXEC sp_xml_removedocument @hndl


SELECT @myID = vwCMRSentID, @myMessageId=iMessageID  FROM
(
SELECT TOP 1 vwCMRSentID,iMessageID   FROM #ShipmentConMan
 )aa

--SELECT * FROM #ShipmentConMan
--SELECT TOP 1 * FROM [dbo].[CommunicationMessagesShipmentOrdersConfirmation] WHERE [ShipmentOrderID] = @myID
--SELECT * FROM vwCMRSent WHERE ID = @myID

SET @myError = 0
SELECT @ReturnValue=0, @ReturnMessage='OK'

  BEGIN TRY
  BEGIN TRAN
      INSERT INTO [dbo].[CommunicationMessagesShipmentOrdersConfirmation]
                 ([MessageId]
                 ,[MessageTypeId]
                 ,[MessageDescription]
                 ,[MessageDateOfReceipt]
                 ,[ShipmentOrderID]
                 ,[CustomerID]
                 ,[ContactID]
                 ,[Reconciliation]
                 ,[IsActive]
                 ,[ModifyDate]
                 ,[ModifyUserId])
      SELECT TOP 1
                  @myMessageId
                 ,[MessageTypeId]
                 ,[MessageDescription]
                 ,[MessageDateOfReceipt]
                 ,[ShipmentOrderID]
                 ,[CustomerID]
                 ,[ContactID]
                 ,0
                 ,[IsActive]
                 ,@myToDay
                 ,@ModifyUserId
      FROM [dbo].[CommunicationMessagesShipmentOrdersConfirmation] WHERE [ShipmentOrderID] = @myID
      SET @myIdentity = @@IDENTITY
      SET @myError    = @@ERROR

      INSERT INTO [dbo].[CommunicationMessagesShipmentOrdersConfirmationItems]
                   ([CMSOId]                      --
                   ,[SingleOrMaster]              --
                   ,[HeliosOrderRecordID]         --
                   ,[ItemVerKit]                  --
                   ,[ItemOrKitID]                 --
                   ,[ItemOrKitDescription]        --
                   ,[ItemOrKitQuantity]           --
                   ,[ItemOrKitUnitOfMeasureId]    --
                   ,[ItemOrKitUnitOfMeasure]      --
                   ,[ItemOrKitQualityId]          --
                   ,[ItemOrKitQualityCode]        --
                   ,[IncotermsId]                 --
                   ,[IncotermDescription]         --
                   ,[RealDateOfDelivery]          --
                   ,[RealItemOrKitQuantity]
                   ,[RealItemOrKitQualityID]     --
                   ,[RealItemOrKitQuality]       --
                   ,[Status]                       --
                   ,[KitSNs]                       --
                   ,[IsActive]                     --
                   ,[ModifyDate]                   --
                   ,[ModifyUserId])                 --
        SELECT 
               @myIdentity                          --
              ,[SingleOrMaster]                     --
              ,[HeliosOrderRecordId]                                 --
              ,[ItemVerKit]                         --
              ,[ItemOrKitID]                        --
              ,[ItemOrKitDescription]               --
              ,[ItemOrKitQuantity]                  --
              ,[ItemOrKitUnitOfMeasureId]           --
              ,[ItemOrKitUnitOfMeasure]             --
              ,[ItemOrKitQualityId]                 --
              ,[ItemOrKitQualityCode]               --
              ,[IncotermsId]                        --
              ,[Incoterms]                          --
              ,@myToDay                             --
              ,TMP.ItemQuantity
              ,[ItemOrKitQualityId]                 --
              ,[ItemOrKitQualityCode]               --
              ,4                                    --
              ,''                                   --
              ,1                                    --
              ,@myToDay                             --
              ,@ModifyUserId                        --
          FROM [dbo].[CommunicationMessagesShipmentOrdersSentItems] OSI
          INNER JOIN #ShipmentConMan                                TMP
          ON OSI.ID = TMP.ID

         SET @myError    = @myError + @@ERROR
         IF @myError = 0 
         BEGIN
             COMMIT TRAN
         END
         ELSE
         BEGIN
             IF @@TRANCOUNT > 0 ROLLBACK TRAN

             SELECT @ReturnValue=1, @ReturnMessage='Chyba'
             SET @sub = 'FENIX - S1  Shipment Confirmation ruční - Záznam neuložen !!!' + ' Databáze: '+ISNULL(@myDatabaseName,'')
             SET @msg = 'Program prShipmentConfirmationManuallyIns; '  + ISNULL(ERROR_MESSAGE(),'') + ISNULL(CAST(ERROR_NUMBER() AS VARCHAR(50)),'') 
             EXEC @result = msdb.dbo.sp_send_dbmail
            		@profile_name = 'Automat', --@MailProfileName
            		@recipients = 'jaroslav.tajbl@upc.cz;michal.rezler@upc.cz',
            		@subject = @sub,
            		@body = @msg,
            		@body_format = 'HTML'
         END


  END TRY
  BEGIN CATCH
      IF @@TRANCOUNT > 0 ROLLBACK TRAN
      SELECT @ReturnValue=1, @ReturnMessage='Chyba'
      SET @sub = 'FENIX - S1  Shipment Confirmation ruční' + ' Databáze: '+ISNULL(@myDatabaseName,'')
      SET @msg = 'Program prShipmentConfirmationManuallyIns; '  + ISNULL(ERROR_MESSAGE(),'') + ISNULL(CAST(ERROR_NUMBER() AS VARCHAR(50)),'') 
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
    ON OBJECT::[dbo].[prShipmentConfirmationManuallyIns] TO [FenixW]
    AS [dbo];

