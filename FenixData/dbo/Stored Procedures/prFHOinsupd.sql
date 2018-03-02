CREATE PROCEDURE [dbo].[prFHOinsupd]
AS
BEGIN
-- ===============================================================================================
-- Created by   : Weczerek Max
-- Created date : 2014-06-24
--                2014-09-22, 2015-01-30, 2015-03-25, 2015-06-24
-- Description  : 
-- ===============================================================================================
/*
Nahrává a aktualizuje data v tabulkách [dbo].[FenixHeliosObjHla] a [dbo].[FenixHeliosObjPol] z databáze CISELNIKY
z view [dbo].[vFenixHeliosObjHla] a [dbo].[vFenixHeliosObjPol]
*/

DECLARE @myDatabaseName  nvarchar(100)
SELECT @myDatabaseName = DB_NAME()
BEGIN TRY
     DECLARE @Odeslat as int
     SET @Odeslat = 0

     DECLARE @pocZaznamuHlaOld AS int
     DECLARE @pocZaznamuPolOld AS int
     
     DECLARE @pocZaznamuHlaNew AS int
     DECLARE @pocZaznamuPolNew AS int
     
     
     SELECT @pocZaznamuHlaOld = COUNT(*) FROM [dbo].[FenixHeliosObjHla]
     SELECT @pocZaznamuPolOld = COUNT(*) FROM [dbo].[FenixHeliosObjPol]
     -- ===============================================================
     UPDATE [dbo].[FenixHeliosObjHla] SET [CisloOrg] = vFHOH.CisloOrg, [TerminDodavky] = vFHOH.TerminDodavky, [Splatnost] = vFHOH.Splatnost
     FROM [dbo].[FenixHeliosObjHla]                             FHOH
     INNER JOIN CISELNIKY.[dbo].[tFenixHeliosObjHla]       vFHOH
           ON FHOH.ID = vFHOH.[ID]
     WHERE FHOH.Hit=0
     SELECT 'UPDATE [dbo].[FenixHeliosObjHla]',@@ROWCOUNT 

     UPDATE [dbo].[FenixHeliosObjPol]  SET [Mnozstvi] = vFHOP.Mnozstvi, [MJ] = vFHOP.MJ, [SkupZbo] = vFHOP.SkupZbo,[RegCis] = vFHOP.RegCis
     FROM [dbo].[FenixHeliosObjPol]                        FHOP
     INNER JOIN CISELNIKY.[dbo].[tFenixHeliosObjPol]  vFHOP
           ON FHOP.ID = vFHOP.[ID]
     INNER JOIN [dbo].[FenixHeliosObjHla]                  FHOH
           ON FHOP.[IDDoklad] = FHOH.ID
     WHERE FHOH.Hit=0
     SELECT 'UPDATE [dbo].[FenixHeliosObjPol]',@@ROWCOUNT 
     

      INSERT INTO [dbo].[FenixHeliosObjHla]
                 ([ID]
                 ,[DruhPohybuZbo]
                 ,[IDSklad]
                 ,[RadaDokladu]
                 ,[PoradoveCislo]
                 ,[CisloOrg]
                 ,[Prijemce]
                 ,[MistoUrceni]
                 ,[Autor]
                 ,[DatPorizeni]
                 ,[Poznamka]
                 ,[CisloZakazky]
                 ,[PopisDodavky]
                 ,[TerminDodavky]
                 ,[Splatnost]
                 ,[DodFak]
                 ,[KontaktZam]
                 ,[IdObdobiStavu]
                 ,[KontaktOsoba]
                 ,[DIC]
                 ,[Hit]
                 ,[EndDataFenix]
                 )
      SELECT      [id]
                 ,[druhPohybuZbozi]
                 ,[idSklad]
                 ,[radaDokladu]
                 ,[poradoveCislo]
                 ,[cisloOrg]
                 ,[prijemce]
                 ,[mistoUceni]
                 ,[autor]
                 ,[datPorizeni]
                 ,[poznámka]
                 ,[cisloZakazky]
                 ,[popisDodavky]
                 ,[terminDodavky]
                 ,[splatnost]
                 ,[dodFak]
                 ,[kontaktZam]
                 ,[idObdobiStavu]
                 ,[kontaktOsoba]
                 ,[DIC]
                 ,0
                 ,NULL FROM CISELNIKY.[dbo].[tFenixHeliosObjHla] 
        WHERE CISELNIKY.[dbo].[tFenixHeliosObjHla].ID NOT IN (SELECT ID FROM [dbo].[FenixHeliosObjHla])
              AND [cisloOrg] IN (SELECT [OrganisationNumber] FROM [dbo].[cdlSuppliers] WHERE [IsActive] = 1)  -- 20150624

SELECT 'INSERT [dbo].[FenixHeliosObjHla]',@@ROWCOUNT
  
    
INSERT INTO [dbo].[FenixHeliosObjPol]
      ([ID],[IDDoklad],[SkupZbo],[RegCis],[Nazev1],[MJ],[MJEvidence],[Mnozstvi],[ItemTypeDesc1],[ItemTypeDesc2])
