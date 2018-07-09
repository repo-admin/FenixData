CREATE PROCEDURE [dbo].[prCMSOins]
	  @ReturnValue  int = -1 OUTPUT,
     @ReturnMessage nvarchar(2048) = null OUTPUT
AS
-- ===============================================================================================
-- Created by   : Weczerek Max
-- Created date : 2014-06-23
-- Description  : 
-- ===============================================================================================
/*
Kopiruje data z tabulek [dbo].[FenixHeliosObjHla] a [dbo].[FenixHeliosObjPol] 
         do tabulek [dbo].[CommunicationMessagesReceptionSent] a [dbo].[CommunicationMessagesReceptionSentItems]
Kontroluje data
Přiřazuje číslo message
*/
SET NOCOUNT ON
DECLARE @myDatabaseName  nvarchar(100)
BEGIN TRY

    SELECT @myDatabaseName = DB_NAME() 

    IF (SELECT CURSOR_STATUS('global','crFenixHeliosObjHla')) >= -1
     BEGIN
              DEALLOCATE crFenixHeliosObjHla
     END
     
    DECLARE crFenixHeliosObjHla CURSOR 
         FOR SELECT [ID], [RadaDokladu], [PoradoveCislo], [CisloOrg], [DIC], [Hit], [EndDataFenix], Splatnost
               FROM [dbo].[FenixHeliosObjHla] 
               WHERE [Hit]=CAST(0 AS bit) --AND [ID]>147963
               FOR UPDATE OF [Hit]
    
    DECLARE	@hID [int],
    	      @hRadaDokladu [nvarchar](3),
    	      @hPoradoveCislo [int],
    	      @hCisloOrg [int] ,
            @hSplatnost [datetime] ,
    	      @hDIC [nvarchar](15) ,
    	      @hHit [bit],
    	      @hEndDataFenix [datetime] 
    
    DECLARE	@pID [int],
    	      @pIDDoklad [int],
    	      @pSkupZbo [nvarchar](3),
    	      @pRegCis [nvarchar](30),
    	      @pNazev1 [nvarchar](100),
    	      @pMJ [nvarchar](10) ,
    	      @pMJEvidence [nvarchar](10) ,
    	      @pMnozstvi [numeric](19, 6)
    
    DECLARE	@keyID [int], @hIdent [int], @ItemSupplierID  [int], @ItemSupplierDescription [nvarchar] (500), @myError [int]
          , @iRadaPlusPoradoveCislo [int], @cRadaPlusPoradoveCislo [varchar](50)

    SELECT @keyID = -1, @hIdent = -1, @ItemSupplierID = -1, @ItemSupplierDescription = NULL
    
    DECLARE  @myPocetPolozekCelkem [int], @myPocetPolozekPomooc[int], @mOK [bit]
    
    DECLARE  @myAdresaLogistika  varchar(500),@myAdresaProgramator  varchar(500) 
    SET @myAdresaLogistika   = [dbo].[fnHomeAdresses] (4)
    SET @myAdresaProgramator = [dbo].[fnHomeAdresses] (2)
    
    DECLARE  @myMessage [nvarchar] (max), @myReturnValue [int],@myReturnMessage nvarchar(2048)
    -- ---
    DECLARE @msg    varchar(max)
    DECLARE @MailTo varchar(150)
    DECLARE @MailBB varchar(150)
    DECLARE @sub    varchar(1000)
    DECLARE @Result int
    SET @msg = ''
    -- ---
    -- ==========================================================
    OPEN crFenixHeliosObjHla
    
    FETCH NEXT FROM crFenixHeliosObjHla 
    INTO 	@hID, @hRadaDokladu, @hPoradoveCislo ,@hCisloOrg, @hDIC, @hHit, @hEndDataFenix, @hSplatnost
    SET @mOK = 1
    -- SELECT '1'
    WHILE @@FETCH_STATUS = 0
    BEGIN
          SET @myError = 0
          IF @hID<>@keyID
          BEGIN
              SET @keyID = @hID
              -- ============ Kontrola existence dodavatele ======================================================
              SET @msg=''
              SELECT @ItemSupplierID = ID, @ItemSupplierDescription = [CompanyName]  FROM [dbo].[cdlSuppliers] WHERE [OrganisationNumber] = @hCisloOrg
    
              IF @ItemSupplierID IS NULL OR  @ItemSupplierID < 1 OR @ItemSupplierDescription IS NULL OR @ItemSupplierDescription=''
              BEGIN
                  SELECT  @myMessage = NULL, @myReturnValue = -1,@myReturnMessage = NULL
                  SET @myMessage = 'Schází dodavatel: @hCisloOrg=' + CAST(@hCisloOrg AS VARCHAR(50))
                  SET @msg = @msg + @myMessage + '<br />'
                  SELECT @msg = @msg + ' O ' + [RadaDokladu]+ ' / '+CAST([PoradoveCislo] AS VARCHAR(50)) FROM [dbo].[FenixHeliosObjHla] WHERE [ID]=@hID
    
                  SET @myMessage =  REPLACE(@msg,'<br />','; ')
    
                  EXEC [dbo].[prAppLogWrite] @Type='INFO', @Message =  @myMessage, @XmlMessage = NULL, @UserId = 0,@Source = 'prCMSOins'
                                           , @ReturnValue = @myReturnValue,@ReturnMessage=@myReturnMessage
                  SET @mOK = 0
    
                  SET @sub = 'FENIX - Kontrola objednávek z Heliosu - kontrola existence dodavatele' + ' Databáze: '+ISNULL(@myDatabaseName,'')
    			     EXEC @result = msdb.dbo.sp_send_dbmail
    			          @profile_name = 'Automat', 
    			          @recipients =  @myAdresaProgramator ,--@myAdresaLogistika,
                       --@copy_recipients = @myAdresaProgramator,
    			          @subject = @sub,
    			          @body = @msg,
        		          @body_format = 'HTML'
              END
    
              -- ============ Kontrola existence zboží ===========================================================
              SET @msg=''
              SELECT @myPocetPolozekCelkem = COUNT(*) FROM [dbo].[FenixHeliosObjPol]  WHERE [IDDoklad] = @hID
              SELECT @myPocetPolozekPomooc = COUNT(*) FROM [dbo].[FenixHeliosObjPol] P INNER JOIN [dbo].[cdlItems] cdl 
                  ON P.[SkupZbo]=cdl.[GroupGoods]  COLLATE SQL_Czech_CP1250_CI_AS AND P.[RegCis] = cdl.[Code] COLLATE SQL_Czech_CP1250_CI_AS     
                  WHERE [IDDoklad] = @hID
    
              IF @myPocetPolozekCelkem<>@myPocetPolozekPomooc
              BEGIN
                    SELECT  @myMessage = NULL, @myReturnValue = -1, @myReturnMessage = NULL
                    SELECT @myMessage = LEFT(r.ResourceName , LEN(r.ResourceName)-1)
                    FROM (
                           SELECT Item + ', '   FROM  
                                  (
                                  SELECT [SkupZbo] + '  ' +[RegCis]+', ID='+CAST(id AS VARCHAR) AS Item FROM [dbo].[FenixHeliosObjPol] 
                                  WHERE [IDDoklad] = @hID AND CAST([SkupZbo] AS CHAR(5)) + CAST([RegCis] AS CHAR(20)) COLLATE SQL_Czech_CP1250_CI_AS NOT IN (SELECT CAST([GroupGoods] AS CHAR(5)) + CAST([Code] AS CHAR(20)) FROM [dbo].[cdlItems])
                                  ) A   FOR XML PATH('')
                         ) r (ResourceName) 
    
                    SET @myMessage = 'Schází skladová položka: @hID=' + CAST(@hID AS VARCHAR(50)) +' --- ' +ISNULL(@myMessage,'')
                    SET @msg = @msg + @myMessage + '<br />'
                    SELECT @msg = @msg + ' O ' + [RadaDokladu]+ ' / '+CAST([PoradoveCislo] AS VARCHAR(50)) FROM [dbo].[FenixHeliosObjHla] WHERE [ID]=@hID
    
                    SET @myMessage =  REPLACE(@msg,'<br />','; ')
    
                    EXEC [dbo].[prAppLogWrite] @Type='INFO', @Message =  @myMessage, @XmlMessage = NULL, @UserId = 0,@Source = 'prCMSOins'
                                             , @ReturnValue = @myReturnValue,@ReturnMessage=@myReturnMessage
                    SET @mOK = 0
    
                    SET @sub = 'FENIX - Kontrola objednávek z Heliosu - kontrola existence zboží' + ' Databáze: '+ISNULL(@myDatabaseName,'')
    		          EXEC @result = msdb.dbo.sp_send_dbmail
    		 	             @profile_name = 'Automat', --@MailProfileName
                          @recipients =  @myAdresaProgramator,
    		 	             --     @recipients = @myAdresaLogistika,
                          --     @copy_recipients = @myAdresaProgramator,
    		 	             @subject = @sub,
    		 	             @body = @msg,
        	 	             @body_format = 'HTML'
    
              END
    
              -- ============ Kontrola existence měrné jednotky ==================================================
              SET @msg=''
              SELECT @myPocetPolozekPomooc = COUNT(*) FROM [dbo].[FenixHeliosObjPol] P INNER JOIN [dbo].[cdlMeasures] cdl 
                  ON UPPER(P.[MJ]) = UPPER(cdl.[Code]) COLLATE SQL_Czech_CP1250_CI_AS     
                  WHERE [IDDoklad] = @hID
    
              IF @myPocetPolozekCelkem<>@myPocetPolozekPomooc
              BEGIN
                    SELECT  @myMessage = NULL, @myReturnValue = -1, @myReturnMessage = NULL
                    SELECT @myMessage = LEFT(r.ResourceName , LEN(r.ResourceName)-1)
                    FROM (
                           SELECT Item + ', '   FROM  
                                  (
                                  SELECT ISNULL(MJ,'NULL ')+'hodnota, ID='+CAST(id AS VARCHAR) AS Item FROM [dbo].[FenixHeliosObjPol] 
                                  WHERE [IDDoklad]=@hID AND UPPER(ISNULL(MJ,'')) COLLATE SQL_Czech_CP1250_CI_AS NOT IN (SELECT UPPER(CODE) FROM [dbo].[cdlMeasures])
                                  ) A   FOR XML PATH('')
                         ) r (ResourceName) 
    
                    SET @myMessage = 'Schází měrná jednotka: @hID=' + CAST(@hID AS VARCHAR(50)) +' --- ' +ISNULL(@myMessage,'')
                    SET @msg = @msg + @myMessage + '<br />'
                    SELECT @msg = @msg + ' O ' + [RadaDokladu]+ ' / '+CAST([PoradoveCislo] AS VARCHAR(50)) FROM [dbo].[FenixHeliosObjHla] WHERE [ID]=@hID
    
                    SET @myMessage =  REPLACE(@msg,'<br />','; ')
    
                    EXEC [dbo].[prAppLogWrite] @Type='INFO', @Message =  @myMessage, @XmlMessage = NULL, @UserId = 0,@Source = 'prCMSOins'
                                             , @ReturnValue = @myReturnValue,@ReturnMessage=@myReturnMessage
                    SET @mOK = 0
    
                    SET @sub = 'FENIX - Kontrola objednávek z Heliosu - kontrola existence měrné jednotky' + ' Databáze: '+ISNULL(@myDatabaseName,'')
    		 	       EXEC @result = msdb.dbo.sp_send_dbmail
    		 	             @profile_name = 'Automat', --@MailProfileName
    		 	             @recipients = @myAdresaLogistika,
                          @copy_recipients = @myAdresaProgramator,
    		 	             @subject = @sub,
    		 	             @body = @msg,
        	 	             @body_format = 'HTML'
              END
    
              -- ============ Kontroly výsledek =================================================================
              IF @mOk = CAST(1 AS bit)
              BEGIN
                    BEGIN TRY
                          BEGIN TRAN
                             DECLARE @myIdentity [int], @FreeNumber [int], @MessageDescription  [nvarchar] (500)
                             SELECT @FreeNumber = [LastFreeNumber] FROM [dbo].[cdlMessageNumber]        WHERE [Code]=1 
                             UPDATE [dbo].[cdlMessageNumber] SET [LastFreeNumber] = @FreeNumber + 1     WHERE [Code]=1
                             SELECT @MessageDescription = [DescriptionEng] FROM [dbo].[cdlMessageTypes] WHERE  [ID]=1

                             SET @cRadaPlusPoradoveCislo = @hRadaDokladu + CAST(@hPoradoveCislo AS VARCHAR(50))
                             SET @iRadaPlusPoradoveCislo  = CAST(@cRadaPlusPoradoveCislo AS int)

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
                                        ,[RadaDokladu]
                                        ,[PoradoveCislo]
                                        ,[RadaPlusPorCislo]
                                        ,[IsActive]
                                        ,[ModifyDate]
                                        ,[ModifyUserId])
                                  VALUES
                                        (@FreeNumber          -- <MessageId, int,>
                                        ,1                    --<MessageType, int,>
                                        ,@MessageDescription  --<MessageDescription, nvarchar(200),>
                                        ,NULL                 --<MessageDateOfShipment, datetime,>
                                        ,1                    --<MessageStatus, int,>
                                        ,@iRadaPlusPoradoveCislo    --<HeliosOrderId, int,>   [RadaDokladu] + CAST([PoradoveCislo]
                                        ,@ItemSupplierID      --<ItemSupplierID, int,>
                                        ,@ItemSupplierDescription --<ItemSupplierDescription, nvarchar(500),>
                                        ,@hSplatnost          --<ItemDateOfDelivery, datetime,>
                                        ,@hRadaDokladu
                                        ,@hPoradoveCislo
                                        ,@cRadaPlusPoradoveCislo
                                        ,1                    --<IsActive, bit,>
                                        ,GetDate()            --<ModifyDate, datetime,>
                                        ,0                    --<ModifyUserId, int,>
                                        )
                             SET @hIdent = @@IDENTITY
                             SET @myError = @@ERROR
    
                             IF  @myError = 0
                             BEGIN
                                 -- *********************
                                 DECLARE @cdlItemsID [int],@cdlMeasuresID [int], @cdlItemDescription [nvarchar] (100)
    
                                 IF (SELECT CURSOR_STATUS('global','crFenixHeliosObjPol')) >= -1
                                 BEGIN
                                          DEALLOCATE crFenixHeliosObjPol
                                 END
                                 DECLARE crFenixHeliosObjPol CURSOR 
                                      FOR SELECT [ID]
                                                ,[IDDoklad]
                                                ,[SkupZbo]
                                                ,[RegCis]
                                                ,[Nazev1]
                                                ,[MJ]
                                                ,[MJEvidence]
                                                ,[Mnozstvi]
                                          FROM [dbo].[FenixHeliosObjPol] WHERE [IDDoklad] = @hID
    
                                 OPEN crFenixHeliosObjPol
                                 FETCH NEXT FROM crFenixHeliosObjPol 
                                 INTO 	@pID, @pIDDoklad, @pSkupZbo, @pRegCis, @pNazev1, @pMJ, @pMJEvidence, @pMnozstvi
                                 WHILE @@FETCH_STATUS = 0 AND @myError = 0
                                 BEGIN
                                      SELECT @cdlItemsID = ID, @cdlItemDescription = [DescriptionCz] FROM  [dbo].[cdlItems] cdl WHERE [GroupGoods] = @pSkupZbo AND [Code] = CAST(@pRegCis AS nvarchar(50))
                                      SELECT @cdlMeasuresID = ID FROM [dbo].[cdlMeasures] cdl WHERE UPPER(@pMJ) = UPPER(cdl.[Code]) COLLATE SQL_Czech_CP1250_CI_AS     
     
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
                                                 ,[IsActive]
                                                 ,[ModifyDate]
                                                 ,[ModifyUserId])
                                           VALUES
                                                 (@hIdent                            --<CMSOId, int,>
                                                 ,@iRadaPlusPoradoveCislo            --<HeliosOrderId, int,> RadaPlusPoradoveCislo
                                                 ,@pID                               --<HeliosOrderRecordId, int,>
                                                 ,@cdlItemsID                        --<ItemID, int,>
                                                 ,@pSkupZbo                          --<GroupGoods, nvarchar(3),>
                                                 ,CAST(@pRegCis AS nvarchar(50) )    --<ItemCode, nvarchar(50),>
                                                 ,@cdlItemDescription                --<ItemDescription, nvarchar(500),>
                                                 ,CAST(@pMnozstvi AS numeric (18,3)) --<ItemQuantity, numeric(18,3),>
                                                 ,@cdlMeasuresID                     --<MeasuresID, int,>
                                                 ,@pMJ                               --<ItemUnitOfMeasure, nvarchar(50),>
                                                 ,1                                  --<IsActive, bit,>
                                                 ,GetDate()                          --<ModifyDate, datetime,>
                                                 ,0                                  --<ModifyUserId, int,>
                                                 )
                                      SET @myError = @myError + @@ERROR
                                      FETCH NEXT FROM crFenixHeliosObjPol 
                                      INTO 	@pID, @pIDDoklad, @pSkupZbo, @pRegCis, @pNazev1, @pMJ, @pMJEvidence, @pMnozstvi
                                 END
