

CREATE PROCEDURE [dbo].[prCMRCKins] 
      @par1 as XML,
	   @ReturnValue     int            = -1 OUTPUT,
	   @ReturnMessage   nvarchar(2048) = null OUTPUT
 AS
BEGIN
-- =========================================================================================================
-- Created by   : Weczerek Max
-- Created date : 2014-08-12
--                2014-09-30, 2014-11-14
-- Description  :
-- Edited       : 2015-08-11 M.Rezler kontrola počtu SN 
-- Edited       : 2015-08-13 M.Rezler přidán sloupec Multiplayer () 
-- Edited       : 2015-08-17 Weczerek, Rezler  ser. numbers - osetreni pripadu, kdy neni zadano ani jedno SN
-- =========================================================================================================
/*
Fáze K1 -  z ND přijde MESSAGE, viz níže

Kontroluje data
Aktualizuje karty

*/
	SET NOCOUNT ON;
   DECLARE @myDatabaseName  nvarchar(100)
   DECLARE @msg    varchar(max)
   DECLARE @MailTo varchar(150)
   DECLARE @MailBB varchar(150)
   DECLARE @sub    varchar(1000) 
   DECLARE @Result int
   SET @msg = ''



   BEGIN TRY
    SELECT @myDatabaseName = DB_NAME() 

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
          @myKitQuality  [int],
          @myAnnouncement [nvarchar](max),
					@Multiplayer int

          SET @ItemSNs=''
          SET @myAnnouncement = ''

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
       SELECT 	   @ReturnValue=0,  @ReturnMessage='OK'

   END --- DECLARACE
   -- ---
   -- =======================================================================
   -- Nacteni xml souboru do tabulky
   -- =======================================================================
      IF OBJECT_ID('tempdb..#TmpCMRCKhd','table') IS NOT NULL DROP TABLE #TmpCMRCKhd
      IF OBJECT_ID('tempdb..#TmpCMRCKsn','table') IS NOT NULL DROP TABLE #TmpCMRCKsn

      EXEC sp_xml_preparedocument @hndl OUTPUT, @par1
      SELECT x.[ID], x.[MessageID], x.[MessageTypeID], x.[MessageTypeDescription], x.[MessageDateOfReceipt], x.[KitOrderID]
           , x.[HeliosOrderID], x.[KitID],x.[KitDescription]
           , x.[KitQuantity], x.[KitUnitOfMeasureID], x.[KitUnitOfMeasure],  x.[KitQualityID], x.[KitQuality]
      INTO #TmpCMRCKhd
      FROM OPENXML (@hndl, '/NewDataSet/CommunicationMessagesKittingConfirmation',2)
      WITH (
      ID                        int           'ID',
      MessageID                 nvarchar(50)  'MessageID',
      MessageTypeID             nvarchar(50)  'MessageTypeID',
      MessageTypeDescription    nvarchar(150) 'MessageTypeDescription',
      MessageDateOfReceipt      nvarchar(150) 'MessageDateOfReceipt',
      KitOrderID                nvarchar(50)  'KitOrderID',
      HeliosOrderID             nvarchar(50)  'HeliosOrderID',
      KitID                    int            'KitID',
      KitDescription           nvarchar(50)   'KitDescription',
      KitQuantity              numeric  (18, 3)        'KitQuantity',
      KitUnitOfMeasureID       int          'KitUnitOfMeasureID',
      KitUnitOfMeasure         nvarchar(50) 'KitUnitOfMeasure',
      KitQualityID             int          'KitQualityID',
      KitQuality               nvarchar(50) 'KitQuality'
      ) x
      ----
      SELECT y.[ID], y.[KitID], y.[HeliosOrderID], y.[KitQualityID], y.[SN1],y.[SN2]
      INTO #TmpCMRCKsn
      FROM OPENXML (@hndl, '/NewDataSet/CommunicationMessagesKittingConfirmation/ItemSNs/ItemSN',2)
      WITH (
      ID                        int          '../../ID',
      KitID                    int          '../../KitID',
      HeliosOrderID             nvarchar(50) '../../HeliosOrderID',
      KitQualityID             int          '../../KitQualityID',
      SN1  nvarchar(50) '@SN1',
      SN2  nvarchar(50) '@SN2'
      ) y

      EXEC sp_xml_removedocument @hndl

 
  
