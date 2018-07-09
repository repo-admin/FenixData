

CREATE PROCEDURE [dbo].[prKiCLins] 
		@Code nvarchar(5),
		@DescriptionCz nvarchar(50),
		@DescriptionEng nvarchar(50),
      @par1 as XML,
		@MeasuresId AS Int,
		@MeasuresCode AS nvarchar(50),
		@KitQualitiesId AS Int,
		@KitQualitiesCode AS nvarchar(50),
      @KitPackaging AS Int,
      @KitGroupsId AS Int,

      @ModifyUserId int = 0,
	   @ReturnValue     int            = -1 OUTPUT,
	   @ReturnMessage   nvarchar(2048) = null OUTPUT
 AS
BEGIN
-- ===============================================================================================
-- Created by   : Weczerek Max
-- Created date : 2014-08-04
--                2014-09-22
-- Description  : 
-- ===============================================================================================
/*

Vytváří data v číselníku kitů

*/
	SET NOCOUNT ON;
DECLARE @myDatabaseName  nvarchar(100)
   BEGIN TRY

    SELECT @myDatabaseName = DB_NAME() 

      BEGIN --- DECLARACE
          DECLARE
                @ID [int] ,
                @ItemVerKit [varchar](50) ,
                @ItemOrKitID [varchar](50),
                @ItemGroupGoods [nvarchar](50),
                @ItemCode [nvarchar](50),
                @DescriptionCzItemsOrKit [nvarchar](50),
                @ItemOrKitQuantity [numeric](18, 3),
                @ModifyDate [datetime],
                @myIdentity [int]
    
          SET @ModifyDate = GetDate()
    
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
      IF OBJECT_ID('tempdb..#TmpKittingCodeList','table') IS NOT NULL DROP TABLE #TmpKittingCodeList

      EXEC sp_xml_preparedocument @hndl OUTPUT, @par1
      --
      SELECT x.[ItemVerKit], x.[ItemOrKitID], x.[ItemGroupGoods], x.[ItemCode], x.[DescriptionCzItemsOrKit], x.[ItemOrKitQuantity]
      INTO #TmpKittingCodeList
      FROM OPENXML (@hndl, '/NewDataSet/KittingCodeList', 2)
      WITH (ItemVerKit               [int], 
            ItemOrKitID              [int],
            ItemGroupGoods           [nvarchar](3),
            ItemCode                 [nvarchar](50) ,
            DescriptionCzItemsOrKit  [nvarchar](100) ,
            ItemOrKitQuantity        [decimal](18,3) 
           ) x
      --
      EXEC sp_xml_removedocument @hndl

      UPDATE #TmpKittingCodeList SET DescriptionCzItemsOrKit = REPLACE(DescriptionCzItemsOrKit, '&lt;','<')
      UPDATE #TmpKittingCodeList SET DescriptionCzItemsOrKit = REPLACE(DescriptionCzItemsOrKit, '&gt;','>')

      -- ============================ Zpracování ===============================
        IF @mOK=1
        BEGIN
        BEGIN TRAN
              INSERT INTO [dbo].[cdlKits]
                         ([Code]
                         ,[DescriptionCz]
                         ,[DescriptionEng]
                         ,MeasuresId
	                      ,MeasuresCode
	                      ,KitQualitiesId
	                      ,KitQualitiesCode
                         ,Packaging
                         ,GroupsId
                         ,ModifyDate
                         ,[ModifyUserId])
                   VALUES
                         (
                         @Code,
                         @DescriptionCz,
		                   @DescriptionEng,
                         @MeasuresId,
		                   @MeasuresCode
	                     ,@KitQualitiesId
	                     ,@KitQualitiesCode
                        ,@KitPackaging
                        ,@KitGroupsId
                        ,@ModifyDate
                        ,@ModifyUserId
                          )
               SET @myError = @@ERROR
               SET @ID = @@IDENTITY
            IF @myError = 0
            BEGIN
                        IF (SELECT CURSOR_STATUS('global','myCursor')) >= -1
                        BEGIN
                                 DEALLOCATE myCursor
                        END

                        DECLARE myCursor CURSOR 
                        FOR  SELECT [ItemVerKit], [ItemOrKitID], [ItemGroupGoods], [ItemCode],[DescriptionCzItemsOrKit],[ItemOrKitQuantity] FROM #TmpKittingCodeList 
                   
                        OPEN myCursor
                        FETCH NEXT FROM myCursor INTO @ItemVerKit, @ItemOrKitID, @ItemGroupGoods, @ItemCode,@DescriptionCzItemsOrKit,@ItemOrKitQuantity
                        
                        WHILE @@FETCH_STATUS = 0
                        BEGIN
                        INSERT INTO [dbo].[cdlKitsItems]
                              ([cdlKitsID]
                              ,[ItemVerKit]
                              ,[ItemOrKitID]
                              ,[ItemGroupGoods]
                              ,[ItemCode]
                              ,[ItemOrKitQuantity]
                              ,[PackageType]
                              ,[IsActive]
                              ,[ModifyDate]
                              ,[ModifyUserId]
                        )
                        VALUES
                              (@ID                 --cdlKitsID, int,>
                              ,@ItemVerKit         --ItemVerKit, bit,>
                              ,@ItemOrKitID        --ItemOrKitID, int,>
                              ,@ItemGroupGoods     --ItemGroupGoods, nvarchar(3),>
                              ,@ItemCode           --ItemCode, nvarchar(50),>
                              ,@ItemOrKitQuantity  --ItemOrKitQuantity, numeric(18,3),>
                              ,'Single'            --PackageType, nchar(50),>
                              ,1                   --IsActive, bit,>
                              ,@ModifyDate         --ModifyDate, datetime,>
                              ,@ModifyUserId       --ModifyUserId, int,>
                         )

                            SET @myError = @myError + @@ERROR
                            FETCH NEXT FROM myCursor INTO @ItemVerKit, @ItemOrKitID, @ItemGroupGoods, @ItemCode,@DescriptionCzItemsOrKit,@ItemOrKitQuantity
                        END

                        CLOSE myCursor;
                        DEALLOCATE myCursor;

                        IF @myError = 0 
                        BEGIN
                           COMMIT TRAN 
                           SET @ReturnValue = 0
                        END
                        ELSE 
                        BEGIN
                           ROLLBACK TRAN
                           SET @ReturnValue = 1
                           SET @ReturnMessage = 'Program prKiCLins; '  + ISNULL(ERROR_MESSAGE(),'') + ISNULL(CAST(ERROR_NUMBER() AS VARCHAR(50)),'')
                        END
            END
        END

END TRY 

BEGIN CATCH
      IF @@TRANCOUNT>0 ROLLBACK TRAN
      SELECT @ReturnValue=1, @ReturnMessage='Chyba'
      SET @sub = 'FENIX - Reception KITS číselník CHYBA' + ' Databáze: '+ISNULL(@myDatabaseName,'')
      SET @msg = 'Program prKiCLins; '  + ISNULL(ERROR_MESSAGE(),'') + ISNULL(CAST(ERROR_NUMBER() AS VARCHAR(50)),'') 

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
    ON OBJECT::[dbo].[prKiCLins] TO [FenixW]
    AS [dbo];

