

CREATE PROCEDURE [dbo].[prRORF1ins] 
      @par1 as XML,

	   @ReturnValue     int            = -1 OUTPUT,
	   @ReturnMessage   nvarchar(2048) = null OUTPUT
 AS
BEGIN
-- =================================================================================================
-- Created by   : Weczerek Max
-- Created date : 2014-09-24
--                2014-09-29, 2014-11-06, 2011-11-07, 2015-01-19
--                2015-11-20 M.Rezler : kontrola poctu SN (nove se pracuje i s 'CPV' - vracene CPE)
--                2016-07-04 M.Weczerek : kontrola počtu SN (i když jsou vyplněny SN1 a SN2, vždy to je jen jeden objekt  - Radomír Beran
-- Description  : 
-- =================================================================================================
/*
Fáze RF1 -  z ND přijde MESSAGE, viz níže

Kontroluje data
Aktualizuje karty

POZOR PRI ZAMITNUTI - NUTNO OPRAVIT KARTY !!! PLATI I PRO ODSOUHLASENI

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
	          @myItemOrKitQualityId int,
             @myItemOrKitQualityCode varchar(50),
             @myItemOrKitQuality varchar(50),
	          @myItemOrKitDateOfDelivery datetime,
             @myDateOfShipment datetime,
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
            ,@myRefurbishedOrderID int
            ,@myHeliosOrderID int
            ,@myCardStockItemsId int
            ,@myKeyMessageID  int
            ,@myKeyCustomerID  int
            ,@myCustomerDescription  nvarchar(150)
            ,@myNDReceipt  nvarchar(50)
            ,@myIdentityx Int

      DECLARE 
             @myKeyRefurbishedOrderID int,
             @myKeyItemVerKit int,
	          @myKeyItemOrKitID int,
             @myKeyDestinationPlacesId int,
             @myKeyDestinationPlacesContactsId int,
             @myKeyDateOfExpedition  nvarchar(20),
             @myKeycdlStocksName  nvarchar(100)


       SELECT @myDatabaseName = DB_NAME() 

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
      IF OBJECT_ID('tempdb..#TmpCMSRF1hd','table') IS NOT NULL DROP TABLE #TmpCMSRF1hd
      IF OBJECT_ID('tempdb..#TmpCMSRF1sn','table') IS NOT NULL DROP TABLE #TmpCMSRF1sn

      EXEC sp_xml_preparedocument @hndl OUTPUT, @par1
      SELECT  x.ID                       
             ,x.MessageID                
             ,x.MessageTypeID            
             ,x.MessageTypeDescription   
             ,x.RefurbishedOrderID       
             ,x.CustomerID               
             ,x.CustomerDescription      
             ,x.DateOfShipment           
             ,x.ItemVerKit               
             ,x.ItemOrKitID              
             ,x.ItemOrKitDescription     
             ,x.ItemOrKitQuantity        
             ,x.ItemOrKitUnitOfMeasureID 
             ,x.ItemOrKitUnitOfMeasure   
             ,x.ItemOrKitQualityID       
             ,x.ItemOrKitQuality         
             ,x.NDReceipt                
      INTO #TmpCMSRF1hd
      FROM OPENXML (@hndl, '/NewDataSet/CommunicationMessagesRefurbishedConfirmation/itemsOrKits/itemOrKit',2)
      WITH (
      ID                             int           '../../ID',
      MessageID                      int           '../../MessageID',
      MessageTypeID                  int           '../../MessageTypeID',
      MessageTypeDescription         nvarchar(150) '../../MessageTypeDescription',
      RefurbishedOrderID             int           '../../RefurbishedOrderID',
      CustomerID                     int           '../../CustomerID',
      CustomerDescription            nvarchar(150) '../../CustomerDescription',
      DateOfShipment                 nvarchar(50)  '../../DateOfShipment',
      ItemVerKit                     int           'ItemVerKit',
      ItemOrKitID                    int           'ItemOrKitID',
      ItemOrKitDescription           nvarchar(150) 'ItemOrKitDescription',
      ItemOrKitQuantity              numeric(18, 3)'ItemOrKitQuantity',
      ItemOrKitUnitOfMeasureID       nvarchar(150) 'ItemOrKitUnitOfMeasureID',
      ItemOrKitUnitOfMeasure         nvarchar(150) 'ItemOrKitUnitOfMeasure',
      ItemOrKitQualityID             int           'ItemOrKitQualityID',
      ItemOrKitQuality               nvarchar(150) 'ItemOrKitQuality',
      NDReceipt                      nvarchar(150) 'NDReceipt'
      ) x
      ----
      SELECT y.ID, y.MessageID, y.ItemVerKit, y.[ItemOrKitID],y.ItemOrKitQualityID, y.[SN1],y.[SN2]
      INTO #TmpCMSRF1sn
      FROM OPENXML (@hndl, '/NewDataSet/CommunicationMessagesRefurbishedConfirmation/itemsOrKits/itemOrKit/ItemOrKitSNs/ItemSN',2)
      WITH (
      ID                             int           '../../../../ID',
      MessageID                      int           '../../../../MessageID',
      ItemVerKit                     int           '../../ItemVerKit',
      ItemOrKitID                    int           '../../ItemOrKitID',
      ItemOrKitQualityID             int           '../../ItemOrKitQualityID',
      SN1                            nvarchar(150) '@SN1',
      SN2                            nvarchar(150) '@SN2'
      ) y
      EXEC sp_xml_removedocument @hndl


      SELECT @myMessageId              = CAST(a.MessageId AS VARCHAR(50)),
             @myMessageTypeId          = CAST(a.MessageTypeID AS VARCHAR(50)),
             @myMessageTypeDescription = a.MessageTypeDescription,
             @myRefurbishedOrderID     = a.RefurbishedOrderID
       FROM (
             SELECT TOP 1 MessageId,MessageTypeID,MessageTypeDescription,RefurbishedOrderID FROM #TmpCMSRF1hd Tmp
             ) a

---- ===========
      --SELECT * FROM #TmpCMSRF1hd
      --SELECT * FROM [dbo].[CommunicationMessagesRefurbishedOrderItems] WHERE [CMSOId]=99
      --SELECT * FROM #TmpCMSRF1sn
      --SELECT  @myRefurbishedOrderID '@myRefurbishedOrderID'
---- ===========   
         
   -- =======================================================================
   --        Kontrola úplnosti a správnosti dat
   -- =======================================================================
   SELECT @myPocet=COUNT(*) FROM  CommunicationMessagesRefurbishedOrderConfirmation   C
   INNER JOIN #TmpCMSRF1hd H ON C.MessageId = H.MessageId

   IF @myPocet = 0 OR @myPocet IS NULL
   BEGIN -- hlavni

      BEGIN -- ============ Kontrola existence zdrojové message ======================
           SELECT @myPocet=COUNT(*) FROM [dbo].[CommunicationMessagesRefurbishedOrder] WHERE ID = @myRefurbishedOrderID
           
           IF  @myPocet<>1
           BEGIN
                      SET @myMessage = 'NEEXISTUJE ID='+CAST(@myRefurbishedOrderID AS VARCHAR(50)) + ' v tabulce [dbo].[CommunicationMessagesRefurbishedOrder]'
                      EXEC [dbo].[prAppLogWriteNew] @Type='INFO', @Message =  @myMessage, @XmlMessage = NULL, @UserId = 0,@Source = 'prRORF1ins'
                                               , @ReturnValue = @myReturnValue,@ReturnMessage=@myReturnMessage
        
                      SET @sub = 'FENIX - Kontrola Refurbished CONFIRMATION  - kontrola existence zdrojové message' + ' Databáze: '+ISNULL(@myDatabaseName,'')
                      SET @msg = @myMessage
	     	 	          EXEC @result = msdb.dbo.sp_send_dbmail
	     	 	               @profile_name = 'Automat', --@MailProfileName
	     	 	               @recipients = @myAdresaLogistika,
                           @copy_recipients = @myAdresaProgramator,
	     	 	               @subject = @sub,
	     	 	               @body = @msg,
         	 	            @body_format = 'HTML'
        
                      SET @ReturnValue = 1
           END
      END
  
      BEGIN -- ============ Kontrola existence zboží proti objednávce ================
          SET @msg='' 
          SELECT @myPocet = COUNT(*)  FROM #TmpCMSRF1hd Tmp    
          SELECT @myPocetPolozekPomooc  = COUNT(*) 
          FROM [dbo].[CommunicationMessagesRefurbishedOrderItems] 
          WHERE [CMSOId] = @myRefurbishedOrderID AND ISACTIVE=1

          IF @myPocet-@myPocetPolozekPomooc<>0
          BEGIN
                
                 SET @myMessage = 'NESOUHLASÍ počet položek objednávky s potvrzením závozu. ID objednávky='+ISNULL(CAST(@myRefurbishedOrderID AS VARCHAR(50)),'') +', POČET = '+CAST(@myPocetPolozekPomooc AS VARCHAR(50)) + ' v tabulce CommunicationMessagesRefurbishedOrderItems'
                     + ',  Confirmace:  MessageId = '+CAST(@myMessageId AS VARCHAR(50))+', MessageType = '+CAST(@myMessageTypeId AS VARCHAR(50))+', MessageDescription = '+CAST(@myMessageTypeDescription  AS NVARCHAR(250)) +', POČET = '+CAST(@myPocet AS VARCHAR(50)) +
                     '<br />Pokračuji dále ve zpracování'
                 EXEC [dbo].[prAppLogWriteNew] @Type='INFO', @Message =  @myMessage, @XmlMessage = NULL, @UserId = 0,@Source = 'prRORF1ins'
                                          , @ReturnValue = @myReturnValue,@ReturnMessage=@myReturnMessage
                 --SET @mOK = 0
                 SET @msg = @myMessage
            
                 SET @sub = 'FENIX - Kontrola Refurbished CONFIRMATION  - kontrola počtu položek proti objednávce' + ' Databáze: '+ISNULL(@myDatabaseName,'')
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
                SELECT @myPocet = COUNT(*)  FROM #TmpCMSRF1hd Tmp
                SELECT @myPocetPolozekPomooc  = COUNT(*) 
                FROM #TmpCMSRF1hd           Tmp
                INNER JOIN  [dbo].[CommunicationMessagesRefurbishedOrderItems]   I
                      ON I.[CMSOId] = @myRefurbishedOrderID AND Tmp.ItemOrKitID= I.ItemOrKitID AND I.ItemVerKit = Tmp.ItemVerKit AND I.ItemOrKitQuantity = Tmp.ItemOrKitQuantity
                WHERE I.ISACTIVE=1
 
                IF @myPocet-@myPocetPolozekPomooc<>0
                BEGIN
                       SET @myMessage = 'NESOUHLASÍ počet Items položek objednávky nebo množství objednané s potvrzením závozu. ID objednávky='+CAST(@myRefurbishedOrderID AS VARCHAR(50)) +
                           + ',  Confirmace:  MessageId = '+CAST(@myMessageId AS VARCHAR(50))+', MessageType = '+CAST(@myMessageTypeId AS VARCHAR(50))+', MessageDescription = '+CAST(@myMessageTypeDescription  AS NVARCHAR(250)) 
                           +'<br />Pokračuji dále ve zpracování'
                       EXEC [dbo].[prAppLogWriteNew] @Type='INFO', @Message =  @myMessage, @XmlMessage = NULL, @UserId = 0,@Source = 'prRORF1ins'
                                                , @ReturnValue = @myReturnValue,@ReturnMessage=@myReturnMessage
                       --SET @mOK = 0
                       SET @msg = @myMessage
                  
                       SET @sub = 'FENIX - Kontrola Refurbished CONFIRMATION  - kontrola ItemOrKitID položek proti objednávce' + ' Databáze: '+ISNULL(@myDatabaseName,'')
		       	        EXEC @result = msdb.dbo.sp_send_dbmail
		       	             @profile_name = 'Automat', --@MailProfileName
		       	             @recipients = @myAdresaLogistika,
                            @copy_recipients = @myAdresaProgramator,
		       	             @subject = @sub,
		       	             @body = @msg,
    	       	             @body_format = 'HTML'
             
                END
          END
      END

			-- SN start
      BEGIN -- =========== KOntrola počtu SN ve vztahu k itemu (CPE) =============  2014-11-12

           -- ================== toto je nově ================ START ===============================
           DECLARE @PocetSnCelkemTabTmpCMSOCsn INT

           SELECT @PocetSnCelkemTabTmpCMSOCsn = SUM(SUMx)  
           FROM (
                 SELECT SUM(SUMAsn1) SUMx, ItemOrKitID, ItemVerKit, ItemOrKitQualityID
                 FROM
                 (
                                        SELECT SUM(1) SUMAsn1, ItemOrKitID, ItemVerKit, ItemOrKitQualityID 
                                              FROM  #TmpCMSRF1sn 
                                              WHERE RTRIM(SN1)<>'' OR RTRIM(SN2)<>''
                                              GROUP BY ItemOrKitID, ItemVerKit, ItemOrKitQualityID                   -- 2016-07-04

                       --SELECT SUM(1) SUMAsn1, ItemOrKitID, ItemVerKit, ItemOrKitQualityID                          -- 2016-07-04
                       --                       FROM  #TmpCMSRF1sn 
                       --                       WHERE RTRIM(SN1)<>''
                       --                       GROUP BY ItemOrKitID, ItemVerKit, ItemOrKitQualityID
                       --UNION ALL
                       --SELECT SUM(1) SUMAsn1, ItemOrKitID, ItemVerKit, ItemOrKitQualityID 
                       --                       FROM  #TmpCMSRF1sn 
                       --                       WHERE RTRIM(SN2)<>''
                       --                       GROUP BY ItemOrKitID, ItemVerKit, ItemOrKitQualityID
                                              
                 )        TmpSN
                 GROUP BY ItemOrKitID, ItemVerKit, ItemOrKitQualityID
           ) nnn
           -- ============================================================================
           DECLARE @PocetSnKitTabTmpCMSOChd INT

           SELECT @PocetSnKitTabTmpCMSOChd = SUM(SUMA) FROM
           (
              SELECT SUM(NASOBENI) SUMA 
              FROM (
                     SELECT bbb.ItemOrKitID, bbb.ItemVerKit, bbb.ItemOrKitQualityID, bbb.SumRealItemOrKitQuantity,bbb.[ItemOrKitQuantity]
                           ,KIItemOrKitId,bbb.SumRealItemOrKitQuantity*bbb.[ItemOrKitQuantity]*bbb.Multiplayer  NASOBENI 
                     FROM
                      (
                           SELECT aa.ItemOrKitID, aa.ItemVerKit, aa.ItemOrKitQualityID, aa.SumRealItemOrKitQuantity
                                 ,KI.[ItemOrKitQuantity],KI.[ItemOrKitId] AS KIItemOrKitId,cI.[ItemType], K.Multiplayer 
                            FROM
                            (
                                   SELECT ItemOrKitID, ItemVerKit, ItemOrKitQualityID, SUM(ItemOrKitQuantity) SumRealItemOrKitQuantity 
                                   FROM #TmpCMSRF1hd 
                                   WHERE ItemVerKit = 1 
                                   GROUP BY ItemOrKitID, ItemVerKit, ItemOrKitQualityID
                            ) aa
                            INNER JOIN [dbo].[cdlKits]    K
                              ON aa.ItemOrKitID = K.ID
                            INNER JOIN [dbo].[cdlKitsItems]    KI
                              ON aa.ItemOrKitID = KI.cdlKitsId
                            INNER JOIN cdlItems   cI
                              ON KI.[ItemOrKitId] = cI.ID 
                            WHERE cI.ItemType='CPE' OR cI.ItemType='CPV'
                      ) bbb
               ) vvv
           )
           xxx
           -- ============================================================================
           DECLARE @PocetSnItemTabTmpCMSOChd INT

           SELECT @PocetSnItemTabTmpCMSOChd = SumRealItemOrKitQuantity
           FROM 
           (
                 SELECT aaa.ItemOrKitID, aaa.ItemVerKit, aaa.ItemOrKitQualityID, SumRealItemOrKitQuantity  FROM
                 (
                    SELECT aa.ItemOrKitID, aa.ItemVerKit, aa.ItemOrKitQualityID, aa.SumRealItemOrKitQuantity FROM
                    (
                           SELECT ItemOrKitID, ItemVerKit, ItemOrKitQualityID, SUM(ItemOrKitQuantity) SumRealItemOrKitQuantity 
                           FROM #TmpCMSRF1hd 
                           WHERE ItemVerKit = 0
                           GROUP BY ItemOrKitID, ItemVerKit, ItemOrKitQualityID
                    ) aa
                    INNER JOIN cdlItems   cI
                         ON aa.ItemOrKitID = cI.ID 
                    WHERE cI.ItemType='CPE' OR cI.ItemType = 'CPV'
                  ) aaa
            ) x
           ---- ============================================================================

           -- SELECT @PocetSnCelkemTabTmpCMSOCsn '@PocetSnCelkemTabTmpCMSOCsn',ISNULL(@PocetSnItemTabTmpCMSOChd,0) '@PocetSnItemTabTmpCMSOChd',ISNULL(@PocetSnKitTabTmpCMSOChd,0) '@PocetSnKitTabTmpCMSOChd'
           -- SELECT ISNULL(@PocetSnItemTabTmpCMSOChd,0) + ISNULL(@PocetSnKitTabTmpCMSOChd,0)

           -- -- ============================================================================

            DECLARE @SeznamItems AS nvarchar(max)       -- zde se zapisují itemy (CPE) nebo Kity, které mají problém s počtem SN (SN může přebývat nebo scházet)
            SET @SeznamItems = 'MessageId = ' + CAST(@myMessageId AS  nvarchar(50)) +'<br />'

            IF ISNULL(@PocetSnCelkemTabTmpCMSOCsn,0)<>(ISNULL(@PocetSnItemTabTmpCMSOChd,0) + ISNULL(@PocetSnKitTabTmpCMSOChd,0))
            BEGIN

            -- 1.  Items
               DECLARE @seznamItemsOnly as varchar(max)  -- sem se zapisuje seznam jen Itemů, které mají problém s počtem SN (SN může přebývat nebo scházet)
               SET @seznamItemsOnly = 'ITEMY: '

               SELECT @seznamItemsOnly = @seznamItemsOnly + CAST(hd.ItemOrKitID AS varchar(50))  + ', '  --, hd.ItemVerKit, hd.ItemOrKitQualityID
               FROM #TmpCMSRF1hd         hd
               INNER JOIN cdlItems      cI
                    ON hd.ItemOrKitID = cI.ID 
               LEFT OUTER JOIN  (SELECT SUMA, ItemOrKitID, ItemVerKit, ItemOrKitQualityID
                            FROM (
                                           SELECT SUM(SUMAsn1) SUMA, ItemOrKitID, ItemVerKit, ItemOrKitQualityID
                                           FROM
                                           (
                                                 SELECT SUM(1) SUMAsn1, ItemOrKitID, ItemVerKit, ItemOrKitQualityID 
                                                                        FROM  #TmpCMSRF1sn 
                                                                        WHERE RTRIM(SN1)<>'' AND ItemVerKit = 0   -- itemy
                                                                        GROUP BY ItemOrKitID, ItemVerKit, ItemOrKitQualityID
                                                 UNION ALL
                                                 SELECT SUM(1) SUMAsn1, ItemOrKitID, ItemVerKit, ItemOrKitQualityID 
                                                                        FROM  #TmpCMSRF1sn 
                                                                        WHERE RTRIM(SN2)<>''  AND ItemVerKit = 0   -- itemy
                                                                        GROUP BY ItemOrKitID, ItemVerKit, ItemOrKitQualityID
                                                                        
                                           )        TmpSN
                                           GROUP BY ItemOrKitID, ItemVerKit, ItemOrKitQualityID
                                   ) b
                           ) sn
                    ON hd.ItemOrKitID =sn.ItemOrKitID AND  hd.ItemVerKit= sn.ItemVerKit AND hd.ItemOrKitQualityID =sn.ItemOrKitQualityID
               WHERE hd.ItemVerKit = 0 AND (cI.ItemType='CPE' OR cI.ItemType='CPV') AND hd.ItemOrKitQuantity<>ISNULL(sn.Suma ,0)

            -- 2. Kits
               DECLARE @seznamKitsOnly as varchar(max)   -- sem se zapisuje seznam jen Kitů, které mají problém s počtem SN (SN může přebývat nebo scházet)
               SET @seznamKitsOnly = 'KITY: '

                 SELECT @seznamKitsOnly = @seznamKitsOnly +CAST(hd.ItemOrKitID AS varchar(50))  + ' '
                 FROM
                 (
                 SELECT  y.ItemOrKitID, y.ItemVerKit, y.ItemOrKitQualityID, y.NASOBENI, sn.SUMA
                   FROM (
                            SELECT  x.ItemOrKitID, x.ItemVerKit, x.ItemOrKitQualityID, SUM(x.NASOBENI) NASOBENI
                            FROM (
                                   SELECT bbb.ItemOrKitID, bbb.ItemVerKit, bbb.ItemOrKitQualityID, bbb.SumRealItemOrKitQuantity,bbb.[ItemOrKitQuantity]
                                         ,KIItemOrKitId
                                         ,bbb.SumRealItemOrKitQuantity*bbb.[ItemOrKitQuantity]*bbb.Multiplayer  NASOBENI -- výpočet počtu SN PocetSN=RealněDodaneMnozstviKitu*PocetMnozstviItemuvKitu*KoeficientNasobeni
                                   FROM
                                   (
                                         SELECT aa.ItemOrKitID, aa.ItemVerKit, aa.ItemOrKitQualityID, aa.SumRealItemOrKitQuantity
                                               ,KI.[ItemOrKitQuantity],KI.[ItemOrKitId] AS KIItemOrKitId,cI.[ItemType], K.Multiplayer 
                                          FROM
                                          (
                                                 SELECT ItemOrKitID, ItemVerKit, ItemOrKitQualityID, SUM(ItemOrKitQuantity) SumRealItemOrKitQuantity 
                                                 FROM #TmpCMSRF1hd 
                                                 WHERE ItemVerKit = 1 
                                                 GROUP BY ItemOrKitID, ItemVerKit, ItemOrKitQualityID
                                          ) aa
                                          INNER JOIN [dbo].[cdlKits]         K      -- napojení na číselník kitů, abychom získali koeficient násobení
                                            ON aa.ItemOrKitID = K.ID
                                          INNER JOIN [dbo].[cdlKitsItems]    KI     -- napojení na itemy obsažené v kitu, abychom se uměli napojit na číselník itemů
                                            ON aa.ItemOrKitID = KI.cdlKitsId
                                          INNER JOIN cdlItems                cI     -- napojení na číselník itemů, abychom získali jen CPE
                                            ON KI.[ItemOrKitId] = cI.ID 
                                          WHERE cI.ItemType='CPE' OR cI.ItemType='CPV'
                                   ) bbb
                             ) x 
                             GROUP BY x.ItemOrKitID, x.ItemVerKit, x.ItemOrKitQualityID
                      ) y
                      INNER JOIN  (SELECT SUMA, ItemOrKitID, ItemVerKit, ItemOrKitQualityID
                            FROM (
                                  SELECT SUMx SUMA, ItemOrKitID, ItemVerKit, ItemOrKitQualityID                               -- tenhle select se stal vývojem asi nadbytečný, ale nechci ho nyní vyhazovat, abych něco nezvoral a tím posunul čas
                                  FROM (
                                           SELECT SUM(SUMAsn1) SUMx, ItemOrKitID, ItemVerKit, ItemOrKitQualityID              -- součet 
                                           FROM
                                           (
                                                 SELECT SUM(1) SUMAsn1, ItemOrKitID, ItemVerKit, ItemOrKitQualityID 
                                                                        FROM  #TmpCMSRF1sn 
                                                                        WHERE RTRIM(SN1)<>'' AND ItemVerKit = 1               -- jen kity a vyplněné SN1
                                                                        GROUP BY ItemOrKitID, ItemVerKit, ItemOrKitQualityID
                                                 UNION ALL
                                                 SELECT SUM(1) SUMAsn1, ItemOrKitID, ItemVerKit, ItemOrKitQualityID 
                                                                        FROM  #TmpCMSRF1sn 
                                                                        WHERE RTRIM(SN2)<>''  AND ItemVerKit = 1              -- jen kity a vyplněné SN2
                                                                        GROUP BY ItemOrKitID, ItemVerKit, ItemOrKitQualityID
                                           )        TmpSN
                                           GROUP BY ItemOrKitID, ItemVerKit, ItemOrKitQualityID
                                       ) b
                                 )bb
                           ) sn
                             ON y.ItemOrKitID =sn.ItemOrKitID AND  y.ItemVerKit= sn.ItemVerKit AND y.ItemOrKitQualityID =sn.ItemOrKitQualityID
                    ) hd
                    WHERE  hd.NASOBENI <> hd.SUMA

                 SET @SeznamItems = @seznamItemsOnly +'<br />' + @seznamKitsOnly
                 
                 SET @myAdresaLogistika = @myAdresaLogistika+';michal.rezler@upc.cz;jaroslav.tajbl@upc.cz'
                 --SET @myAdresaLogistika = ';michal.rezler@upc.cz;jaroslav.tajbl@upc.cz'
                 SET @sub = 'FENIX - RF1 INFO' + ' Databáze: '+ISNULL(@myDatabaseName,'')
                 SET @msg = 'Program [dbo].[prRORF1ins](Refurbished Confirmation)<br /> Nesouhlasí počty SN s reálným množstvím <br />' +@SeznamItems   
                 EXEC @result = msdb.dbo.sp_send_dbmail
                		@profile_name = 'Automat', --@MailProfileName
                		@recipients = @myAdresaLogistika,
                		@subject = @sub,
                		@body = @msg,
                		@body_format = 'HTML'

            END

           -- ================== toto je nově ================ END ===============================
      END      
			-- SN konec

      BEGIN -- ============================ Zpracování ===============================
         SELECT  @myPocet = COUNT(*) 
         FROM [dbo].[CommunicationMessagesRefurbishedOrder]
         WHERE [MessageId]=@myMessageId AND [MessageTypeId] = @myMessageTypeId AND  MessageDescription = @myMessageTypeDescription

         IF @mOK=1 AND  (@myPocet = 0 OR  @myPocet IS NULL)
         BEGIN  -- @mOK=1
            IF (SELECT CURSOR_STATUS('global','myCursorCMSOChd')) >= -1
             BEGIN
                      DEALLOCATE myCursorCMSOChd
             END
             SET @myError     = 0 
             SET @myIdentity  = 0
             SET @myIdentityx = 0

             BEGIN TRAN
             DECLARE myCursorCMSOChd CURSOR 
             FOR  
             SELECT 
              x.ID                       
             ,x.MessageID                
             ,x.MessageTypeID            
             ,x.MessageTypeDescription   
             ,x.RefurbishedOrderID       
             ,x.CustomerID               
             ,x.CustomerDescription      
             ,x.DateOfShipment           
             ,x.ItemVerKit               
             ,x.ItemOrKitID              
             ,x.ItemOrKitDescription     
             ,x.ItemOrKitQuantity        
             ,x.ItemOrKitUnitOfMeasureID 
             ,x.ItemOrKitUnitOfMeasure   
             ,x.ItemOrKitQualityID       
             ,x.ItemOrKitQuality         
             ,x.NDReceipt                
             FROM #TmpCMSRF1hd x ORDER BY MessageID, MessageTypeID, CustomerID, DateOfShipment, ItemVerKit, ItemOrKitID

             OPEN myCursorCMSOChd
             FETCH NEXT FROM myCursorCMSOChd INTO                 
                    @myID,@myMessageID,@myMessageTypeID,@myMessageTypeDescription,@myRefurbishedOrderID,@myCustomerID,@myCustomerDescription,@myDateOfShipment
                   ,@myItemVerKit,@myItemOrKitID,@myItemOrKitDescription,@myItemOrKitQuantity,@myItemOrKitUnitOfMeasureID,@myItemOrKitUnitOfMeasure
                   ,@myItemOrKitQualityID,@myItemOrKitQuality,@myNDReceipt

             SELECT @myKeyRefurbishedOrderID = -1, @myKeyMessageID = -1, @myKeyCustomerID = -1

             WHILE @@FETCH_STATUS = 0
             BEGIN  -- @@FETCH_STATUS    
                   IF @myKeyRefurbishedOrderID <> @myRefurbishedOrderID OR @myKeyCustomerID <> @myCustomerID OR @myKeyMessageID <> @myMessageID
                    BEGIN
                       SELECT @myKeyRefurbishedOrderID = @myRefurbishedOrderID , @myKeyCustomerID = @myCustomerID , @myKeyMessageID = @myMessageID
                       SELECT @myStockId = [StockId] FROM [dbo].[CommunicationMessagesRefurbishedOrder] WHERE ID = @myRefurbishedOrderID

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
                            VALUES
                                  ( @myMessageID              
                                  , @myMessageTypeID          
                                  , @myMessageTypeDescription 
                                  , @myDateOfShipment         
                                  , @myRefurbishedOrderID     
                                  , @myCustomerID             
                                  , 0                         
                                  , 1                         
                                  , @myToDay                  
                                  , 0                         
                                  )
                                                  
                        SET @myError = @myError + @@ERROR
                        SET @myIdentity = @@IDENTITY  
                    END

                    IF @myError=0 AND @myIdentity>0
                    BEGIN  -- 1
                        SET @myItemSNs=''
                        SELECT @myItemSNs = SN FROM (
                        SELECT DISTINCT LEFT(r.ResourceName , LEN(r.ResourceName)-1) [SN], A.[ItemOrKitQualityID], A.[MessageID], A.[ItemVerKit],A.ItemOrKitID
                        FROM #TmpCMSRF1sn A
                         CROSS APPLY (SELECT CAST([SN1] AS VARCHAR(50))+ ', ' + CAST([SN2] AS VARCHAR(50))+ '; '   FROM #TmpCMSRF1sn  B
                             WHERE A.[ItemOrKitQualityID] = B.[ItemOrKitQualityID] AND A.[MessageID] =  B.[MessageID] AND A.[ItemVerKit] = B.[ItemVerKit] AND A.ItemOrKitID = B.ItemOrKitID
                             FOR XML PATH('')
                             ) r (ResourceName) 
                             ) AA 
                             WHERE  AA.[ItemOrKitQualityID] = @myItemOrKitQualityID AND AA.[MessageID] = @myMessageID AND AA.[ItemVerKit] = @myItemVerKit AND AA.ItemOrKitID = @myItemOrKitID

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
                                        ,[ModifyUserId])
                                  VALUES
                                        (@myIdentity                  ---   <CMSOId, int,>
                                        ,@myItemVerKit              ---   <ItemVerKit, int,>
                                        ,@myItemOrKitID             ---   <ItemOrKitID, int,>
                                        ,@myItemOrKitDescription    ---   <ItemOrKitDescription, nvarchar(100),>
                                        ,@myItemOrKitQuantity       ---   <ItemOrKitQuantity, numeric(18,3),>
                                        ,@myItemOrKitUnitOfMeasureId    ---   <ItemOrKitUnitOfMeasureId, int,>
                                        ,@myItemOrKitUnitOfMeasure    ---   <ItemOrKitUnitOfMeasure, nvarchar(50),>
                                        ,@myItemOrKitQualityID      ---   <ItemOrKitQualityId, int,>
                                        ,@myItemOrKitQuality       ---   <ItemOrKitQualityCode, nvarchar(50),> 
                                        ,NULL                       ---   <IncotermsId, int,>
                                        ,NULL                       ---   <IncotermDescription, nvarchar(50),>
                                        ,@myNDReceipt               ---   <NDReceipt, nvarchar(50),>
                                        ,@myItemSNs                 ---   <KitSNs, varchar(max),>
                                        ,1                          ---   <IsActive, bit,>
                                        ,@myToDay                   ---   <ModifyDate, datetime,>
                                        ,0                                    ---   <ModifyUserId, int,>
                                        )
                        SET @myError = @myError + @@ERROR
                        SET @myIdentityx = @@IDENTITY 

                        IF @myError=0 AND @myIdentityx>0
                        BEGIN -- @myIdentityx
                             INSERT INTO [dbo].[CommunicationMessagesRefurbishedOrderConfirmationSerNumSent]
                                        ([RefurbishedItemsOrKitsID]
                                        ,[SN1]
                                        ,[SN2]
                                        ,[IsActive]
                                        ,[ModifyDate]
                                        ,[ModifyUserId])
                              SELECT @myIdentityx, SN1, SN2, 1,@myToDay,0 FROM #TmpCMSRF1sn AA  
                              WHERE 
                              AA.[ItemOrKitQualityID] = @myItemOrKitQualityID AND AA.[MessageID] = @myMessageID AND 
                              AA.[ItemVerKit]         = @myItemVerKit         AND AA.ItemOrKitID = @myItemOrKitID

                             SET @myError = @myError + @@ERROR

                              IF @myError=0
                              BEGIN  -- ===== CARDS =====
                                SET @myPocet = 0
                                SELECT @myPocet = COUNT(*) FROM [dbo].[CardStockItems] 
                                WHERE  [ItemVerKit]       = @myItemVerKit 
                                   AND [ItemOrKitId]      = @myItemOrKitID 
                                   AND [ItemOrKitQuality] = @myItemOrKitQualityID 
                                   AND [IsActive] = 1 AND [StockId] = @myStockId 
                                   AND [ItemOrKitUnitOfMeasureId] = @myItemOrKitUnitOfMeasureId

                                IF @myPocet = 0 OR @myPocet IS NULL
                                BEGIN  -- karta neni
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
                                          VALUES
                                                ( @myItemVerKit                    -- <ItemVerKit, bit,>
                                                , @myItemOrKitID                   -- <ItemOrKitId, int,>
                                                , @myItemOrKitUnitOfMeasureId      -- <ItemOrKitUnitOfMeasureId, int,>
                                                , @myItemOrKitQualityID            -- <ItemOrKitQuality, int,>
                                                , 0                                -- <ItemOrKitFree, numeric(18,3),>
                                                , @myItemOrKitQuantity             -- <ItemOrKitUnConsilliation, numeric(18,3),>
                                                , 0                                -- <ItemOrKitReserved, numeric(18,3),>
                                                , 0                                -- <ItemOrKitReleasedForExpedition, numeric(18,3),>
                                                , 0                                -- <ItemOrKitExpedited, numeric(18,3),>
                                                , @myStockId                       -- <StockId, int,>
                                                , 1                                -- <IsActive, bit,>
                                                , @myToDay                         -- <ModifyDate, datetime,>
                                                , 0                                -- <ModifyUserId, int,>
                                                )                    
                                     SET @myError = @myError + @@ERROR                                                                          
                                END    -- karta neni
                                ELSE
                                BEGIN  -- karta je
                                  IF @myPocet = 1
                                  BEGIN
                                     SELECT @myPocet = ID FROM [dbo].[CardStockItems] 
                                     WHERE  [ItemVerKit]   = @myItemVerKit 
                                        AND [ItemOrKitId]  = @myItemOrKitID 
                                        AND [ItemOrKitQuality] = @myItemOrKitQualityID 
                                        AND [IsActive] = 1 AND [StockId] = @myStockId  
                                        AND [ItemOrKitUnitOfMeasureId] = @myItemOrKitUnitOfMeasureId
                                     IF @myPocet IS NOT NULL
                                     UPDATE [dbo].[CardStockItems] SET [ItemOrKitUnConsilliation] = ISNULL([ItemOrKitUnConsilliation],0) + @myItemOrKitQuantity
                                     WHERE ID = @myPocet  -- v tomto případě ID

                                     SET @myError = @myError + @@ERROR 
                                  END
                                END       -- karta je

                                -- ========== 2014-10-22 =========
                                IF @myItemVerKit = 1 
                                BEGIN
                                    -- je to kit, je třeba zpracovat karty itemů v kitu
                                    -- 1.  dohrat karty, ktere nejsou
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
                                                ,[MeasuresId]
                                                ,[KitQualitiesId] 
                                                ,0,0,0,0,0
                                                ,2,1                       --
                                                ,@myToDay                             --
                                                ,0                        --
                                               FROM (
                                                     SELECT cKI.[ItemVerKit], cKI.[ItemOrKitId], cK.KitQualitiesId, cI.[MeasuresId] 
                                                     FROM [dbo].[cdlKitsItems]      cKI
                                                     INNER JOIN [dbo].[cdlKits]     cK
                                                         ON cKI.cdlKitsId = cK.ID
                                                     INNER JOIN [dbo].[cdlItems]    cI
                                                         ON cKI.ItemOrKitId = cI.ID
                                                     WHERE cK.IsActive=1 AND [cdlKitsId] = @myItemOrKitID AND cKI.[ItemVerKit] = 0  -- Items
                                                     ) aa
                                     WHERE  CAST([ItemVerKit] AS CHAR(50))+ CAST([ItemOrKitID] AS CHAR(50))+ CAST([MeasuresId] AS CHAR(50))+
                                            CAST([KitQualitiesId] AS CHAR(50)) 
                                            NOT IN 
                                            (SELECT CAST([ItemVerKit] AS CHAR(50))+ CAST([ItemOrKitID] AS CHAR(50))+ CAST([ItemOrKitUnitOfMeasureId] AS CHAR(50))+
                                            CAST([ItemOrKitQuality] AS CHAR(50)) FROM [dbo].[CardStockItems] WHERE IsActive=1)
                                     SET @myError    = @myError + @@ERROR

/*  2015-01-19 --  po poradě s D.Vavrou za účasti RM WeM zaremováno
                                    --UPDATE [dbo].[CardStockItems] 
                                    --SET [ItemOrKitUnConsilliation] = ISNULL([ItemOrKitUnConsilliation],0) + aa.ItemOrKitQuantity * @myItemOrKitQuantity
                                    --FROM [dbo].[CardStockItems]  CSI
                                    --INNER JOIN (
                                    --    SELECT cKI.[ItemVerKit], cKI.[ItemOrKitId], cK.KitQualitiesId, cI.[MeasuresId], cKI.[ItemOrKitQuantity]
                                    --    FROM [dbo].[cdlKitsItems]      cKI
                                    --    INNER JOIN [dbo].[cdlKits]     cK
                                    --        ON cKI.cdlKitsId = cK.ID
                                    --    INNER JOIN [dbo].[cdlItems]    cI
                                    --        ON cKI.ItemOrKitId = cI.ID
                                    --    WHERE cK.IsActive=1 AND [cdlKitsId] = @myItemOrKitID AND cKI.[ItemVerKit] = 0  -- Items  !!
                                    --    ) aa
                                    --   ON   cSI.ItemOrKitId = aa.ItemOrKitId AND cSI.[ItemOrKitQuality] = aa.KitQualitiesId 
                                    --   AND  cSI.ItemOrKitUnitOfMeasureId = aa.MeasuresId AND cSI.[ItemVerKit] = aa.[ItemVerKit]

                                    --   SET @myError    = @myError + @@ERROR
*/
                                END



                              END    -- ===== CARDS =====
                         END   -- @myIdentityx
 
                     END  -- 1

                     FETCH NEXT FROM myCursorCMSOChd INTO                 
                             @myID,@myMessageID,@myMessageTypeID,@myMessageTypeDescription,@myRefurbishedOrderID,@myCustomerID,@myCustomerDescription,@myDateOfShipment
                            ,@myItemVerKit,@myItemOrKitID,@myItemOrKitDescription,@myItemOrKitQuantity,@myItemOrKitUnitOfMeasureID,@myItemOrKitUnitOfMeasure
                            ,@myItemOrKitQualityID,@myItemOrKitQuality,@myNDReceipt

             END    -- @@FETCH_STATUS

             CLOSE myCursorCMSOChd;
             DEALLOCATE myCursorCMSOChd;

                      IF @myError = 0
                      BEGIN
                         IF @@TRANCOUNT > 0 COMMIT TRAN
                         SET @sub = 'FENIX - Refurbished   -  Oznámení o příchodu RF1- Databáze: '+ ISNULL( @myDatabaseName,'')
                         SET @msg = 'Žádost o vyjádření ke konfirmaci ID = '+CAST(@myIdentity AS VARCHAR(50))     
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
      END
    END  -- hlavni
    ELSE
    BEGIN  -- hlavni
    SELECT @myPocet = MessageId FROM (
         SELECT TOP 1 C.MessageId FROM  CommunicationMessagesRefurbishedOrderConfirmation   C
         INNER JOIN #TmpCMSRF1hd H ON C.MessageId = H.MessageId
    ) aa
       SELECT @ReturnValue=1, @ReturnMessage='Chyba'
       SET @sub = 'FENIX - RF1 CHYBA - Databáze: '+ ISNULL( @myDatabaseName,'')
       SET @msg = 'Program [dbo].[prRORF1ins]; MessageID  jiz byl zapsan ' + CAST(@myPocet AS VARCHAR(50))
       EXEC @result = msdb.dbo.sp_send_dbmail
      		@profile_name = 'Automat', --@MailProfileName
      		@recipients = 'jaroslav.tajbl@upc.cz;michal.rezler@upc.cz',
      		@subject = @sub,
      		@body = @msg,
      		@body_format = 'HTML'

    END     -- hlavni
END TRY
BEGIN CATCH
       IF @@TRANCOUNT > 0 ROLLBACK TRAN
    
       SELECT @ReturnValue=1, @ReturnMessage='Chyba'
       SET @sub = 'FENIX - RF1 CHYBA - Databáze: '+ ISNULL( @myDatabaseName,'')
       SET @msg = 'Program [dbo].[prRORF1ins]; '  + ISNULL(ERROR_MESSAGE(),'') + ISNULL(CAST(ERROR_NUMBER() AS VARCHAR(50)),'') 
       EXEC @result = msdb.dbo.sp_send_dbmail
      		@profile_name = 'Automat', --@MailProfileName
      		@recipients = 'jaroslav.tajbl@upc.cz;michal.rezler@upc.cz',
      		@subject = @sub,
      		@body = @msg,
      		@body_format = 'HTML'
END CATCH
END








SET ANSI_NULLS ON


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[prRORF1ins] TO [FenixW]
    AS [dbo];

