

CREATE PROCEDURE [dbo].[prCMSAins] 
      @par1 as XML,
	   @ReturnValue     int            = -1 OUTPUT,
	   @ReturnMessage   nvarchar(2048) = null OUTPUT
AS
-- ===============================================================================================
-- Created by   : Weczerek Max
-- Created date : 2014-08-19
-- Description  : 
-- ===============================================================================================
/*
Fáze K2 -  odsouhlasuje Approval

Kontroluje data
Aktualizuje karty

*/
DECLARE @myDatabaseName  nvarchar(100)
SET NOCOUNT ON;
BEGIN TRY


    SELECT @myDatabaseName = DB_NAME() 

   DECLARE
           @myApprovalId AS INT 
          ,@myIdentity  AS   [int]
          ,@myError     AS   [int]
          ,@myCardStockItemsId AS   [int]
          ,@myPocet [int]
          ,@myKitID [int]
          ,@myKitQuantity [int]
          ,@mytxt   [nvarchar] (max)
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
  -- =======================================================================
   -- Nacteni xml souboru do tabulky
   -- =======================================================================
      IF OBJECT_ID('tempdb..#TmpApprovalSent','table') IS NOT NULL DROP TABLE #TmpApprovalSent

      EXEC sp_xml_preparedocument @hndl OUTPUT, @par1
      SELECT x.[ApprovalId ]
      INTO #TmpApprovalSent
      FROM OPENXML (@hndl, '/NewDataSet/Approval',2)
      WITH (
      ApprovalId                        int          'ApprovalId'
      ) x
      EXEC sp_xml_removedocument @hndl

SELECT * FROM #TmpApprovalSent

   SET @myError = 0
   IF (SELECT CURSOR_STATUS('global','myCursor')) >= -1
   BEGIN
             DEALLOCATE myCursor
   END

   DECLARE myCursor CURSOR 
   FOR SELECT ApprovalId FROM #TmpApprovalSent  --ORDER BY ApprovalId
 
   OPEN myCursor
   FETCH NEXT FROM myCursor INTO @myApprovalId

   WHILE @@FETCH_STATUS = 0
   BEGIN -- FETCH_STATUS
            UPDATE [dbo].[CommunicationMessagesKittingsApprovalSent] SET [Released] = CAST(1 AS BIT) , [RequiredReleaseDate] = GetDate()
            WHERE ID = @myApprovalId  AND ([Released]=0 OR [Released] IS NULL)
            SET @myError = @@ERROR

            IF @myError = 0 AND @@ROWCOUNT = 1
            BEGIN   -- 2
               IF (SELECT CURSOR_STATUS('global','myCursorKitsSent')) >= -1
               BEGIN
                         DEALLOCATE myCursorKitsSent
               END
               DECLARE myCursorKitsSent CURSOR 
               FOR SELECT [KitID], [KitQuantity] FROM [dbo].[CommunicationMessagesKittingsApprovalKitsSent] WHERE [ApprovalID] = @myApprovalId

                 OPEN myCursorKitsSent
                 FETCH NEXT FROM myCursorKitsSent INTO @myKitID, @myKitQuantity

                 WHILE @@FETCH_STATUS = 0
                 BEGIN -- FETCH_STATUS
                      UPDATE [dbo].[CardStockItems] 
                             SET [ItemOrKitFree] = ISNULL(ItemOrKitFree,0) - @myKitQuantity, [ItemOrKitReleasedForExpedition] = ISNULL(ItemOrKitReleasedForExpedition,0) + @myKitQuantity
                      WHERE [ItemOrKitId] = @myKitID AND [ItemVerKit] = 1

                      FETCH NEXT FROM myCursorKitsSent INTO @myKitID, @myKitQuantity
--SELECT @myKitID '@myKitID', @myKitQuantity '@myKitQuantity'
                 END
                 CLOSE myCursorKitsSent
                 DEALLOCATE myCursorKitsSent
            END   -- 2
            ELSE
            BEGIN   -- 2

               IF @myError <>0
               BEGIN
                   SET @ReturnValue = @myError
               END
            END   -- 2
--SELECT @myApprovalId '@myApprovalIdo'
        FETCH NEXT FROM myCursor INTO @myApprovalId
--SELECT @myApprovalId '@myApprovalIdn'

   END
   CLOSE myCursor
   DEALLOCATE myCursor

END TRY
BEGIN CATCH
   SET @ReturnValue = @@ERROR
   IF (SELECT CURSOR_STATUS('global','myCursor')) >= -1
   BEGIN
             DEALLOCATE myCursor
   END
END CATCH








GO
GRANT EXECUTE
    ON OBJECT::[dbo].[prCMSAins] TO [FenixW]
    AS [dbo];