---- ===========
      --SELECT * FROM #TmpCMRCKhd
      --SELECT TOP 1 * FROM #TmpCMRCKsn
---- ===========   

   -- =======================================================================
   -- Kontrola úplnosti a správnosti dat
   -- =======================================================================
      SELECT @MessageId              = CAST(a.MessageId AS VARCHAR(50)),
             @MessageTypeId          = CAST(a.MessageTypeID AS VARCHAR(50)),
             @MessageTypeDescription = a.MessageTypeDescription,
             @KitOrderID             = a.KitOrderID
       FROM (
             SELECT TOP 1 MessageId,MessageTypeID,MessageTypeDescription,KitOrderID FROM #TmpCMRCKhd Tmp
             ) a

      BEGIN -- ============ Kontrola existence zdrojové message ======================
           SELECT @myPocet=COUNT(*) FROM [dbo].[CommunicationMessagesKittingsSent] WHERE ID = @KitOrderID
           
           IF  @myPocet<>1
           BEGIN
                      SET @myMessage = 'NEEXISTUJE ID='+CAST(@KitOrderID AS VARCHAR(50)) + ' v tabulce CommunicationMessagesKittingsSent<br />NEPOKRAČUJI ve zpracování'
                      EXEC [dbo].[prAppLogWriteNew] @Type='INFO', @Message =  @myMessage, @XmlMessage = NULL, @UserId = 0,@Source = 'prCMSOKins'
                                               , @ReturnValue = @myReturnValue,@ReturnMessage=@myReturnMessage
        
                      SET @sub = 'FENIX - Kontrola KITTING CONFIRMATION  - kontrola existence zdrojové message' + ' Databáze: '+ISNULL(@myDatabaseName,'')
                      SET @msg = @myMessage
	     	 	          EXEC @result = msdb.dbo.sp_send_dbmail
	     	 	               @profile_name = 'Automat', --@MailProfileName
	     	 	               @recipients = @myAdresaLogistika,
                           @copy_recipients = @myAdresaProgramator,
	     	 	               @subject = @sub,
	     	 	               @body = @msg,
         	 	            @body_format = 'HTML'
        
                      SET @ReturnValue = 1
                      SET @mOK=0
           END
      END
  
      BEGIN -- ============ Kontrola existence zboží proti objednávce ================
          SET @myReconciliation = 0                        -- vždy je neodsouhlaseno  20140710
          SET @msg='' 
          SELECT @myPocet = COUNT(*)  FROM #TmpCMRCKhd Tmp    
          SELECT @myPocetPolozekPomooc  = COUNT(*) FROM [dbo].[CommunicationMessagesKittingsSentItems] 
          WHERE [CMSOId] = @KitOrderID AND ISACTIVE=1

          IF @myPocet-@myPocetPolozekPomooc<>0
          BEGIN
                
                 SET @myMessage = 'NESOUHLASÍ počet položek objednávky s potvrzením kompletace. ID objednávky='+ISNULL(CAST(@KitOrderID AS VARCHAR(50)),'') +', POČET = '+CAST(@myPocetPolozekPomooc AS VARCHAR(50)) + ' v tabulce CommunicationMessagesKittingsSentItems'
                     + ',  Confirmace:  MessageId = '+CAST(@MessageId AS VARCHAR(50))+', MessageType = '+CAST(@MessageTypeId AS VARCHAR(50))+', MessageDescription = '+CAST(@MessageTypeDescription  AS NVARCHAR(250)) +', POČET = '+CAST(@myPocet AS VARCHAR(50))
                 EXEC [dbo].[prAppLogWriteNew] @Type='INFO', @Message =  @myMessage, @XmlMessage = NULL, @UserId = 0,@Source = 'prCMSOKins'
                                          , @ReturnValue = @myReturnValue,@ReturnMessage=@myReturnMessage
                 SET @mOK = 0
                 SET @msg = @myMessage
            
                 SET @sub = 'FENIX - Kontrola KITTING CONFIRMATION  - kontrola počtu položek proti objednávce' + ' Databáze: '+ISNULL(@myDatabaseName,'')
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
                SELECT @myPocet = COUNT(*)  FROM #TmpCMRCKhd Tmp
                SELECT @myPocetPolozekPomooc  = COUNT(*) 
                FROM #TmpCMRCKhd           Tmp
                INNER JOIN  [dbo].[CommunicationMessagesKittingsSentItems]   I
                      ON I.[CMSOId] = @KitOrderID AND Tmp.KitID= I.KitID
                WHERE I.ISACTIVE=1

                IF @myPocet-@myPocetPolozekPomooc<>0
                BEGIN
                      

                       SET @myMessage = 'NESOUHLASÍ Items položek objednávky s potvrzením kompletace. ID objednávky='+CAST(@KitOrderID AS VARCHAR(50)) +
                           + ',  Confirmace:  MessageId = '+CAST(@MessageId AS VARCHAR(50))+', MessageType = '+CAST(@MessageTypeId AS VARCHAR(50))+', MessageDescription = '+CAST(@MessageTypeDescription  AS NVARCHAR(250)) 
                       EXEC [dbo].[prAppLogWriteNew] @Type='INFO', @Message =  @myMessage, @XmlMessage = NULL, @UserId = 0,@Source = 'prCMSOKins'
                                                , @ReturnValue = @myReturnValue,@ReturnMessage=@myReturnMessage
                       SET @mOK = 0
                       SET @msg = @myMessage
                  
                       SET @sub = 'FENIX - Kontrola KITTING CONFIRMATION  - kontrola KitID položek proti objednávce' + ' Databáze: '+ISNULL(@myDatabaseName,'')
		       	        EXEC @result = msdb.dbo.sp_send_dbmail
		       	             @profile_name = 'Automat', --@MailProfileName
		       	             @recipients = @myAdresaLogistika,
                            @copy_recipients = @myAdresaProgramator,
		       	             @subject = @sub,
		       	             @body = @msg,
    	       	             @body_format = 'HTML'
             
                       -- SET @ReturnValue = 1
                       -- return @ReturnValue
                END
          END
      END

      BEGIN -- ============ Kontrola existence měrných jednotek proti číselníku ======
          SELECT @myMessage = LEFT(r.ResourceName , LEN(r.ResourceName)-1)
                FROM ( SELECT Item + ', '   FROM  
                            (
                              SELECT KitUnitOfMeasure+', '  AS ITEM FROM #TmpCMRCKhd 
                                     WHERE KitUnitOfMeasure NOT IN (SELECT [Code] FROM [dbo].[cdlMeasures])
                            ) A   FOR XML PATH('')
                     ) r (ResourceName) 
         
         IF NOT (@myMessage IS NULL OR @myMessage='')
         BEGIN
                 SET @mOK = 0
                 SET @msg = 'Schází měrné jednotky v číselníku : ' + @myMessage+', Confirmace:  MessageId = '+ISNULL(CAST(@MessageId AS VARCHAR(50)),'') +
                 '<br />NEPOKRAČUJI ve zpracování!'
            
                 SET @sub = 'FENIX - Kontrola KITTING CONFIRMATION  - kontrola měrných jednotek' + ' Databáze: '+ISNULL(@myDatabaseName,'')
		 	        EXEC @result = msdb.dbo.sp_send_dbmail
		 	             @profile_name = 'Automat', --@MailProfileName
		 	             @recipients = @myAdresaLogistika,
                      @copy_recipients = @myAdresaProgramator,
		 	             @subject = @sub,
		 	             @body = @msg,
    	 	             @body_format = 'HTML'

                 SET @ReturnValue = 1
                 -- return @ReturnValue
                 EXEC [dbo].[prAppLogWriteNew] @Type='INFO', @Message =  @msg, @XmlMessage = NULL, @UserId = 0,@Source = 'prCMSOKins'
                                          , @ReturnValue = @myReturnValue,@ReturnMessage=@myReturnMessage

                 SET @mOK=0
         END
      END
						
      BEGIN  -- =========== Kontrola počtu SN ve vztahu ke kitu, ktery je CPE =============  2015-08-13
					DECLARE @myCount INT
					
          SELECT @myCount = POCET  FROM (
          SELECT COUNT(*) AS POCET FROM
          (
               SELECT aa.KitID, aa.KitQualityID, aa.SumKitQuantity * K.Multiplayer SumKitQuantity FROM
               (
                      SELECT KitID, KitQualityID, SUM(KitQuantity) SumKitQuantity 
                      FROM #TmpCMRCKhd
                      GROUP BY KitID, KitQualityID
               ) aa
							 INNER JOIN cdlKitsItems cKI
									ON aa.KitID = cKI.cdlKitsId
               INNER JOIN cdlItems   cI
                    ON cI.ID = cKI.ItemOrKitId
               INNER JOIN [dbo].cdlKits K
										ON aa.KitID = K.ID   
               WHERE cI.ItemType = 'CPE' 
          ) bb
          LEFT OUTER JOIN  (SELECT COUNT(*) SUMA, KitID, KitQualityID               -- 2015-08-17 nahrada INNER JOIN
														FROM  #TmpCMRCKsn 
														GROUP BY KitID, KitQualityID) TmpSN
             ON     bb.KitID         = TmpSN.KitID                  
                AND bb.KitQualityID  = TmpSN.KitQualityID
          WHERE ISNULL(SumKitQuantity, 0) - ISNULL(SUMA, 0) <> 0                    -- 2015-08-17 pridano ISNULL
					) xx

          --IF @@ROWCOUNT>0 
					IF ISNULL(@myCount,0) > 0   -- 2015-08-17
          BEGIN 
                 DECLARE @SeznamItems AS nvarchar(max)
                 SET @SeznamItems = 'MessageId = ' + CAST(@MessageId AS  nvarchar(50)) +'<br />'
								 
                 SELECT @SeznamItems= @SeznamItems +'Kit = '+CAST(bb.KitID AS nvarchar(50)) + ' , kvalita = '+ CAST(bb.KitQualityID AS nvarchar(50)) +'<br />' 
								 FROM
                 (
										 SELECT aa.KitID, aa.KitQualityID, aa.SumKitQuantity * K.Multiplayer SumKitQuantity FROM
										 (
														SELECT KitID, KitQualityID, SUM(KitQuantity) SumKitQuantity 
														FROM #TmpCMRCKhd
														GROUP BY KitID, KitQualityID
										 ) aa
										 INNER JOIN cdlKitsItems cKI
												ON aa.KitID = cKI.cdlKitsId
										 INNER JOIN [dbo].cdlKits K
										    ON aa.KitID = K.ID
										 INNER JOIN cdlItems   cI
													ON cI.ID = cKI.ItemOrKitId
										 WHERE cI.ItemType = 'CPE' 
							  ) bb
							  LEFT OUTER JOIN  (SELECT COUNT(*) SUMA, KitID, KitQualityID        -- 2015-08-17 nahrada INNER JOIN 
																	FROM  #TmpCMRCKsn 
																	GROUP BY KitID, KitQualityID) TmpSN
								 ON     bb.KitID         = TmpSN.KitID                  
										AND bb.KitQualityID  = TmpSN.KitQualityID
							  WHERE ISNULL(SumKitQuantity, 0) - ISNULL(SUMA, 0) <> 0            -- 2015-08-17 pridano ISNULL
								
                SET @myAdresaLogistika = @myAdresaLogistika + ';jaroslav.tajbl@upc.cz;michal.rezler@upc.cz'
                SET @sub = 'FENIX - K1 INFO' + ' Databáze: ' + ISNULL(@myDatabaseName,'')
                SET @msg = 'Program [dbo].[prCMRCKins](Kitting Confirmation)<br /> Nesouhlasí počty SN s reálným množstvím <br />' +@SeznamItems   
                EXEC @result = msdb.dbo.sp_send_dbmail
                	@profile_name = 'Automat', --@MailProfileName
                	@recipients = @myAdresaLogistika,
                	@subject = @sub,
                	@body = @msg,
                	@body_format = 'HTML'
          END
      END 			-- =========== Kontrola počtu SN ve vztahu ke kitu, ktery je CPE =============  2015-08-13

      BEGIN -- ============================ Zpracování ===============================
        
        SELECT TOP 1  @MessageId = [MessageId], @MessageTypeId = [MessageTypeId], @MessageTypeDescription =MessageTypeDescription   FROM  #TmpCMRCKhd

        SELECT  @myPocet = COUNT(*) FROM [dbo].[CommunicationMessagesKittingsConfirmation] WHERE [MessageId]=@MessageId AND
                                         [MessageTypeId] = @MessageTypeId AND  MessageDescription = @MessageTypeDescription
 
        IF @mOK=1 AND  (@myPocet = 0 OR  @myPocet IS NULL)
        BEGIN
            IF (SELECT CURSOR_STATUS('global','myCursor')) >= -1
             BEGIN
                      DEALLOCATE myCursor
             END
 
             SET @myError=0 
             SET @myIdentity = 0
             
             DECLARE myCursor CURSOR 
             FOR  
             SELECT x.[ID], x.[MessageID], x.[MessageTypeID], x.[MessageTypeDescription], x.[MessageDateOfReceipt], x.[KitOrderID]
                       , x.[HeliosOrderID],  x.[KitID],x.[KitDescription]
                       , x.[KitQuantity], x.[KitUnitOfMeasureID], x.[KitUnitOfMeasure],  x.[KitQualityID], x.[KitQuality]
                   FROM #TmpCMRCKhd x ORDER BY MessageId, MessageTypeID, KitOrderID

             OPEN myCursor
             FETCH NEXT FROM myCursor INTO  @ID, @MessageID, @MessageTypeID, @MessageTypeDescription, @MessageDateOfReceipt, @KitOrderID
                       , @HeliosOrderID,  @KitID,@KitDescription
                       , @KitQuantity, @KitUnitOfMeasureID, @KitUnitOfMeasure,  @KitQualityID, @KitQuality

             SELECT @myMessageId = '-1',  @myMessageTypeId  = '-1',  @myKitOrderID  = '-1', @myKitQuality = -1
             BEGIN TRAN
             WHILE @@FETCH_STATUS = 0
             BEGIN

                    IF @myMessageId <> @MessageId OR  @myMessageTypeId  <>  @MessageTypeId OR  @myKitOrderID  <> @KitOrderID
                    BEGIN
                       SELECT @myMessageId = @MessageId,  @myMessageTypeId = @MessageTypeId, @myKitOrderID = @KitOrderID
                       INSERT INTO [dbo].[CommunicationMessagesKittingsConfirmation]
                                  ([MessageId]
                                  ,[MessageTypeId]
                                  ,[MessageDescription]
                                  ,[MessageDateOfReceipt]
                                  ,[KitOrderID]
                                  ,[Reconciliation]
                            )
                       VALUES
                                  (@MessageId
                                  ,@MessageTypeId
                                  ,@MessageTypeDescription
                                  ,@MessageDateOfReceipt
                                  ,@myKitOrderID
                                  ,0
                            )
                        SET @myError = @myError + @@ERROR
                        SET @myIdentity = @myIdentity+@@IDENTITY  
                        SET @myAnnouncement = @myAnnouncement + CAST(@myIdentity AS VARCHAR(50))+','
                    END

                    IF @myError=0 AND @myIdentity>0
                    BEGIN

                            SELECT @ItemSNs = SN FROM (
                            SELECT DISTINCT LEFT(r.ResourceName , LEN(r.ResourceName)-1) [SN], A.[ID],A.[KitID], A.[KitQualityID]
                            FROM #TmpCMRCKsn A
                             CROSS APPLY (SELECT CAST([SN1] AS VARCHAR(50))+ ', ' + CAST([SN2] AS VARCHAR(50))+ '; '   FROM #TmpCMRCKsn  B
                                 WHERE A.[ID] =  B.[ID] AND A.[KitID] = B.[KitID] --AND  A.[KitOrderID] = B.[KitOrderID] 
                                   AND  A.[KitQualityID] = B.[KitQualityID]
                                 FOR XML PATH('')
                                 ) r (ResourceName) 
                                 ) AA 
                                 WHERE  AA.[ID] =  @ID AND AA.[KitID] = @KitID 
                                   AND AA.[KitQualityID] = @KitQualityID

                        INSERT INTO [dbo].[CommunicationMessagesKittingsConfirmationItems]
                                   ([CMSOId]
                                   ,[KitID]
                                   ,[KitDescription]
                                   ,[KitQuantity]
                                   ,[KitUnitOfMeasure]
                                   ,[KitQualityId]
                                   ,[KitSNs]                       )
                             VALUES
                                   (@myIdentity
                                   ,@KitID
                                   ,@KitDescription
                                   ,@KitQuantity
                                   ,@KitUnitOfMeasure
                                   ,@KitQualityId
                                   ,@ItemSNs 
                         )
                        SET @myError = @myError + @@ERROR

                        IF @myError=0
                        BEGIN
                              --  ********* ID merne jednotky ***********************
                              SELECT @KitUnitOfMeasureID = ID FROM [dbo].[cdlMeasures] 
                              WHERE ([DescriptionCz] = RTRIM(@KitUnitOfMeasure) OR [DescriptionEng] =  RTRIM(@KitUnitOfMeasure) OR CODE=@KitUnitOfMeasure) AND IsActive=1
                              --  ********* zjisteni existence karty ****************
                              SELECT @myPocet = COUNT(*) 
                              FROM [dbo].[CardStockItems] 
                              WHERE [ItemVerKit]=1 AND [IsActive] = 1 AND [ItemOrKitID] = @KitID AND [ItemOrKitUnitOfMeasureID] = @KitUnitOfMeasureID AND ItemOrKitQuality = @KitQualityId
                                    AND [StockId] = 2   -- pouze ND potvrzuje objednávky

                              IF @myPocet IS NULL OR @myPocet=0
                              BEGIN
                                 --  ********* karta není ****************
                                 INSERT INTO [dbo].[CardStockItems]
                                       ([ItemVerKit]
                                       ,[ItemOrKitID]
                                       ,[ItemOrKitUnitOfMeasureID]
                                       ,[ItemOrKitUnConsilliation]
                                       ,[ItemOrKitQuality]
                                       ,[ItemOrKitReserved]
                                       ,[StockId]
                                 )
                                 VALUES
                                       (1                           -- <ItemVerKit, bit,>
                                       ,@KitID                      -- <ItemOrKitID, int,>
                                       ,@KitUnitOfMeasureID         -- <ItemOrKitUnitOfMeasure, int,>
                                       ,@KitQuantity                -- <ItemOrKitQuantity, numeric(18,3),>
                                       ,@KitQualityId
                                       ,0                            -- <ItemOrKitReserved, numeric(18,3),>
                                       ,2                            -- pouze ND
                                 )
                                 SET @myError = @myError + @@ERROR
                                 SET @myIdentitySklad = @@IDENTITY
                              END
                              ELSE
                              BEGIN
                                 --  ********* karta je ****************
                                 SELECT @myIdentitySklad = ID 
                                 FROM [dbo].[CardStockItems] 
                                 WHERE [ItemVerKit] = 1 AND [IsActive] = 1 AND [ItemOrKitID] = @KitID AND [ItemOrKitUnitOfMeasureId] = @KitUnitOfMeasureID 
                                   AND [StockId] = 2 AND ItemOrKitQuality = @KitQualityId
                       
                                 UPDATE [dbo].[CardStockItems] SET [ItemOrKitUnConsilliation] = ISNULL([ItemOrKitUnConsilliation],0) + @KitQuantity
                                 WHERE [ID] = @myIdentitySklad
                                 SET @myError = @myError + @@ERROR
                              END
                                
                              UPDATE [dbo].[CommunicationMessagesKittingsSentItems] 
                              SET [KitQuantityDelivered] = ISNULL([KitQuantityDelivered],0) + @KitQuantity
                              WHERE [CMSOId] = @KitOrderID  AND [KitID] = @KitID AND [IsActive] = 1 
                              SET @myError = @myError + @@ERROR 

                              UPDATE [dbo].[CommunicationMessagesKittingsSent] 
                              SET MessageStatusID=5
                              WHERE [Id] = @KitOrderID AND [IsActive] = 1   
                              SET @myError = @myError + @@ERROR          
                        END
                    END

                    FETCH NEXT FROM myCursor INTO @ID, @MessageID, @MessageTypeID, @MessageTypeDescription, @MessageDateOfReceipt, @KitOrderID
                             , @HeliosOrderID,   @KitID,@KitDescription
                             , @KitQuantity, @KitUnitOfMeasureID, @KitUnitOfMeasure,  @KitQualityID, @KitQuality

             END
 
             CLOSE myCursor;
             DEALLOCATE myCursor;
             IF @myError = 0 AND @@TRANCOUNT > 0 
             BEGIN
                 COMMIT TRAN  
                 SET @sub = 'FENIX - K1 - Oznámení' + ' Databáze: '+ISNULL(@myDatabaseName,'')
                 SET @msg = 'Ke schválení byly obdrženy následující message(ID = ): <br />'  + @myAnnouncement
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
                         SET @ReturnMessage = ISNULL(ERROR_MESSAGE(),'')
                         SET @ReturnValue = @myError
             END 
        END 
        ELSE 
        BEGIN 
    
          IF @myPocet>0
          BEGIN 
                SELECT @ReturnValue=1, @ReturnMessage='CInfo'
                SET @sub = 'FENIX - Reception Confirmation ' + ' Databáze: '+ISNULL(@myDatabaseName,'')
                SET @msg = 'Program prCMRCKins; Záznam MessageId=' + ISNULL(CAST(@MessageId AS VARCHAR(50)),'') + ', MessageTypeId = '+ ISNULL(CAST(@MessageTypeId AS VARCHAR(50)),'') + ' byl již jednou naveden !'
                EXEC @result = msdb.dbo.sp_send_dbmail
               		@profile_name = 'Automat', --@MailProfileName
               		@recipients = 'jaroslav.tajbl@upc.cz;michal.rezler@upc.cz',
               		@subject = @sub,
               		@body = @msg,
               		@body_format = 'HTML'

                 EXEC [dbo].[prAppLogWriteNew] @Type='INFO', @Message =  @msg, @XmlMessage = NULL, @UserId = 0,@Source = 'prCMSOKins'
                                          , @ReturnValue = @myReturnValue,@ReturnMessage=@myReturnMessage

          END
        END
      END

