
CREATE PROCEDURE [dbo].[prFHITEMSupd]
AS
-- ---
/*
Aktualizuje skladové položky z Heliosu
*/

GRANT CREATE TABLE TO FenixW

DECLARE @msg    varchar(max)
DECLARE @MailTo varchar(150)
DECLARE @MailBB varchar(150)
DECLARE @sub    varchar(1000)
DECLARE @Result int
SET @msg = ''

DECLARE  @myAdresaLogistika  varchar(500),@myAdresaProgramator  varchar(500)
DECLARE  @myResult  varchar(500)
SET @myResult=''

DECLARE @myDatabaseName  nvarchar(100)
SELECT @myDatabaseName = DB_NAME()

Begin Try
DROP TABLE [dbo].[SkladPolozkyHeliosPomoc]
End Try
Begin CATCH
       SET @myAdresaProgramator = [dbo].[fnHomeAdresses] (2)

       SET @sub = 'FENIX - Aktualizace číselníku Items - scházela tabulka SkladPolozkyHeliosPomoc' + ' Databáze: '+ISNULL(@myDatabaseName,'')
       SET @msg = 'ERROR = ' + CAST(@@ERROR AS VARCHAR(50))
	    EXEC @result = msdb.dbo.sp_send_dbmail
	       @profile_name = 'Automat', --@MailProfileName
	       @recipients = @myAdresaProgramator,
             --@copy_recipients = @myAdresaProgramator,
	       @subject = @sub,
	       @body = @msg,
          @body_format = 'HTML'
End CATCH

BEGIN TRY
       CREATE TABLE [dbo].[SkladPolozkyHeliosPomoc](
       	[SkupZbo] [nvarchar](3) NOT NULL,
       	[RegCis] [nvarchar](30) NOT NULL,
       	[Nazev1] [nvarchar](100) NOT NULL,
       	[MJ] [nvarchar](10) NULL,
       	[itemType] [nchar](3) NULL,
       	[Packaging] [int] NULL,
       	[ItemTypeDesc1] [nvarchar](50) NULL,
       	[ItemTypeDesc2] [nvarchar](50) NULL,
       	[ItemTypeId] [int] NULL
       ) ON [PRIMARY]

       DECLARE @PocetPred as Integer
       SELECT @PocetPred = COUNT(*) FROM [dbo].[SkladPolozkyHeliosPomoc]
       DELETE [dbo].[SkladPolozkyHeliosPomoc]
       
       INSERT INTO [dbo].[SkladPolozkyHeliosPomoc]
                  ([SkupZbo]
                  ,[RegCis]
                  ,[Nazev1]
                  ,[MJ]
                  ,[itemType]
                  ,[Packaging])
       SELECT [SkupZbo]
             ,[RegCis]
             ,[Nazev1]
             ,[MJ]
             ,[itemType]
             ,[packaging]
       FROM [Ciselniky].[dbo].[tFenixSkladPol] WHERE ISNUMERIC(RegCis)=1;

  UPDATE  [dbo].[SkladPolozkyHeliosPomoc] SET [ItemTypeDesc1] = cdlItemTypes.[DescriptionCz] 
                                             ,[ItemTypeDesc2] = cdlItemTypes.[DescriptionEng] 
                                             ,[ItemTypeId]    = cdlItemTypes.ID 
  FROM [dbo].[SkladPolozkyHeliosPomoc]
  INNER JOIN [dbo].[cdlItemTypes]
  ON  SkladPolozkyHeliosPomoc.itemType = cdlItemTypes.Code

       
       DECLARE @PocetPo as Integer
       SELECT @PocetPo = COUNT(*) FROM [dbo].[SkladPolozkyHeliosPomoc]
       
       --SELECT '@PocetPred',@PocetPred,'@PocetPo',@PocetPo
       
       
       UPDATE [dbo].[cdlItems]
          SET [DescriptionCz]   = xx.Nazev1
             ,[DescriptionEng] = xx.Nazev1
             ,[MeasuresId] = MIDID
             ,[PC] = xx.MJ
             ,[Packaging] = CAST(xx.Packaging AS VARCHAR(6))
             ,[itemType] = xx.[itemType]
             ,[IsSent] = CAST(0 AS BIT)
             ,[ModifyDate] = GetDate()
             ,[ItemTypesId] = xx.[ItemTypeId]
             ,[ItemTypeDesc1] = xx.[ItemTypeDesc1]
             ,[ItemTypeDesc2] = xx.[ItemTypeDesc2]
       FROM [dbo].[cdlItems]    CDLI
       INNER JOIN (SELECT * FROM (
              SELECT CAST([SkupZbo]+[RegCis] AS INT) ID,  [SkupZbo] ,[RegCis] ,[Nazev1] ,[MJ] ,MID.[Id] AS MIDID,[itemType],[Packaging], [ItemTypeId], [ItemTypeDesc1],[ItemTypeDesc2] 
              FROM [dbo].[SkladPolozkyHeliosPomoc]
              LEFT OUTER JOIN [dbo].[cdlMeasures]    MID
                   ON [MJ] = [Code]  ) aa) xx
         ON CDLI.[GroupGoods] = xx.SkupZbo AND CDLI.[Code]=xx.[RegCis]
       WHERE [MeasuresId] <> MIDID  OR  [PC] <> xx.MJ   OR  [DescriptionCz] <> xx.Nazev1
       
       SELECT @myResult = @myResult + 'Počet aktualizovaných záznamů ' + CAST(@@ROWCOUNT AS VARCHAR(50)) +'<br /> '
