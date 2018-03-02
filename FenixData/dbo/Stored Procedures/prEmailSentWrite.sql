CREATE PROCEDURE [dbo].[prEmailSentWrite]
(
	@Type [nvarchar] (40),
	@EmailFrom [nvarchar] (1024) = '',
	@EmailTo [nvarchar] (1024) = '',
	@EmailSubject [nvarchar] (2048) = '',
	@EmailMessageHash [varchar] (128),
	@EmailMessage [nvarchar] (max),	
	@EmbededPicture [nvarchar] (1024) = '',	
	@UserId int,
	@Source [nvarchar] (200) = null,
	@IsInternal bit = 1,
	@ReturnValue int = -1 OUTPUT,
	@ReturnMessage nvarchar(2048) = null OUTPUT
)
AS
-- ==================================================================================================================================
-- Created by   : Rezler Michal
-- Created date : 2014-12-04
-- Description  : Ulozeni odeslaneho emailu
-- Returns      : 0 je-li zapis uspesny, jinak cislo chyby ( > 0 )
--               -1 = nespecifikovana chyba
-- Used by      : 
-- History		    : 1.0.0       Rezler Michal
-- Edit         : 2015-03-24  Rezler Michal   přidány sloupce:
--                                            EmailFrom - odesílatel emailu
--                                            EmailTo - příjemce emailu
--                                            EmbededPicture - název obrázku vloženého do těla emailu
--                                            IsInternal - příznak, zda jde o email interní (UPC), nebo externí (příjemce není z UPC) 
-- ==================================================================================================================================
SET NOCOUNT ON
--
SET @ReturnValue = -1
SET @ReturnMessage = ''
--
BEGIN TRY
	INSERT INTO [dbo].[EmailSent] ([Type], [EmailFrom], [EmailTo], [EmailSubject], [EmailMessageHash], [EmailMessage], [EmbededPicture], [ModifyUserId], [Source], [IsInternal])
		                      VALUES (@Type, @EmailFrom, @EmailTo, @EmailSubject, @EmailMessageHash, @EmailMessage, @EmbededPicture, @UserId, @Source, @IsInternal)
   --
   SET @ReturnValue = 0
END TRY
BEGIN CATCH
   DECLARE @errTask nvarchar (126), @errLine int, @errNumb int
   SET @errTask = ERROR_PROCEDURE()
   SET @errLine = ERROR_LINE()
   SET @errNumb = ERROR_NUMBER()
   SET @ReturnMessage  = ERROR_MESSAGE()
   SET @ReturnValue = CASE WHEN ISNULL(@errNumb,-1) > 0 THEN @errNumb ELSE -1 END
END CATCH
--
RETURN @ReturnValue

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[prEmailSentWrite] TO [FenixW]
    AS [dbo];