END TRY
BEGIN CATCH
      IF @@TRANCOUNT > 0 ROLLBACK TRAN
      SELECT @ReturnValue=1, @ReturnMessage='Chyba'
      SET @sub = 'FENIX - Reception Confirmation CHYBA' + ' Databáze: '+ISNULL(@myDatabaseName,'')
      SET @msg = 'Program prCMRCKins; '  + ISNULL(ERROR_MESSAGE(),'') + ISNULL(CAST(ERROR_NUMBER() AS VARCHAR(50)),'') 
      EXEC @result = msdb.dbo.sp_send_dbmail
     		@profile_name = 'Automat', --@MailProfileName
     		@recipients = 'jaroslav.tajbl@upc.cz;michal.rezler@upc.cz',
     		@subject = @sub,
     		@body = @msg,
     		@body_format = 'HTML'
END CATCH

/*
USE [Fenix]
GO

DECLARE	@return_value int,
		@ReturnValue int,
		@ReturnMessage nvarchar(2048)

EXEC	@return_value = [dbo].[prCMRCKins]
		@par1 = N'<NewDataSet>
  <CommunicationMessagesKittingConfirmation>
    <ID>1</ID>
    <MessageID>01000000033</MessageID>
    <MessageTypeID>4</MessageTypeID>
    <MessageTypeDescription>KittingConfirmation</MessageTypeDescription>
    <MessageDateOfReceipt>2014-08-26</MessageDateOfReceipt>
    <KitOrderID>8</KitOrderID>
    <HeliosOrderID></HeliosOrderID>
    <HeliosOrderRecordID>0</HeliosOrderRecordID>
    <KitID>9</KitID>
    <KitDescription>CA MODUL SMIT CI+</KitDescription>
    <KitQuantity>33</KitQuantity>
    <KitUnitOfMeasureID>1</KitUnitOfMeasureID>
    <KitUnitOfMeasure>KS</KitUnitOfMeasure>
    <KitQualityID>1</KitQualityID>
    <KitQuality>NEW</KitQuality>
    <ItemSNs>
      <ItemSN SN1="ED40060376" SN2="ED400603711"></ItemSN>
      <ItemSN SN1="ED40060377" SN2="ED400603712"></ItemSN>
      <ItemSN SN1="ED40060378" SN2="ED400603713"></ItemSN>
    </ItemSNs>
  </CommunicationMessagesKittingConfirmation>
</NewDataSet>',
@ReturnValue = @ReturnValue OUTPUT,
@ReturnMessage = @ReturnMessage OUTPUT


SELECT	'Return Value' = @return_value
----SELECT *  FROM [FenixW].[dbo].[CommunicationMessagesKittingsSentItems]
--SELECT *  FROM [FenixW].[dbo].[CommunicationMessagesKittingsSent]
*/
END







GO
GRANT EXECUTE
    ON OBJECT::[dbo].[prCMRCKins] TO [FenixW]
    AS [dbo];

