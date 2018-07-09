CREATE PROCEDURE [dbo].[prCMRCconsentS]
      @Decision  AS Int, -- -- 3... zamítám, 1... schvaluji  2015-11-09 hodnota 2 se už nepoužívá
      @Id        AS Int, -- ID záznamu z tabulky [dbo].[CommunicationMessagesShipmentOrdersConfirmation]

			@DeleteMessageId AS Int,													--2015-11-09 MessageId záznamu z tabulky [dbo].[CommunicationMessagesShipmentOrdersConfirmation]
			@DeleteMessageTypeId AS Int,											--2015-11-09 z tabulky [dbo].[cdlMessageTypes]
			@DeleteMessageTypeDescription AS nvarchar(200),		--2015-11-09 z tabulky [dbo].[cdlMessageTypes]

      @ModifyUserId        AS Int = 0,
	    @ReturnValue     int            = -1 OUTPUT,
	    @ReturnMessage   nvarchar(2048) = null OUTPUT
AS

SET NOCOUNT ON;
    DECLARE @myDatabaseName  nvarchar(100)
BEGIN TRY
/*
    2014-11-03,2014-11-05, 2014-11-19, 2014-11-20, 2014-11-24, 2014-11-25, 2014-12-01, 2015-01-19, 2015-01-21, 2015-01-27, 2015-04-13, 2015-04-29, 2015-11-09
		2015-11-09  M.Rezler  Decision: přidána hodnota 3  (D0 odeslána),  hodnota 2 se nepoužívá
*/
BEGIN
    SELECT @myDatabaseName = DB_NAME() 

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

       SELECT  @ReturnValue=0,  @ReturnMessage='OK'
       DECLARE @myError AS INT
       SET @myError = 0
