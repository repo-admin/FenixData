-- =============================================
-- Author:		   Weczerek Max
-- Create date:   2014-06-26
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[prSendMail]
     @smsg         varchar(max),
     @sMailTo      varchar(150),
     @sMailBB      varchar(150),
     @ssub         varchar(1000),
	  @ReturnValue  int = -1 OUTPUT,
     @ReturnMessage nvarchar(2048) = null OUTPUT

AS
BEGIN
	SET NOCOUNT ON;
   DECLARE @myDatabaseName  nvarchar(100)
   SELECT @myDatabaseName = DB_NAME() 

    BEGIN TRY

   	EXEC @ReturnValue  = msdb.dbo.sp_send_dbmail
   	     @profile_name = 'Automat', 
   	     @recipients   = @sMailTo,
           @copy_recipients = @sMailBB,
   	     @subject      = @ssub,
   	     @body         = @smsg,
           @body_format  = 'HTML'
   END TRY
   BEGIN CATCH
      DECLARE @errTask nvarchar (126), @errLine int, @errNumb int
      SET @errTask = ERROR_PROCEDURE()
      SET @errLine = ERROR_LINE()
      SET @errNumb = ERROR_NUMBER()
      SET @ReturnMessage  = ERROR_MESSAGE()
      SET @ReturnValue = CASE WHEN ISNULL(@errNumb,-1) > 0 THEN @errNumb ELSE -1 END
   END CATCH

   return @ReturnValue
END









GO
GRANT EXECUTE
    ON OBJECT::[dbo].[prSendMail] TO [FenixW]
    AS [dbo];

