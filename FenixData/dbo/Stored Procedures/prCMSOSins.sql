
CREATE PROCEDURE [dbo].[prCMSOSins] 
      @par1 as XML,
      @ModifyUserId    AS INT    = 0,
	   @ReturnValue     AS INT    = -1 OUTPUT,
	   @ReturnMessage   nvarchar(2048) = null OUTPUT
AS
BEGIN
-- ===============================================================================================
-- Created by   : Weczerek Max
-- Created date : 2014-07-09
-- Updated date : 2014-09-05, 2014-09-19, 2015-02-18
-- Description  : 
-- ===============================================================================================
/*
Z Fenixu ze stránky načítá záznamy ručně definovaných objednávek

 Neaktualizuje stavy na kartě

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
          @myMessageStatus [int],
          @myOrderId [int],
          @myOrderDescription [nvarchar](200),
          @myCustomerId [int],
          @myCustomerName [nvarchar](200),
          @myCustomerAddress [nvarchar](200),
          @myCustomerZipCode [nvarchar](200),
          @myCustomerCountry [nvarchar](200),
          @myCustomerPhoneNumber [varchar](200),
          @myItemVerKit [bit],
          @myItemOrKitID [varchar](50),
          @myItemOrKitDescription [varchar](500),
          @myItemOrKitQuantity [numeric](18, 3),
          @myItemOrKitUnitOfMeasureId [varchar](50),
          @myItemOrKitQuality [int],
          @myItemOrKitDateOfDelivery [datetime],
          @myItemType [varchar](50),
          @myIncoterms [nchar](50),
          @myPackageType [nchar](50),
          @myIsActive [bit],
          @myModifyDate [datetime],
          @myModifyUserId [int] ,
          @myKeyCustomerId [int] ,
          @myKeyItemVerKit [bit] ,
          @myKeyItemOrKitDateOfDelivery [datetime] ,
          @myDate [datetime],
          @hIdent [int],
          @mySourceId [int],@myHeliosOrderId [int]

       SELECT @myKeyCustomerId = -1 , @myKeyItemVerKit = null,   @myKeyItemOrKitDateOfDelivery = NULL, @myDate = GetDate()
       
       DECLARE @myIdentity [int], @FreeNumber [int], @MessageDescription  [nvarchar] (500), @myOrderIdFromTable [int]
       
       DECLARE
          @myPocet [int],
          @myError [int],
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
   END --- DECLARACE
   -- =======================================================================
   -- Nacteni xml souboru do tabulky
   -- =======================================================================
   IF OBJECT_ID('tempdb..#CommunicationMessagesOrdersSentmanually','table') IS NOT NULL DROP TABLE #CommunicationMessagesOrdersSentmanually

      EXEC sp_xml_preparedocument @hndl OUTPUT, @par1
      --
      SELECT x.[OrderId],x.[OrderDescription],x.[CustomerId],x.[CustomerName],x.[CustomerAddress],
             x.[CustomerZipCode],x.[CustomerCountry],x.[CustomerPhoneNumber],x.[ItemVerKit],x.[ItemOrKitID],x.[ItemOrKitDescription],x.[ItemOrKitQuantity],     
             x.[ItemOrKitUnitOfMeasureId],x.[ItemOrKitQuality],x.[ItemOrKitDateOfDelivery],x.[ItemType],x.[Incoterms],x.[PackageType],x.[ModifyUserId], 
             x.[SourceId],x.[HeliosOrderId]
         
      INTO #CommunicationMessagesOrdersSentmanually
      FROM OPENXML (@hndl, '/NewDataSet/CommunicationMessagesOrdersSentmanually', 2)
      WITH (
	          [OrderId] [int],
             [OrderDescription] [nvarchar](200),
	          [CustomerId] [int],
	          [CustomerName] [nvarchar](200),
	          [CustomerAddress] [nvarchar](200),
	          [CustomerZipCode] [nvarchar](200),
	          [CustomerCountry] [nvarchar](200),
	          [CustomerPhoneNumber] [varchar](200),
	          [ItemVerKit] [bit],
	          [ItemOrKitID] [varchar](50),
	          [ItemOrKitDescription] [varchar](500),
	          [ItemOrKitQuantity] [numeric](18, 3),
	          [ItemOrKitUnitOfMeasureId] [varchar](50),
	          [ItemOrKitQuality] [int],
	          [ItemOrKitDateOfDelivery] [datetime],
	          [ItemType] [varchar](50),
	          [Incoterms] [nchar](50),
	          [PackageType] [nchar](50),
	          [ModifyUserId] [int],
             [SourceId] [int],
             [HeliosOrderId] [int]  ) x
      --
      EXEC sp_xml_removedocument @hndl

--SELECT * FROM  #CommunicationMessagesOrdersSentmanually

--SELECT Datediff(mi,y.ModifyDate,@myDate), y.*        
--FROM #CommunicationMessagesOrdersSentmanually  x
--INNER JOIN [dbo].[CommunicationMessagesReceptionSent]  y
--    ON x.[CustomerId]=y.ItemSupplierID 

--SELECT @myPocet = COUNT(*)       
--FROM #CommunicationMessagesOrdersSentmanually  x
--INNER JOIN [dbo].[CommunicationMessagesReceptionSent]  y
--    ON x.[CustomerId]=y.ItemSupplierID
--INNER JOIN  [dbo].[CommunicationMessagesReceptionSentItems]  z
--    ON y.ID= z.CMSOId
--WHERE x.[ItemOrKitID] = z.ItemID --AND x.[ItemOrKitDescription]= z.ItemDescription 
--  AND CAST(x.[ItemOrKitQuantity] AS INT) = CAST(z.ItemQuantity AS INT) AND x.[ItemOrKitQuality] = z.ItemQualityId
--  AND CONVERT(CHAR(8),x.[ItemOrKitDateOfDelivery],112) = CONVERT(CHAR(8),y.ItemDateOfDelivery,112)
--   AND Datediff(mi,y.ModifyDate,@myDate)<3

-- ========================================================================================================
DECLARE @myOK AS INT
SET @myOK = 1

SET @myPocet = 0

SELECT  @myPocet = COUNT(*)         
FROM #CommunicationMessagesOrdersSentmanually  x
INNER JOIN [dbo].[CommunicationMessagesReceptionSent]  y
    ON x.[CustomerId]=y.ItemSupplierID
INNER JOIN  [dbo].[CommunicationMessagesReceptionSentItems]  z
    ON y.ID= z.CMSOId
WHERE x.[ItemOrKitID] = z.ItemID --AND x.[ItemOrKitDescription]= z.ItemDescription 
   AND CAST(x.[ItemOrKitQuantity] AS INT) = CAST(z.ItemQuantity AS INT) AND x.[ItemOrKitQuality] = z.ItemQualityId
   AND CONVERT(CHAR(8),x.[ItemOrKitDateOfDelivery],112) = CONVERT(CHAR(8),y.ItemDateOfDelivery,112)
   AND Datediff(mi,y.ModifyDate,@myDate)<5

-- ========================================================================================================
IF @myPocet = 0 OR @myPocet IS NULL
BEGIN  -- *** jeste nebylo zapsáno ***
--SELECT 'x'

IF (SELECT CURSOR_STATUS('global','crCommunicationMessagesOrdersSentmanually')) >= -1
 BEGIN
          DEALLOCATE crCommunicationMessagesOrdersSentmanually
 END
     -- zpracovávají se pouze objednávky zboží a materilálů
     BEGIN TRAN
     DECLARE myCursor CURSOR 
     FOR  SELECT x.[CustomerId],x.[CustomerName],x.[CustomerAddress], x.[CustomerZipCode], x.[CustomerCountry]
               , x.[CustomerPhoneNumber], x.[ItemVerKit], x.[ItemOrKitID],x.[ItemOrKitDescription],x.[ItemOrKitQuantity]     
               , x.[ItemOrKitUnitOfMeasureId],x.[ItemOrKitQuality],x.[ItemOrKitDateOfDelivery],x.[ItemType],x.[Incoterms],x.[PackageType],x.[ModifyUserId] 
               , x.[SourceId],x.[HeliosOrderId]         
          FROM #CommunicationMessagesOrdersSentmanually  x   WHERE x.[ItemVerKit] = 0
          ORDER BY CustomerId,[ItemVerKit],[ItemOrKitDateOfDelivery]

             OPEN myCursor
             FETCH NEXT FROM myCursor INTO @myCustomerId,@myCustomerName,@myCustomerAddress,
             @myCustomerZipCode,@myCustomerCountry,@myCustomerPhoneNumber,@myItemVerKit,@myItemOrKitID,@myItemOrKitDescription,@myItemOrKitQuantity,     
             @myItemOrKitUnitOfMeasureId,@myItemOrKitQuality,@myItemOrKitDateOfDelivery,@myItemType,@myIncoterms,@myPackageType,@myModifyUserId,
             @mySourceId,@myHeliosOrderId
           
             WHILE @@FETCH_STATUS = 0
             BEGIN
             --SELECT @myKeyCustomerId,@myCustomerId,@myKeyItemVerKit,@myItemVerKit,@myKeyItemOrKitDateOfDelivery,@myItemOrKitDateOfDelivery
                 IF  @myKeyCustomerId <>@myCustomerId OR @myKeyItemVerKit<> @myItemVerKit OR @myKeyItemOrKitDateOfDelivery <> @myItemOrKitDateOfDelivery
                 BEGIN
 
                    --1. 
                    SELECT @myKeyCustomerId = @myCustomerId, @myKeyItemVerKit = @myItemVerKit, @myKeyItemOrKitDateOfDelivery = @myItemOrKitDateOfDelivery
                    --2.
                    SELECT @FreeNumber = [LastFreeNumber] FROM [dbo].[cdlMessageNumber]        WHERE [Code]='1'
                    UPDATE [dbo].[cdlMessageNumber] SET [LastFreeNumber] = @FreeNumber + 1     WHERE [Code]='1'
                    SELECT @MessageDescription = [DescriptionEng] FROM [dbo].[cdlMessageTypes] WHERE [ID]  =1
                    --3.
                    EXEC [dbo].[prGetOrderNumber] @HeliosOrderIDIn = @myHeliosOrderId, @OrderNumberOut = @myOrderIdFromTable output
                    --SELECT @myOrderIdFromTable = [LastFreeNumber] FROM [dbo].[cdlOrderNumber]  WHERE [Code]='1'
                    --UPDATE [dbo].[cdlOrderNumber] SET [LastFreeNumber] = ISNULL(@myOrderIdFromTable,0)-1
                    --4.
                         INSERT INTO [dbo].[CommunicationMessagesReceptionSent]
                                    ([MessageId]
                                    ,[MessageType]
                                    ,[MessageDescription]
                                    ,[MessageDateOfShipment]
                                    ,[MessageStatusID]
                                    ,[HeliosOrderId]
                                    ,[ItemSupplierID]
                                    ,[ItemSupplierDescription]
                                    ,[ItemDateOfDelivery]
                                    ,[IsManually]
                                    ,[IsActive]
                                    ,[ModifyDate]
                                    ,[ModifyUserId])
                              VALUES
                                    (@FreeNumber          -- <MessageId, int,>
                                    ,1                    --<MessageType, int,>
                                    ,@MessageDescription  --<MessageDescription, nvarchar(200),>
                                    ,NULL                 --<MessageDateOfShipment, datetime,>
                                    ,1                    --<MessageStatus, int,>
                                    ,@myOrderIdFromTable  --<HeliosOrderId, int,>
                                    ,@myCustomerId        --<ItemSupplierID, int,>
                                    ,@myCustomerName      --<ItemSupplierDescription, nvarchar(500),>
                                    ,@myItemOrKitDateOfDelivery    --<ItemDateOfDelivery, datetime,>
                                    ,1                    -- [IsManually]
                                    ,1                    --<IsActive, bit,>
                                    ,GetDate()            --<ModifyDate, datetime,>
                                    ,@ModifyUserId        --<ModifyUserId, int,>    2015-02-18
                                    )
                         SET @hIdent = @@IDENTITY
                         SET @myError = @@ERROR
                 END   

                 IF @myError = 0
                 BEGIN
                         DECLARE @GroupGoods [varchar] (50), @pRegCis  [varchar] (50), @ItemUnitOfMeasure nvarchar(50)
                         SELECT  @GroupGoods = GroupGoods, @pRegCis=CODE, @myItemOrKitDescription=[DescriptionCz] FROM  [dbo].[cdlItems] WHERE [ID] = @myItemOrKitID
                         SELECT  @ItemUnitOfMeasure = [Code] FROM  [dbo].[cdlMeasures] WHERE [ID] = @myItemOrKitUnitOfMeasureId

                                  INSERT INTO [dbo].[CommunicationMessagesReceptionSentItems]
                                             ([CMSOId]
                                             ,[HeliosOrderId]
                                             ,[HeliosOrderRecordId]
                                             ,[ItemID]
                                             ,[GroupGoods]
                                             ,[ItemCode]
                                             ,[ItemDescription]
                                             ,[ItemQuantity]
                                             ,[MeasuresID]
                                             ,[ItemUnitOfMeasure]
                                             ,[SourceId]
                                             ,[IsActive]
                                             ,[ModifyDate]
                                             ,[ModifyUserId])
                                       VALUES
                                             (@hIdent                            --<CMSOId, int,>
                                             ,@myOrderIdFromTable   --            @myHeliosOrderId                   --<HeliosOrderId, int,>
                                             ,NULL                               --<HeliosOrderRecordId, int,>
                                             ,@myItemOrKitID                     --<ItemID, int,>,,,
                                             ,@GroupGoods                        --<GroupGoods, nvarchar(3),>
                                             ,CAST(@pRegCis AS nvarchar(50) )    --<ItemCode, nvarchar(50),>
                                             ,@myItemOrKitDescription            --<ItemDescription, nvarchar(500),>
                                             ,CAST(@myItemOrKitQuantity AS numeric (18,3)) --<ItemQuantity, numeric(18,3),>
                                             ,@myItemOrKitUnitOfMeasureId                     --<MeasuresID, int,>
                                             ,@ItemUnitOfMeasure                --<ItemUnitOfMeasure, nvarchar(50),>
                                             ,CASE @mySourceId
                                                WHEN -1 THEN NULL
                                                ELSE @mySourceId
                                              END
                                             ,1                                  --<IsActive, bit,>
                                             ,GetDate()                          --<ModifyDate, datetime,>
                                             ,@ModifyUserId                      --<ModifyUserId, int,>    2015-02-18
                                             )
                                  SET @myError = @myError + @@ERROR


                 END
              FETCH NEXT FROM myCursor INTO @myCustomerId,@myCustomerName,@myCustomerAddress,
              @myCustomerZipCode,@myCustomerCountry,@myCustomerPhoneNumber,@myItemVerKit,@myItemOrKitID,@myItemOrKitDescription,@myItemOrKitQuantity,     
              @myItemOrKitUnitOfMeasureId,@myItemOrKitQuality,@myItemOrKitDateOfDelivery,@myItemType,@myIncoterms,@myPackageType,@myModifyUserId,
              @mySourceId,@myHeliosOrderId 
             END
    
      CLOSE myCursor
	   DEALLOCATE myCursor

      IF @myError = 0
      BEGIN
        IF @@TRANCOUNT>0 
        BEGIN
           COMMIT TRAN
        END
      END
      ELSE
      BEGIN
        IF @@TRANCOUNT>0 
        BEGIN
           ROLLBACK TRAN
           SET @ReturnValue = 3
        END
      END



END    -- *** jeste nebylo zapsáno ***
ELSE
BEGIN
 SET @ReturnValue = 0
 SET @ReturnMessage = 'dvojitý klik ?'
END

END TRY

BEGIN CATCH
      SET @ReturnValue=1
      SET @sub = 'FENIX - načtení ručně definovaných objednávek CHYBA' + ' Databáze: '+ISNULL(@myDatabaseName,'')
      SET @msg = 'Program prCMSOSins' + ISNULL(ERROR_MESSAGE(),'') + ISNULL(CAST(ERROR_NUMBER() AS VARCHAR(50)),'')
      EXEC @result = msdb.dbo.sp_send_dbmail
     		@profile_name = 'Automat', --@MailProfileName
     		@recipients = 'max.weczerek@upc.cz;michal.rezler@upc.cz',
     		@subject = @sub,
     		@body = @msg,
     		@body_format = 'HTML'


END CATCH

END











GO
GRANT EXECUTE
    ON OBJECT::[dbo].[prCMSOSins] TO [FenixW]
    AS [dbo];

