
CREATE PROCEDURE [dbo].[prCMSOKins] 
      @par1 as XML,
	   @ReturnValue     int            = -1 OUTPUT,
	   @ReturnMessage   nvarchar(2048) = null OUTPUT
AS
BEGIN
-- ===============================================================================================
-- Created by   : Weczerek Max
-- Created date : 2014-08-11
-- Description  : 
-- ===============================================================================================
/*
Z Fenixu ze stránky načítá záznamy ručně definovaných objednávek kompletace KITů !!!

Aktualizuje stavu na kartě


-- 20140820  20.8.2014  -- pozadavek ND, jeden kit jedna message  -- identifikace "pozadavek ND, jeden kit jedna message"

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
          @myItemOrKitQualityID [int],
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
          @myStockID [int],
          @mycdlStocksId [int],
          @myKeycdlStocksId [int],
          @myItemOrKitMeasuresCode [varchar](50),
          @myKitQualitiesCode [varchar](50),
          @myHeliosOrderID [int],
          @myKItemCode [varchar](50),
          @myKDescriptionCzKit [nvarchar](150),
          @myKDescriptionCzItemsOrKit [nvarchar](150),
          @myKeyHeliosOrderID  [int],
          @myHeliosOrderIDx AS INT

       DECLARE @myKcdlKitsItemsID [int]
             , @myKcdlKitsID      [int]
             , @myKItemVerKit     [varchar](1)
             , @myKItemOrKitID    [int]
             , @myKItemOrKitQuantity [numeric](18, 3)
             , @myKPackageType    [varchar](50)

       SELECT @myItemOrKitID = -1,   @myKeyItemOrKitDateOfDelivery = NULL, @myDate = GetDate(),  @myKeycdlStocksId = -1, @hIdent = -1, @myKeyHeliosOrderID = -1
       
       DECLARE @myIdentity [int], @FreeNumber [int],  @MessageDescription  [nvarchar] (500)
       , @myOrderIdFromTable [int], @myFreeNumber [numeric](18, 3), @myReservedNumber [numeric](18, 3)
       
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
   IF OBJECT_ID('tempdb..#CMSKManually','table') IS NOT NULL DROP TABLE #CMSKManually   -- CommunicationMessagesSentKitManually

      EXEC sp_xml_preparedocument @hndl OUTPUT, @par1
      --
      SELECT x.[ItemVerKit],x.[StockID],x.[StockName],x.[ItemOrKitID],x.[ItemOrKitDescription],x.[ItemOrKitQuantity],     
             x.[ItemOrKitUnitOfMeasureId],x.[ItemOrKitMeasuresCode], x.[ItemOrKitDateOfDelivery], x.[ItemOrKitQualityID],x.[KitQualitiesCode],x.[HeliosOrderID],x.[ModifyUserId]          
      INTO #CMSKManually
      FROM OPENXML (@hndl, '/NewDataSet/CommunicationMessagesSentKitManually', 2)
      WITH (
	          [ItemVerKit] [int],
				 [StockID] [varchar](50),
				 [StockName] [varchar](50),
	          [ItemOrKitID] [int],
	          [ItemOrKitDescription] [varchar](500),
	          [ItemOrKitQuantity] [numeric](18, 3),
             [ItemOrKitUnitOfMeasureID] [int],
             [ItemOrKitMeasuresCode] [varchar](50),
	          [ItemOrKitDateOfDelivery] [datetime],
	          [ItemOrKitQualityID] [int],
	          [KitQualitiesCode] [varchar](50),
	          [HeliosOrderID] [int],
	          [ModifyUserId] [int] ) x
      --
      EXEC sp_xml_removedocument @hndl

      SELECT * FROM #CMSKManually ORDER BY StockID,ItemOrKitDateOfDelivery

-- =======================================================================================================
DECLARE @myOK AS INT
SET @myOK = 1

SET @myPocet = 0

SELECT  @myPocet = COUNT(*)         
FROM #CMSKManually x
INNER JOIN [dbo].[CommunicationMessagesKittingsSent]  y
    ON x.[StockId] = y.[StockId] AND CONVERT(CHAR(8),x.[ItemOrKitDateOfDelivery],112) = CONVERT(CHAR(8),y.KitDateOfDelivery,112)
INNER JOIN  [dbo].[CommunicationMessagesKittingsSentItems]  z
    ON y.ID= z.CMSOId
WHERE x.[ItemOrKitID] = z.KitId --AND x.[ItemOrKitDescription]= z.ItemDescription 
  AND CAST(x.[ItemOrKitQuantity] AS INT) = CAST(z.KitQuantity AS INT) AND x.[ItemOrKitQualityID] = z.KitQualityId
  AND Datediff(mi,y.ModifyDate,@myDate)<5

-- ========================================================================================================
IF @myPocet = 0 OR @myPocet IS NULL
BEGIN  -- *** jeste nebylo zapsáno ***
--SELECT 'x'

IF (SELECT CURSOR_STATUS('global','myCursor')) >= -1
 BEGIN
          DEALLOCATE myCursor
 END
 

     DECLARE myCursor CURSOR 
     FOR SELECT x.[ItemVerKit],x.[StockID],x.[ItemOrKitID],x.[ItemOrKitDescription],x.[ItemOrKitQuantity],     
                x.[ItemOrKitUnitOfMeasureId],x.[ItemOrKitMeasuresCode], x.[ItemOrKitDateOfDelivery], x.[ItemOrKitQualityID]
                ,x.[KitQualitiesCode],ISNULL(x.[HeliosOrderID],0),x.[ModifyUserId]          
      FROM #CMSKManually x WHERE x.[ItemVerKit] = 1 ORDER BY StockID,ItemOrKitDateOfDelivery
 
      OPEN myCursor
      FETCH NEXT FROM myCursor INTO @myItemVerKit,@myStockID,@myItemOrKitID,@myItemOrKitDescription,@myItemOrKitQuantity    
                                    ,@myItemOrKitUnitOfMeasureId,@myItemOrKitMeasuresCode, @myItemOrKitDateOfDelivery, @myItemOrKitQualityID
                                    ,@myKitQualitiesCode,@myHeliosOrderID,@myModifyUserId
           
      WHILE @@FETCH_STATUS = 0
      BEGIN -- FETCH_STATUS
           -- IF  @myKeycdlStocksId <> @myStockID OR @myKeyItemOrKitDateOfDelivery <> @myItemOrKitDateOfDelivery  OR @myKeyHeliosOrderID <> @myHeliosOrderID
           -- pozadavek ND, jeden kit jedna message
           IF  @myKeycdlStocksId <> @myStockID OR @myKeyItemOrKitDateOfDelivery <> @myItemOrKitDateOfDelivery  OR @myKeyHeliosOrderID <> -999
           BEGIN -- 1
                    --1. 
                    SET @hIdent = -1
                    SELECT @myKeycdlStocksId = @myStockID, @myKeyItemOrKitDateOfDelivery = @myItemOrKitDateOfDelivery, @myItemOrKitID = @myItemOrKitID, @myKeyHeliosOrderID = @myHeliosOrderID
           END
                    --2.
                    IF (SELECT CURSOR_STATUS('global','myCursorKitsItems')) >= -1
                    BEGIN
                              DEALLOCATE myCursorKitsItems
                    END

                    DECLARE  myCursorKitsItems CURSOR
                    FOR SELECT  [cdlKitsItemsID],[cdlKitsID],[ItemVerKit],[ItemOrKitID],[ItemCode],[DescriptionCzKit],[DescriptionCzItemsOrKit] ,[ItemOrKitQuantity],[PackageType]
                        FROM [dbo].[vwKitsIt] WHERE [IsActive] = 1 AND [cdlKitsID] = @myItemOrKitID
                    
                    OPEN myCursorKitsItems
                    FETCH NEXT FROM myCursorKitsItems INTO @myKcdlKitsItemsID, @myKcdlKitsID, @myKItemVerKit, @myKItemOrKitID, @myKItemCode, @myKDescriptionCzKit, @myKDescriptionCzItemsOrKit, @myKItemOrKitQuantity,@myKPackageType

                    WHILE @@FETCH_STATUS = 0
                    BEGIN -- FETCH_STATUS
                        SELECT @myFreeNumber  = [ItemOrKitFree] FROM [dbo].[CardStockItems] 
                        WHERE [IsActive]=1 AND [StockId] = @myKeycdlStocksId AND [ItemOrKitID] = @myKItemOrKitID AND [ItemVerKit] = @myKItemVerKit AND [ItemOrKitQuality] = @myItemOrKitQualityID
                        IF @myKItemOrKitQuantity*@myItemOrKitQuantity>ISNULL(@myFreeNumber ,0)
                        BEGIN SET @mOk=0  END

                        FETCH NEXT FROM myCursorKitsItems INTO @myKcdlKitsItemsID, @myKcdlKitsID, @myKItemVerKit, @myKItemOrKitID, @myKItemCode, @myKDescriptionCzKit, @myKDescriptionCzItemsOrKit, @myKItemOrKitQuantity,@myKPackageType
                    END    -- FETCH_STATUS
                  
                    CLOSE myCursorKitsItems
	                 DEALLOCATE myCursorKitsItems

                    IF @mOk = 1
                    BEGIN 
                        BEGIN TRAN
                           
                           SET @myError = 0
                           IF @hIdent = -1
                           BEGIN
                             SELECT @FreeNumber = [LastFreeNumber] FROM [dbo].[cdlMessageNumber]        WHERE [Code]=1 
                             UPDATE [dbo].[cdlMessageNumber] SET [LastFreeNumber] = @FreeNumber + 1     WHERE [Code]=1
                             SELECT @MessageDescription = [DescriptionEng] FROM [dbo].[cdlMessageTypes] WHERE  [ID]=1
                             EXEC [dbo].[prGetOrderNumber] @HeliosOrderIdin = @myHeliosOrderID, @OrderNumberOut = @myHeliosOrderIDx   output

                             INSERT INTO [dbo].[CommunicationMessagesKittingsSent]
                                         ([MessageId]
                                         ,[MessageType]
                                         ,[MessageDescription]
                                         ,[MessageStatusId]
                                         ,[HeliosOrderId]
                                         ,[KitDateOfDelivery]
                                         ,[StockId]
                                         ,IsManually
                                         ,[IsActive]
                                         ,[ModifyDate]
                                         ,[ModifyUserId])
                                   VALUES
                                         (@FreeNumber                   -- <MessageId, int,>
                                         ,3
                                         ,'KittingOrder'
                                         ,1                             -- <MessageStatusId, int,>
                                         ,@myHeliosOrderIDx
                                         ,@myKeyItemOrKitDateOfDelivery -- <KitDateOfDelivery, datetime,>
                                         ,@myStockID                    -- <StockId, int,>
                                         ,1                             -- IsManually
                                         ,1                             -- <IsActive, bit,>
                                         ,@myDate                       -- <ModifyDate, datetime,>
                                         ,0                             -- <ModifyUserId, int,>
                                         )

                             SET @hIdent = @@IDENTITY
                             SET @myError = @@ERROR
--SELECT @myError '@myError1'
                           END
                           IF @myError = 0
                           BEGIN
                                      SELECT @myItemOrKitDescription = ISNULL([DescriptionCz],'') FROM [dbo].[cdlKits] WHERE ID=@myItemOrKitID
--SELECT @myHeliosOrderID
                                      
--SELECT @myHeliosOrderIDx
                                      INSERT INTO [dbo].[CommunicationMessagesKittingsSentItems]
                                                  ([CMSOId]
                                                  ,[KitId]
                                                  ,[KitDescription]
                                                  ,[KitQuantity]
                                                  ,[MeasuresID]
                                                  ,[KitUnitOfMeasure]
                                                  ,[KitQualityId]
                                                  ,[KitQualityCode]
                                                  ,[HeliosOrderID]
                                                  ,[CardStockItemsId]
                                                  ,[IsActive]
                                                  ,[ModifyDate]
                                                  ,[ModifyUserId])
                                            VALUES
                                                  (@hIdent                       -- <CMSOId, int,>
                                                  ,@myItemOrKitID                -- <KitId, varchar(50),>
                                                  ,@myItemOrKitDescription       -- <KitDescription, nvarchar(500),>
                                                  ,@myItemOrKitQuantity          -- <KitQuantity, numeric(18,3),>
                                                  ,@myItemOrKitUnitOfMeasureId   -- <MeasuresID, int,>
                                                  ,@myItemOrKitMeasuresCode      -- <KitUnitOfMeasure, nvarchar(50),>
                                                  ,@myItemOrKitQualityID         -- <KitQualitiesId, int,>
                                                  ,ISNULL(@myKitQualitiesCode,'')           -- <KitQualitiesCode, nvarchar(50),>
                                                  ,@myHeliosOrderIDx             -- <HeliosOrderID, int,>
                                                  ,@myStockID                    -- <CardStockItemsId, int,>
                                                  ,1                             -- <IsActive, bit,>
                                                  ,@myDate                       -- <ModifyDate, datetime,>
                                                  ,0                             -- <ModifyUserId, int,>
                                                   )
--SELECT @myError '@myError2'
                               SET @myError = @myError+@@ERROR
                               IF @myError = 0
                               BEGIN
                               DECLARE @mySuma AS numeric(18,3)
                                  DECLARE  myCursorKitsItems CURSOR
                                  FOR SELECT  [cdlKitsItemsID],[cdlKitsID],[ItemVerKit],[ItemOrKitID],[ItemCode],[DescriptionCzKit],[DescriptionCzItemsOrKit] ,[ItemOrKitQuantity],[PackageType]
                                      FROM [dbo].[vwKitsIt] WHERE [IsActive] = 1 AND [cdlKitsID] = @myItemOrKitID
                                  
                                  OPEN myCursorKitsItems
                                  FETCH NEXT FROM myCursorKitsItems INTO @myKcdlKitsItemsID, @myKcdlKitsID, @myKItemVerKit, @myKItemOrKitID, @myKItemCode, @myKDescriptionCzKit, @myKDescriptionCzItemsOrKit, @myKItemOrKitQuantity,@myKPackageType
                              
                                  WHILE @@FETCH_STATUS = 0
                                  BEGIN -- FETCH_STATUS
                                      SET @mySuma = @myKItemOrKitQuantity*@myItemOrKitQuantity
                                      SELECT @myFreeNumber  = [ItemOrKitFree] FROM [dbo].[CardStockItems] 
                                      WHERE [IsActive]=1 AND [StockId] = @myKeycdlStocksId AND [ItemOrKitID] = @myKItemOrKitID AND [ItemVerKit] = @myKItemVerKit AND [ItemOrKitQuality] = @myItemOrKitQualityID
                                      IF @mySuma > ISNULL(@myFreeNumber ,0)
                                      BEGIN SET @myError = 333  END
                                      ELSE
                                      BEGIN
                                         UPDATE [dbo].[CardStockItems]
                                            SET [ItemOrKitFree] = ISNULL(ItemOrKitFree,0.0) - @mySuma
                                               ,[ItemOrKitReserved] = ISNULL(ItemOrKitReserved,0.0) + @mySuma
                                               ,[ModifyDate] = @myDate
                                               ,[ModifyUserId] = 0
                                          WHERE [IsActive]=1 AND [StockId] = @myKeycdlStocksId AND [ItemOrKitID] = @myKItemOrKitID AND [ItemVerKit] = @myKItemVerKit AND [ItemOrKitQuality] = @myItemOrKitQualityID
                                          SET @myError = @myError+@@ERROR
                                      END
SELECT @myError '@myError3'
                                      FETCH NEXT FROM myCursorKitsItems INTO @myKcdlKitsItemsID, @myKcdlKitsID, @myKItemVerKit, @myKItemOrKitID, @myKItemCode, @myKDescriptionCzKit, @myKDescriptionCzItemsOrKit, @myKItemOrKitQuantity,@myKPackageType
                                  END    -- FETCH_STATUS
                                
                                  CLOSE myCursorKitsItems
	                               DEALLOCATE myCursorKitsItems
                                 
                               END
                                IF @@TRANCOUNT>0 COMMIT TRAN
                                --SELECT '@@TRANCOUNT>0 COMMIT TRAN'
                           END
                           ELSE
                           BEGIN
                           --SELECT '@@TRANCOUNT',@@TRANCOUNT
                              IF @@TRANCOUNT>0 ROLLBACK TRAN
                           END
                    END


                 FETCH NEXT FROM myCursor INTO @myItemVerKit,@myStockID,@myItemOrKitID,@myItemOrKitDescription,@myItemOrKitQuantity    
                                    ,@myItemOrKitUnitOfMeasureId,@myItemOrKitMeasuresCode, @myItemOrKitDateOfDelivery, @myItemOrKitQualityID
                                    ,@myKitQualitiesCode,@myHeliosOrderID,@myModifyUserId
      END    -- FETCH_STATUS
      CLOSE myCursor
	   DEALLOCATE myCursor

       IF @myError = 0 
       BEGIN
             IF @@TRANCOUNT>0  COMMIT TRAN 
       END
       ELSE
       BEGIN
             IF @@TRANCOUNT>0 ROLLBACK TRAN
             SET @ReturnValue = 10
       END

      
      END    -- *** jeste nebylo zapsáno ***
ELSE
BEGIN
 SET @ReturnValue = 0
 SET @ReturnMessage = 'dvojitý klik ?'
END

END TRY

BEGIN CATCH

      IF @@TRANCOUNT>0 ROLLBACK TRAN

      SET @ReturnValue=1
      SET @sub = 'FENIX - načtení ručně definovaných objednávek CHYBA' + ' Databáze: '+ISNULL(@myDatabaseName,'')
      SET @msg = 'Program prCMSOKins' + ISNULL(ERROR_MESSAGE(),'') + ISNULL(CAST(ERROR_NUMBER() AS VARCHAR(50)),'')
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
    ON OBJECT::[dbo].[prCMSOKins] TO [FenixW]
    AS [dbo];