SELECT 'x'       
       INSERT INTO [dbo].[cdlItems]
                  ([ID]
                  ,[GroupGoods]
                  ,[Code]
                  ,[DescriptionCz]
                  ,[DescriptionEng]
                  ,[MeasuresId]
                  ,[ItemTypesId]
                  ,[PackagingId]
                  ,[ItemType]
                  ,[PC]
                  ,[Packaging]
                  ,[IsSent]
                  ,[SentDate]
                  ,[ItemTypeDesc1]
                  ,[ItemTypeDesc2]
                  ,[IsActive]
                  ,[ModifyDate]
                  ,[ModifyUserId]
)
        SELECT  CAST([SkupZbo]+[RegCis] AS INT), [SkupZbo] ,[RegCis] ,[Nazev1] ,[Nazev1] , MIDID, 5, [Packaging], ItemType, MJ, [Packaging], 0, NULL, [ItemTypeDesc1], [ItemTypeDesc2], 1, GETDATE(), 0 FROM 
        (
              SELECT [SkupZbo] ,[RegCis] ,[Nazev1] ,[MJ] ,MID.[Id] AS MIDID ,CAST([Packaging] AS VARCHAR(6)) Packaging,ItemType, [ItemTypeDesc1], [ItemTypeDesc2]
              FROM [dbo].[SkladPolozkyHeliosPomoc]
              LEFT OUTER JOIN [dbo].[cdlMeasures]    MID
                   ON [MJ] = [Code]  ) xx
       WHERE CAST([SkupZbo]+[RegCis] AS INT) NOT IN ( SELECT ID FROM  [dbo].[cdlItems])
SELECT 'y'       
       SELECT @myResult = @myResult + 'Počet nových záznamů ' + CAST(@@ROWCOUNT AS VARCHAR(50))

       SET @myAdresaProgramator = [dbo].[fnHomeAdresses] (2)

       SET @sub = 'FENIX - Aktualizace číselníku Items - ÚSPĚCH' + ' Databáze: '+ISNULL(@myDatabaseName,'')
       SET @msg = 'SkladPolozkyHeliosPomoc : @PocetPred =' + CAST(@PocetPred AS VARCHAR(50)) + ', @PocetPo = ' + CAST(@PocetPo AS VARCHAR(50)) + '<br />' + @myResult
		 --EXEC @result = msdb.dbo.sp_send_dbmail
		 --     @profile_name = 'Automat', --@MailProfileName
		 --     @recipients = @myAdresaProgramator,
   --          --@copy_recipients = @myAdresaProgramator,
		 --     @subject = @sub,
		 --     @body = @msg,
   --         @body_format = 'HTML'
END TRY
BEGIN CATCH
       SET @myAdresaProgramator = [dbo].[fnHomeAdresses] (2)

       SET @sub = 'FENIX - Aktualizace číselníku Items - CHYBA' + ' Databáze: '+ISNULL(@myDatabaseName,'')
       SET @msg = 'ERROR = ' + CAST(@@ERROR AS VARCHAR(50)) + ' '  + ISNULL(ERROR_MESSAGE(),'')
	    EXEC @result = msdb.dbo.sp_send_dbmail
	       @profile_name = 'Automat', --@MailProfileName
	       @recipients = @myAdresaProgramator,
             --@copy_recipients = @myAdresaProgramator,
	       @subject = @sub,
	       @body = @msg,
          @body_format = 'HTML'
END CATCH
REVOKE CREATE TABLE TO FenixW




GO
GRANT EXECUTE
    ON OBJECT::[dbo].[prFHITEMSupd] TO [FenixW]
    AS [dbo];

