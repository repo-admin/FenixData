

CREATE PROCEDURE [dbo].[prKiSHCins_PredZmenou20160104] 
      @par1 as XML,

	   @ReturnValue     int            = -1 OUTPUT,
	   @ReturnMessage   nvarchar(2048) = null OUTPUT
 AS
BEGIN
-- =================================================================================================
-- Created by   : Weczerek Max
-- Created date : 2014-08-31
--                2014-09-30, 2014-10-21, 2014-11-06
--                2014-11-12, 2014-11-13, 2014-11-19, 2014-11-24, 2015-01-21, 2015-01-27, 2015-08-13
-- Description  : 
-- =================================================================================================
/*
Fáze S1 -  z ND přijde MESSAGE, viz níže

Kontroluje data
Aktualizuje karty

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
             ,@myAnnouncement [nvarchar](max)

             SET @myAnnouncement = ''
      DECLARE 
             @myKeyShipmentOrderID int,
             @myKeyItemVerKit int,
	          @myKeyItemOrKitID int,
             @myKeyDestinationPlacesId int,
             @myKeyDestinationPlacesContactsId int,
             @myKeyDateOfExpedition  nvarchar(20),
             @myKeycdlStocksName  nvarchar(100),
             @myIdentityx AS INT

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
      IF OBJECT_ID('tempdb..#TmpCMSOChd','table') IS NOT NULL DROP TABLE #TmpCMSOChd
      IF OBJECT_ID('tempdb..#TmpCMSOCsn','table') IS NOT NULL DROP TABLE #TmpCMSOCsn

      EXEC sp_xml_preparedocument @hndl OUTPUT, @par1
      SELECT x.[ID], x.[MessageID], x.[MessageTypeID], x.[MessageTypeDescription], x.[RequiredDateOfReceipt], x.[ShipmentOrderID], x.[HeliosOrderID]
             ,x.[CustomerID], x.[CustomerName], x.[CustomerAddress1], x.[CustomerAddress2], x.[CustomerAddress3], x.[CustomerCity], x.[CustomerZipCode]
             ,x.[CustomerCountryISO], x.[ContactID], x.[ContactTitle], x.[ContactFirstName], x.[ContactLastName], x.[ContactPhoneNumber1], x.[ContactPhoneNumber2]
             ,x.[ContactFaxNumber], x.[ContactEmail], x.[SingleOrMaster], x.[HeliosOrderRecordID], x.[ItemOrKitID], x.[ItemOrKitDescription], x.[ItemOrKitQuantity]
             ,x.[ItemOrKitUnitOfMeasureID], x.[ItemOrKitUnitOfMeasure], x.[ItemOrKitQualityID], x.[ItemOrKitQuality], x.[ItemVerKit], x.[IncotermID]
             ,x.[IncotermDescription], x.[RealDateOfDelivery], x.[RealItemOrKitQuantity], x.[RealItemOrKitQualityID], x.[RealItemOrKitQuality], x.[Status]
      INTO #TmpCMSOChd
      FROM OPENXML (@hndl, '/NewDataSet/CommunicationMessagesShipmentConfirmation/itemsOrKits/itemOrKit',2)
      WITH (
      ID                             int           '../../ID',
      MessageID                      int           '../../MessageID',
      MessageTypeID                  int           '../../MessageTypeID',
      MessageTypeDescription         nvarchar(150) '../../MessageTypeDescription',
      MessageDateOfShipment          nvarchar(50)  '../../MessageDateOfShipment',
      RequiredDateOfReceipt          nvarchar(150) '../../RequiredDateOfReceipt',
      ShipmentOrderID                int           '../../ShipmentOrderID',
      HeliosOrderID                  int           '../../HeliosOrderID',
      CustomerID                     int           '../../CustomerID',
      CustomerName                   nvarchar(150) '../../CustomerName',
      CustomerAddress1               nvarchar(150) '../../CustomerAddress1',
      CustomerAddress2               nvarchar(150) '../../CustomerAddress2',
      CustomerAddress3               nvarchar(150) '../../CustomerAddress3',
      CustomerCity                   nvarchar(150) '../../CustomerCity',
      CustomerZipCode                nvarchar(150) '../../CustomerZipCode',
      CustomerCountryISO             nvarchar(150) '../../CustomerCountryISO',
      ContactID                      int           '../../ContactID',
      ContactTitle                   nvarchar(150) '../../ContactTitle',
      ContactFirstName               nvarchar(150) '../../ContactFirstName',
      ContactLastName                nvarchar(150) '../../ContactLastName',
      ContactPhoneNumber1            nvarchar(150) '../../ContactPhoneNumber1',
      ContactPhoneNumber2            nvarchar(150) '../../ContactPhoneNumber2',
      ContactFaxNumber               nvarchar(150) '../../ContactFaxNumber',
      ContactEmail                   nvarchar(150) '../../ContactEmail',
      SingleOrMaster                 int           'SingleOrMaster',
      HeliosOrderRecordID            int           'HeliosOrderRecordID',
      ItemOrKitID                    int           'ItemOrKitID',
      ItemOrKitDescription           nvarchar(150) 'ItemOrKitDescription',
      ItemOrKitQuantity              numeric(18, 3)'ItemOrKitQuantity',
      ItemOrKitUnitOfMeasureID       nvarchar(150) 'ItemOrKitUnitOfMeasureID',
      ItemOrKitUnitOfMeasure         nvarchar(150) 'ItemOrKitUnitOfMeasure',
      ItemOrKitQualityID             int           'ItemOrKitQualityID',
      ItemOrKitQuality               nvarchar(150) 'ItemOrKitQuality',
      ItemVerKit                     int           'ItemVerKit',
      IncotermID                     int           'IncotermID',
      IncotermDescription            nvarchar(150) 'IncotermDescription',
      RealDateOfDelivery             nvarchar(150) 'RealDateOfDelivery',
      RealItemOrKitQuantity          numeric(18, 3)'RealItemOrKitQuantity',
      RealItemOrKitQualityID         int           'RealItemOrKitQualityID',
      RealItemOrKitQuality           nvarchar(150) 'RealItemOrKitQuality',
      Status                         nvarchar(150) 'Status'
      ) x
      ----
      SELECT y.SingleOrMaster, y.HeliosOrderRecordID,y.ItemOrKitQualityID,y.ItemVerKit, y.[ItemOrKitID], y.[SN1],y.[SN2]
      INTO #TmpCMSOCsn
      FROM OPENXML (@hndl, '/NewDataSet/CommunicationMessagesShipmentConfirmation/itemsOrKits/itemOrKit/ItemOrKitSNs/ItemSN',2)
      WITH (SingleOrMaster      int           '../../SingleOrMaster',
            HeliosOrderRecordID int           '../../HeliosOrderRecordID',
            ItemOrKitQualityID  int           '../../ItemOrKitQualityID',
            ItemVerKit          int           '../../ItemVerKit',
            ItemOrKitID         int           '../../ItemOrKitID',
            SN1                 nvarchar(150) '@SN1',
            SN2                 nvarchar(150) '@SN2'
            ) y
      EXEC sp_xml_removedocument @hndl

 
  

      SELECT @myMessageId              = CAST(a.MessageId AS VARCHAR(50)),
             @myMessageTypeId          = CAST(a.MessageTypeID AS VARCHAR(50)),
             @myMessageTypeDescription = a.MessageTypeDescription,
             @myShipmentOrderID        = a.ShipmentOrderID
       FROM (
             SELECT TOP 1 MessageId,MessageTypeID,MessageTypeDescription,ShipmentOrderID FROM #TmpCMSOChd Tmp
             ) a

---- ===========
      --SELECT * FROM #TmpCMSOChd
      --SELECT * FROM [dbo].[CommunicationMessagesShipmentOrdersSentItems] WHERE [CMSOId]=99
      --SELECT * FROM #TmpCMSOCsn
      --SELECT  @myShipmentOrderID '@myShipmentOrderID'
---- ===========   
         
   -- =======================================================================
   --        Kontrola úplnosti a správnosti dat
   -- =======================================================================
      BEGIN -- ============ Kontrola existence zdrojové message ======================
           SELECT @myPocet=COUNT(*) FROM [dbo].[CommunicationMessagesShipmentOrdersSent] WHERE ID = @myShipmentOrderID
           
           IF  @myPocet<>1
           BEGIN
                      SET @myMessage = 'NEEXISTUJE ID='+CAST(@myShipmentOrderID AS VARCHAR(50)) + ' v tabulce CommunicationMessagesShipmentOrdersSent'
                      EXEC [dbo].[prAppLogWriteNew] @Type='INFO', @Message =  @myMessage, @XmlMessage = NULL, @UserId = 0,@Source = 'prKiSHCins'
                                               , @ReturnValue = @myReturnValue,@ReturnMessage=@myReturnMessage
        
                      SET @sub = 'FENIX - Kontrola SHIPMENT CONFIRMATION  - kontrola existence zdrojové message' + ' Databáze: '+ISNULL(@myDatabaseName,'')
                      SET @msg = @myMessage
	     	 	          EXEC @result = msdb.dbo.sp_send_dbmail
	     	 	               @profile_name = 'Automat', --@MailProfileName
	     	 	               @recipients = @myAdresaLogistika,
                           @copy_recipients = @myAdresaProgramator,
	     	 	               @subject = @sub,
	     	 	               @body = @msg,
         	 	            @body_format = 'HTML'
        
                      SET @ReturnValue = 1
--SELECT @ReturnValue,  @ReturnMessage, 'A'
           END
      END
  
      BEGIN -- ============ Kontrola existence zboží proti objednávce ================
          SET @msg='' 
          SELECT @myPocet = COUNT(*)  FROM #TmpCMSOChd Tmp    
          SELECT @myPocetPolozekPomooc  = COUNT(*) 
          FROM [dbo].[CommunicationMessagesShipmentOrdersSentItems] 
          WHERE [CMSOId] = @myShipmentOrderID AND ISACTIVE=1

          IF @myPocet-@myPocetPolozekPomooc<>0
          BEGIN
                
                 SET @myMessage = 'NESOUHLASÍ počet položek objednávky s potvrzením závozu. ID objednávky='+ISNULL(CAST(@myShipmentOrderID AS VARCHAR(50)),'') +', POČET = '+CAST(@myPocetPolozekPomooc AS VARCHAR(50)) + ' v tabulce CommunicationMessagesShipmentOrdersSentItems'
                     + ',  Confirmace:  MessageId = '+CAST(@myMessageId AS VARCHAR(50))+', MessageType = '+CAST(@myMessageTypeId AS VARCHAR(50))+', MessageDescription = '+CAST(@myMessageTypeDescription  AS NVARCHAR(250)) +', POČET = '+CAST(@myPocet AS VARCHAR(50)) +
                     '<br />Pokračuji dále ve zpracování'
                 EXEC [dbo].[prAppLogWriteNew] @Type='INFO', @Message =  @myMessage, @XmlMessage = NULL, @UserId = 0,@Source = 'prKiSHCins'
                                          , @ReturnValue = @myReturnValue,@ReturnMessage=@myReturnMessage
                 --SET @mOK = 0
                 SET @msg = @myMessage
            
                 SET @sub = 'FENIX - Kontrola SHIPMENT CONFIRMATION  - kontrola počtu položek proti objednávce' + ' Databáze: '+ISNULL(@myDatabaseName,'')
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
                SELECT @myPocet = COUNT(*)  FROM #TmpCMSOChd Tmp
                SELECT @myPocetPolozekPomooc  = COUNT(*) 
                FROM #TmpCMSOChd           Tmp
                INNER JOIN  [dbo].[CommunicationMessagesShipmentOrdersSentItems]   I
                      ON I.[CMSOId] = @myShipmentOrderID AND Tmp.ItemOrKitID= I.ItemOrKitID AND I.ItemVerKit = Tmp.ItemVerKit AND I.ItemOrKitQuantity = Tmp.ItemOrKitQuantity
                WHERE I.ISACTIVE=1
 
                IF @myPocet-@myPocetPolozekPomooc<>0
                BEGIN
                       SET @myMessage = 'NESOUHLASÍ počet Items položek objednávky nebo množství objednané s potvrzením závozu. ID objednávky='+CAST(@myShipmentOrderID AS VARCHAR(50)) +
                           + ',  Confirmace:  MessageId = '+CAST(@myMessageId AS VARCHAR(50))+', MessageType = '+CAST(@myMessageTypeId AS VARCHAR(50))+', MessageDescription = '+CAST(@myMessageTypeDescription  AS NVARCHAR(250)) 
                           +'<br />Pokračuji dále ve zpracování'
                       EXEC [dbo].[prAppLogWriteNew] @Type='INFO', @Message =  @myMessage, @XmlMessage = NULL, @UserId = 0,@Source = 'prKiSHCins'
                                                , @ReturnValue = @myReturnValue,@ReturnMessage=@myReturnMessage
                       --SET @mOK = 0
                       SET @msg = @myMessage
                  
                       SET @sub = 'FENIX - Kontrola SHIPMENT CONFIRMATION  - kontrola ItemOrKitID položek proti objednávce' + ' Databáze: '+ISNULL(@myDatabaseName,'')
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

      BEGIN -- =========== KOntrola počtu SN ve vztahu k itemu (CPE) =============  2014-11-12

           -- ================== toto je nově ================ START ===============================
           DECLARE @PocetSnCelkemTabTmpCMSOCsn INT

           SELECT @PocetSnCelkemTabTmpCMSOCsn = SUM(SUMx)  
           FROM (
                 SELECT SUM(SUMAsn1) SUMx, ItemOrKitID, ItemVerKit, ItemOrKitQualityID
                 FROM
                 (
                       SELECT SUM(1) SUMAsn1, ItemOrKitID, ItemVerKit, ItemOrKitQualityID 
                                              FROM  #TmpCMSOCsn 
                                              WHERE RTRIM(SN1)<>''
                                              GROUP BY ItemOrKitID, ItemVerKit, ItemOrKitQualityID
                       UNION ALL
                       SELECT SUM(1) SUMAsn1, ItemOrKitID, ItemVerKit, ItemOrKitQualityID 
                                              FROM  #TmpCMSOCsn 
                                              WHERE RTRIM(SN2)<>''
                                              GROUP BY ItemOrKitID, ItemVerKit, ItemOrKitQualityID
                                              
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
                                   SELECT ItemOrKitID, ItemVerKit, ItemOrKitQualityID, SUM(RealItemOrKitQuantity) SumRealItemOrKitQuantity 
                                   FROM #TmpCMSOChd 
                                   WHERE ItemVerKit = 1 
                                   GROUP BY ItemOrKitID, ItemVerKit, ItemOrKitQualityID
                            ) aa
                            INNER JOIN [dbo].[cdlKits]    K
                              ON aa.ItemOrKitID = K.ID
                            INNER JOIN [dbo].[cdlKitsItems]    KI
                              ON aa.ItemOrKitID = KI.cdlKitsId
                            INNER JOIN cdlItems   cI
                              ON KI.[ItemOrKitId] = cI.ID 
                            WHERE cI.ItemType='CPE' 
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
                           SELECT ItemOrKitID, ItemVerKit, ItemOrKitQualityID, SUM(RealItemOrKitQuantity) SumRealItemOrKitQuantity 
                           FROM #TmpCMSOChd 
                           WHERE ItemVerKit = 0
                           GROUP BY ItemOrKitID, ItemVerKit, ItemOrKitQualityID
                    ) aa
                    INNER JOIN cdlItems   cI
                         ON aa.ItemOrKitID = cI.ID 
                    WHERE cI.ItemType='CPE' 
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
               FROM #TmpCMSOChd         hd
               INNER JOIN cdlItems      cI
                    ON hd.ItemOrKitID = cI.ID 
               LEFT OUTER JOIN  (SELECT SUMA, ItemOrKitID, ItemVerKit, ItemOrKitQualityID
                            FROM (
                                           SELECT SUM(SUMAsn1) SUMA, ItemOrKitID, ItemVerKit, ItemOrKitQualityID
                                           FROM
                                           (
                                                 SELECT SUM(1) SUMAsn1, ItemOrKitID, ItemVerKit, ItemOrKitQualityID 
                                                                        FROM  #TmpCMSOCsn 
                                                                        WHERE RTRIM(SN1)<>'' AND ItemVerKit = 0   -- itemy
                                                                        GROUP BY ItemOrKitID, ItemVerKit, ItemOrKitQualityID
                                                 UNION ALL
                                                 SELECT SUM(1) SUMAsn1, ItemOrKitID, ItemVerKit, ItemOrKitQualityID 
                                                                        FROM  #TmpCMSOCsn 
                                                                        WHERE RTRIM(SN2)<>''  AND ItemVerKit = 0   -- itemy
                                                                        GROUP BY ItemOrKitID, ItemVerKit, ItemOrKitQualityID
                                                                        
                                           )        TmpSN
                                           GROUP BY ItemOrKitID, ItemVerKit, ItemOrKitQualityID
                                   ) b
                           ) sn
                    ON hd.ItemOrKitID =sn.ItemOrKitID AND  hd.ItemVerKit= sn.ItemVerKit AND hd.ItemOrKitQualityID =sn.ItemOrKitQualityID
               WHERE hd.ItemVerKit = 0 AND cI.ItemType='CPE' AND hd.RealItemOrKitQuantity<>ISNULL(sn.Suma ,0)

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
                                                 SELECT ItemOrKitID, ItemVerKit, ItemOrKitQualityID, SUM(RealItemOrKitQuantity) SumRealItemOrKitQuantity 
                                                 FROM #TmpCMSOChd 
                                                 WHERE ItemVerKit = 1 
                                                 GROUP BY ItemOrKitID, ItemVerKit, ItemOrKitQualityID
                                          ) aa
                                          INNER JOIN [dbo].[cdlKits]         K      -- napojení na číselník kitů, abychom získali koeficient násobení
                                            ON aa.ItemOrKitID = K.ID
                                          INNER JOIN [dbo].[cdlKitsItems]    KI     -- napojení na itemy obsažené v kitu, abychom se uměli napojit na číselník itemů
                                            ON aa.ItemOrKitID = KI.cdlKitsId
                                          INNER JOIN cdlItems                cI     -- napojení na číselník itemů, abychom získali jen CPE
                                            ON KI.[ItemOrKitId] = cI.ID 
                                          WHERE cI.ItemType='CPE' 
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
                                                                        FROM  #TmpCMSOCsn 
                                                                        WHERE RTRIM(SN1)<>'' AND ItemVerKit = 1               -- jen kity a vyplněné SN1
                                                                        GROUP BY ItemOrKitID, ItemVerKit, ItemOrKitQualityID
                                                 UNION ALL
                                                 SELECT SUM(1) SUMAsn1, ItemOrKitID, ItemVerKit, ItemOrKitQualityID 
                                                                        FROM  #TmpCMSOCsn 
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
                 SET @sub = 'FENIX - S1 INFO' + ' Databáze: '+ISNULL(@myDatabaseName,'')
                 SET @msg = 'Program [dbo].[prKiSHCins]<br /> Nesouhlasí počty SN s reálným množstvím <br />' +@SeznamItems   
                 EXEC @result = msdb.dbo.sp_send_dbmail
                		@profile_name = 'Automat', --@MailProfileName
                		@recipients = @myAdresaLogistika,
                		@subject = @sub,
                		@body = @msg,
                		@body_format = 'HTML'

            END

           -- ================== toto je nově ================ END ===============================
      END 
      BEGIN -- ============================ Zpracování ===============================
         --@myMessageId             
         --@myMessageTypeId         
         --@myMessageTypeDescription
         --@myShipmentOrderID       
         SELECT  @myPocet = COUNT(*) 
         FROM [dbo].[CommunicationMessagesShipmentOrdersConfirmation]
         WHERE [MessageId]=@myMessageId AND [MessageTypeId] = @myMessageTypeId AND  MessageDescription = @myMessageTypeDescription
   
         IF @mOK=1 AND  (@myPocet = 0 OR  @myPocet IS NULL)
         BEGIN  -- @mOK=1
            IF (SELECT CURSOR_STATUS('global','myCursorCMSOChd')) >= -1
             BEGIN
                      DEALLOCATE myCursorCMSOChd
             END
             SET @myError=0 
             SET @myIdentity = 0

             BEGIN TRAN
             DECLARE myCursorCMSOChd CURSOR 
             FOR  
             SELECT x.[ID], x.[MessageID], x.[MessageTypeID], x.[MessageTypeDescription], x.[RequiredDateOfReceipt], x.[ShipmentOrderID], x.[HeliosOrderID]
                   ,x.[CustomerID], x.[CustomerName], x.[CustomerAddress1], x.[CustomerAddress2], x.[CustomerAddress3], x.[CustomerCity], x.[CustomerZipCode]
                   ,x.[CustomerCountryISO], x.[ContactID], x.[ContactTitle], x.[ContactFirstName], x.[ContactLastName], x.[ContactPhoneNumber1], x.[ContactPhoneNumber2]
                   ,x.[ContactFaxNumber], x.[ContactEmail], x.[SingleOrMaster], x.[HeliosOrderRecordID], x.[ItemOrKitID], x.[ItemOrKitDescription], x.[ItemOrKitQuantity]
                   ,x.[ItemOrKitUnitOfMeasureID], x.[ItemOrKitUnitOfMeasure], x.[ItemOrKitQualityID], x.[ItemOrKitQuality], x.[ItemVerKit], x.[IncotermID]
                   ,x.[IncotermDescription], x.[RealDateOfDelivery], x.[RealItemOrKitQuantity], x.[RealItemOrKitQualityID], x.[RealItemOrKitQuality], x.[Status]
             FROM #TmpCMSOChd x ORDER BY MessageID, MessageTypeID, ShipmentOrderID, CustomerID, ContactID, SingleOrMaster, ItemVerKit, ItemOrKitID

             OPEN myCursorCMSOChd
             FETCH NEXT FROM myCursorCMSOChd INTO   @myID, @myMessageID, @myMessageTypeID, @myMessageTypeDescription, @myRequiredDateOfReceipt, @myShipmentOrderID, @myHeliosOrderID
                   ,@myCustomerID, @myCustomerName, @myCustomerAddress1, @myCustomerAddress2, @myCustomerAddress3, @myCustomerCity, @myCustomerZipCode
                   ,@myCustomerCountryISO, @myContactID, @myContactTitle, @myContactFirstName, @myContactLastName, @myContactPhoneNumber1, @myContactPhoneNumber2
                   ,@myContactFaxNumber, @myContactEmail, @mySingleOrMaster, @myHeliosOrderRecordID, @myItemOrKitID, @myItemOrKitDescription, @myItemOrKitQuantity
                   ,@myItemOrKitUnitOfMeasureID, @myItemOrKitUnitOfMeasure, @myItemOrKitQualityID, @myItemOrKitQuality, @myItemVerKit, @myIncotermsID
                   ,@myIncotermDescription, @myRealDateOfDelivery, @myRealItemOrKitQuantity, @myRealItemOrKitQualityID, @myRealItemOrKitQuality, @myStatus

             SELECT @myKeyShipmentOrderID = -1, @myKeyDestinationPlacesId = -1, @myKeyDestinationPlacesId = -1

             WHILE @@FETCH_STATUS = 0
             BEGIN  -- @@FETCH_STATUS    --  OR @myKeyItemVerKit<>@myItemVerKit
                   IF @myKeyShipmentOrderID <> @myShipmentOrderID OR @myKeyDestinationPlacesId <> @myDestinationPlacesId OR @myKeyDestinationPlacesId <> @myDestinationPlacesId
                    BEGIN
                       SELECT @myKeyShipmentOrderID = @myShipmentOrderID, @myKeyItemVerKit=@myItemVerKit, @myKeyDestinationPlacesId = @myDestinationPlacesId, @myKeyDestinationPlacesId = @myDestinationPlacesId
                       INSERT INTO [dbo].[CommunicationMessagesShipmentOrdersConfirmation]
                                  ([MessageId]
                                  ,[MessageTypeId]
                                  ,[MessageDescription]
                                  ,[MessageDateOfReceipt]
                                  ,[ShipmentOrderID]
                                  ,[CustomerID]
                                  ,[ContactID]
                                  ,[IsActive]
                                  ,[ModifyDate]
                                  ,[ModifyUserId])
                            VALUES
                                  (@myMessageId -- <MessageId, int,>
                                  ,@myMessageTypeId -- <MessageTypeId, int,>
                                  ,@myMessageTypeDescription -- <MessageDescription, nvarchar(200),>
                                  ,@myRequiredDateOfReceipt -- <MessageDateOfReceipt, datetime,>
                                  ,@myShipmentOrderID -- <ShipmentOrderID, int,>
                                  ,@myCustomerID -- <CustomerID, int,>
                                  ,@myContactID -- <ContactID, int,>
                                  ,1 -- <IsActive, bit,>
                                  ,@myToDay -- <ModifyDate, datetime,>
                                  ,0 -- <ModifyUserId, int,>
                                  )    
                                                      
                        SET @myError = @myError + @@ERROR
                        SET @myIdentity = @@IDENTITY          -- ID hlavicky
                        SET @myAnnouncement = @myAnnouncement + CAST(@myIdentity AS VARCHAR(50))+','

                        /* 2015-01-27 */
                        UPDATE [dbo].[CommunicationMessagesShipmentOrdersSent] SET [MessageStatusId] = 5, [ModifyDate] = @myToDay
                        FROM [dbo].[CommunicationMessagesShipmentOrdersSent]   CMSOS
                        WHERE ID = @myKeyShipmentOrderID   -- 2015-01-26
                  
                        SET @myError = @myError + @@ERROR
                    END

                    IF @myError=0 AND @myIdentity>0
                    BEGIN  -- 1
                        SET @myItemSNs=''
                        SELECT @myItemSNs = SN FROM (
                        SELECT DISTINCT LEFT(r.ResourceName , LEN(r.ResourceName)-1) [SN], A.[SingleOrMaster],A.[HeliosOrderRecordID], A.[ItemVerKit],A.ItemOrKitID
                        FROM #TmpCMSOCsn A
                         CROSS APPLY (SELECT CAST([SN1] AS VARCHAR(50))+ ', ' + CAST([SN2] AS VARCHAR(50))+ '; '   FROM #TmpCMSOCsn  B
                             WHERE A.[SingleOrMaster] = B.[SingleOrMaster] AND A.[HeliosOrderRecordID] =  B.[HeliosOrderRecordID] AND A.[ItemVerKit] = B.[ItemVerKit] AND A.ItemOrKitID = B.ItemOrKitID
                             FOR XML PATH('')
                             ) r (ResourceName) 
                             ) AA 
                             WHERE  AA.[SingleOrMaster] = @mySingleOrMaster AND AA.[HeliosOrderRecordID] = @myHeliosOrderRecordID AND AA.[ItemVerKit] = @myItemVerKit AND AA.ItemOrKitID = @myItemOrKitID

                        INSERT INTO [dbo].[CommunicationMessagesShipmentOrdersConfirmationItems]
                                   ([CMSOId]
                                   ,[SingleOrMaster]
                                   ,[HeliosOrderRecordID]
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
                                   ,[RealDateOfDelivery]
                                   ,[RealItemOrKitQuantity]
                                   ,[RealItemOrKitQualityID]
                                   ,[RealItemOrKitQuality]
                                   ,[Status]
                                   ,[KitSNs]
                                   ,[IsActive]
                                   ,[ModifyDate]
                                   ,[ModifyUserId])
                             VALUES
                                   (@myIdentity   -- <CMSOId, int,>
                                   ,@mySingleOrMaster   -- <SingleOrMaster, int,>
                                   ,@myHeliosOrderRecordID   -- <HeliosOrderRecordID, int,>
                                   ,@myItemVerKit   -- <ItemVerKit, int,>
                                   ,@myItemOrKitID   -- <ItemOrKitID, int,>
                                   ,@myItemOrKitDescription   -- <ItemOrKitDescription, nvarchar(100),>
                                   ,@myItemOrKitQuantity   -- <ItemOrKitQuantity, numeric(18,3),>
                                   ,@myItemOrKitUnitOfMeasureId   -- <ItemOrKitUnitOfMeasureId, int,>
                                   ,@myItemOrKitUnitOfMeasure   -- <ItemOrKitUnitOfMeasure, nvarchar(50),>
                                   ,@myItemOrKitQualityId   -- <ItemOrKitQualityId, int,>
                                   ,@myItemOrKitQuality   -- <ItemOrKitQualityCode, nvarchar(50),>
                                   ,@myIncotermsId   -- <IncotermsId, int,>
                                   ,@myIncotermDescription   -- <IncotermDescription, nvarchar(50),>
                                   ,@myRealDateOfDelivery   -- <RealDateOfDelivery, datetime,>
                                   ,@myRealItemOrKitQuantity   -- <RealItemOrKitQuantity, numeric(18,3),>
                                   ,@myRealItemOrKitQualityID   -- <RealItemOrKitQualityID, int,>
                                   ,@myRealItemOrKitQuality   -- <RealItemOrKitQuality, nvarchar(50),>
                                   ,@myStatus   -- <Status, int,>
                                   ,@myItemSNs   -- <KitSNs, varchar(max),>
                                   ,1 -- <IsActive, bit,>
                                   ,@myToDay -- <ModifyDate, datetime,>
                                   ,0 -- <ModifyUserId, int,>
                                   )                      
                        SET @myError = @myError + @@ERROR
                        SET @myIdentityx = @@IDENTITY         -- ID itemu


                        -- ==============================2014-11-19 ========================
                         --INSERT INTO [dbo].[CardStockItems]
                         --           ([ItemVerKit]
                         --           ,[ItemOrKitId]
                         --           ,[ItemOrKitUnitOfMeasureId]
                         --           ,[ItemOrKitQuality]
                         --           ,[ItemOrKitFree]
                         --           ,[ItemOrKitUnConsilliation]
                         --           ,[ItemOrKitReserved]
                         --           ,[ItemOrKitReleasedForExpedition]
                         --           ,[ItemOrKitExpedited]
                         --           ,[StockId]
                         --           ,[IsActive]
                         --           ,[ModifyDate]
                         --           ,[ModifyUserId])
                         --SELECT @myItemVerKit,@myItemOrKitID,@myItemOrKitUnitOfMeasureId,@myItemOrKitQualityId,0,0,0,0,0,2,1,Getdate(),0
                         --WHERE CAST(@myItemOrKitQualityId AS CHAR(20)) + CAST(@myItemOrKitUnitOfMeasureId AS CHAR(20)) +  CAST(@myItemOrKitID AS CHAR(50))+ CAST(@myItemVerKit AS CHAR(50))  
                         --NOT IN (SELECT CAST(ItemOrKitQuality AS CHAR(20)) + CAST([ItemOrKitUnitOfMeasureId] AS CHAR(20)) +  CAST(ItemOrKitId AS CHAR(50))++ CAST(ItemVerKit AS CHAR(50)) FROM CardStockItems WHERE StockId=2 AND ItemVerKit=0)  
 
                         --SET @myError = @myError + @@ERROR


                        IF @myError = 0 AND  @myIdentityx > 0
                        BEGIN
                              INSERT INTO [dbo].[CommunicationMessagesShipmentOrdersConfirmationSerNumSent]
                                        ([ShipmentOrdersItemsOrKitsID]
                                        ,[SN1]
                                        ,[SN2]
                                        ,[IsActive]
                                        ,[ModifyDate]
                                        ,[ModifyUserId])
                              SELECT @myIdentityx, SN1, SN2, 1,@myToDay,0 FROM #TmpCMSOCsn AA  
                              WHERE 
                              AA.[SingleOrMaster]     = @mySingleOrMaster AND AA.ItemOrKitQualityID = @myItemOrKitQualityId AND 
                              AA.[ItemVerKit]         = @myItemVerKit     AND AA.ItemOrKitID = @myItemOrKitID

                              SET @myError = @myError + @@ERROR
                        END
                     END  -- 1
                    FETCH NEXT FROM myCursorCMSOChd INTO   @myID, @myMessageID, @myMessageTypeID, @myMessageTypeDescription, @myRequiredDateOfReceipt, @myShipmentOrderID, @myHeliosOrderID
                          ,@myCustomerID, @myCustomerName, @myCustomerAddress1, @myCustomerAddress2, @myCustomerAddress3, @myCustomerCity, @myCustomerZipCode
                          ,@myCustomerCountryISO, @myContactID, @myContactTitle, @myContactFirstName, @myContactLastName, @myContactPhoneNumber1, @myContactPhoneNumber2
                          ,@myContactFaxNumber, @myContactEmail, @mySingleOrMaster, @myHeliosOrderRecordID, @myItemOrKitID, @myItemOrKitDescription, @myItemOrKitQuantity
                          ,@myItemOrKitUnitOfMeasureID, @myItemOrKitUnitOfMeasure, @myItemOrKitQualityID, @myItemOrKitQuality, @myItemVerKit, @myIncotermsID
                          ,@myIncotermDescription, @myRealDateOfDelivery, @myRealItemOrKitQuantity, @myRealItemOrKitQualityID, @myRealItemOrKitQuality, @myStatus

             END    -- @@FETCH_STATUS
             CLOSE myCursorCMSOChd;
             DEALLOCATE myCursorCMSOChd;



            IF @myError = 0
            BEGIN 
                IF @@TRANCOUNT > 0 
                BEGIN
                         IF @@TRANCOUNT > 0 COMMIT TRAN

                         SET @sub = 'FENIX - S1 - Oznámení' + ' Databáze: '+ISNULL(@myDatabaseName,'')
                         SET @msg = 'Ke schválení byly obdrženy následující message (ID = ): <br />'  + @myAnnouncement
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
                         SELECT @ReturnValue=1, @ReturnMessage='Chyba'
                         SET @sub = 'FENIX - S1 CHYBA ROLLBACK' + ' Databáze: '+ISNULL(@myDatabaseName,'')
                         SET @msg = 'Program [dbo].[prKiSHCins]; '  + ISNULL(ERROR_MESSAGE(),'') + ISNULL(CAST(ERROR_NUMBER() AS VARCHAR(50)),'') 
                         EXEC @result = msdb.dbo.sp_send_dbmail
                        		@profile_name = 'Automat', --@MailProfileName
                        		@recipients = 'jaroslav.tajbl@upc.cz;michal.rezler@upc.cz',
                        		@subject = @sub,
                        		@body = @msg,
                        		@body_format = 'HTML'

                 END 
             END 
            ELSE
            BEGIN 
                IF @@TRANCOUNT > 0 ROLLBACK TRAN 
                SELECT @ReturnValue=1, @ReturnMessage='Chyba'
                SET @sub = 'FENIX - S1 CHYBA ROLLBACK 2' + ' Databáze: '+ISNULL(@myDatabaseName,'')
                SET @msg = 'Program [dbo].[prKiSHCins]; '  + ISNULL(ERROR_MESSAGE(),'') + ISNULL(CAST(ERROR_NUMBER() AS VARCHAR(50)),'') 
                EXEC @result = msdb.dbo.sp_send_dbmail
               		@profile_name = 'Automat', --@MailProfileName
               		@recipients = 'jaroslav.tajbl@upc.cz;michal.rezler@upc.cz',
               		@subject = @sub,
               		@body = @msg,
               		@body_format = 'HTML'
             
             END 
         END    -- @mOK=1
         ELSE
         BEGIN
             IF @myPocet>0
             BEGIN 
                   IF @@TRANCOUNT > 0 ROLLBACK TRAN
                   SELECT @ReturnValue=1, @ReturnMessage='CInfo'
                   SET @sub = 'FENIX - S1' + ' Databáze: '+ISNULL(@myDatabaseName,'')
                   SET @msg = 'Program [dbo].[prKiSHCins]; Záznam MessageId=' + ISNULL(CAST(@myMessageId AS VARCHAR(50)),'') + ', MessageTypeId = '+ ISNULL(CAST(@myMessageTypeId AS VARCHAR(50)),'') + ' byl již jednou naveden !'
                   EXEC @result = msdb.dbo.sp_send_dbmail
                  		@profile_name = 'Automat', --@MailProfileName
                  		@recipients = 'jaroslav.tajbl@upc.cz;michal.rezler@upc.cz',
                  		@subject = @sub, 
                  		@body = @msg,
                  		@body_format = 'HTML'
              END
         END
      END
END TRY
BEGIN CATCH
       IF @@TRANCOUNT > 0 ROLLBACK TRAN
    
       SELECT @ReturnValue=1, @ReturnMessage='Chyba'
       SET @sub = 'FENIX - S1 CHYBA' + ' Databáze: '+ISNULL(@myDatabaseName,'')
       SET @msg = 'Program [dbo].[prKiSHCins]; '  + ISNULL(ERROR_MESSAGE(),'') + ISNULL(CAST(ERROR_NUMBER() AS VARCHAR(50)),'') 
       EXEC @result = msdb.dbo.sp_send_dbmail
      		@profile_name = 'Automat', --@MailProfileName
      		@recipients = 'jaroslav.tajbl@upc.cz;michal.rezler@upc.cz',
      		@subject = @sub,
      		@body = @msg,
      		@body_format = 'HTML'
END CATCH
END


