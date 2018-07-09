

CREATE PROCEDURE [dbo].[prCMRCins] 
      @par1 as XML,
	   @ReturnValue     int            = -1 OUTPUT,
	   @ReturnMessage   nvarchar(2048) = null OUTPUT
 AS
BEGIN
-- =========================================================================================================
-- Created by   : Weczerek Max
-- Created date : 2014-06-26
--                2014-09-30, 2014-11-05, 
-- Description  : 
-- Edited       : 2015-08-13 M.Rezler kontrola počtu SN
-- Edited       : 2015-08-17 Weczerek, Rezler  ser. numbers - osetreni pripadu, kdy neni zadano ani jedno SN
-- =========================================================================================================
/*
Fáze R1 -  z ND přijde MESSAGE, viz níže

Kontroluje data
Aktualizuje karty

*/
	SET NOCOUNT ON;
       DECLARE @myDatabaseName  nvarchar(100)
   BEGIN TRY

    SELECT @myDatabaseName = DB_NAME() 

   BEGIN --- DECLARACE
       DECLARE
          @ID [int] ,
          @MessageId  [varchar](50),                  -- [int],
          @MessageTypeId  [varchar](50),              -- [int],
          @MessageTypeDescription   [nvarchar](250),        
          @MessageDescription [nvarchar](200),
          @MessageDateOfReceipt [datetime],
          @HeliosOrderID  [int],
          @HeliosOrderRecordID   [int],
          @CommunicationMessagesSentId [varchar](50), -- [int],
          @ItemID [varchar](50),
          @ItemDescription [nvarchar](500),
          @ItemQuantity [numeric](18, 3),
          @ItemUnitOfMeasure [varchar](50),
          @ItemUnitOfMeasureID [int],
          @ItemQualityId [int],
          @ItemQuality [nvarchar](250),
          @ItemSNs [varchar](max),
          @ItemSupplierID [int],
          @ItemSupplierDescription [nvarchar](500),
          @IsActive [bit],
          @ModifyDate [datetime],
          @ModifyUserId [int],
          @Reconciliation  [bit],
          @myIdentity [int],
          @myReconciliation  [bit],
          @myMessageId  [varchar](50), -- [int],
          @myMessageTypeId  [varchar](50), -- [int],
          @myReceptionOrderID [varchar](50),
          @myIdentitySklad  [int],
          @ReceptionOrderID   [int],
          @NDReceipt [varchar](50),
          @myAnnouncement [nvarchar](max)

          set @myAnnouncement = ''
  
       DECLARE
          @myPocet [int],
          @myError [int],
          @mytxt   [nvarchar] (max)
       DECLARE 
          @hndl int
       
       DECLARE  @myAdresaLogistika  varchar(500),  @myAdresaProgramator  varchar(500) 
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
      IF OBJECT_ID('tempdb..#TmpCMRChd','table') IS NOT NULL DROP TABLE #TmpCMRChd
      IF OBJECT_ID('tempdb..#TmpCMRCsn','table') IS NOT NULL DROP TABLE #TmpCMRCsn

      EXEC sp_xml_preparedocument @hndl OUTPUT, @par1
      SELECT x.[ID], x.[MessageID], x.[MessageTypeID], x.[MessageTypeDescription], x.[MessageDateOfReceipt], x.[ReceptionOrderID]
           , x.[HeliosOrderID], x.[ItemSupplierID], x.[ItemSupplierDescription], x.[HeliosOrderRecordID], x.[ItemID],x.[ItemDescription]
           , x.[ItemQuantity], x.[ItemUnitOfMeasureID], x.[ItemUnitOfMeasure],  x.[ItemQualityID], x.[ItemQuality], x.[NDReceipt]
      INTO #TmpCMRChd
      FROM OPENXML (@hndl, '/NewDataSet/CommunicationMessagesReceptionConfirmation/items/item',2)
      WITH (
      ID                        int          '../../ID',
      MessageID                 nvarchar(50) '../../MessageID',
      MessageTypeID             nvarchar(50) '../../MessageTypeID',
      MessageTypeDescription    nvarchar(150) '../../MessageTypeDescription',
      MessageDateOfReceipt      nvarchar(150) '../../MessageDateOfReceipt',
      ReceptionOrderID          nvarchar(50) '../../ReceptionOrderID',
      HeliosOrderID             nvarchar(50) '../../HeliosOrderID',
      ItemSupplierID            nvarchar(50) '../../ItemSupplierID',
      ItemSupplierDescription   nvarchar(50) '../../ItemSupplierDescription',
      HeliosOrderRecordID       nvarchar(50) 'HeliosOrderRecordID',
      ItemID                    int          'ItemID',
      ItemDescription           nvarchar(50) 'ItemDescription',
      ItemQuantity              numeric  (18, 3)        'ItemQuantity',
      ItemUnitOfMeasureID       int          'ItemUnitOfMeasureID',
      ItemUnitOfMeasure         nvarchar(50) 'ItemUnitOfMeasure',
      ItemQualityID             int          'ItemQualityID',
      ItemQuality               nvarchar(50) 'ItemQuality',
      NDReceipt                 nvarchar(50) 'NDReceipt'
      ) x
      ----
      SELECT y.[ID], y.[ItemID], y.[HeliosOrderID], y.[HeliosOrderRecordID], y.[ItemQualityID], y.[SN]
      INTO #TmpCMRCsn
      FROM OPENXML (@hndl, '/NewDataSet/CommunicationMessagesReceptionConfirmation/items/item/ItemSNs/ItemSN',2)
      WITH (
      ID                        int          '../../../../ID',
      ItemID                    int          '../../ItemID',
      HeliosOrderID             nvarchar(50) '../../../../HeliosOrderID',
      HeliosOrderRecordID       nvarchar(50) '../../HeliosOrderRecordID',
      ItemQualityID             int          '../../ItemQualityID',
      SN  nvarchar(500) '@SN'
      ) y

      EXEC sp_xml_removedocument @hndl

 
  
