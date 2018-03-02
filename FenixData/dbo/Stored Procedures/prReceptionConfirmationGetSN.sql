
CREATE PROCEDURE [dbo].[prReceptionConfirmationGetSN] 
    @ReceptionConfirmationID				int,
    @CalculatedCountSN              numeric(18,3)   =  0   OUTPUT,
    @SavedSN                        varchar(max)    = ''   OUTPUT,
    @ReturnValue                    int             =  2   OUTPUT,
    @ReturnMessage                  nvarchar(2048)  = null OUTPUT
AS

-- ===================================================================================================================
-- Created by   : Rezler Michal
-- Created date : 2015-08-06
-- Description  : pro potvrzení recepce vrací požadovaný počet sériových čísel a seznam uložených sériových čísel
--                
-- Returns      : 0 = OK
--                1 = chyba (se specifikací)
--                2 = nespecifikovana chyba
-- Used by      : 
-- History				: 1.0.0       Rezler Michal
-- ===================================================================================================================

DECLARE @myDatabaseName  nvarchar(100)

SET NOCOUNT ON;
BEGIN TRY
      SELECT @myDatabaseName = DB_NAME() 
      			
      DECLARE @msg varchar(max), @sub varchar(1000), @Result int
      									
      SELECT @CalculatedCountSN = RCI.[ItemQuantity], @SavedSN = RCI.[ItemSNs]
      FROM [dbo].[CommunicationMessagesReceptionConfirmationItems] RCI
      LEFT OUTER JOIN [dbo].[cdlItems] I
      	ON I.ID = RCI.[ItemID]
      WHERE RCI.[IsActive] = 1 
      			AND I.[IsActive] = 1
      			AND I.[ItemType] = 'CPE'
      			AND RCI.CMSOId = @ReceptionConfirmationID
      
      IF @@ERROR = 0 
      	SET @ReturnValue = 0
      ELSE 
      	SET @ReturnValue = 2
				
END TRY
BEGIN CATCH
      IF @@TRANCOUNT > 0 ROLLBACK TRAN
      SELECT @ReturnValue = 1, @ReturnMessage = 'Chyba'
      SET @sub = 'FENIX - Reception Confirmation Get SN CHYBA' + ' Databáze: '+ISNULL(@myDatabaseName,'')
      SET @msg = 'Program prReceptionConfirmationGetSN; '  + ISNULL(ERROR_MESSAGE(),'') + ISNULL(CAST(ERROR_NUMBER() AS VARCHAR(50)),'') 
      EXEC	@result = msdb.dbo.sp_send_dbmail
     				@profile_name = 'Automat', 
     				@recipients = 'michal.rezler@upc.cz',
     				@subject = @sub,
     				@body = @msg,
     				@body_format = 'HTML'
END CATCH

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[prReceptionConfirmationGetSN] TO [FenixW]
    AS [dbo];