--SELECT @myError
                                 IF @myError = 0
                                 BEGIN
                                    UPDATE FenixHeliosObjHla SET [Hit]=CAST(1 AS bit) WHERE CURRENT OF crFenixHeliosObjHla
                                    IF @@TRANCOUNT>0 COMMIT TRAN 
                                    SET @ReturnValue = 0
                                 END
                                 ELSE
                                    BEGIN
                                       SET @ReturnValue = @myError
                                       IF @@TRANCOUNT>0 ROLLBACK TRAN
                                       SET @sub = 'FENIX - Kontrola objednávek z Heliosu - nutná kontrola    X' + ' Databáze: '+ISNULL(@myDatabaseName,'')
                                       SET @msg = 'Zkontrolujte @hID=' + CAST(@hID AS VARCHAR(50)) +' '+ ISNULL(ERROR_MESSAGE(),'')
    			                    		  EXEC @result = msdb.dbo.sp_send_dbmail
    			                    		       @profile_name = 'Automat', --@MailProfileName
    			                    		       @recipients = 'max.weczerek@upc.cz',
    			                    		       @subject = @sub,
    			                    		       @body = @msg,
    			                    		       @body_format = 'HTML'
                                    END 
                                                       
                                 CLOSE crFenixHeliosObjPol
                                 DEALLOCATE crFenixHeliosObjPol
                             END
                             ELSE 
                             BEGIN
                                 SET @ReturnValue = @myError
                                 IF @@TRANCOUNT>0 ROLLBACK TRAN
                                 SET @sub = 'FENIX - Kontrola objednávek z Heliosu - nutná kontrola    Y' + ' Databáze: '+ISNULL(@myDatabaseName,'')
                                 SET @msg = 'Zkontrolujte @hID=' + CAST(@hID AS VARCHAR(50)) +' '+ ISNULL(ERROR_MESSAGE(),'')
    			              		  EXEC @result = msdb.dbo.sp_send_dbmail
    			              		       @profile_name = 'Automat', --@MailProfileName
    			              		       @recipients = 'max.weczerek@upc.cz;michal.rezler@upc.cz',
    			              		       @subject = @sub,
    			              		       @body = @msg,
    			              		       @body_format = 'HTML'
                                      IF (SELECT CURSOR_STATUS('global','crFenixHeliosObjPol')) >= -1
                                      BEGIN
                                           DEALLOCATE crFenixHeliosObjPol
                                      END
                                      --IF (SELECT CURSOR_STATUS('global','crFenixHeliosObjHla')) >= -1
                                      --BEGIN
                                      --     DEALLOCATE crFenixHeliosObjHla
                                      --END
                              END
                    END TRY
                    BEGIN CATCH
                         IF @@TRANCOUNT>0 ROLLBACK TRAN
                         SET @sub = 'FENIX - Kontrola objednávek z Heliosu - nutná kontrola    Z' + ' Databáze: '+ISNULL(@myDatabaseName,'')
                         SET @msg = 'Zkontrolujte @hID=' + CAST(@hID AS VARCHAR(50)) +' '+ ISNULL(ERROR_MESSAGE(),'')
    			          	EXEC @result = msdb.dbo.sp_send_dbmail
    			          	     @profile_name = 'Automat', --@MailProfileName
    			          	     @recipients = 'max.weczerek@upc.cz;michal.rezler@upc.cz',
    			          	     @subject = @sub,
    			          	     @body = @msg,
    			                 @body_format = 'HTML'
    
                         DECLARE @errTask nvarchar (126), @errLine int, @errNumb int
                         SET @errTask = ERROR_PROCEDURE()
                         SET @errLine = ERROR_LINE()
                         SET @errNumb = ERROR_NUMBER()
                         SET @ReturnMessage  = ERROR_MESSAGE()
                         SET @ReturnValue = CASE WHEN ISNULL(@errNumb,-1) > 0 THEN @errNumb ELSE -1 END
    
                         IF (SELECT CURSOR_STATUS('global','crFenixHeliosObjPol')) >= -1
                         BEGIN
                              DEALLOCATE crFenixHeliosObjPol
                         END
                         --IF (SELECT CURSOR_STATUS('global','crFenixHeliosObjHla')) >= -1
                         --BEGIN
                         --     DEALLOCATE crFenixHeliosObjHla
                         --END
                     END CATCH
              END
              ELSE
              BEGIN
                    IF @@TRANCOUNT>0 ROLLBACK TRAN
                    SET @sub = 'FENIX - Kontrola objednávek z Heliosu - nutná kontrola' + ' Databáze: '+ISNULL(@myDatabaseName,'')
                    SET @msg = 'Zkontrolujte ' +' OBJ Hlavička ID='+ ISNULL(CAST(@hID AS VARCHAR(50)),'???')+ ISNULL(ERROR_MESSAGE(),'') + ISNULL(CAST(ERROR_NUMBER() AS VARCHAR(50)),'')
    					 EXEC @result = msdb.dbo.sp_send_dbmail
    							@profile_name = 'Automat', --@MailProfileName
    							@recipients = 'max.weczerek@upc.cz;michal.rezler@upc.cz',
    							@subject = @sub,
    							@body = @msg,
    							@body_format = 'HTML'
     
                    IF (SELECT CURSOR_STATUS('global','crFenixHeliosObjPol')) >= -1
                    BEGIN
                         DEALLOCATE crFenixHeliosObjPol
                    END
                    --IF (SELECT CURSOR_STATUS('global','crFenixHeliosObjHla')) >= -1
                    --BEGIN
                    --     DEALLOCATE crFenixHeliosObjHla
                    --END
     
              END
          END
          FETCH NEXT FROM crFenixHeliosObjHla 
          INTO 	@hID, @hRadaDokladu, @hPoradoveCislo ,@hCisloOrg, @hDIC, @hHit, @hEndDataFenix, @hSplatnost
          SET @mOK = 1
    END
    
    IF (SELECT CURSOR_STATUS('global','crFenixHeliosObjHla')) >= -1
     BEGIN
              CLOSE crFenixHeliosObjHla
              DEALLOCATE crFenixHeliosObjHla
     END

    --CLOSE crFenixHeliosObjHla
    --DEALLOCATE crFenixHeliosObjHla
    
    SET @ReturnValue=0