---- ===========
      --SELECT * FROM #TmpCMRChd
      --SELECT * FROM #TmpCMRCsn
---- ===========   
--      SELECT DISTINCT LEFT(r.ResourceName , LEN(r.ResourceName)-1) [SN], A.[ID],A.[ItemID], A.[HeliosOrderID], A.[HeliosOrderRecordID], A.[ItemQualityID]
--       FROM #TmpCMRCsn A
--       CROSS APPLY (SELECT CAST([SN] AS VARCHAR(50))+ ', '   FROM #TmpCMRCsn  B
--           WHERE A.[ID] =  B.[ID] AND A.[ItemID] = B.[ItemID] AND  A.[HeliosOrderID] = B.[HeliosOrderID] 
--             AND A.[HeliosOrderRecordID] =  B.[HeliosOrderRecordID] AND A.[ItemQualityID] = B.[ItemQualityID]
--           FOR XML PATH('')
--           ) r (ResourceName) 

   -- =======================================================================
   -- Kontrola úplnosti a správnosti dat
   -- =======================================================================
      SELECT @ReceptionOrderID   = CAST(a.ReceptionOrderID AS VARCHAR(50)),
             @MessageId          = CAST(a.MessageId AS VARCHAR(50)),
             @MessageTypeId      = CAST(a.MessageTypeID AS VARCHAR(50)),
             @MessageDescription = a.MessageTypeDescription
       FROM (
             SELECT TOP 1 MessageId,MessageTypeID,MessageTypeDescription,ReceptionOrderID FROM #TmpCMRChd Tmp
             ) a

      BEGIN -- ============ Kontrola existence zdrojové message ======================
           SELECT @myPocet=COUNT(*) FROM [dbo].[CommunicationMessagesReceptionSent] WHERE ID = @ReceptionOrderID
           IF  @myPocet<>1
           BEGIN
                      SET @myMessage = 'NEEXISTUJE ID='+CAST(@ReceptionOrderID AS VARCHAR(50)) + ' v tabulce CommunicationMessagesReceptionSent'
                      EXEC [dbo].[prAppLogWrite] @Type='INFO', @Message =  @myMessage, @XmlMessage = NULL, @UserId = 0,@Source = 'prCMSOins'
                                              , @ReturnValue = @myReturnValue,@ReturnMessage=@myReturnMessage
        
                      SET @sub = 'FENIX - Kontrola RECEPTION CONFIRMATION  - kontrola existence zdrojové message' + ' Databáze: '+ISNULL(@myDatabaseName,'')
                      SET @msg = @myMessage
	     	 	          EXEC @result = msdb.dbo.sp_send_dbmail
	     	 	               @profile_name = 'Automat', --@MailProfileName
	     	 	               @recipients = @myAdresaLogistika,
                           @copy_recipients = @myAdresaProgramator,
	     	 	               @subject = @sub,
	     	 	               @body = @msg,
         	 	            @body_format = 'HTML'
        
                      SET @ReturnValue = 1
                      SET @mOK = 0
           END
      END
   
      BEGIN -- ============ Kontrola existence zboží proti číselníku =================

      SELECT @myPocetPolozekCelkem = COUNT(*) FROM #TmpCMRChd 
      SELECT @myPocetPolozekPomooc = COUNT(*) FROM #TmpCMRChd P 
                                              INNER JOIN [dbo].[cdlItems] cdl ON P.ItemID=cdl.ID    --COLLATE SQL_Czech_CP1250_CI_AS
                                                                              
      --SELECT @myPocetPolozekCelkem '@myPocetPolozekCelkem', @myPocetPolozekPomooc '@myPocetPolozekPomooc'

      IF  @myPocetPolozekCelkem<>@myPocetPolozekPomooc
      BEGIN
                SELECT @myMessage = NULL, @myReturnValue = -1, @myReturnMessage = NULL
                SELECT @myMessage = LEFT(r.ResourceName , LEN(r.ResourceName)-1)
                FROM (
                       SELECT Item + ', '   FROM  
                              (
                              SELECT 'ItemID = '+ CAST(ItemID AS VARCHAR(150))+' / '+ISNULL(ItemDescription,' !!! bez popisu') AS Item 
                              FROM #TmpCMRChd 
                              WHERE CAST(ItemID AS varchar(50))+ CAST(ItemDescription AS nvarchar(500)) NOT IN (SELECT CAST(ID AS varchar(50))+ CAST([DescriptionCz] AS nvarchar(500)) FROM  [dbo].[cdlItems])
                              
                              ) A   FOR XML PATH('')
                     ) r (ResourceName) 


                SET @myMessage = 'Schází skladová položka: '  +' --- ' +ISNULL(@myMessage,'')
                SET @msg = @msg + @myMessage + '<br />'

                SELECT @msg = @msg + ' Zdrojová Message ID= ' + CAST(ISNULL(@ReceptionOrderID,'něco je špatně') AS VARCHAR(500))+ ' (tabulka [dbo].[CommunicationMessagesReceptionSent])' +
                '<br /> Odesláno: '+CONVERT(CHAR(10),CMSO.[MessageDateOfShipment],104) + '<br /> Helios order ID: ' +CAST(CMSO.[HeliosOrderId] AS VARCHAR(50)) +
                '<br /> Objednávka: ' + ISNULL(CAST(CMSO.[RadaDokladu] AS VARCHAR(50))+'/'+CAST(CMSO.[PoradoveCislo] AS VARCHAR(50)), 'neznámá řada dokladů resp pořadové číslo')
                FROM [dbo].[CommunicationMessagesReceptionSent] CMSO 
                LEFT OUTER JOIN [dbo].[FenixHeliosObjHla]  H 
                   ON CMSO.[RadaDokladu] = H.RadaDokladu COLLATE SQL_Czech_CP1250_CI_AS AND CMSO.[PoradoveCislo] = H.PoradoveCislo
                WHERE CMSO.ID = @ReceptionOrderID

                SET @myMessage =  REPLACE(@msg,'<br />','; ')

                EXEC [dbo].[prAppLogWrite] @Type='ERROR', @Message =  @myMessage, @XmlMessage = NULL, @UserId = 0,@Source = 'prCMSOins'
                                         , @ReturnValue = @myReturnValue,@ReturnMessage=@myReturnMessage
                SET @mOK = 0

                SET @sub = 'FENIX - Kontrola RECEPTION CONFIRMATION  - kontrola existence zboží' + ' Databáze: '+ISNULL(@myDatabaseName,'')
		 	        EXEC @result = msdb.dbo.sp_send_dbmail
		 	             @profile_name = 'Automat', --@MailProfileName
		 	             @recipients = @myAdresaLogistika,
                      @copy_recipients = @myAdresaProgramator,
		 	             @subject = @sub,
		 	             @body = @msg,
    	 	             @body_format = 'HTML'

                 SET @ReturnValue = 1
                 -- return @ReturnValue
      END
      END