SELECT [ID],[IDDoklad],[SkupZbo],[RegCis],[Nazev1],[MJ],[MJEvidence],[Mnozstvi], NULL, NULL 
FROM CISELNIKY.[dbo].[tFenixHeliosObjPol] 
WHERE CISELNIKY.[dbo].[tFenixHeliosObjPol].ID NOT IN (SELECT ID FROM [dbo].[FenixHeliosObjPol])  
     AND  [IDDoklad] IN (SELECT id FROM [dbo].[FenixHeliosObjHla] WHERE [IsActive] = 1)  -- 20150624 
     
     -- ===============================================================
     SELECT @pocZaznamuHlaNew = COUNT(*) FROM [dbo].[FenixHeliosObjHla]
     SELECT @pocZaznamuPolNew = COUNT(*) FROM [dbo].[FenixHeliosObjPol]


     DECLARE @err AS varchar(max)
     SET @err ='<br /><br />Scházející dodavatelé: '
     SELECT @err = @err +'<br />CisloOrg ' + CAST([CisloOrg] AS varchar(50))+', řada dokladů:' + [RadaDokladu]+', pořadové číslo:'+ CAST([PoradoveCislo] AS varchar(50)) +'; '  
     FROM CISELNIKY.[dbo].[tFenixHeliosObjHla] WHERE [CisloOrg] NOT IN (SELECT [OrganisationNumber]  FROM [dbo].[cdlSuppliers])    -- 20150624 
     --FROM [dbo].[FenixHeliosObjHla] WHERE [CisloOrg] NOT IN (SELECT [OrganisationNumber]  FROM [dbo].[cdlSuppliers])             -- 20150624 
     
     IF @@ROWCOUNT > 0 SET @Odeslat = 1

     SET @err = @err +'<br /><br />Scházející zboží: '
     --SELECT @err = @err +'<br />' + [SkupZbo] + '  ' +[RegCis] + '  ' + [Nazev1] +'; ' FROM [dbo].[FenixHeliosObjPol]           -- 20150624 
     SELECT @err = @err +'<br />' + [SkupZbo] + '  ' +[RegCis] + '  ' + [Nazev1] +'; ' FROM CISELNIKY.[dbo].[tFenixHeliosObjPol]  -- 20150624 
     WHERE LTRIM(RTRIM([SkupZbo])) + LTRIM(RTRIM([RegCis]) COLLATE Czech_CI_AS) NOT IN  (SELECT LTRIM(RTRIM([GroupGoods]))+LTRIM(RTRIM([Code]))  FROM [dbo].[cdlItems])
     IF @@ROWCOUNT > 0 SET @Odeslat = 1

     SET @err = @err +'<br /><br />Scházející MJ: '
     SELECT @err = @err +'<br />' + ISNULL(MJ,'NULL ')+', ' FROM CISELNIKY.[dbo].[tFenixHeliosObjPol] WHERE MJ  COLLATE Czech_CI_AS NOT IN (SELECT CODE FROM [dbo].[cdlMeasures])   -- 20150624 
     --SELECT @err = @err +'<br />' + ISNULL(MJ,'NULL ')+', ' FROM [dbo].[FenixHeliosObjPol] WHERE MJ  COLLATE Czech_CI_AS NOT IN (SELECT CODE FROM [dbo].[cdlMeasures])            -- 20150624 
     IF @@ROWCOUNT > 0 SET @Odeslat = 1

     --SELECT @pocZaznamuHlaOld, @pocZaznamuPolOld, @pocZaznamuHlaNew, @pocZaznamuPolNew 
     
 
                DECLARE @msg    varchar(max)
                DECLARE @MailTo varchar(150)
                DECLARE @MailBB varchar(150)
                DECLARE @sub    varchar(1000)
                DECLARE @Result int

           IF @pocZaznamuHlaOld<>@pocZaznamuHlaNew OR @pocZaznamuPolOld<>@pocZaznamuPolNew 
           BEGIN
                
                SET @sub = 'Fenix - aktualizace tabulek [dbo].[FenixHeliosObjHla],[dbo].[FenixHeliosObjPol]' + ' Databáze: '+ISNULL(@myDatabaseName,'')
                SET @msg = 'Původní počet FenixHeliosObjHla = ' + CAST(@pocZaznamuHlaOld AS VARCHAR(50)) + '<br />' +
                           'Nový počet FenixHeliosObjHla = ' + CAST(@pocZaznamuHlaNew AS VARCHAR(50)) + '<br /><br />' +
                           'Původní počet FenixHeliosObjPol = ' + CAST(@pocZaznamuPolOld AS VARCHAR(50)) + '<br />' +
                           'Nový počet FenixHeliosObjPol = ' + CAST(@pocZaznamuPolNew AS VARCHAR(50)) + '<br />' +
                            @err
     					 EXEC @result = msdb.dbo.sp_send_dbmail
     							@profile_name = 'Automat', --@MailProfileName
     							@recipients = 'jaroslav.tajbl@upc.cz;michal.rezler@upc.cz',
     							@subject = @sub,
     							@body = @msg,
     							@body_format = 'HTML'
           END
           ELSE
           BEGIN
                IF @Odeslat = 1 
                BEGIN
                  SET @sub = 'Fenix - aktualizace tabulek [dbo].[FenixHeliosObjHla],[dbo].[FenixHeliosObjPol] - NUTNÁ KONTROLA' + ' Databáze: '+ISNULL(@myDatabaseName,'')
                  SET @msg =  @err
     			    	EXEC @result = msdb.dbo.sp_send_dbmail
     			    			@profile_name = 'Automat', --@MailProfileName
     			    			@recipients = 'jaroslav.tajbl@upc.cz;michal.rezler@upc.cz',
     			    			@subject = @sub,
     			    			@body = @msg,
     			    				@body_format = 'HTML'
                END
           END
           
     END TRY
     BEGIN CATCH
                SET @sub = 'Fenix - aktualizace tabulek [dbo].[FenixHeliosObjHla],[dbo].[FenixHeliosObjPol]' + ' Databáze: '+ISNULL(@myDatabaseName,'')
                SET @msg = 'CHYBA !!!' + '<br />'+ ERROR_MESSAGE()
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
    ON OBJECT::[dbo].[prFHOinsupd] TO [FenixW]
    AS [dbo];

