




CREATE PROCEDURE [dbo].[prCMAKins] 
      @par1 as XML,
	   @ReturnValue     int            = -1 OUTPUT,
	   @ReturnMessage   nvarchar(2048) = null OUTPUT
 AS
BEGIN
-- ===============================================================================================
-- Created by   : Weczerek Max
-- Created date : 2014-08-18
-- Description  : 
-- ===============================================================================================
/*
Fáze K2 -  chystá Approval

Kontroluje data
Aktualizuje karty

*/
	SET NOCOUNT ON;
   BEGIN TRY
   BEGIN --- DECLARACE
       DECLARE
          @ID [int] ,
          @MessageId  [varchar](50),                  -- [int],
          @MessageTypeId  [varchar](50),              -- [int],
          @MessageTypeDescription   [nvarchar](250),        
          @MessageDateOfReceipt [datetime],
          @KitOrderID  [int],
          @HeliosOrderID  [int],
          @HeliosOrderRecordID   [int],
          @KitID [varchar](50),
          @KitDescription [nvarchar](500),
          @KitQuantity [numeric](18, 3),
          @KitUnitOfMeasureID [int],
          @KitUnitOfMeasure [varchar](50),
          @KitQualityId [int],
          @KitQuality [nvarchar](250),
          @ItemSNs [nvarchar](max),
          @IsActive [bit],
          @ModifyDate [datetime],
          @ModifyUserId [int],
          @Reconciliation  [bit],
          @myIdentity [int],
          @myReconciliation  [bit],
          @myMessageId  [varchar](50), -- [int],
          @myMessageTypeId  [varchar](50), -- [int],
          @myHeliosOrderID [varchar](50),
          @myIdentitySklad  [int],
          @myKitOrderID  [int],
          @myKitQuality  [int]

          SET @ItemSNs=''

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

       SELECT 	   @ReturnValue=0,  @ReturnMessage='OK'

   END --- DECLARACE
   -- ---
   -- =======================================================================
   -- Nacteni xml souboru do tabulky
   -- =======================================================================
      IF OBJECT_ID('tempdb..#TmpCMAK','table') IS NOT NULL DROP TABLE #TmpCMAK
  
      EXEC sp_xml_preparedocument @hndl OUTPUT, @par1
      SELECT x.[KitQuantity], x.[RequiredReleaseDate], x.[CardStockItemsId], x.[SN1], x.[SN2], x.[ModifyUserId]
      INTO #TmpCMAK
      FROM OPENXML (@hndl, '/NewDataSet/CommunicationMessagesKittingApproval',2)
      WITH (
      KitQuantity           int          'KitQuantity',
      RequiredReleaseDate   nvarchar(50) 'RequiredReleaseDate',
      CardStockItemsId      int          'CardStockItemsId',
      SN1                   nvarchar(50) 'SN1',
      SN2                   nvarchar(50) 'SN2',
      ModifyUserId          int          'ModifyUserId'
       ) x
       EXEC sp_xml_removedocument @hndl
 
---- ===========
      SELECT * FROM #TmpCMAK

