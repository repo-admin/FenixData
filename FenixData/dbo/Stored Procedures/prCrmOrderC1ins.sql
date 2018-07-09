

CREATE PROCEDURE [dbo].[prCrmOrderC1ins] 
     @par1 as XML,
	   @ReturnValue     int            = -1 OUTPUT,
	   @ReturnMessage   nvarchar(2048) = null OUTPUT
 AS
BEGIN
-- =================================================================================================
-- Created by   : Rezler Michal
-- Created date : 2017-04-26
--                
-- Description  : 
-- =================================================================================================
/*

Fáze C1 -  z XPO přijde MESSAGE

*/
	SET NOCOUNT ON;
	
  BEGIN TRY
	 
   BEGIN --- DECLARACE
       DECLARE
	          @myID int,
	          @myMessageId int,
	          @myMessageTypeId int,
	          @myMessageDescription nvarchar(200),	          
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
             ,@myCrmOrderID int
             ,@myHeliosOrderID int
             ,@myCardStockItemsId int
             ,@myAnnouncement [nvarchar](max)
						 	
							,@myMessageDateOfShipment datetime --nvarchar(50)													
							,@myX_SHIPMENT_REAL datetime --nvarchar(50) 
							,@myX_PARCEL_NUMBER nvarchar(100) 
							,@myX_RECONCILIATION int
							,@myL_ITEM_OR_KIT_ID int
							,@myL_ITEM_OR_KIT_DESCRIPTION nvarchar(100)
							,@myL_ITEM_OR_KIT_QUANTITY numeric(18, 3)
							,@myL_ITEM_OR_KIT_MEASURE_ID nvarchar(150)
							,@myL_ITEM_OR_KIT_MEASURE nvarchar(250)
							,@myL_ITEM_OR_KIT_QUALITY_ID int
							,@myL_ITEM_OR_KIT_QUALITY nvarchar(150)
							,@myL_ITEM_VER_KIT bit

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
			 DECLARE @myDatabaseName  nvarchar(100)
       DECLARE @Result int

       SET @msg = ''
			 SELECT @myDatabaseName = DB_NAME() 
       SELECT 	@ReturnValue=0,  @ReturnMessage='OK'

   END --- DECLARACE
   -- ---
   -- =======================================================================
   -- Nacteni xml souboru do tabulky
   -- =======================================================================
      IF OBJECT_ID('tempdb..#TmpCRC1hd','table') IS NOT NULL DROP TABLE #TmpCRC1hd
      IF OBJECT_ID('tempdb..#TmpCRC1sn','table') IS NOT NULL DROP TABLE #TmpCRC1sn

      EXEC sp_xml_preparedocument @hndl OUTPUT, @par1

      SELECT    x.[ID], x.[MessageID], x.[MessageTypeID] , x.[MessageTypeDescription], x.[MessageDateOfShipment]
							 ,x.[CrmOrderID], x.[X_SHIPMENT_REAL], x.[X_PARCEL_NUMBER], x.[X_RECONCILIATION] 
							 ,x.[L_ITEM_OR_KIT_ID], x.[L_ITEM_OR_KIT_DESCRIPTION], x.[L_ITEM_OR_KIT_QUANTITY] 
							 ,x.[L_ITEM_OR_KIT_MEASURE_ID], x.[L_ITEM_OR_KIT_MEASURE], x.[L_ITEM_OR_KIT_QUALITY_ID] 
							 ,x.[L_ITEM_OR_KIT_QUALITY], x.[L_ITEM_VER_KIT]
      INTO #TmpCRC1hd
      FROM OPENXML (@hndl, '/NewDataSet/CommunicationMessagesCrmOrderConfirmation/itemsOrKits/itemOrKit',2)
      WITH (
							ID                             int           '../../ID',
							MessageID                      int           '../../MessageID',
							MessageTypeID                  int           '../../MessageTypeID',
							MessageTypeDescription         nvarchar(150) '../../MessageTypeDescription',
							MessageDateOfShipment          datetime      '../../MessageDateOfShipment',
							CrmOrderID                     int           '../../CrmOrderID',
							X_SHIPMENT_REAL                nvarchar(50)  '../../X_SHIPMENT_REAL',
							X_PARCEL_NUMBER                nvarchar(100) '../../X_PARCEL_NUMBER',
							X_RECONCILIATION               int           '../../X_RECONCILIATION',
							L_ITEM_OR_KIT_ID               int           'L_ITEM_OR_KIT_ID',
							L_ITEM_OR_KIT_DESCRIPTION      nvarchar(100) 'L_ITEM_OR_KIT_DESCRIPTION',
							L_ITEM_OR_KIT_QUANTITY         numeric(18, 3)'L_ITEM_OR_KIT_QUANTITY',
							L_ITEM_OR_KIT_MEASURE_ID       nvarchar(150) 'L_ITEM_OR_KIT_MEASURE_ID',
							L_ITEM_OR_KIT_MEASURE          nvarchar(250) 'L_ITEM_OR_KIT_MEASURE',
							L_ITEM_OR_KIT_QUALITY_ID       int           'L_ITEM_OR_KIT_QUALITY_ID',
							L_ITEM_OR_KIT_QUALITY          nvarchar(150) 'L_ITEM_OR_KIT_QUALITY',
							L_ITEM_VER_KIT                 bit           'L_ITEM_VER_KIT'
						) x
      ----
      SELECT y.[L_ITEM_OR_KIT_QUALITY_ID], y.[L_ITEM_VER_KIT], y.[L_ITEM_OR_KIT_ID], y.[SN1],y.[SN2]
      INTO #TmpCRC1sn
      FROM OPENXML (@hndl, '/NewDataSet/CommunicationMessagesCrmOrderConfirmation/itemsOrKits/itemOrKit/ItemOrKitSNs/ItemSN',2)
      WITH (
							L_ITEM_OR_KIT_QUALITY_ID       int           '../../L_ITEM_OR_KIT_QUALITY_ID',
							L_ITEM_VER_KIT                 bit           '../../L_ITEM_VER_KIT',
							L_ITEM_OR_KIT_ID               int           '../../L_ITEM_OR_KIT_ID',            
							SN1                            nvarchar(150) '@SN1',
							SN2                            nvarchar(150) '@SN2'
            ) y
      EXEC sp_xml_removedocument @hndl
 
      SELECT @myMessageId              = CAST(a.MessageId AS VARCHAR(50)),
             @myMessageTypeId          = CAST(a.MessageTypeID AS VARCHAR(50)),
             @myMessageTypeDescription = a.MessageTypeDescription,
             @myCrmOrderID             = a.CrmOrderID
       FROM (
             SELECT TOP 1 MessageId, MessageTypeID, MessageTypeDescription, CrmOrderID FROM #TmpCRC1hd Tmp
             ) a

   -- ===============================================================================================================================================
   --        Kontrola úplnosti a správnosti dat
   -- ===============================================================================================================================================
      BEGIN -- ============ Kontrola existence zdrojové message ======================
           SELECT @myPocet = COUNT(*) FROM [dbo].[CommunicationMessagesCrmOrder] WHERE ID = @myCrmOrderID
           
           IF  @myPocet <> 1
           BEGIN
                      SET @myMessage = 'NEEXISTUJE ID = ' + CAST(@myCrmOrderID AS VARCHAR(50)) + ' v tabulce CommunicationMessagesCrmOrder'											                 
                      EXEC [dbo].[prAppLogWriteNew] @Type='INFO', @Message =  @myMessage, @XmlMessage = NULL, @UserId = 0,@Source = 'prCrmOrderC1ins'
                                                  , @ReturnValue = @myReturnValue, @ReturnMessage = @myReturnMessage
        
                      SET @sub = 'FENIX - Kontrola CRM CONFIRMATION (prCrmOrderC1ins) - kontrola existence zdrojové message' + ' Databáze: ' + ISNULL(@myDatabaseName,'')
                      SET @msg = @myMessage
	     	 							EXEC @result = msdb.dbo.sp_send_dbmail
	     	 									 @profile_name = 'Automat',
	     	 									 @recipients = @myAdresaLogistika,
													 @copy_recipients = @myAdresaProgramator,
	     	 									 @subject = @sub,
	     	 									 @body = @msg,
         	 								 @body_format = 'HTML'
											SET @ReturnMessage = @msg + ' {CrmOrderId = ' + CAST(@myCrmOrderID AS VARCHAR(50)) + ' not found. Processing was stopped.}'  
                      SET @ReturnValue = 1
           END
      END

			IF @ReturnValue <> 0
			BEGIN
				RETURN
			END
  
      BEGIN -- ============ Kontrola existence zboží proti objednávce ================
          SET @msg='' 
          SELECT @myPocet = COUNT(*) FROM #TmpCRC1hd Tmp    
          SELECT @myPocetPolozekPomooc  = COUNT(*) 
          FROM   [dbo].[CommunicationMessagesCrmOrderItems] 
          WHERE  [CommunicationMessageID] = @myCrmOrderID AND ISACTIVE = 1

          IF @myPocet - @myPocetPolozekPomooc <> 0
          BEGIN     
                 SET @myMessage = 'CHYBA - NESOUHLASÍ počet položek objednávky s potvrzením závozu. ID objednávky='+ISNULL(CAST(@myCrmOrderID AS VARCHAR(50)),'') +', POČET = '+CAST(@myPocetPolozekPomooc AS VARCHAR(50)) + ' v tabulce CommunicationMessagesCrmOrderItems'
                     + ',  Confirmace:  MessageId = ' + CAST(@myMessageId AS VARCHAR(50))+', MessageType = ' + CAST(@myMessageTypeId AS VARCHAR(50))+', MessageDescription = '+CAST(@myMessageTypeDescription  AS NVARCHAR(250)) +', POČET = '+CAST(@myPocet AS VARCHAR(50))                      
										 
                 EXEC [dbo].[prAppLogWriteNew] @Type='INFO', @Message =  @myMessage, @XmlMessage = NULL, @UserId = 0,@Source = 'prCrmOrderC1ins'
                                          , @ReturnValue = @myReturnValue,@ReturnMessage=@myReturnMessage
                 
                 SET @msg = @myMessage
            
                 SET @sub = 'FENIX - Kontrola CRM CONFIRMATION (prCrmOrderC1ins) - kontrola počtu položek proti objednávce' + ' Databáze: '+ISNULL(@myDatabaseName,'')
		 						 EXEC @result = msdb.dbo.sp_send_dbmail
		 									@profile_name = 'Automat', 
		 									@recipients = @myAdresaLogistika,
											@copy_recipients = @myAdresaProgramator,
		 									@subject = @sub,
		 									@body = @msg,
    	 									@body_format = 'HTML'
								 SET @ReturnMessage = 'Crm Order Items not equal Crm Order Items Confirmation for CrmOrderId = ' + ISNULL(CAST(@myCrmOrderID AS VARCHAR(50)),'') 
								                    + ' Processing was stopped.' 
								 SET @ReturnValue = 1
           END
          ELSE
          BEGIN	
                SELECT @myPocet = COUNT(*)  FROM #TmpCRC1hd Tmp
                SELECT @myPocetPolozekPomooc  = COUNT(*) 
                FROM #TmpCRC1hd           Tmp
                INNER JOIN  [dbo].[CommunicationMessagesCrmOrderItems]   I
                      ON I.[CommunicationMessageID]= @myCrmOrderID AND Tmp.L_ITEM_OR_KIT_ID = I.L_ITEM_OR_KIT_ID 
											AND I.L_ITEM_VER_KIT = Tmp.L_ITEM_VER_KIT AND I.L_ITEM_OR_KIT_QUANTITY = Tmp.L_ITEM_OR_KIT_QUANTITY
                WHERE I.ISACTIVE = 1

						--SELECT * FROM #TmpCRC1hd
						--SELECT @myPocet '@myPocet', @myPocetPolozekPomooc '@myPocetPolozekPomooc', @myPocet - @myPocetPolozekPomooc '@myPocet - @myPocetPolozekPomooc'
						--RETURN
						 
                IF @myPocet - @myPocetPolozekPomooc <> 0
                BEGIN
                       SET @myMessage = 'CHYBA - NESOUHLASÍ počet Items položek objednávky nebo množství objednané s potvrzením závozu. ID objednávky=' + CAST(@myCrmOrderID AS VARCHAR(50)) +
                           + ',  Confirmace:  MessageId = ' + CAST(@myMessageId AS VARCHAR(50))+', MessageType = ' + CAST(@myMessageTypeId AS VARCHAR(50)) + ', MessageDescription = ' + CAST(@myMessageTypeDescription  AS NVARCHAR(250)) 
                           
                       EXEC [dbo].[prAppLogWriteNew] @Type='INFO', @Message =  @myMessage, @XmlMessage = NULL, @UserId = 0,@Source = 'prCrmOrderC1ins'
                                                , @ReturnValue = @myReturnValue,@ReturnMessage=@myReturnMessage
                       
                       SET @msg = @myMessage                  
                       SET @sub = 'FENIX - Kontrola CRM CONFIRMATION (prCrmOrderC1ins) - kontrola ItemOrKitID položek proti objednávce' + ' Databáze: ' + ISNULL(@myDatabaseName,'')
		       						 EXEC @result = msdb.dbo.sp_send_dbmail
													  @profile_name = 'Automat', 
													  @recipients = @myAdresaLogistika,
													  @copy_recipients = @myAdresaProgramator,
													  @subject = @sub,
													  @body = @msg,
														@body_format = 'HTML'  
                       SET @ReturnMessage = 'Crm Order Items <> Crm Order Items Confirmation or CrmOrder quantity <> CrmOrderConfirmation quantity CrmOrderId = ' + ISNULL(CAST(@myCrmOrderID AS VARCHAR(50)),'') + ' processing was stopped.'
											 SET @ReturnValue = 1
                END
          END
      END
			
			IF @ReturnValue <> 0
			BEGIN
				RETURN
			END
			
			-- ================== Kontrola poctu SN (item, kit typu CPE) ==================
			BEGIN -- kontrola poctu SN
			
				--	-- Celkovy pocet SN
				DECLARE @PocetSnCelkemTabTmpCRC1sn INT = 0
				SELECT @PocetSnCelkemTabTmpCRC1sn = SUM(SUMx)  
				FROM (
							SELECT SUM(SUMAsn1) SUMx, L_ITEM_OR_KIT_ID, L_ITEM_VER_KIT, L_ITEM_OR_KIT_QUALITY_ID
							FROM
							(
										SELECT SUM(1) SUMAsn1, L_ITEM_OR_KIT_ID, L_ITEM_VER_KIT, L_ITEM_OR_KIT_QUALITY_ID 
																					FROM  #TmpCRC1sn 
																					WHERE RTRIM(SN1)<>''                    
																					GROUP BY L_ITEM_OR_KIT_ID, L_ITEM_VER_KIT, L_ITEM_OR_KIT_QUALITY_ID
										UNION ALL                                                                      
										SELECT SUM(1) SUMAsn1, L_ITEM_OR_KIT_ID, L_ITEM_VER_KIT, L_ITEM_OR_KIT_QUALITY_ID 
																					FROM  #TmpCRC1sn 
																					WHERE RTRIM(SN2)<>''
																					GROUP BY L_ITEM_OR_KIT_ID, L_ITEM_VER_KIT, L_ITEM_OR_KIT_QUALITY_ID
                                              
							)        TmpSN
							GROUP BY L_ITEM_OR_KIT_ID, L_ITEM_VER_KIT, L_ITEM_OR_KIT_QUALITY_ID
				) nnn
			
				--	-- Pocet SN pro kity
				DECLARE @PocetSnKitTabTmpCRC1hd INT = 0
				SELECT @PocetSnKitTabTmpCRC1hd = SUM(SUMA) 
				FROM
				(
						SELECT SUM(NASOBENI) SUMA
						FROM
						(
								SELECT bbb.L_ITEM_OR_KIT_ID, bbb.L_ITEM_VER_KIT, bbb.L_ITEM_OR_KIT_QUALITY_ID, bbb.SumRealItemOrKitQuantity,bbb.[ItemOrKitQuantity]
											,KIItemOrKitId,bbb.SumRealItemOrKitQuantity*bbb.[ItemOrKitQuantity]*bbb.Multiplayer  NASOBENI 
								FROM
								(
										SELECT aa.L_ITEM_OR_KIT_ID, aa.L_ITEM_VER_KIT, aa.L_ITEM_OR_KIT_QUALITY_ID, aa.SumRealItemOrKitQuantity
													,KI.[ItemOrKitQuantity],KI.[ItemOrKitId] AS KIItemOrKitId,cI.[ItemType], K.Multiplayer 
										FROM (
														SELECT L_ITEM_OR_KIT_ID, L_ITEM_VER_KIT, L_ITEM_OR_KIT_QUALITY_ID, SUM(L_ITEM_OR_KIT_QUANTITY) SumRealItemOrKitQuantity 
														FROM #TmpCRC1hd 
														WHERE L_ITEM_VER_KIT = 1 
														GROUP BY L_ITEM_OR_KIT_ID, L_ITEM_VER_KIT, L_ITEM_OR_KIT_QUALITY_ID
													) aa
													INNER JOIN [dbo].[cdlKits]    K
														ON aa.L_ITEM_OR_KIT_ID = K.ID
													INNER JOIN [dbo].[cdlKitsItems]    KI
														ON aa.L_ITEM_OR_KIT_ID = KI.cdlKitsId
													INNER JOIN cdlItems   cI
														ON KI.[ItemOrKitId] = cI.ID 
													WHERE cI.ItemType='CPE' 
								) bbb
						) ccc
				) ddd
			
				--	--Celkovy pocet SN pro itemy
				DECLARE @PocetSnItemTabTmpCRC1hd INT = 0

				SELECT @PocetSnItemTabTmpCRC1hd = SumRealItemOrKitQuantity
				FROM 
				(
							SELECT aaa.L_ITEM_OR_KIT_ID, aaa.L_ITEM_VER_KIT, aaa.L_ITEM_OR_KIT_QUALITY_ID, SumRealItemOrKitQuantity  FROM
							(
								SELECT aa.L_ITEM_OR_KIT_ID, aa.L_ITEM_VER_KIT, aa.L_ITEM_OR_KIT_QUALITY_ID, aa.SumRealItemOrKitQuantity FROM
								(                    
												SELECT L_ITEM_OR_KIT_ID, L_ITEM_VER_KIT, L_ITEM_OR_KIT_QUALITY_ID, SUM(L_ITEM_OR_KIT_QUANTITY) SumRealItemOrKitQuantity
												FROM #TmpCRC1hd 
												WHERE L_ITEM_VER_KIT = 0
												GROUP BY L_ITEM_OR_KIT_ID, L_ITEM_VER_KIT, L_ITEM_OR_KIT_QUALITY_ID
								) aa
								INNER JOIN cdlItems   cI
											ON aa.L_ITEM_OR_KIT_ID = cI.ID 
								WHERE cI.ItemType='CPE' 
							) aaa
				) x
      
				IF ISNULL(@PocetSnCelkemTabTmpCRC1sn, 0) <> ISNULL(@PocetSnKitTabTmpCRC1hd, 0) + ISNULL(@PocetSnItemTabTmpCRC1hd, 0)
				BEGIN       			 
					 SET @sub = 'FENIX - Kontrola CRM CONFIRMATION (prCrmOrderC1ins) - kontrola počtu SN' + ' Databáze: ' + ISNULL(@myDatabaseName,'')       
					 SET @msg = 'Program [dbo].[prCrmOrderC1ins]; nesouhlasí počty sériových čísel' 
					 SET @msg = @msg + '<br />' + 'počet požadovaných SN:' + CAST((ISNULL(@PocetSnKitTabTmpCRC1hd, 0) + ISNULL(@PocetSnItemTabTmpCRC1hd, 0)) AS varchar(50))
					 SET @msg = @msg + '<br />' + 'počet zadaných     SN:' + CAST(ISNULL(@PocetSnCelkemTabTmpCRC1sn, 0) AS varchar(50))
					 SET @msg = @msg + '<br />' + 'POZOR - VE ZPRACOVÁNÍ SE NEPOKRAČUJE !!!'
					 EXEC @result = msdb.dbo.sp_send_dbmail
								@profile_name = 'Automat', 
      						@recipients = @myAdresaProgramator,
      						@subject = @sub,
      						@body = @msg,
      						@body_format = 'HTML'
						SET @ReturnValue = 1 
						SET @ReturnMessage = '{Count of serial numers PROBLEM - required SN:' + CAST((ISNULL(@PocetSnKitTabTmpCRC1hd, 0) + ISNULL(@PocetSnItemTabTmpCRC1hd, 0)) AS varchar(50)) + ' '						
																 + 'entered SN:' + CAST(ISNULL(@PocetSnCelkemTabTmpCRC1sn, 0) AS varchar(50)) + ' '
																 + 'processing was stoped.}'
				END				
			END		-- kontrola poctu SN
			
			--select ISNULL(@PocetSnCelkemTabTmpCRC1sn, 0) 'SN celkem', ISNULL(@PocetSnKitTabTmpCRC1hd, 0) 'SN kity', ISNULL(@PocetSnItemTabTmpCRC1hd, 0) 'SN item'

			IF @ReturnValue <> 0
			BEGIN
				RETURN
			END
			
      --BEGIN -- =========== KOntrola počtu SN ve vztahu k itemu (CPE) =============  2014-11-12

      --     -- ================== toto je nově ================ START ===============================
      --     DECLARE @PocetSnCelkemTabTmpCMSOCsn INT

      --     SELECT @PocetSnCelkemTabTmpCMSOCsn = SUM(SUMx)  
      --     FROM (
      --           SELECT SUM(SUMAsn1) SUMx, L_ITEM_OR_KIT_ID, L_ITEM_VER_KIT, L_ITEM_OR_KIT_QUALITY_ID
      --           FROM
      --           (
      --                 SELECT SUM(1) SUMAsn1, L_ITEM_OR_KIT_ID, L_ITEM_VER_KIT, L_ITEM_OR_KIT_QUALITY_ID 
      --                                        FROM  #TmpCRC1sn 
      --                                        WHERE RTRIM(SN1)<>''                    -- 2016-07-20 
      --                                        GROUP BY L_ITEM_OR_KIT_ID, L_ITEM_VER_KIT, L_ITEM_OR_KIT_QUALITY_ID
      --                 UNION ALL                                                                      -- 2016-07-20
      --                 SELECT SUM(1) SUMAsn1, L_ITEM_OR_KIT_ID, L_ITEM_VER_KIT, L_ITEM_OR_KIT_QUALITY_ID 
      --                                        FROM  #TmpCRC1sn 
      --                                        WHERE RTRIM(SN2)<>''
      --                                        GROUP BY L_ITEM_OR_KIT_ID, L_ITEM_VER_KIT, L_ITEM_OR_KIT_QUALITY_ID
                                              
      --           )        TmpSN
      --           GROUP BY L_ITEM_OR_KIT_ID, L_ITEM_VER_KIT, L_ITEM_OR_KIT_QUALITY_ID
      --     ) nnn
      --     -- ============================================================================
					 	
      --     DECLARE @PocetSnKitTabTmpCMSOChd INT

      --     SELECT @PocetSnKitTabTmpCMSOChd = SUM(SUMA) FROM
      --     (
      --        SELECT SUM(NASOBENI) SUMA 
      --        FROM (
      --               SELECT bbb.L_ITEM_OR_KIT_ID, bbb.L_ITEM_VER_KIT, bbb.L_ITEM_OR_KIT_QUALITY_ID, bbb.SumRealItemOrKitQuantity,bbb.[ItemOrKitQuantity]
      --                     ,KIItemOrKitId,bbb.SumRealItemOrKitQuantity*bbb.[ItemOrKitQuantity]*bbb.Multiplayer  NASOBENI 
      --               FROM
      --                (
      --                     SELECT aa.L_ITEM_OR_KIT_ID, aa.L_ITEM_VER_KIT, aa.L_ITEM_OR_KIT_QUALITY_ID, aa.SumRealItemOrKitQuantity
      --                           ,KI.[ItemOrKitQuantity],KI.[ItemOrKitId] AS KIItemOrKitId,cI.[ItemType], K.Multiplayer 
      --                      FROM
      --                      (
      --                             SELECT L_ITEM_OR_KIT_ID, L_ITEM_VER_KIT, L_ITEM_OR_KIT_QUALITY_ID, SUM(L_ITEM_OR_KIT_QUANTITY) SumRealItemOrKitQuantity 
      --                             FROM #TmpCRC1hd 
      --                             WHERE ItemVerKit = 1 
      --                             GROUP BY L_ITEM_OR_KIT_ID, L_ITEM_VER_KIT, L_ITEM_OR_KIT_QUALITY_ID
      --                      ) aa
      --                      INNER JOIN [dbo].[cdlKits]    K
      --                        ON aa.ItemOrKitID = K.ID
      --                      INNER JOIN [dbo].[cdlKitsItems]    KI
      --                        ON aa.ItemOrKitID = KI.cdlKitsId
      --                      INNER JOIN cdlItems   cI
      --                        ON KI.[ItemOrKitId] = cI.ID 
      --                      WHERE cI.ItemType='CPE' 
      --                ) bbb
      --         ) vvv
      --     )
      --     xxx
      --     -- ============================================================================
      --     DECLARE @PocetSnItemTabTmpCMSOChd INT

      --     SELECT @PocetSnItemTabTmpCMSOChd = SumRealItemOrKitQuantity
      --     FROM 
      --     (
      --           SELECT aaa.ItemOrKitID, aaa.ItemVerKit, aaa.ItemOrKitQualityID, SumRealItemOrKitQuantity  FROM
      --           (
      --              SELECT aa.ItemOrKitID, aa.ItemVerKit, aa.ItemOrKitQualityID, aa.SumRealItemOrKitQuantity FROM
      --              (
      --                     SELECT ItemOrKitID, ItemVerKit, ItemOrKitQualityID, SUM(RealItemOrKitQuantity) SumRealItemOrKitQuantity 
      --                     FROM #TmpCRC1hd 
      --                     WHERE ItemVerKit = 0
      --                     GROUP BY ItemOrKitID, ItemVerKit, ItemOrKitQualityID
      --              ) aa
      --              INNER JOIN cdlItems   cI
      --                   ON aa.ItemOrKitID = cI.ID 
      --              WHERE cI.ItemType='CPE' 
      --            ) aaa
      --      ) x
      --     ---- ============================================================================

      --     -- SELECT @PocetSnCelkemTabTmpCMSOCsn '@PocetSnCelkemTabTmpCMSOCsn',ISNULL(@PocetSnItemTabTmpCMSOChd,0) '@PocetSnItemTabTmpCMSOChd',ISNULL(@PocetSnKitTabTmpCMSOChd,0) '@PocetSnKitTabTmpCMSOChd'
      --     -- SELECT ISNULL(@PocetSnItemTabTmpCMSOChd,0) + ISNULL(@PocetSnKitTabTmpCMSOChd,0)

      --     -- -- ============================================================================

      --      DECLARE @SeznamItems AS nvarchar(max)       -- zde se zapisují itemy (CPE) nebo Kity, které mají problém s počtem SN (SN může přebývat nebo scházet)
      --      SET @SeznamItems = 'MessageId = ' + CAST(@myMessageId AS  nvarchar(50)) +'<br />'

      --      IF ISNULL(@PocetSnCelkemTabTmpCMSOCsn,0)<>(ISNULL(@PocetSnItemTabTmpCMSOChd,0) + ISNULL(@PocetSnKitTabTmpCMSOChd,0))
      --      BEGIN

      --      -- 1.  Items
      --         DECLARE @seznamItemsOnly as varchar(max)  -- sem se zapisuje seznam jen Itemů, které mají problém s počtem SN (SN může přebývat nebo scházet)
      --         SET @seznamItemsOnly = 'ITEMY: '

      --         SELECT @seznamItemsOnly = @seznamItemsOnly + CAST(hd.ItemOrKitID AS varchar(50))  + ', '  --, hd.ItemVerKit, hd.ItemOrKitQualityID
      --         FROM #TmpCRC1hd         hd
      --         INNER JOIN cdlItems      cI
      --              ON hd.ItemOrKitID = cI.ID 
      --         LEFT OUTER JOIN  (SELECT SUMA, ItemOrKitID, ItemVerKit, ItemOrKitQualityID
      --                      FROM (
      --                                     SELECT SUM(SUMAsn1) SUMA, ItemOrKitID, ItemVerKit, ItemOrKitQualityID
      --                                     FROM
      --                                     (
      --                                           SELECT SUM(1) SUMAsn1, ItemOrKitID, ItemVerKit, ItemOrKitQualityID 
      --                                                                  FROM  #TmpCRC1sn 
      --                                                                  WHERE RTRIM(SN1)<>'' AND ItemVerKit = 0   -- itemy   -- 2016-07-20
      --                                                                  GROUP BY ItemOrKitID, ItemVerKit, ItemOrKitQualityID
      --                                           UNION ALL                                                                                     -- 2016-07-20
      --                                           SELECT SUM(1) SUMAsn1, ItemOrKitID, ItemVerKit, ItemOrKitQualityID    
      --                                                                  FROM  #TmpCRC1sn 
      --                                                                  WHERE RTRIM(SN2)<>''  AND ItemVerKit = 0   -- itemy
      --                                                                  GROUP BY ItemOrKitID, ItemVerKit, ItemOrKitQualityID
                                                                        
      --                                     )        TmpSN
      --                                     GROUP BY ItemOrKitID, ItemVerKit, ItemOrKitQualityID
      --                             ) b
      --                     ) sn
      --              ON hd.ItemOrKitID =sn.ItemOrKitID AND  hd.ItemVerKit= sn.ItemVerKit AND hd.ItemOrKitQualityID =sn.ItemOrKitQualityID
      --         WHERE hd.ItemVerKit = 0 AND cI.ItemType='CPE' AND hd.RealItemOrKitQuantity<>ISNULL(sn.Suma ,0)

      --      -- 2. Kits
      --         DECLARE @seznamKitsOnly as varchar(max)   -- sem se zapisuje seznam jen Kitů, které mají problém s počtem SN (SN může přebývat nebo scházet)
      --         SET @seznamKitsOnly = 'KITY: '

      --           SELECT @seznamKitsOnly = @seznamKitsOnly +CAST(hd.ItemOrKitID AS varchar(50))  + ' '
      --           FROM
      --           (
      --           SELECT  y.ItemOrKitID, y.ItemVerKit, y.ItemOrKitQualityID, y.NASOBENI, sn.SUMA
      --             FROM (
      --                      SELECT  x.ItemOrKitID, x.ItemVerKit, x.ItemOrKitQualityID, SUM(x.NASOBENI) NASOBENI
      --                      FROM (
      --                             SELECT bbb.ItemOrKitID, bbb.ItemVerKit, bbb.ItemOrKitQualityID, bbb.SumRealItemOrKitQuantity,bbb.[ItemOrKitQuantity]
      --                                   ,KIItemOrKitId
      --                                   ,bbb.SumRealItemOrKitQuantity*bbb.[ItemOrKitQuantity]*bbb.Multiplayer  NASOBENI -- výpočet počtu SN PocetSN=RealněDodaneMnozstviKitu*PocetMnozstviItemuvKitu*KoeficientNasobeni
      --                             FROM
      --                             (
      --                                   SELECT aa.ItemOrKitID, aa.ItemVerKit, aa.ItemOrKitQualityID, aa.SumRealItemOrKitQuantity
      --                                         ,KI.[ItemOrKitQuantity],KI.[ItemOrKitId] AS KIItemOrKitId,cI.[ItemType], K.Multiplayer 
      --                                    FROM
      --                                    (
      --                                           SELECT ItemOrKitID, ItemVerKit, ItemOrKitQualityID, SUM(RealItemOrKitQuantity) SumRealItemOrKitQuantity 
      --                                           FROM #TmpCRC1hd 
      --                                           WHERE ItemVerKit = 1 
      --                                           GROUP BY ItemOrKitID, ItemVerKit, ItemOrKitQualityID
      --                                    ) aa
      --                                    INNER JOIN [dbo].[cdlKits]         K      -- napojení na číselník kitů, abychom získali koeficient násobení
      --                                      ON aa.ItemOrKitID = K.ID
      --                                    INNER JOIN [dbo].[cdlKitsItems]    KI     -- napojení na itemy obsažené v kitu, abychom se uměli napojit na číselník itemů
      --                                      ON aa.ItemOrKitID = KI.cdlKitsId
      --                                    INNER JOIN cdlItems                cI     -- napojení na číselník itemů, abychom získali jen CPE
      --                                      ON KI.[ItemOrKitId] = cI.ID 
      --                                    WHERE cI.ItemType='CPE' 
      --                             ) bbb
      --                       ) x 
      --                       GROUP BY x.ItemOrKitID, x.ItemVerKit, x.ItemOrKitQualityID
      --                ) y
      --                LEFT OUTER JOIN  (SELECT SUMA, ItemOrKitID, ItemVerKit, ItemOrKitQualityID       -- 2016-01-04
      --                      FROM (
      --                            SELECT SUMx SUMA, ItemOrKitID, ItemVerKit, ItemOrKitQualityID                               -- tenhle select se stal vývojem asi nadbytečný, ale nechci ho nyní vyhazovat, abych něco nezvoral a tím posunul čas
      --                            FROM (
      --                                     SELECT SUM(SUMAsn1) SUMx, ItemOrKitID, ItemVerKit, ItemOrKitQualityID              -- součet 
      --                                     FROM
      --                                     (
      --                                           SELECT SUM(1) SUMAsn1, ItemOrKitID, ItemVerKit, ItemOrKitQualityID 
      --                                                                  FROM  #TmpCRC1sn 
      --                                                                  WHERE RTRIM(SN1)<>'' AND ItemVerKit = 1               -- jen kity a vyplněné SN1   -- 2016-07-20
      --                                                                  GROUP BY ItemOrKitID, ItemVerKit, ItemOrKitQualityID
      --                                           UNION ALL                                                                                                                   -- 2016-07-20
      --                                           SELECT SUM(1) SUMAsn1, ItemOrKitID, ItemVerKit, ItemOrKitQualityID 
      --                                                                  FROM  #TmpCRC1sn 
      --                                                                  WHERE RTRIM(SN2)<>''  AND ItemVerKit = 1              -- jen kity a vyplněné SN2
      --                                                                  GROUP BY ItemOrKitID, ItemVerKit, ItemOrKitQualityID
      --                                     )        TmpSN
      --                                     GROUP BY ItemOrKitID, ItemVerKit, ItemOrKitQualityID
      --                                 ) b
      --                           )bb
      --                     ) sn
      --                       ON y.ItemOrKitID =sn.ItemOrKitID AND  y.ItemVerKit= sn.ItemVerKit AND y.ItemOrKitQualityID =sn.ItemOrKitQualityID
      --              ) hd
      --              WHERE  hd.NASOBENI <> ISNULL(hd.SUMA,0)   -- 2016-01-04

      --           SET @SeznamItems = @seznamItemsOnly +'<br />' + @seznamKitsOnly
								                  
      --           SET @myAdresaLogistika = @myAdresaLogistika+';michal.rezler@upc.cz;max.weczerek@upc.cz'
      --           --SET @myAdresaLogistika = ';michal.rezler@upc.cz;max.weczerek@upc.cz'
      --           SET @sub = 'FENIX - C1 INFO' + ' Databáze: '+ISNULL(@myDatabaseName,'')+
      --                      '; MessageId = ' + ISNULL(CAST(@myMessageId AS VARCHAR(50)),'') +  
      --                      '; (Objednávka = ' + ISNULL(CAST(@myCrmOrderID AS VARCHAR(50)),'') + ')'  -- 2016-01-13 
      --           SET @msg = 'Program [dbo].[prCrmOrderC1ins]<br /> Nesouhlasí počty SN s reálným množstvím <br />' +@SeznamItems   
      --           EXEC @result = msdb.dbo.sp_send_dbmail
      --          		@profile_name = 'Automat', --@MailProfileName
      --          		@recipients = @myAdresaLogistika,
      --          		@subject = @sub,
      --          		@body = @msg,
      --          		@body_format = 'HTML'

      --      END

      --     -- ================== toto je nově ================ END ===============================
      --END 

      BEGIN -- ============================ Zpracování ===============================
         --@myMessageId             
         --@myMessageTypeId         
         --@myMessageTypeDescription
         --@myCrmOrderID       
         SELECT  @myPocet = COUNT(*) 
         FROM [dbo].[CommunicationMessagesCrmOrderConfirmation]
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
             SELECT x.[ID], x.[MessageID], x.[MessageTypeID], x.[MessageTypeDescription], x.[MessageDateOfShipment], x.[CrmOrderID]
						       ,x.[X_SHIPMENT_REAL], x.[X_PARCEL_NUMBER], x.[X_RECONCILIATION]
									 ,x.[L_ITEM_OR_KIT_ID], x.[L_ITEM_OR_KIT_DESCRIPTION], x.[L_ITEM_OR_KIT_QUANTITY], x.[L_ITEM_OR_KIT_MEASURE_ID]
									 ,x.[L_ITEM_OR_KIT_MEASURE], x.[L_ITEM_OR_KIT_QUALITY_ID], x.[L_ITEM_OR_KIT_QUALITY], x.[L_ITEM_VER_KIT]
             FROM #TmpCRC1hd x ORDER BY MessageID, MessageTypeID, CrmOrderID, L_ITEM_VER_KIT, L_ITEM_OR_KIT_ID

             OPEN myCursorCMSOChd
             FETCH NEXT FROM myCursorCMSOChd INTO @myID, @myMessageID, @myMessageTypeID, @myMessageTypeDescription, @myMessageDateOfShipment, @myCrmOrderID
										, @myX_SHIPMENT_REAL, @myX_PARCEL_NUMBER, @myX_RECONCILIATION
										, @myL_ITEM_OR_KIT_ID, @myL_ITEM_OR_KIT_DESCRIPTION, @myL_ITEM_OR_KIT_QUANTITY, @myL_ITEM_OR_KIT_MEASURE_ID
										, @myL_ITEM_OR_KIT_MEASURE, @myL_ITEM_OR_KIT_QUALITY_ID, @myL_ITEM_OR_KIT_QUALITY, @myL_ITEM_VER_KIT

             SELECT @myKeyShipmentOrderID = -1, @myKeyDestinationPlacesId = -1, @myKeyDestinationPlacesId = -1

             WHILE @@FETCH_STATUS = 0
             BEGIN  -- @@FETCH_STATUS    --  OR @myKeyItemVerKit<>@myItemVerKit
                   IF @myKeyShipmentOrderID <> @myCrmOrderID --OR @myKeyDestinationPlacesId <> @myDestinationPlacesId OR @myKeyDestinationPlacesId <> @myDestinationPlacesId
                    BEGIN
                       SELECT @myKeyShipmentOrderID = @myCrmOrderID --, @myKeyItemVerKit=@myItemVerKit, @myKeyDestinationPlacesId = @myDestinationPlacesId, @myKeyDestinationPlacesId = @myDestinationPlacesId
                       INSERT INTO [dbo].[CommunicationMessagesCrmOrderConfirmation]
                                  ([MessageId]
                                  ,[MessageTypeId]
                                  ,[MessageDescription]
																	,[MessageDateOfShipment]
																	,[CrmOrderID]
																	,[X_SHIPMENT_REAL]
																	,[X_PARCEL_NUMBER]
																	,[X_RECONCILIATION]
                                  ,[IsActive]
                                  ,[ModifyDate]
                                  ,[ModifyUserId])
                            VALUES
                                  (@myMessageId -- <MessageId, int,>
                                  ,@myMessageTypeId -- <MessageTypeId, int,>
                                  ,@myMessageTypeDescription -- <MessageDescription, nvarchar(200),>
                                  ,@myMessageDateOfShipment -- <MessageDateOfShipment, datetime,>                                  
																	,@myCrmOrderID
																	,@myX_SHIPMENT_REAL
																	,@myX_PARCEL_NUMBER
																	,@myX_RECONCILIATION
                                  ,1 -- <IsActive, bit,>
                                  ,@myToDay -- <ModifyDate, datetime,>
                                  ,0 -- <ModifyUserId, int,>
                                  )    
                                                      
                        SET @myError = @myError + @@ERROR
                        SET @myIdentity = @@IDENTITY          -- ID hlavicky
                        SET @myAnnouncement = @myAnnouncement + CAST(@myIdentity AS VARCHAR(50))+','
												                        
                        UPDATE [dbo].[CommunicationMessagesCrmOrder] SET [MessageStatusId] = 5, [ModifyDate] = @myToDay
                        FROM [dbo].[CommunicationMessagesCrmOrder]   CMSOS
                        WHERE ID = @myKeyShipmentOrderID 
                  
                        SET @myError = @myError + @@ERROR
                    END

					--BEGIN --- VYMAZAT  ---
					--	IF @@TRANCOUNT > 0 COMMIT TRAN
					--	SELECT 1
					--	SELECT @myIdentity '@myIdentity'		-- TODO : vymazat
					--	SELECT @myError '@myError'					-- TODO : vymazat
					--	--SELECT @myItemSNs '@myItemSNs'    -- TODO : vymazat
					--	--SELECT * FROM #TmpCRC1sn A
					--	IF OBJECT_ID('tempdb..#TmpCRC1hd','table') IS NOT NULL DROP TABLE #TmpCRC1hd			-- TODO : vymazat
					--	IF OBJECT_ID('tempdb..#TmpCRC1sn','table') IS NOT NULL DROP TABLE #TmpCRC1sn			-- TODO : vymazat
					--	RETURN															-- TODO : vymazat
					--END --- VYMAZAT  ---
					
                    IF @myError = 0 AND @myIdentity > 0
                    BEGIN  -- 1
                        SET @myItemSNs=''
                        SELECT @myItemSNs = SN FROM (
                        SELECT DISTINCT LEFT(r.ResourceName , CASE WHEN LEN(r.ResourceName) > 0 THEN LEN(r.ResourceName)-1 ELSE 0 END) [SN], A.[L_ITEM_VER_KIT], A.[L_ITEM_OR_KIT_ID]
                        FROM #TmpCRC1sn A
                         CROSS APPLY (SELECT CAST([SN1] AS VARCHAR(50))+ ', ' + CAST([SN2] AS VARCHAR(50))+ '; '   FROM #TmpCRC1sn  B
                             WHERE A.[L_ITEM_VER_KIT] = B.[L_ITEM_VER_KIT] AND A.L_ITEM_OR_KIT_ID = B.L_ITEM_OR_KIT_ID
                             FOR XML PATH('')
                             ) r (ResourceName) 
                             ) AA 
                             WHERE AA.[L_ITEM_VER_KIT] = @myL_ITEM_VER_KIT AND AA.L_ITEM_OR_KIT_ID = @myL_ITEM_OR_KIT_ID

                        INSERT INTO [dbo].[CommunicationMessagesCrmOrderConfirmationItems]
																([CrmOrderConfirmationID]
																,[L_ITEM_VER_KIT]
																,[L_ITEM_OR_KIT_ID]
																,[L_ITEM_OR_KIT_DESCRIPTION]
																,[L_ITEM_OR_KIT_QUALITY]
																,[L_ITEM_OR_KIT_QUALITY_ID]
																,[L_ITEM_OR_KIT_QUANTITY]
																,[L_ITEM_OR_KIT_MEASURE_ID]
																,[L_ITEM_OR_KIT_MEASURE]
																,[KitSNs]
																,[IsActive]
																,[ModifyDate]
																,[ModifyUserID])
                             VALUES
																 (@myIdentity
																 ,@myL_ITEM_VER_KIT
																 ,@myL_ITEM_OR_KIT_ID
																 ,@myL_ITEM_OR_KIT_DESCRIPTION
																 ,@myL_ITEM_OR_KIT_QUALITY
																 ,@myL_ITEM_OR_KIT_QUALITY_ID
																 ,@myL_ITEM_OR_KIT_QUANTITY
																 ,@myL_ITEM_OR_KIT_MEASURE_ID
																 ,@myL_ITEM_OR_KIT_MEASURE
																 ,@myItemSNs
                                 ,1					-- <IsActive, bit,>
                                 ,@myToDay		-- <ModifyDate, datetime,>
                                 ,0					-- <ModifyUserId, int,>
                                 )                      
                        SET @myError = @myError + @@ERROR
                        SET @myIdentityx = @@IDENTITY         -- ID itemu
																								
                        IF @myError = 0 AND  @myIdentityx > 0 AND LTRIM(RTRIM(ISNULL(@myItemSNs, ''))) <> ''
                        BEGIN
                              INSERT INTO [dbo].[CommunicationMessagesCrmOrderConfirmationItemsSerNum]
                                        ([CrmOrderConfirmationItemsID]
                                        ,[SN1]
                                        ,[SN2]
                                        ,[IsActive]
                                        ,[ModifyDate]
                                        ,[ModifyUserId])
                              SELECT @myIdentityx, SN1, SN2, 1, @myToDay, 0 FROM #TmpCRC1sn AA  
                              WHERE 
                              AA.[L_ITEM_OR_KIT_QUALITY_ID] = @myL_ITEM_OR_KIT_QUALITY_ID AND 
                              AA.[L_ITEM_VER_KIT] = @myL_ITEM_VER_KIT AND AA.[L_ITEM_OR_KIT_ID] = @myL_ITEM_OR_KIT_ID

                              SET @myError = @myError + @@ERROR
                        END
                     END  -- 1
										 FETCH NEXT FROM myCursorCMSOChd INTO @myID, @myMessageID, @myMessageTypeID, @myMessageTypeDescription, @myMessageDateOfShipment, @myCrmOrderID
														, @myX_SHIPMENT_REAL, @myX_PARCEL_NUMBER, @myX_RECONCILIATION
														, @myL_ITEM_OR_KIT_ID, @myL_ITEM_OR_KIT_DESCRIPTION, @myL_ITEM_OR_KIT_QUANTITY, @myL_ITEM_OR_KIT_MEASURE_ID
														, @myL_ITEM_OR_KIT_MEASURE, @myL_ITEM_OR_KIT_QUALITY_ID, @myL_ITEM_OR_KIT_QUALITY, @myL_ITEM_VER_KIT

             END    -- @@FETCH_STATUS
             CLOSE myCursorCMSOChd;
             DEALLOCATE myCursorCMSOChd;
						 				
				--BEGIN------ TODO : VYMAZAT ---
				--	IF @@TRANCOUNT > 0 COMMIT TRAN					-- TODO : vymazat
				--	SELECT 2																-- TODO : vymazat
				--	SELECT @myIdentity '@myIdentity'				-- TODO : vymazat
				--	SELECT @myIdentityx '@myIdentityx'			-- TODO : vymazat
				--	SELECT @myError '@myError'							-- TODO : vymazat
				--	RETURN																	-- TODO : vymazat																				
				--END------ TODO : VYMAZAT ---
						 
            IF @myError = 0
            BEGIN 
                IF @@TRANCOUNT > 0 
                BEGIN
                         IF @@TRANCOUNT > 0 COMMIT TRAN

                         SET  @sub = 'FENIX - C1 (prCrmOrderC1ins) - Oznámení' + ' Databáze: '+ISNULL(@myDatabaseName,'')
                         SET  @msg = 'Ke schválení byly obdrženy následující message <br /> ID = : '  + @myAnnouncement + ', MessageId = ' + ISNULL(CAST(@myMessageId AS  nvarchar(50)),'')
												 EXEC @result = msdb.dbo.sp_send_dbmail
		                          @profile_name = 'Automat', 
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
                         SET  @sub = 'FENIX - C1 (prCrmOrderC1ins) CHYBA ROLLBACK' + ' Databáze: '+ISNULL(@myDatabaseName,'')
                         SET  @msg = 'Program [dbo].[prCrmOrderC1ins]; '  + ISNULL(ERROR_MESSAGE(),'') + ISNULL(CAST(ERROR_NUMBER() AS VARCHAR(50)),'') 
                         EXEC @result = msdb.dbo.sp_send_dbmail
                        				@profile_name = 'Automat', 
                        				@recipients = @myAdresaProgramator,
                        				@subject = @sub,
                        				@body = @msg,
                        				@body_format = 'HTML'
												 SET @ReturnMessage = @msg + '. Processing was stopped.}'
												 SET @ReturnValue = 1
                 END 
             END 
            ELSE
            BEGIN 
                IF @@TRANCOUNT > 0 ROLLBACK TRAN 
                SELECT @ReturnValue=1, @ReturnMessage='Chyba'
                SET @sub = 'FENIX - C1 (prCrmOrderC1ins) CHYBA ROLLBACK 2' + ' Databáze: '+ISNULL(@myDatabaseName,'')
                SET @msg = 'Program [dbo].[prCrmOrderC1ins]; '  + ISNULL(ERROR_MESSAGE(),'') + ISNULL(CAST(ERROR_NUMBER() AS VARCHAR(50)),'') 
                EXEC @result = msdb.dbo.sp_send_dbmail
               		@profile_name = 'Automat', 
               		@recipients = @myAdresaProgramator,
               		@subject = @sub,
               		@body = @msg,
               		@body_format = 'HTML'
             			SET @ReturnMessage = @msg + '. Processing was stopped.}'
									SET @ReturnValue = 1
             END 
         END    -- @mOK=1
         ELSE
         BEGIN
             IF @myPocet>0
             BEGIN 
                   IF @@TRANCOUNT > 0 ROLLBACK TRAN
                   SELECT @ReturnValue=1, @ReturnMessage='CInfo'
                   SET    @sub = 'FENIX - C1 (prCrmOrderC1ins)' + ' Databáze: '+ISNULL(@myDatabaseName,'')
                   SET    @msg = 'Program [dbo].[prCrmOrderC1ins]; Záznam MessageId=' + ISNULL(CAST(@myMessageId AS VARCHAR(50)),'') + ', MessageTypeId = '+ ISNULL(CAST(@myMessageTypeId AS VARCHAR(50)),'') + ' byl již jednou naveden !'
                   EXEC   @result = msdb.dbo.sp_send_dbmail
                  			@profile_name = 'Automat', 
                  			@recipients = @myAdresaProgramator,
                  			@subject = @sub, 
                  			@body = @msg, 
                  			@body_format = 'HTML'
										SET @ReturnMessage = @msg + ' {Program [dbo].[prCrmOrderC1ins]; MessageId=' + ISNULL(CAST(@myMessageId AS VARCHAR(50)),'') + ', MessageTypeId = '+ ISNULL(CAST(@myMessageTypeId AS VARCHAR(50)),'') 
										                          + ' already exist! Processing was stopped'
										SET @ReturnValue = 1
             END
         END
      END
END TRY
BEGIN CATCH
       IF @@TRANCOUNT > 0 ROLLBACK TRAN
           
       SET @sub = 'FENIX - C1 (prCrmOrderC1ins) CHYBA' + ' Databáze: '+ISNULL(@myDatabaseName,'')
       SET @msg = 'Program [dbo].[prCrmOrderC1ins]; '  + ISNULL(ERROR_MESSAGE(),'') + ISNULL(CAST(ERROR_NUMBER() AS VARCHAR(50)),'') 
       EXEC @result = msdb.dbo.sp_send_dbmail
      		    @profile_name = 'Automat', 
      		    @recipients = @myAdresaProgramator,
      		    @subject = @sub,
      		    @body = @msg,
      		    @body_format = 'HTML'								

				SET @ReturnMessage = @msg + '. Processing was stopped.}'
				SET @ReturnValue = 10 
END CATCH
END
GO
GRANT EXECUTE
    ON OBJECT::[dbo].[prCrmOrderC1ins] TO [FenixW]
    AS [dbo];