END
       DECLARE @myShipmentOrderID  AS Integer
       SELECT  @myShipmentOrderID = [ShipmentOrderID] FROM [dbo].[CommunicationMessagesShipmentOrdersConfirmation] WHERE id = @Id

       DECLARE @myIdWf          AS INT  -- ID cele vydejky
              ,@myRecnoIdWf     AS INT  -- ID radku ve vydejce tabulky [dbo].[VydejkySprWrhMaterials]
       

     IF @Decision = 3		--2  2015-11-09
     BEGIN -- zamítnuto 
         BEGIN TRAN
               -- 1.
               UPDATE [dbo].[CommunicationMessagesShipmentOrdersConfirmation] SET [Reconciliation]  = @Decision, ModifyUserId = @ModifyUserId WHERE [ID] = @Id
               UPDATE [dbo].[CommunicationMessagesShipmentOrdersSent]         SET [MessageStatusId] = 7 WHERE [ID] = @myShipmentOrderID

							 --novinka 2015-11-09 start
							 DECLARE @FreeNumber AS [int]
							 SELECT @FreeNumber = [LastFreeNumber] FROM [dbo].[cdlMessageNumber]        WHERE [Code]=1 
               UPDATE [dbo].[cdlMessageNumber] SET [LastFreeNumber] = @FreeNumber + 1     WHERE [Code]=1

							 INSERT INTO [dbo].[CommunicationMessagesDeleteMessage]
													([MessageId], [MessageTypeId], [MessageTypeDescription], [MessageStatusId]
													,[DeleteId], [DeleteMessageId], [DeleteMessageTypeId], [DeleteMessageTypeDescription]
													,[Notice], [SentDate], [SentUserId]
													,[IsActive], [ModifyDate], [ModifyUserId])
										VALUES
													(@FreeNumber, 15, 'DeleteMessage', 1
													,@Id, @DeleteMessageId, @DeleteMessageTypeId, @DeleteMessageTypeDescription
													,NULL, NULL, NULL
													,1, getdate(), @ModifyUserId)							  
							 --novinka 2015-11-09 konec

               IF @@ERROR = 0 
                   COMMIT TRAN 
               ELSE              
               BEGIN
                   ROLLBACK TRAN
                   SET @ReturnMessage = ISNULL(ERROR_MESSAGE(),'') + ISNULL(CAST(ERROR_NUMBER() AS VARCHAR(50)),'')
              END
 
     END   -- zamítnuto
     
     IF @Decision = 1
     BEGIN -- schváleno
         BEGIN TRAN
               -- 1.
               UPDATE [dbo].[CommunicationMessagesShipmentOrdersConfirmation] SET [Reconciliation] = 1, ModifyUserId = @ModifyUserId  WHERE [ID] = @Id
               SET @myError = @myError + @@ERROR

               -- *******************************************************
               -- týká se výdejky ?
               -- *******************************************************
               SELECT @myIdWf = [IdWf]  FROM [dbo].[CommunicationMessagesShipmentOrdersSent]  O
               INNER JOIN [dbo].[CommunicationMessagesShipmentOrdersConfirmation]             C
               ON O.ID = C.ShipmentOrderID
               WHERE C.[ID] = @Id
               -- 2.
               -- *******************************************************
               -- sem prijde cursor pres ShipmentOrdersConfirmationItems
               -- *******************************************************
               IF OBJECT_ID('tempdb..#TmpShipmentOrdersConfirmationItems','table') IS NOT NULL DROP TABLE #TmpShipmentOrdersConfirmationItems
               CREATE TABLE #TmpShipmentOrdersConfirmationItems(
                   [CMSOId] [int] NOT NULL,
                   [SingleOrMaster] [int] NOT NULL,
                   [ItemVerKit] [int] NOT NULL,
                   [ItemOrKitID] [int] NOT NULL,
                   [ItemOrKitUnitOfMeasureId] [int] NOT NULL,
                   [ItemOrKitQualityId] [int] NOT NULL,
                   [SumRealItemOrKitQuantity] [numeric](18, 3) NULL,  -- tady bude suma
                   [RealItemOrKitQualityID] [int] NULL
               )

               INSERT INTO #TmpShipmentOrdersConfirmationItems(
                   [CMSOId],
                   [SingleOrMaster],
                   [ItemVerKit] ,
                   [ItemOrKitID] ,
                   [ItemOrKitUnitOfMeasureId],
                   [ItemOrKitQualityId],
                   [SumRealItemOrKitQuantity],
                   [RealItemOrKitQualityID]
                )
              SELECT [CMSOId],
                   [SingleOrMaster],
                   [ItemVerKit] ,
                   [ItemOrKitID] ,
                   [ItemOrKitUnitOfMeasureId],
                   [ItemOrKitQualityId],
                   SUM([RealItemOrKitQuantity]),
                   [RealItemOrKitQualityID]
              FROM [dbo].[CommunicationMessagesShipmentOrdersConfirmationItems]
              WHERE [IsActive] = 1 AND [CMSOId] = @Id
              GROUP BY  [CMSOId],
                        [SingleOrMaster],
                        [ItemVerKit] ,
                        [ItemOrKitID] ,
                        [ItemOrKitUnitOfMeasureId],
                        [ItemOrKitQualityId],
                        [RealItemOrKitQualityID]
               -- ****************************************************************
               DECLARE
                @myID int,
                @myCMSOId int,
                @mySingleOrMaster int,
                @myHeliosOrderRecordID int,
                @myItemVerKit int,
                @myItemOrKitID int,
                @myItemOrKitDescription nvarchar(100),
                @myItemOrKitQuantity numeric(18, 3),
                @myItemOrKitUnitOfMeasureId int,
                @myItemOrKitUnitOfMeasure nvarchar(50),
                @myItemOrKitQualityId int,
                @myItemOrKitQualityCode nvarchar(50),
                @myIncotermsId int,
                @myIncotermDescription nvarchar(50),
                @myRealDateOfDelivery datetime,
                @myRealItemOrKitQuantity numeric(18, 3),
                @mySumRealItemOrKitQuantity numeric(18, 3),
                @mySumRealItemOrKitQuantityObj numeric(18, 3),  -- objednane mnozstvi, pokud v objednavce je x naprosto stejných řádků (které se mohou lisit mnozstvím)
                @myRealItemOrKitQualityID int,
                @myRealItemOrKitQuality nvarchar(50),
                @myStatus int,
                @myKitSNs varchar(max),
                @myIsActive bit ,
                @myModifyDate datetime ,
                @myModifyUserId int,
                @myRecCountOb int,               -- pocet dotcenych zaznamu v objednavce
                @myRecCountCo int,               -- pocet dotcenych zaznamu v konfirmaci
                @myDifAmount numeric(18, 3)      -- diference v množství

               IF (SELECT CURSOR_STATUS('global','myCursorThroughShipmentOrdersConfirmationItems')) >= -1
               BEGIN
                      DEALLOCATE myCursorThroughShipmentOrdersConfirmationItems
               END

               DECLARE myCursorThroughShipmentOrdersConfirmationItems CURSOR 
               FOR
               SELECT [CMSOId],
                      [SingleOrMaster],
                      [ItemVerKit] ,
                      [ItemOrKitID] ,
                      [ItemOrKitUnitOfMeasureId],
                      [ItemOrKitQualityId],
                      [SumRealItemOrKitQuantity],
                      [RealItemOrKitQualityID]
               FROM #TmpShipmentOrdersConfirmationItems
               ORDER BY  [ItemOrKitID],[ItemVerKit],[SingleOrMaster],[RealItemOrKitQualityID]

               OPEN myCursorThroughShipmentOrdersConfirmationItems

               FETCH NEXT FROM myCursorThroughShipmentOrdersConfirmationItems INTO
                      @myCMSOId
                     ,@mySingleOrMaster
                     ,@myItemVerKit
                     ,@myItemOrKitID
                     ,@myItemOrKitUnitOfMeasureId
                     ,@myItemOrKitQualityId
                     ,@mySumRealItemOrKitQuantity
                     ,@myRealItemOrKitQualityID
 
               WHILE @@FETCH_STATUS = 0
               BEGIN
                   -- 1. pocet dotcenych záznamů v objednávce
                   SELECT @myRecCountOb = COUNT(*) FROM [dbo].[CommunicationMessagesShipmentOrdersSentItems]  SI
                   WHERE     SI.[ItemOrKitID] = @myItemOrKitID
                         AND SI.[ItemVerKit]  = @myItemVerKit
                         AND SI.[SingleOrMaster]           = @mySingleOrMaster
                         AND SI.[ItemOrKitUnitOfMeasureId] = @myItemOrKitUnitOfMeasureId
                         AND SI.[ItemOrKitQualityID]       = @myRealItemOrKitQualityID
                         AND SI.[CMSOId] = @myShipmentOrderID
                   --
                   IF @myRecCountOb = 0 OR @myRecCountOb IS NULL
                   BEGIN
                        -- chyba a co ted?
                        SELECT @ReturnValue=1, @ReturnMessage='Chyba v obsahu konfirmace'
                        SET @sub = 'FENIX - Shipment Confirmation CHYBA v obsahu konfirmace' + ' Databáze: '+ISNULL(@myDatabaseName,'')
                        SET @msg = 'Program prCMRCconsentS; '  + ' V konfirmaci je záznam, který nemá odpovídající záznam v objednávce<br />' +
                                   'ItemOrKitID= '+CAST(@myItemOrKitID AS varchar(50))+', ItemVerKit='+CAST(@myItemVerKit AS varchar(50))+
                                   ', SingleOrMaster='+CAST(@mySingleOrMaster AS varchar(50))+', ShipmentOrderID='+CAST(@myShipmentOrderID AS varchar(50))
                        EXEC @result = msdb.dbo.sp_send_dbmail
                       		@profile_name = 'Automat', --@MailProfileName
                       		@recipients = 'max.weczerek@upc.cz;michal.rezler@upc.cz',
                       		@subject = @sub,
                       		@body = @msg,
                       		@body_format = 'HTML'
                   END
                   ELSE
                   BEGIN
                        IF @myRecCountOb = 1
                        BEGIN --@myRecCountOb = 1
                           -- právě jeden záznam
                           --
                           -- diference mezi objednaným množstvím a přijatým množstvím
                           SELECT @myDifAmount = ([ItemOrKitQuantity] - @mySumRealItemOrKitQuantity) 
                           FROM [dbo].[CommunicationMessagesShipmentOrdersSentItems]  SI
                           WHERE     SI.[ItemOrKitID] = @myItemOrKitID
                                 AND SI.[ItemVerKit]  = @myItemVerKit
                                 AND SI.[SingleOrMaster]           = @mySingleOrMaster
                                 AND SI.[ItemOrKitUnitOfMeasureId] = @myItemOrKitUnitOfMeasureId
                                 AND SI.[ItemOrKitQualityID]       = @myRealItemOrKitQualityID
                                 AND SI.[CMSOId] = @myShipmentOrderID

                           -- aktualizace záznamu objednávky - nacteni skutecneho (dodaneho) mnozstvi
                           UPDATE [dbo].[CommunicationMessagesShipmentOrdersSentItems]
                           SET [ItemOrKitQuantityReal] = ISNULL([ItemOrKitQuantityReal],0) + @mySumRealItemOrKitQuantity
                           WHERE     [ItemOrKitID] = @myItemOrKitID
                                 AND [ItemVerKit]  = @myItemVerKit
                                 AND [SingleOrMaster]           = @mySingleOrMaster
                                 AND [ItemOrKitUnitOfMeasureId] = @myItemOrKitUnitOfMeasureId
                                 AND [ItemOrKitQualityID]       = @myRealItemOrKitQualityID
                                 AND [CMSOId] = @myShipmentOrderID
                           SET @myError = @myError + @@Error

                           -- aktualizace karty
                           IF @myItemVerKit = 0
                           BEGIN
                               -- Items
                               UPDATE [dbo].[CardStockItems] 
                               SET [ItemOrKitExpedited] = ISNULL([ItemOrKitExpedited],0) + @mySumRealItemOrKitQuantity,
                                   [ItemOrKitReserved]  = ISNULL([ItemOrKitReserved],0)  - (@mySumRealItemOrKitQuantity + @myDifAmount),
                                   [ItemOrKitFree]      = ISNULL([ItemOrKitFree],0) + @myDifAmount   -- !!!
                               WHERE     [ItemOrKitID] = @myItemOrKitID
                                     AND [ItemVerKit]  = @myItemVerKit
                                     AND [ItemOrKitUnitOfMeasureId] = @myItemOrKitUnitOfMeasureId
                                     AND [ItemOrKitQuality]         = @myRealItemOrKitQualityID
                               SET @myError = @myError + @@Error
                           END
                           ELSE
                           BEGIN
                               -- Kits
                               UPDATE [dbo].[CardStockItems] 
                               SET [ItemOrKitExpedited] = ISNULL([ItemOrKitExpedited],0) + @mySumRealItemOrKitQuantity,
                                   [ItemOrKitReserved]  = ISNULL([ItemOrKitReserved],0)  - (@mySumRealItemOrKitQuantity + @myDifAmount),
                                   [ItemOrKitReleasedForExpedition] = ISNULL([ItemOrKitReleasedForExpedition],0) + @myDifAmount   -- !!!
                               WHERE     [ItemOrKitID] = @myItemOrKitID
                                     AND [ItemVerKit]  = @myItemVerKit
                                     AND [ItemOrKitUnitOfMeasureId] = @myItemOrKitUnitOfMeasureId
                                     AND [ItemOrKitQuality]         = @myRealItemOrKitQualityID
                               SET @myError = @myError + @@Error
                           END
                        END  --@myRecCountOb = 1
                        ELSE
                        BEGIN --@myRecCountOb > 1
                           -- v objednávce je více záznamů na stejné Items
                           -- pocet záznamů v konfirmaci
                           SELECT @myRecCountCo = COUNT(*) FROM [dbo].[CommunicationMessagesShipmentOrdersConfirmationItems]
                           WHERE     [ItemOrKitID] = @myItemOrKitID
                                 AND [ItemVerKit]  = @myItemVerKit
                                 AND [SingleOrMaster]           = @mySingleOrMaster
                                 AND [ItemOrKitUnitOfMeasureId] = @myItemOrKitUnitOfMeasureId
                                 AND [ItemOrKitQualityID]       = @myRealItemOrKitQualityID
                                 AND [CMSOId]                   = @myCMSOId
                                 AND [IsActive] = 1
                           -- suma objednaného množství
                           SELECT @mySumRealItemOrKitQuantityObj = SUM([ItemOrKitQuantity]) 
                           FROM [dbo].[CommunicationMessagesShipmentOrdersSentItems]
                           WHERE     [ItemOrKitID] = @myItemOrKitID
                                 AND [ItemVerKit]  = @myItemVerKit
                                 AND [SingleOrMaster]           = @mySingleOrMaster
                                 AND [ItemOrKitUnitOfMeasureId] = @myItemOrKitUnitOfMeasureId
                                 AND [ItemOrKitQualityID]       = @myRealItemOrKitQualityID
                                 AND [CMSOId] = @myShipmentOrderID
                                 AND [IsActive] = 1
                           GROUP BY   [CMSOId],
                                      [SingleOrMaster],
                                      [ItemVerKit] ,
                                      [ItemOrKitID] ,
                                      [ItemOrKitUnitOfMeasureId],
                                      [ItemOrKitQualityId]
                           -- diference 
                           SELECT @myDifAmount = (@mySumRealItemOrKitQuantityObj - @mySumRealItemOrKitQuantity)
                          -- aktualizace karty
                           IF @myItemVerKit = 0
                           BEGIN
                               -- Items
                               UPDATE [dbo].[CardStockItems] 
                               SET [ItemOrKitExpedited] = ISNULL([ItemOrKitExpedited],0) + @mySumRealItemOrKitQuantity,
                                   [ItemOrKitReserved]  = ISNULL([ItemOrKitReserved],0)  - (@mySumRealItemOrKitQuantity + @myDifAmount),
                                   [ItemOrKitFree]      = ISNULL([ItemOrKitFree],0) + @myDifAmount   -- !!!
                               WHERE     [ItemOrKitID] = @myItemOrKitID
                                     AND [ItemVerKit]  = @myItemVerKit
                                     AND [ItemOrKitUnitOfMeasureId] = @myItemOrKitUnitOfMeasureId
                                     AND [ItemOrKitQuality]         = @myRealItemOrKitQualityID
                                     AND [IsActive] = 1
                               SET @myError = @myError + @@Error
                           END
                           ELSE
                           BEGIN
                               -- Kits
                               UPDATE [dbo].[CardStockItems] 
                               SET [ItemOrKitExpedited] = ISNULL([ItemOrKitExpedited],0) + @mySumRealItemOrKitQuantity,
                                   [ItemOrKitReserved]  = ISNULL([ItemOrKitReserved],0)  - (@mySumRealItemOrKitQuantity + @myDifAmount),
                                   [ItemOrKitReleasedForExpedition] = ISNULL([ItemOrKitReleasedForExpedition],0) + @myDifAmount   -- !!!
                               WHERE     [ItemOrKitID] = @myItemOrKitID
                                     AND [ItemVerKit]  = @myItemVerKit
                                     AND [ItemOrKitUnitOfMeasureId] = @myItemOrKitUnitOfMeasureId
                                     AND [ItemOrKitQuality]         = @myRealItemOrKitQualityID
                                     AND [IsActive] = 1
                               SET @myError = @myError + @@Error
                           END
                           -- 
                           IF @myDifAmount = 0
                           BEGIN
                               UPDATE  [dbo].[CommunicationMessagesShipmentOrdersSentItems]
                               SET [ItemOrKitQuantityReal] = ISNULL([ItemOrKitQuantityReal],0) + [ItemOrKitQuantity]
                               WHERE     [ItemOrKitID] = @myItemOrKitID
                                     AND [ItemVerKit]  = @myItemVerKit
                                     AND [SingleOrMaster]           = @mySingleOrMaster
                                     AND [ItemOrKitUnitOfMeasureId] = @myItemOrKitUnitOfMeasureId
                                     AND [ItemOrKitQualityID]       = @myRealItemOrKitQualityID
                                     AND [CMSOId] = @myShipmentOrderID
                                     AND [IsActive] = 1
                               SET @myError = @myError + @@Error
                           END
                           ELSE
                           BEGIN
                               SELECT @ReturnValue=1, @ReturnMessage='Chyba obsahu konfirmace - v objednaqvce jsou stejné řádky'
                               SET @sub = 'FENIX - Shipment Confirmation CHYBA - v objednaqvce jsou stejné řádky ' + ' Databáze: '+ISNULL(@myDatabaseName,'')
                               SET @msg = 'Program prCMRCconsentS; '  + ' Nutný ruční zásah <b>!!! </b><br /><br />' +
                                   'ItemOrKitID= '+CAST(@myItemOrKitID AS varchar(50))+', ItemVerKit='+CAST(@myItemVerKit AS varchar(50))+
                                   ', SingleOrMaster='+CAST(@mySingleOrMaster AS varchar(50))+', ShipmentOrderID='+CAST(@myShipmentOrderID AS varchar(50))
                                   +'<br />'
                                   +'Množství v objednávce: '+ CAST(@mySumRealItemOrKitQuantityObj AS varchar(50))+'<br />'
                                   +'Množství v konfirmaci: '+ CAST(@mySumRealItemOrKitQuantity AS varchar(50))+'<br />'
                                   +'Počet řádků v objednávce: '+ CAST(@myRecCountOb AS varchar(50))+'<br />'
                                   +'Počet řádků v konfirmaci: '+ CAST(@myRecCountCo AS varchar(50))+'<br />'

                               EXEC @result = msdb.dbo.sp_send_dbmail
                               	@profile_name = 'Automat', --@MailProfileName
                               	@recipients = 'max.weczerek@upc.cz;michal.rezler@upc.cz',
                               	@subject = @sub,
                               	@body = @msg,
                               	@body_format = 'HTML'

                           END
                        END  --@myRecCountOb > 1
                   END

                   FETCH NEXT FROM myCursorThroughShipmentOrdersConfirmationItems INTO
                      @myCMSOId
                     ,@mySingleOrMaster
                     ,@myItemVerKit
                     ,@myItemOrKitID
                     ,@myItemOrKitUnitOfMeasureId
                     ,@myItemOrKitQualityId
                     ,@mySumRealItemOrKitQuantity
                     ,@myRealItemOrKitQualityID
               END

               CLOSE myCursorThroughShipmentOrdersConfirmationItems
               DEALLOCATE myCursorThroughShipmentOrdersConfirmationItems

               -- *******************************************************
               -- konec zpracovani
               -- *******************************************************

               -- *******************************************************
               -- ošetření výdejky (pokud je)
               -- *******************************************************
               IF NOT (@myIdWf IS NULL OR @myIdWf = 0) AND @myError=0
               BEGIN
                  BEGIN TRAN VydejkySprWrhMaterials
                  UPDATE [dbo].[VydejkySprWrhMaterials] 
                         SET [SuppliedQuantities] = ISNULL([SuppliedQuantities],0) + CMSOCI.RealItemOrKitQuantity
                           , [S1Id] = @Id                                                      -- doplneno 2015-04-13
                  FROM [dbo].[VydejkySprWrhMaterials]      V
                  INNER JOIN [dbo].[CommunicationMessagesShipmentOrdersSentItems]                CMSOSI
                     ON V.IdWf = CMSOSI.VydejkyId AND V.Id = CMSOSI.[IdRowReleaseNote]
                  INNER JOIN [dbo].[CommunicationMessagesShipmentOrdersSent]                     CMSOS
                     ON  CMSOSI.CMSOId = CMSOS.ID                                                               -- 2014-11-19                 
                  INNER JOIN [dbo].[CommunicationMessagesShipmentOrdersConfirmation]             CMSOC          -- 2014-11-19
                     ON  CMSOS.ID = CMSOC.ShipmentOrderID                         -- 2014-11-12                 
                  INNER JOIN [dbo].[CommunicationMessagesShipmentOrdersConfirmationItems]        CMSOCI
                     ON CMSOCI.CMSOId                      = CMSOC.ID AND
                        CMSOSI.[ItemVerKit]                = CMSOCI.ItemVerKit AND 
                        CMSOSI.ItemOrKitID                 = CMSOCI.ItemOrKitID AND 
                        CMSOSI.[SingleOrMaster]            = CMSOCI.SingleOrMaster AND
                        CMSOSI.[ItemOrKitQualityId]        = CMSOCI.RealItemOrKitQualityID AND 
                        CMSOSI.[ItemOrKitUnitOfMeasureId]  = CMSOCI.ItemOrKitUnitOfMeasureId                                                                                                   -- CMSOSI.ID = CMSOCI.HeliosOrderRecordID
                  WHERE CMSOCI.[CMSOId] = @Id AND Done <> 1  AND CMSOC.Reconciliation = 1 
                  SET @myError = @myError + @@ERROR
                  IF  @myError <>0 
                  BEGIN
                           if @@TRANCOUNT>0  ROLLBACK TRAN VydejkySprWrhMaterials  -- 2015-11-09
                           SELECT @ReturnValue=1, @ReturnMessage='Chyba'
                           SET @sub = 'FENIX - Shipment Confirmation CHYBA' + ' Databáze: '+ISNULL(@myDatabaseName,'')
                           SET @msg = 'Program prCMRCconsentS; '  + ISNULL(ERROR_MESSAGE(),'') + ISNULL(CAST(ERROR_NUMBER() AS VARCHAR(50)),'') +' Problém s aktualizací tabulky VydejkySprWrhMaterials, S1ID = ' + ISNULL(CAST(@Id  AS VARCHAR(50)),'')
                           EXEC @result = msdb.dbo.sp_send_dbmail
                          		@profile_name = 'Automat', --@MailProfileName
                          		@recipients = 'max.weczerek@upc.cz;michal.rezler@upc.cz',
                          		@subject = @sub,
                          		@body = @msg,
                          		@body_format = 'HTML'
                  END
                  ELSE
                           COMMIT TRAN VydejkySprWrhMaterials  -- 2015-11-09
               END

               -- 4
               -- *******************************************************
               -- určení statusu (nepřesné - pro uživatele dostatečné)
               -- *******************************************************

               DECLARE @myDecision AS Integer
               
               SELECT  @myDecision =  COUNT(*) FROM
               ( 
                 SELECT SUM(ISNULL([ItemOrKitQuantity],0) - ISNULL([ItemOrKitQuantityReal],0)) SUMA, [ItemVerKit],[ItemOrKitID]
                 FROM [dbo].[CommunicationMessagesShipmentOrdersSentItems] 
                 WHERE IsActive=1 AND [CMSOId]=@myShipmentOrderID 
                 GROUP BY [ItemVerKit],[ItemOrKitID]
               ) aa
               WHERE SUMA<>0

               IF @myDecision=0 OR @myDecision IS NULL
               BEGIN
                   UPDATE [dbo].[CommunicationMessagesShipmentOrdersSent] SET [MessageStatusId] = 6
                   WHERE ID = @myShipmentOrderID
                   SET @myError = @myError + @@ERROR
               END
               ELSE
               BEGIN
                   UPDATE [dbo].[CommunicationMessagesShipmentOrdersSent] SET [MessageStatusId] = 8
                   WHERE ID = @myShipmentOrderID
                   SET @myError = @myError + @@ERROR
               END
               IF @myError = 0 
               BEGIN
                  if @@TRANCOUNT>0  COMMIT TRAN 
               END
               ELSE 
               BEGIN
                    if @@TRANCOUNT>0  ROLLBACK TRAN
                    SET @ReturnValue = @myError
                    SET @ReturnMessage = ISNULL(ERROR_MESSAGE(),'') + ISNULL(CAST(ERROR_NUMBER() AS VARCHAR(50)),'')
               END
     END   -- schváleno

END TRY
BEGIN CATCH
      if @@TRANCOUNT>0  ROLLBACK TRAN
      SELECT @ReturnValue=1, @ReturnMessage='Chyba'
      SET @sub = 'FENIX - Shipment Confirmation CHYBA' + ' Databáze: '+ISNULL(@myDatabaseName,'')
      SET @msg = 'Program prCMRCconsentS; '  + ISNULL(ERROR_MESSAGE(),'') + ISNULL(CAST(ERROR_NUMBER() AS VARCHAR(50)),'') 
      EXEC @result = msdb.dbo.sp_send_dbmail
     		@profile_name = 'Automat', --@MailProfileName
     		@recipients = 'max.weczerek@upc.cz;michal.rezler@upc.cz',
     		@subject = @sub,
     		@body = @msg,
     		@body_format = 'HTML'
END CATCH


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[prCMRCconsentS] TO [FenixW]
    AS [dbo];