---- ===========   

   ---- =======================================================================
   ---- Kontrola úplnosti a správnosti dat
   ---- =======================================================================
   --   SELECT @MessageId              = CAST(a.MessageId AS VARCHAR(50)),
   --          @MessageTypeId          = CAST(a.MessageTypeID AS VARCHAR(50)),
   --          @MessageTypeDescription = a.MessageTypeDescription,
   --          @KitOrderID             = a.KitOrderID
   --    FROM (
   --          SELECT TOP 1 MessageId,MessageTypeID,MessageTypeDescription,KitOrderID FROM #TmpCMAK Tmp
   --          ) a

   --   BEGIN -- ============ Kontrola existence zdrojové message ======================
   --        SELECT @myPocet=COUNT(*) FROM [dbo].[CommunicationMessagesKittingsSent] WHERE ID = @KitOrderID
           
   --        IF  @myPocet<>1
   --        BEGIN
   --                   SET @myMessage = 'NEEXISTUJE ID='+CAST(@KitOrderID AS VARCHAR(50)) + ' v tabulce CommunicationMessagesKittingsSent'
   --                   EXEC [dbo].[prAppLogWriteNew] @Type='INFO', @Message =  @myMessage, @XmlMessage = NULL, @UserId = 0,@Source = 'prCMSOKins'
   --                                            , @ReturnValue = @myReturnValue,@ReturnMessage=@myReturnMessage
        
   --                   SET @sub = 'Fenix - Kontrola KITTING CONFIRMATION  - kontrola existence zdrojové message'
   --                   SET @msg = @myMessage
	  --   	 	          EXEC @result = msdb.dbo.sp_send_dbmail
	  --   	 	               @profile_name = 'Automat', --@MailProfileName
	  --   	 	               @recipients = @myAdresaLogistika,
   --                        @copy_recipients = @myAdresaProgramator,
	  --   	 	               @subject = @sub,
	  --   	 	               @body = @msg,
   --      	 	            @body_format = 'HTML'
        
   --                   SET @ReturnValue = 1
   --        END
   --   END
  
   --   BEGIN -- ============ Kontrola existence zboží proti objednávce ================
   --       SET @myReconciliation = 0                        -- vždy je neodsouhlaseno  20140710
   --       SET @msg='' 
   --       SELECT @myPocet = COUNT(*)  FROM #TmpCMAK Tmp    
   --       SELECT @myPocetPolozekPomooc  = COUNT(*) FROM [dbo].[CommunicationMessagesKittingsSentItems] 
   --       WHERE [CMSOId] = @KitOrderID AND ISACTIVE=1

   --       IF @myPocet-@myPocetPolozekPomooc<>0
   --       BEGIN
                
   --              SET @myMessage = 'NESOUHLASÍ počet položek objednávky s potvrzením kompletace. ID objednávky='+ISNULL(CAST(@KitOrderID AS VARCHAR(50)),'') +', POČET = '+CAST(@myPocetPolozekPomooc AS VARCHAR(50)) + ' v tabulce CommunicationMessagesKittingsSentItems'
   --                  + ',  Confirmace:  MessageId = '+CAST(@MessageId AS VARCHAR(50))+', MessageType = '+CAST(@MessageTypeId AS VARCHAR(50))+', MessageDescription = '+CAST(@MessageTypeDescription  AS NVARCHAR(250)) +', POČET = '+CAST(@myPocet AS VARCHAR(50))
   --              EXEC [dbo].[prAppLogWriteNew] @Type='INFO', @Message =  @myMessage, @XmlMessage = NULL, @UserId = 0,@Source = 'prCMSOKins'
   --                                       , @ReturnValue = @myReturnValue,@ReturnMessage=@myReturnMessage
   --              SET @mOK = 0
   --              SET @msg = @myMessage
            
   --              SET @sub = 'Fenix - Kontrola KITTING CONFIRMATION  - kontrola počtu položek proti objednávce'
		 --	        EXEC @result = msdb.dbo.sp_send_dbmail
		 --	             @profile_name = 'Automat', --@MailProfileName
		 --	             @recipients = @myAdresaLogistika,
   --                   @copy_recipients = @myAdresaProgramator,
		 --	             @subject = @sub,
		 --	             @body = @msg,
   -- 	 	             @body_format = 'HTML'

   --        END
   --       ELSE
   --       BEGIN
   --             SELECT @myPocet = COUNT(*)  FROM #TmpCMAK Tmp
   --             SELECT @myPocetPolozekPomooc  = COUNT(*) 
   --             FROM #TmpCMAK           Tmp
   --             INNER JOIN  [dbo].[CommunicationMessagesKittingsSentItems]   I
   --                   ON I.[CMSOId] = @KitOrderID AND Tmp.KitID= I.KitID
   --             WHERE I.ISACTIVE=1

   --             IF @myPocet-@myPocetPolozekPomooc<>0
   --             BEGIN
                      

   --                    SET @myMessage = 'NESOUHLASÍ Items položek objednávky s potvrzením kompletace. ID objednávky='+CAST(@KitOrderID AS VARCHAR(50)) +
   --                        + ',  Confirmace:  MessageId = '+CAST(@MessageId AS VARCHAR(50))+', MessageType = '+CAST(@MessageTypeId AS VARCHAR(50))+', MessageDescription = '+CAST(@MessageTypeDescription  AS NVARCHAR(250)) 
   --                    EXEC [dbo].[prAppLogWriteNew] @Type='INFO', @Message =  @myMessage, @XmlMessage = NULL, @UserId = 0,@Source = 'prCMSOKins'
   --                                             , @ReturnValue = @myReturnValue,@ReturnMessage=@myReturnMessage
   --                    SET @mOK = 0
   --                    SET @msg = @myMessage
                  
   --                    SET @sub = 'Fenix - Kontrola KITTING CONFIRMATION  - kontrola KitID položek proti objednávce'
		 --      	        EXEC @result = msdb.dbo.sp_send_dbmail
		 --      	             @profile_name = 'Automat', --@MailProfileName
		 --      	             @recipients = @myAdresaLogistika,
   --                         @copy_recipients = @myAdresaProgramator,
		 --      	             @subject = @sub,
		 --      	             @body = @msg,
   -- 	       	             @body_format = 'HTML'
             
   --                    -- SET @ReturnValue = 1
   --                    -- return @ReturnValue
   --             END
   --       END
   --   END

   --   BEGIN -- ============ Kontrola existence měrných jednotek proti číselníku ======
   --       SELECT @myMessage = LEFT(r.ResourceName , LEN(r.ResourceName)-1)
   --             FROM ( SELECT Item + ', '   FROM  
   --                         (
   --                           SELECT KitUnitOfMeasure+', '  AS ITEM FROM #TmpCMAK 
   --                                  WHERE KitUnitOfMeasure NOT IN (SELECT [Code] FROM [dbo].[cdlMeasures])
   --                         ) A   FOR XML PATH('')
   --                  ) r (ResourceName) 
         
   --      IF NOT (@myMessage IS NULL OR @myMessage='')
   --      BEGIN
   --              SET @mOK = 0
   --              SET @msg = 'Schází měrné jednotky v číselníku : ' + @myMessage
            
   --              SET @sub = 'Fenix - Kontrola KITTING CONFIRMATION  - kontrola měrných jednotek'
		 --	        EXEC @result = msdb.dbo.sp_send_dbmail
		 --	             @profile_name = 'Automat', --@MailProfileName
		 --	             @recipients = @myAdresaLogistika,
   --                   @copy_recipients = @myAdresaProgramator,
		 --	             @subject = @sub,
		 --	             @body = @msg,
   -- 	 	             @body_format = 'HTML'

   --              SET @ReturnValue = 1
   --              -- return @ReturnValue

   --      END
   --   END

   --   BEGIN -- ============================ Zpracování ===============================
        
   --     SELECT TOP 1  @MessageId = [MessageId], @MessageTypeId = [MessageTypeId], @MessageTypeDescription =MessageTypeDescription   FROM  #TmpCMAK

   --     SELECT  @myPocet = COUNT(*) FROM [dbo].[CommunicationMessagesKittingsConfirmation] WHERE [MessageId]=@MessageId AND
   --                                      [MessageTypeId] = @MessageTypeId AND  MessageDescription = @MessageTypeDescription
 
   --     IF @mOK=1 AND  (@myPocet = 0 OR  @myPocet IS NULL)
   --     BEGIN
   --         IF (SELECT CURSOR_STATUS('global','myCursor')) >= -1
   --          BEGIN
   --                   DEALLOCATE myCursor
   --          END
 
   --          SET @myError=0 
   --          SET @myIdentity = 0
             
   --          DECLARE myCursor CURSOR 
   --          FOR  
   --          SELECT x.[ID], x.[MessageID], x.[MessageTypeID], x.[MessageTypeDescription], x.[MessageDateOfReceipt], x.[KitOrderID]
   --                    , x.[HeliosOrderID], x.[HeliosOrderRecordID], x.[KitID],x.[KitDescription]
   --                    , x.[KitQuantity], x.[KitUnitOfMeasureID], x.[KitUnitOfMeasure],  x.[KitQualityID], x.[KitQuality]
   --                FROM #TmpCMAK x ORDER BY MessageId, MessageTypeID, KitOrderID

   --          OPEN myCursor
   --          FETCH NEXT FROM myCursor INTO  @ID, @MessageID, @MessageTypeID, @MessageTypeDescription, @MessageDateOfReceipt, @KitOrderID
   --                    , @HeliosOrderID,  @HeliosOrderRecordID, @KitID,@KitDescription
   --                    , @KitQuantity, @KitUnitOfMeasureID, @KitUnitOfMeasure,  @KitQualityID, @KitQuality

   --          SELECT @myMessageId = '-1',  @myMessageTypeId  = '-1',  @myKitOrderID  = '-1', @myKitQuality = -1
   --          BEGIN TRAN
   --          WHILE @@FETCH_STATUS = 0
   --          BEGIN

   --                 IF @myMessageId <> @MessageId OR  @myMessageTypeId  <>  @MessageTypeId OR  @myKitOrderID  <> @KitOrderID
   --                 BEGIN
   --                    SELECT @myMessageId = @MessageId,  @myMessageTypeId = @MessageTypeId, @myKitOrderID = @KitOrderID
   --                    INSERT INTO [dbo].[CommunicationMessagesKittingsConfirmation]
   --                               ([MessageId]
   --                               ,[MessageTypeId]
   --                               ,[MessageDescription]
   --                               ,[MessageDateOfReceipt]
   --                               ,[KitOrderID]
   --                               ,[Reconciliation]
   --                         )
   --                    VALUES
   --                               (@MessageId
   --                               ,@MessageTypeId
   --                               ,@MessageTypeDescription
   --                               ,@MessageDateOfReceipt
   --                               ,@myKitOrderID
   --                               ,0
   --                         )
   --                     SET @myError = @myError + @@ERROR
   --                     SET @myIdentity = @myIdentity+@@IDENTITY  
   --                 END

   --                 IF @myError=0 AND @myIdentity>0
   --                 BEGIN

   --                         SELECT @ItemSNs = SN FROM (
   --                         SELECT DISTINCT LEFT(r.ResourceName , LEN(r.ResourceName)-1) [SN], A.[ID],A.[KitID], A.[KitQualityID]
   --                         FROM #TmpCMRCKsn A
   --                          CROSS APPLY (SELECT CAST([SN1] AS VARCHAR(50))+ ', ' + CAST([SN2] AS VARCHAR(50))+ '; '   FROM #TmpCMRCKsn  B
   --                              WHERE A.[ID] =  B.[ID] AND A.[KitID] = B.[KitID] --AND  A.[KitOrderID] = B.[KitOrderID] 
   --                                AND  A.[KitQualityID] = B.[KitQualityID]
   --                              FOR XML PATH('')
   --                              ) r (ResourceName) 
   --                              ) AA 
   --                              WHERE  AA.[ID] =  @ID AND AA.[KitID] = @KitID 
   --                                AND AA.[KitQualityID] = @KitQualityID

   --                     INSERT INTO [dbo].[CommunicationMessagesKittingsConfirmationItems]
   --                                ([CMSOId]
   --                                ,[KitID]
   --                                ,[KitDescription]
   --                                ,[KitQuantity]
   --                                ,[KitUnitOfMeasure]
   --                                ,[KitQualityId]
   --                                ,[KitSNs]                       )
   --                          VALUES
   --                                (@myIdentity
   --                                ,@KitID
   --                                ,@KitDescription
   --                                ,@KitQuantity
   --                                ,@KitUnitOfMeasure
   --                                ,@KitQualityId
   --                                ,@ItemSNs 
   --                      )
   --                     SET @myError = @myError + @@ERROR

   --                     IF @myError=0
   --                     BEGIN
   --                           --  ********* ID merne jednotky ***********************
   --                           SELECT @KitUnitOfMeasureID = ID FROM [dbo].[cdlMeasures] 
   --                           WHERE ([DescriptionCz] = RTRIM(@KitUnitOfMeasure) OR [DescriptionEng] =  RTRIM(@KitUnitOfMeasure) OR CODE=@KitUnitOfMeasure) AND IsActive=1
   --                           --  ********* zjisteni existence karty ****************
   --                           SELECT @myPocet = COUNT(*) 
   --                           FROM [dbo].[CardStockItems] 
   --                           WHERE [ItemVerKit]=1 AND [IsActive] = 1 AND [ItemOrKitID] = @KitID AND [ItemOrKitUnitOfMeasureID] = @KitUnitOfMeasureID AND ItemOrKitQuality = @KitQualityId
   --                                 AND [StockId] = 2   -- pouze ND potvrzuje objednávky

   --                           IF @myPocet IS NULL OR @myPocet=0
   --                           BEGIN
   --                              --  ********* karta není ****************
   --                              INSERT INTO [dbo].[CardStockItems]
   --                                    ([ItemVerKit]
   --                                    ,[ItemOrKitID]
   --                                    ,[ItemOrKitUnitOfMeasureID]
   --                                    ,[ItemOrKitUnConsilliation]
   --                                    ,[ItemOrKitQuality]
   --                                    ,[ItemOrKitReserved]
   --                                    ,[StockId]
   --                              )
   --                              VALUES
   --                                    (1                           -- <ItemVerKit, bit,>
   --                                    ,@KitID                      -- <ItemOrKitID, int,>
   --                                    ,@KitUnitOfMeasureID         -- <ItemOrKitUnitOfMeasure, int,>
   --                                    ,@KitQuantity                -- <ItemOrKitQuantity, numeric(18,3),>
   --                                    ,@KitQualityId
   --                                    ,0                            -- <ItemOrKitReserved, numeric(18,3),>
   --                                    ,2                            -- pouze ND
   --                              )
   --                              SET @myError = @myError + @@ERROR
   --                              SET @myIdentitySklad = @@IDENTITY
   --                           END
   --                           ELSE
   --                           BEGIN
   --                              --  ********* karta je ****************
   --                              SELECT @myIdentitySklad = ID 
   --                              FROM [dbo].[CardStockItems] 
   --                              WHERE [ItemVerKit] = 1 AND [IsActive] = 1 AND [ItemOrKitID] = @KitID AND [ItemOrKitUnitOfMeasureId] = @KitUnitOfMeasureID 
   --                                AND [StockId] = 2 AND ItemOrKitQuality = @KitQualityId
                       
   --                              UPDATE [dbo].[CardStockItems] SET [ItemOrKitUnConsilliation] = ISNULL([ItemOrKitUnConsilliation],0) + @KitQuantity
   --                              WHERE [ID] = @myIdentitySklad
   --                              SET @myError = @myError + @@ERROR
   --                           END
                                
   --                           UPDATE [dbo].[CommunicationMessagesKittingsSentItems] 
   --                           SET [KitQuantityDelivered] = ISNULL([KitQuantityDelivered],0) + @KitQuantity
   --                           WHERE [CMSOId] = @KitOrderID  AND [KitID] = @KitID AND [IsActive] = 1 
   --                           SET @myError = @myError + @@ERROR 

   --                           UPDATE [dbo].[CommunicationMessagesKittingsSent] 
   --                           SET MessageStatusID=5
   --                           WHERE [Id] = @KitOrderID AND [IsActive] = 1   
   --                           SET @myError = @myError + @@ERROR          
   --                     END
   --                 END

   --                 FETCH NEXT FROM myCursor INTO @ID, @MessageID, @MessageTypeID, @MessageTypeDescription, @MessageDateOfReceipt, @KitOrderID
   --                          , @HeliosOrderID,  @HeliosOrderRecordID, @KitID,@KitDescription
   --                          , @KitQuantity, @KitUnitOfMeasureID, @KitUnitOfMeasure,  @KitQualityID, @KitQuality

   --          END
 
   --          CLOSE myCursor;
   --          DEALLOCATE myCursor;
   --          IF @myError = 0 AND @@TRANCOUNT > 0 COMMIT TRAN  
   --          ELSE
   --          BEGIN IF @@TRANCOUNT > 0 ROLLBACK TRAN END 
   --     END 
   --     ELSE 
   --     BEGIN 
    
   --       IF @myPocet>0
   --       BEGIN 
   --             SELECT @ReturnValue=1, @ReturnMessage='CInfo'
   --             SET @sub = 'Fenix - Reception Confirmation '
   --             SET @msg = 'Program prCMRCKins; Záznam MessageId=' + ISNULL(CAST(@MessageId AS VARCHAR(50)),'') + ', MessageTypeId = '+ ISNULL(CAST(@MessageTypeId AS VARCHAR(50)),'') + ' byl již jednou naveden !'
   --             EXEC @result = msdb.dbo.sp_send_dbmail
   --            		@profile_name = 'Automat', --@MailProfileName
   --            		@recipients = 'jaroslav.tajbl@upc.cz',
   --            		@subject = @sub,
   --            		@body = @msg,
   --            		@body_format = 'HTML'

   --       END
   --     END
   --   END

END TRY
BEGIN CATCH
      IF @@TRANCOUNT > 0 ROLLBACK TRAN
      SELECT @ReturnValue=1, @ReturnMessage='Chyba'
      SET @sub = 'Fenix - Kitting Approval CHYBA'
      SET @msg = 'Program prCMAKins; '  + ISNULL(ERROR_MESSAGE(),'') + ISNULL(CAST(ERROR_NUMBER() AS VARCHAR(50)),'') 
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
    ON OBJECT::[dbo].[prCMAKins] TO [FenixW]
    AS [dbo];