END TRY


BEGIN CATCH
    IF (SELECT CURSOR_STATUS('global','crFenixHeliosObjHla')) >= -1
     BEGIN
              CLOSE crFenixHeliosObjHla
              DEALLOCATE crFenixHeliosObjHla
     END
      IF @@TRANCOUNT>0 ROLLBACK TRAN
      IF @@TRANCOUNT>0 ROLLBACK TRAN
      SET @ReturnValue=1
      SET @sub = 'FENIX - aktualizace tabulek [dbo].[FenixHeliosObjHla],[dbo].[FenixHeliosObjPol] CHYBA' + ' Databáze: '+ISNULL(@myDatabaseName,'')
      SET @msg = 'Program prCMSOins'  + ISNULL(ERROR_MESSAGE(),'') + ISNULL(CAST(ERROR_NUMBER() AS VARCHAR(50)),'')
      EXEC @result = msdb.dbo.sp_send_dbmail
     		@profile_name = 'Automat', --@MailProfileName
     		@recipients = 'max.weczerek@upc.cz;michal.rezler@upc.cz',
     		@subject = @sub,
     		@body = @msg,
     		@body_format = 'HTML'

END CATCH
--return @ReturnValue
-- ==========================================================

--DELETE FROM [dbo].[CommunicationMessagesReceptionSentItems]
--GO
--DBCC CHECKIDENT('CommunicationMessagesReceptionSentItems',RESEED,0)
--GO

--DELETE FROM [dbo].[CommunicationMessagesReceptionSent]
--GO
--DBCC CHECKIDENT('CommunicationMessagesReceptionSent',RESEED,0)
--GO

--UPDATE [Fenix].[dbo].[cdlMessageNumber] SET LastFreeNumber = 1
--UPDATE [dbo].[FenixHeliosObjHla] SET [Hit]=CAST(0 AS bit)

--UPDATE [Fenix].[dbo].[cdlOrderNumber]SET LastFreeNumber = 1

--COMMIT TRAN

--ROLLBACK TRAN










GO
GRANT EXECUTE
    ON OBJECT::[dbo].[prCMSOins] TO [FenixW]
    AS [dbo];

