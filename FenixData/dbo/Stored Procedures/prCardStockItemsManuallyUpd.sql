
CREATE PROCEDURE [dbo].[prCardStockItemsManuallyUpd]
(
	@ItemID                         int,	
   @ItemOrKitFree                  int,
   @ItemOrKitUnConsilliation       int,
   @ItemOrKitReserved              int,
   @ItemOrKitReleasedForExpedition int,
   @ItemOrKitExpedited             int,
   @ModifyUserId                   int,
	@ReturnValue                int = -1 OUTPUT,
	@ReturnMessage              nvarchar(2048) = NULL OUTPUT
)
AS

-- ===============================================================================================
-- Created by   : Weczerek Max
-- Created date : 2014-10-13
--                2014-11-07, 2014-11-24
-- Description  : ruční změna ve skladových kartách
-- ===============================================================================================
SET NOCOUNT ON
--
SET @ReturnValue = -1
SET @ReturnMessage = ''
--
DECLARE @myDatabaseName  nvarchar(100)
BEGIN TRY

    SELECT @myDatabaseName = DB_NAME() 

     BEGIN -- DECLARE
       DECLARE  @myAdresaLogistika  varchar(500),@myAdresaProgramator  varchar(500) 
       SET @myAdresaLogistika   = [dbo].[fnHomeAdresses] (4)
       SET @myAdresaProgramator = [dbo].[fnHomeAdresses] (2)
    
       DECLARE  @myMessage [nvarchar] (max), @myReturnValue [int], @myReturnMessage nvarchar(2048)
       
       DECLARE  @myPocetPolozekCelkem [int], @myPocetPolozekPomooc[int], @mOK [bit]
       SET @mOK = 1 
       -- ---
       DECLARE @msg    nvarchar(max)
       DECLARE @MailTo nvarchar(150)
       DECLARE @MailBB nvarchar(150)
       DECLARE @sub    nvarchar(1000) 
       DECLARE @Result int
       SELECT  @msg = '', @sub = ''
       
       -- ---
       DECLARE @myError AS INT
       SET @myError = 0
       -- ---
       DECLARE @myIdentity AS INT
       SET @myIdentity = 0

       DECLARE @KitYesNo AS Int
       SET @KitYesNo = -1
       DECLARE @QualityID AS Int
       SET @QualityID = -1

       DECLARE @ToDay AS DATETIME
       SET @ToDay = GetDate()

       DECLARE  @OldItemOrKitFree                     AS Int
               ,@OldItemOrKitUnConsilliation          AS Int
               ,@OldItemOrKitReserved                 AS Int
               ,@OldItemOrKitReleasedForExpedition    AS Int
               ,@OldItemOrKitExpedited                AS Int

       DECLARE  @DifferenceItemOrKitFree                   AS Int
               ,@DifferenceItemOrKitUnConsilliation        AS Int
               ,@DifferenceItemOrKitReserved               AS Int
               ,@DifferenceItemOrKitReleasedForExpedition  AS Int
               ,@DifferenceItemOrKitExpedited              AS Int

     END    -- DECLARE

     BEGIN -- zpracovani
         BEGIN TRAN

            SELECT @KitYesNo = [ItemVerKit], @QualityID = [ItemOrKitQuality]    FROM [dbo].[CardStockItems] WHERE ID = @ItemID

            UPDATE [dbo].[CardStockItems] 
                SET  [ItemOrKitFree]                 = @ItemOrKitFree                 
                    ,[ItemOrKitUnConsilliation]      = @ItemOrKitUnConsilliation      
                    ,[ItemOrKitReserved]             = @ItemOrKitReserved             
                    ,[ItemOrKitReleasedForExpedition]= @ItemOrKitReleasedForExpedition
                    ,[ItemOrKitExpedited]            = @ItemOrKitExpedited            
                    ,[ModifyUserId]                  = @ModifyUserId                  
                    ,[ModifyDate]                    = @ToDay
            WHERE ID = @ItemID
            SET @myError = @myError + @@ERROR
            IF @myError = 0
            BEGIN 
                IF @@TRANCOUNT>0 COMMIT TRAN
	             SET @ReturnValue = 0
	             SET @ReturnMessage = 'OK' 
            END
            ELSE
            BEGIN
                IF @@TRANCOUNT>0 ROLLBACK TRAN
	             SET @ReturnValue = @myError
	             SET @ReturnMessage = 'prCardStockItemsManuallyUpd CHYBA ' +ISNULL(ERROR_MESSAGE(),'') + ' Databáze: '+ISNULL(@myDatabaseName,'')
            END
     END   -- zpracovani

END TRY
BEGIN CATCH
   IF @@TRANCOUNT>0 ROLLBACK TRAN
   DECLARE @errTask nvarchar (126), @errLine int, @errNumb int
   SET @errTask = ERROR_PROCEDURE()
   SET @errLine = ERROR_LINE()
   SET @errNumb = ERROR_NUMBER()
   SET @ReturnMessage  = ERROR_MESSAGE()
   SET @ReturnValue = CASE WHEN ISNULL(@errNumb,-1) > 0 THEN @errNumb ELSE -1 END
END CATCH



GO
GRANT EXECUTE
    ON OBJECT::[dbo].[prCardStockItemsManuallyUpd] TO [FenixW]
    AS [dbo];

