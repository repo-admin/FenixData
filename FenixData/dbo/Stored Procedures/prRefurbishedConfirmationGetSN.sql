﻿
CREATE PROCEDURE [dbo].[prRefurbishedConfirmationGetSN] 
    @RefurbishedConfirmationID			int,
    @ReturnValue                    int             =  2   OUTPUT,
    @ReturnMessage                  nvarchar(2048)  = null OUTPUT
AS

-- ============================================================================================================================
-- Created by   : Rezler Michal
-- Created date : 2015-08-06
-- Description  : pro potvrzení repase vrací tabulku s požadovanými počty sériových čísel a seznamem uložených sériových čísel
--                
-- Returns      : 0 = OK
--                1 = chyba (se specifikací)
--                2 = nespecifikovana chyba
-- Used by      : 
-- History				: 1.0.0       Rezler Michal
-- ============================================================================================================================

DECLARE @myDatabaseName  nvarchar(100)

SET NOCOUNT ON;
BEGIN TRY
      DECLARE @msg varchar(max), @sub varchar(1000), @Result int

      SELECT @myDatabaseName = DB_NAME() 
      			
      SELECT [dbo].[fnItemIsCpe](ROCI.ItemOrKitID) * ROCI.ItemOrKitQuantity AS SNQuantity 
      			 ,ROCI.KitSNs AS SavedSNs				 
      FROM [dbo].[CommunicationMessagesRefurbishedOrderConfirmationItems] ROCI
      WHERE ROCI.CMSOId = @RefurbishedConfirmationID AND ROCI.ItemVerKit = 0
      
      UNION ALL
      
      SELECT [dbo].[fnKitCpeCount](ROCI.ItemOrKitID) * ROCI.ItemOrKitQuantity AS SNQuantity
      			 ,ROCI.KitSNs AS SavedSNs
      FROM [dbo].[CommunicationMessagesRefurbishedOrderConfirmationItems] ROCI
      WHERE ROCI.CMSOId = @RefurbishedConfirmationID AND ROCI.ItemVerKit = 1
      			
      IF @@ERROR = 0 
      	SET @ReturnValue = 0
      ELSE 
      	SET @ReturnValue = 2
				
END TRY
BEGIN CATCH
      IF @@TRANCOUNT > 0 ROLLBACK TRAN
      SELECT @ReturnValue = 1, @ReturnMessage = 'Chyba'
      SET @sub = 'FENIX - Refurbished Confirmation Get SN CHYBA' + ' Databáze: '+ISNULL(@myDatabaseName,'')
      SET @msg = 'Program prRefurnishedConfirmationGetSN; '  + ISNULL(ERROR_MESSAGE(),'') + ISNULL(CAST(ERROR_NUMBER() AS VARCHAR(50)),'') 
      EXEC	@result = msdb.dbo.sp_send_dbmail
     				@profile_name = 'Automat', 
     				@recipients = 'michal.rezler@upc.cz',
     				@subject = @sub,
     				@body = @msg,
     				@body_format = 'HTML'
END CATCH

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[prRefurbishedConfirmationGetSN] TO [FenixW]
    AS [dbo];