--SELECT 'x2'
      BEGIN -- ============ Kontrola existence dodavatele ============================
          SET @msg=''   -- ; @ItemSupplierID
          SELECT @myPocet = COUNT(*) FROM
          (SELECT DISTINCT ItemSupplierID,ItemSupplierDescription   FROM #TmpCMRChd Tmp) a

          IF @myPocet = 1
          BEGIN
              SELECT @ItemSupplierID = ItemSupplierID ,@ItemSupplierDescription=ItemSupplierDescription FROM (
                     SELECT TOP 1  ItemSupplierID,ItemSupplierDescription  FROM #TmpCMRChd Tmp ) a
              SELECT @myPocet = COUNT(*) FROM [dbo].[cdlSuppliers] WHERE [ID] = @ItemSupplierID 
          END
          ELSE
          BEGIN
              SET @myPocet = 11
          END
          IF @myPocet>1 
          BEGIN
              SELECT  @myMessage = NULL, @myReturnValue = -1, @myReturnMessage = NULL
              SELECT @myMessage = LEFT(r.ResourceName , LEN(r.ResourceName)-1)
              FROM (
                       SELECT Item + ', '   FROM  
                              (
                              SELECT 'ItemSupplierID = '+ CAST(ItemSupplierID AS VARCHAR(50))+' / '+ISNULL(ItemSupplierDescription,' !!! bez popisu') AS Item 
                              FROM #TmpCMRChd 
                              WHERE CAST(ItemSupplierID AS varchar(50))+ CAST(ItemSupplierDescription AS nvarchar(150)) NOT IN (SELECT CAST(ID AS varchar(50))+ CAST([Nazev] AS nvarchar(150)) FROM  [dbo].[cdlSuppliers])
                              
                              ) A   FOR XML PATH('')
                     ) r (ResourceName) 

                SET @myMessage = 'Zkontrolujte dodavatele: '  +' --- ' +ISNULL(@myMessage,'') + ' '
                SET @msg = @msg + @myMessage + '<br /><br />'
                SELECT @msg = @msg +'Zdrojová message CONFIRMATION: MessageId='+@MessageId+'  MessageType=' + @MessageTypeId + '  MessageDescription=' + @MessageDescription+  '<br /><br />'  
                SELECT @msg =  @msg + ' Zdrojová Message ID= ' + ISNULL(@ReceptionOrderID,' něco je špatně') + ' (tabulka [dbo].[CommunicationMessagesReceptionSent])' +
                '<br /> Odesláno: '+CONVERT(CHAR(10),CMSO.[MessageDateOfShipment],104) + '<br /> Helios order ID: ' +CAST(CMSO.[HeliosOrderId] AS VARCHAR(50)) +
                '<br /> Objednávka: ' + ISNULL(CAST(CMSO.[RadaDokladu] AS VARCHAR(50))+'/'+CAST(CMSO.[PoradoveCislo] AS VARCHAR(50)), 'neznámý dodavatel ')
                FROM [dbo].[CommunicationMessagesReceptionSent] CMSO 

                LEFT OUTER JOIN [dbo].[FenixHeliosObjHla]  H 
                ON CMSO.[RadaDokladu] = H.RadaDokladu  COLLATE SQL_Czech_CP1250_CI_AS 
                AND CMSO.[PoradoveCislo] =H.PoradoveCislo     -- CMSO.[HeliosOrderId] = H.ID
                WHERE CMSO.ID = @ReceptionOrderID

                SET @myMessage =  REPLACE(@msg,'<br />','; ')

                EXEC [dbo].[prAppLogWrite] @Type='ERROR', @Message =  @myMessage, @XmlMessage = NULL, @UserId = 0,@Source = 'prCMSOins'
                                         , @ReturnValue = @myReturnValue,@ReturnMessage=@myReturnMessage
                SET @mOK = 0


                SET @sub = 'FENIX - Kontrola RECEPTION CONFIRMATION  - kontrola dodavatele' + ' Databáze: '+ISNULL(@myDatabaseName,'')
		 	        EXEC @result = msdb.dbo.sp_send_dbmail
		 	             @profile_name = 'Automat', --@MailProfileName
		 	             @recipients = @myAdresaLogistika,
                      @copy_recipients = @myAdresaProgramator,
		 	             @subject = @sub,
		 	             @body = @msg,
    	 	             @body_format = 'HTML'

                 SET @ReturnValue = 1
                 -- return @ReturnValue
          END
      END
--SELECT 'x3' 
      BEGIN -- ============ Kontrola existence zboží proti objednávce ================
          SET @myReconciliation = 0  -- vždy je neodsouhlaseno  20140710
          SET @msg='' 
          SELECT @myPocet = COUNT(*)  FROM #TmpCMRChd Tmp 
          SELECT @myPocetPolozekPomooc  = COUNT(*) FROM [dbo].[CommunicationMessagesReceptionSentItems] 
          WHERE [CMSOId] = @ReceptionOrderID AND ISACTIVE=1

          IF @myPocet-@myPocetPolozekPomooc<>0
          BEGIN
                
                 SET @myMessage = 'NESOUHLASÍ počet položek objednávky s potvrzením nákupu. ID objednávky='+CAST(@ReceptionOrderID AS VARCHAR(50)) +', POČET = '+CAST(@myPocetPolozekPomooc AS VARCHAR(50)) + ' v tabulce CommunicationMessagesReceptionSent'
                     + ',  Confirmace:  MessageId = '+CAST(@MessageId AS VARCHAR(50))+', MessageType = '+CAST(@MessageTypeId AS VARCHAR(50))+', MessageDescription = '+CAST(@MessageDescription  AS NVARCHAR(250)) +', POČET = '+CAST(@myPocet AS VARCHAR(50))
                 EXEC [dbo].[prAppLogWrite] @Type='INFO', @Message =  @myMessage, @XmlMessage = NULL, @UserId = 0,@Source = 'prCMSOins'
                                          , @ReturnValue = @myReturnValue,@ReturnMessage=@myReturnMessage
                 -- SET @mOK = 0    nesouhlasí počty, ale jedeme dále    20.8.2014
                 SET @msg = @myMessage + '<br /><br /> Ve zpracování se pokračuje'
            
                 SET @sub = 'FENIX - Kontrola RECEPTION CONFIRMATION  - kontrola počtu položek proti objednávce' + ' Databáze: '+ISNULL(@myDatabaseName,'')
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
          ELSE
          BEGIN
                SELECT @myPocet = COUNT(*)  FROM #TmpCMRChd Tmp
                SELECT @myPocetPolozekPomooc  = COUNT(*) 
                FROM #TmpCMRChd           Tmp
                INNER JOIN  [dbo].[CommunicationMessagesReceptionSentItems]   I
                      ON I.[CMSOId] = @ReceptionOrderID AND Tmp.ItemID= I.ItemID
                WHERE I.ISACTIVE=1
 
                IF @myPocet-@myPocetPolozekPomooc<>0
                BEGIN
                      
                       SET @myMessage = 'NESOUHLASÍ Items položek objednávky s potvrzením nákupu. ID objednávky='+CAST(@ReceptionOrderID AS VARCHAR(50)) +
                           + ',  Confirmace:  MessageId = '+CAST(@MessageId AS VARCHAR(50))+', MessageType = '+CAST(@MessageTypeId AS VARCHAR(50))+', MessageDescription = '+CAST(@MessageDescription  AS NVARCHAR(250)) 
                       EXEC [dbo].[prAppLogWrite] @Type='INFO', @Message =  @myMessage, @XmlMessage = NULL, @UserId = 0,@Source = 'prCMSOins'
                                                , @ReturnValue = @myReturnValue,@ReturnMessage=@myReturnMessage
                       -- SET @mOK = 0    nesouhlasí počty, ale jedeme dále    20.8.2014
                       SET @msg = @myMessage + '<br /><br /> Ve zpracování se pokračuje'
                  
                       SET @sub = 'FENIX - Kontrola RECEPTION CONFIRMATION  - kontrola ItemID položek proti objednávce' + ' Databáze: '+ISNULL(@myDatabaseName,'')
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
--SELECT 'x4'
      BEGIN -- ============ Kontrola existence měrných jednotek proti číselníku ======
          SELECT @myMessage = LEFT(r.ResourceName , LEN(r.ResourceName)-1)
                FROM ( SELECT Item + ', '   FROM  
                            (
                              SELECT ItemUnitOfMeasure+', '  AS ITEM FROM #TmpCMRChd 
                                     WHERE ItemUnitOfMeasure NOT IN (SELECT [Code] FROM [dbo].[cdlMeasures])
                            ) A   FOR XML PATH('')
                     ) r (ResourceName) 
         
         IF NOT (@myMessage IS NULL OR @myMessage='')
         BEGIN
                 SET @mOK = 0
                 SET @msg = 'Schází měrné jednotky v číselníku : ' + @myMessage
            
                 SET @sub = 'FENIX - Kontrola RECEPTION CONFIRMATION  - kontrola měrných jednotek' + ' Databáze: '+ISNULL(@myDatabaseName,'')
		 	        EXEC @result = msdb.dbo.sp_send_dbmail
		 	             @profile_name = 'Automat', --@MailProfileName
		 	             @recipients = @myAdresaLogistika,
                      @copy_recipients = @myAdresaProgramator,
		 	             @subject = @sub,
		 	             @body = @msg,
    	 	             @body_format = 'HTML'

                 SET @ReturnValue = 1
                 -- return @ReturnValue

         END
      END
--SELECT 'x5'
      BEGIN  -- =========== Kontrola počtu SN ve vztahu k itemu (CPE) =============  2015-08-13
          DECLARE @myCount INT


          SELECT @myCount = POCET  FROM (
          SELECT COUNT(*) AS POCET FROM
          (
               SELECT aa.ItemID, aa.ItemQualityID, aa.SumItemQuantity FROM
               (
                      SELECT ItemID, ItemQualityID, SUM(ItemQuantity) SumItemQuantity 
                      FROM #TmpCMRChd
                      GROUP BY ItemID, ItemQualityID
               ) aa
               INNER JOIN cdlItems   cI
                    ON aa.ItemID = cI.ID 
               WHERE cI.ItemType='CPE' 
          ) bb
          LEFT OUTER JOIN  (SELECT COUNT(*) SUMA, ItemID, ItemQualityID                    -- 2015-08-17
														 FROM  #TmpCMRCsn 
														 GROUP BY ItemID, ItemQualityID)        TmpSN
             ON     bb.ItemID         = TmpSN.ItemID                  
                AND bb.ItemQualityID  = TmpSN.ItemQualityID
          WHERE ISNULL(SumItemQuantity,0) - ISNULL(SUMA,0) <> 0     -- 2015-08-17  pridano ISNULL
          ) xx

          --IF @@ROWCOUNT>0 
          IF ISNULL(@myCount,0)>0   -- 2015-08-17
          BEGIN 
                 DECLARE @SeznamItems AS nvarchar(max)
                 SET @SeznamItems = 'MessageId = ' + CAST(@MessageId AS  nvarchar(50)) +'<br />'
								 
                 SELECT @SeznamItems= @SeznamItems +'Item = '+CAST(bb.ItemID AS nvarchar(50)) + ' , kvalita = '+ CAST(bb.ItemQualityID AS nvarchar(50)) +'<br />' 
								 FROM
                 (
										 SELECT aa.ItemID, aa.ItemQualityID, aa.SumItemQuantity FROM
										 (
														SELECT ItemID, ItemQualityID, SUM(ItemQuantity) SumItemQuantity 
														FROM #TmpCMRChd
														GROUP BY ItemID, ItemQualityID
										 ) aa
										 INNER JOIN cdlItems   cI
													ON aa.ItemID = cI.ID 
										 WHERE cI.ItemType='CPE' 
								 ) bb
								 LEFT OUTER JOIN  (SELECT COUNT(*) SUMA, ItemID, ItemQualityID 
															 FROM  #TmpCMRCsn 
															 GROUP BY ItemID, ItemQualityID)        TmpSN
										 ON     bb.ItemID         = TmpSN.ItemID                  
												AND bb.ItemQualityID  = TmpSN.ItemQualityID
								 WHERE SumItemQuantity - SUMA <> 0
								                  
                 SET @myAdresaLogistika = @myAdresaLogistika + ';max.weczerek@upc.cz'
                 SET @sub = 'FENIX - R1 INFO' + ' Databáze: ' + ISNULL(@myDatabaseName,'')
                 SET @msg = 'Program [dbo].[prCMRCins](Reception Confirmation)<br /> Nesouhlasí počty SN s reálným množstvím <br />' +@SeznamItems   
                 EXEC @result = msdb.dbo.sp_send_dbmail
                		@profile_name = 'Automat', --@MailProfileName
                		@recipients = @myAdresaLogistika,
                		@subject = @sub,
                		@body = @msg,
                		@body_format = 'HTML'
          END
      END 

      BEGIN -- ============================ Zpracování ===============================
      
        SELECT TOP 1  @MessageId = [MessageId], @MessageTypeId = [MessageTypeId], @MessageDescription =MessageTypeDescription   FROM  #TmpCMRChd

        SELECT  @myPocet = COUNT(*) FROM [dbo].[CommunicationMessagesReceptionConfirmation] WHERE [MessageId]=@MessageId AND
                                         [MessageTypeId] = @MessageTypeId AND  MessageDescription = @MessageDescription
        IF @mOK=1 AND  (@myPocet = 0 OR  @myPocet IS NULL)
        BEGIN
            IF (SELECT CURSOR_STATUS('global','myCursor')) >= -1
             BEGIN
                      DEALLOCATE myCursor
             END
             BEGIN TRAN 
             DECLARE myCursor CURSOR 
             FOR  SELECT x.[ID], x.[MessageID], x.[MessageTypeID], x.[MessageTypeDescription], x.[MessageDateOfReceipt], x.[ReceptionOrderID]
                       , x.[HeliosOrderID], x.[ItemSupplierID], x.[ItemSupplierDescription], x.[HeliosOrderRecordID], x.[ItemID],x.[ItemDescription]
                       , x.[ItemQuantity], x.[ItemUnitOfMeasureID], x.[ItemUnitOfMeasure],  x.[ItemQualityID], x.[ItemQuality], x.[NDReceipt]
                  FROM #TmpCMRChd x ORDER BY MessageId, MessageTypeID, ReceptionOrderID

             OPEN myCursor
             FETCH NEXT FROM myCursor INTO  @ID, @MessageID, @MessageTypeID, @MessageTypeDescription, @MessageDateOfReceipt, @ReceptionOrderID
                       , @HeliosOrderID, @ItemSupplierID, @ItemSupplierDescription, @HeliosOrderRecordID, @ItemID,@ItemDescription
                       , @ItemQuantity, @ItemUnitOfMeasureID, @ItemUnitOfMeasure,  @ItemQualityID, @ItemQuality,@NDReceipt

             SELECT @myMessageId = '-1',  @myMessageTypeId  = '-1',  @myReceptionOrderID  = '-1'
        
             WHILE @@FETCH_STATUS = 0
             BEGIN

                    IF @myMessageId <> @MessageId OR  @myMessageTypeId  <>  @MessageTypeId OR  @myReceptionOrderID  <> @ReceptionOrderID
                    BEGIN
                       SELECT @myMessageId = @MessageId,  @myMessageTypeId = @MessageTypeId, @myReceptionOrderID = @ReceptionOrderID
                       INSERT INTO [dbo].[CommunicationMessagesReceptionConfirmation]
                                  ([MessageId]
                                  ,[MessageTypeId]
                                  ,[MessageDescription]
                                  ,[MessageDateOfReceipt]
                                  ,[CommunicationMessagesSentId]
                                  ,[ItemSupplierId]
                                  ,[ItemSupplierDescription]
                                  ,[Reconciliation]
                            )
                       VALUES
                                  (@MessageId
                                  ,@MessageTypeId
                                  ,@MessageDescription
                                  ,@MessageDateOfReceipt
                                  ,@ReceptionOrderID
                                  ,@ItemSupplierId
                                  ,@ItemSupplierDescription
                                  ,0
                            )
                        SELECT @myIdentity = @@IDENTITY, @myError = @@ERROR

                    END

                    IF @myError=0 AND @myIdentity>0
                    BEGIN
                            SET @ItemSNs = ''
                            SELECT @ItemSNs = SN FROM (
                            SELECT DISTINCT LEFT(r.ResourceName , LEN(r.ResourceName)-1) [SN], A.[ID],A.[ItemID], A.[HeliosOrderID], A.[HeliosOrderRecordID], A.[ItemQualityID]
                             FROM #TmpCMRCsn A
                             CROSS APPLY (SELECT CAST([SN] AS VARCHAR(50))+ ', '   FROM #TmpCMRCsn  B
                                 WHERE A.[ID] =  B.[ID] AND A.[ItemID] = B.[ItemID] AND  A.[HeliosOrderID] = B.[HeliosOrderID] 
                                   AND A.[HeliosOrderRecordID] =  B.[HeliosOrderRecordID] AND A.[ItemQualityID] = B.[ItemQualityID]
                                 FOR XML PATH('')
                                 ) r (ResourceName) 
                                 ) AA 
                                 WHERE  AA.[ID] =  @ID AND AA.[ItemID] = @ItemID AND  AA.[HeliosOrderID] = @HeliosOrderID 
                                   AND AA.[HeliosOrderRecordID] =  @HeliosOrderRecordID AND AA.[ItemQualityID] = @ItemQualityID

                        INSERT INTO [dbo].[CommunicationMessagesReceptionConfirmationItems]
                                   ([CMSOId]
                                   ,[ItemId]
                                   ,[ItemDescription]
                                   ,[ItemQuantity]
                                   ,[ItemUnitOfMeasure]
                                   ,[ItemQualityId]
                                   ,NDReceipt
                                   ,ItemSNs
                        )
                             VALUES
                                   (@myIdentity
                                   ,@ItemID
                                   ,@ItemDescription
                                   ,@ItemQuantity
                                   ,@ItemUnitOfMeasure
                                   ,@ItemQualityId
                                   ,@NDReceipt
                                   ,@ItemSNs 
                         )
                        SELECT @myError =  @myError + @@ERROR
 
                        IF @myError=0
                        BEGIN
                              --  ********* ID merne jednotky ***********************
                              SELECT @ItemUnitOfMeasureID = ID FROM [dbo].[cdlMeasures] 
                              WHERE ([DescriptionCz] = RTRIM(@ItemUnitOfMeasure) OR [DescriptionEng] =  RTRIM(@ItemUnitOfMeasure) OR CODE=@ItemUnitOfMeasure) AND IsActive=1
                              --  ********* zjisteni existence karty ****************




                              SELECT @myPocet = COUNT(*) 
                              FROM [dbo].[CardStockItems] 
                              WHERE [ItemVerKit] = 0 AND [IsActive] = 1 
                                AND [ItemOrKitID]              = @ItemID 
                                AND [ItemOrKitUnitOfMeasureID] = @ItemUnitOfMeasureID
                                AND [ItemOrKitQuality]         = @ItemQualityId
                                AND [StockId] = 2   -- pouze ND potvrzuje objednávky

                              IF @myPocet IS NULL OR @myPocet=0  -- karta
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
                                       (0                            -- <ItemVerKit, bit,>
                                       ,@ItemID                      -- <ItemOrKitID, int,>
                                       ,@ItemUnitOfMeasureID         -- <ItemOrKitUnitOfMeasure, int,>
                                       ,@ItemQuantity                -- <ItemOrKitQuantity, numeric(18,3),>
                                       ,@ItemQualityId
                                       ,0                            -- <ItemOrKitReserved, numeric(18,3),>
                                       ,2                            -- pouze ND
                                 )
                                 SET @myIdentitySklad = @@IDENTITY
                                 SET @myError = @myError + @@ERROR
                      
                              END
                              ELSE
                              BEGIN
                                 --  ********* karta je ****************
                                 SELECT @myIdentitySklad = ID 
                                 FROM [dbo].[CardStockItems] 
                                 WHERE [ItemVerKit] = 0 
                                 AND [IsActive] = 1 
                                 AND [ItemOrKitID]              = @ItemID 
                                 AND [ItemOrKitUnitOfMeasureId] = @ItemUnitOfMeasureID
                                 AND [ItemOrKitQuality]         = @ItemQualityId 
                                 AND [StockId] = 2
                       
                                 UPDATE [dbo].[CardStockItems] SET [ItemOrKitUnConsilliation] = ISNULL([ItemOrKitUnConsilliation],0) + @ItemQuantity
                                 WHERE [ID] = @myIdentitySklad
                                 SET @myError = @myError + @@ERROR

                              END

                              UPDATE [dbo].[CommunicationMessagesReceptionSentItems] 
                              SET [ItemQuantityDelivered]=ISNULL([ItemQuantityDelivered],0) + @ItemQuantity
                              WHERE [CMSOId] = @ReceptionOrderID  AND [ItemID] = @ItemID AND [IsActive] = 1 
                              SET @myError = @myError + @@ERROR
                               
                              UPDATE [dbo].[CommunicationMessagesReceptionSent] 
                              SET MessageStatusID=5
                              WHERE [Id] = @ReceptionOrderID AND [IsActive] = 1   
                              SET @myError = @myError + @@ERROR

                        END
                    END

                    SET  @myAnnouncement = @myAnnouncement + '<br />MessageID = ' + ISNULL(CAST(@MessageID AS VARCHAR(50)),'')+ 
                                           ', MessageTypeDescription = ' + ISNULL(CAST(@MessageTypeDescription AS VARCHAR(150)),'')

                    FETCH NEXT FROM myCursor INTO @ID, @MessageID, @MessageTypeID, @MessageTypeDescription, @MessageDateOfReceipt, @ReceptionOrderID
                       , @HeliosOrderID, @ItemSupplierID, @ItemSupplierDescription, @HeliosOrderRecordID, @ItemID,@ItemDescription
                       , @ItemQuantity, @ItemUnitOfMeasureID, @ItemUnitOfMeasure,  @ItemQualityID, @ItemQuality,@NDReceipt

             END
 
             CLOSE myCursor;
             DEALLOCATE myCursor;

             IF @myError = 0 
             BEGIN -- 22
                 COMMIT TRAN
                 SET @sub = 'FENIX - R1 - Oznámení' + ' Databáze: '+ISNULL(@myDatabaseName,'')
                 SET @msg = 'Ke schválení byly obdrženy následující message: <br />'  + @myAnnouncement 
		 	        EXEC @result = msdb.dbo.sp_send_dbmail
		 	             @profile_name = 'Automat', --@MailProfileName
		 	             @recipients = @myAdresaLogistika,
                      @copy_recipients = @myAdresaProgramator,
		 	             @subject = @sub,
		 	             @body = @msg,
    	 	             @body_format = 'HTML'
             END    -- 22
             ELSE
             BEGIN -- 22
                 IF @@TRANCOUNT>0 ROLLBACK TRAN
                 SET @sub = 'FENIX - R1 - Oznámení - PROBLEM !!!' + ' Databáze: '+ISNULL(@myDatabaseName,'')
                 SET @msg = 'Nebyly uloženy následující message: <br />'  + @myAnnouncement
		 	        EXEC @result = msdb.dbo.sp_send_dbmail
		 	             @profile_name = 'Automat', --@MailProfileName
		 	             @recipients = @myAdresaLogistika,
                      @copy_recipients = @myAdresaProgramator,
		 	             @subject = @sub,
		 	             @body = @msg,
    	 	             @body_format = 'HTML'
             END    -- 22
 
        END ELSE 
        BEGIN 
          IF @myPocet>0
          BEGIN 
                IF @@TRANCOUNT>0 ROLLBACK TRAN
                SELECT @ReturnValue=1, @ReturnMessage='CInfo'
                SET @sub = 'FENIX - Reception Confirmation ' + ' Databáze: '+ISNULL(@myDatabaseName,'')
                SET @msg = 'Program prCMRCins; Záznam MessageId=' + ISNULL(CAST(@MessageId AS VARCHAR(50)),'') + ', MessageTypeId = '+ ISNULL(CAST(@MessageTypeId AS VARCHAR(50)),'') + ' byl již jednou naveden !'
                EXEC @result = msdb.dbo.sp_send_dbmail
               		@profile_name = 'Automat', --@MailProfileName
               		@recipients = 'max.weczerek@upc.cz',
               		@subject = @sub,
               		@body = @msg,
               		@body_format = 'HTML'

          END
        END
      END

END TRY
BEGIN CATCH
      IF @@TRANCOUNT>0 ROLLBACK TRAN

      SELECT @ReturnValue=1, @ReturnMessage='Chyba'
      SET @sub = 'FENIX - Reception Confirmation CHYBA' + ' Databáze: '+ISNULL(@myDatabaseName,'')
      SET @msg = 'Program prCMRCins; '  + ISNULL(ERROR_MESSAGE(),'') + ISNULL(CAST(ERROR_NUMBER() AS VARCHAR(50)),'') 
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
    ON OBJECT::[dbo].[prCMRCins] TO [FenixW]
    AS [dbo];

