CREATE TABLE [dbo].[AppLogNew] (
    [ID]             INT            IDENTITY (1, 1) NOT NULL,
    [Type]           NVARCHAR (20)  NOT NULL,
    [Message]        NVARCHAR (MAX) NULL,
    [XmlDeclaration] NVARCHAR (200) NULL,
    [XmlMessage]     XML            NULL,
    [IsActive]       BIT            CONSTRAINT [DF_AppLogNew_IsActive] DEFAULT ((1)) NOT NULL,
    [ModifyDate]     DATETIME       CONSTRAINT [DF__AppLogNew__InsertedOn] DEFAULT (getdate()) NOT NULL,
    [ModifyUserId]   INT            CONSTRAINT [DF_AppLogNew_ModifyUserId] DEFAULT ((0)) NOT NULL,
    [Source]         NVARCHAR (200) NULL,
    CONSTRAINT [PK__AppLogNew] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 85)
);


GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE TRIGGER [dbo].[trAppLogNewIns]
   ON  [dbo].[AppLogNew] 
   AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;

   DECLARE @msg    varchar(max)
   DECLARE @MailTo varchar(150)
   DECLARE @MailBB varchar(150)
   DECLARE @sub    varchar(1000) 
   DECLARE @Result int
   SET @msg = ''

   DECLARE @ModifyUserId AS INT
          ,@ID           AS INT
          ,@Type         AS nvarchar(20)

   DECLARE  @myAdresaLogistika  varchar(500),@myAdresaProgramator  varchar(500) 
   SET @myAdresaLogistika   = [dbo].[fnHomeAdresses] (4)
   SET @myAdresaProgramator = [dbo].[fnHomeAdresses] (1)

   SELECT @ModifyUserId = ModifyUserId
          ,@ID = ID
          ,@Type = [Type]
   FROM INSERTED

   IF @ModifyUserId=99999
   BEGIN
      
      SET @sub = 'FENIX --- INSERT INTO [dbo].[AppLogNew] '
      SET @msg = 'Uživatel = '+ CAST(@ModifyUserId AS VARCHAR(50)) + '<br />ID = '+ CAST(@Id AS VARCHAR(50)) + '<br />Typ = '+ISNULL(@Type,'')
      EXEC @result = msdb.dbo.sp_send_dbmail
     		@profile_name = 'Automat', --@MailProfileName
     		@recipients = @myAdresaProgramator,
     		@copy_recipients = 'max.weczerek@upc.cz',
     		@subject = @sub,
     		@body = @msg,
     		@body_format = 'HTML'

   END
END


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Typ uloženého záznamu {''INFO'', ''WARNING'', ''ERROR'', ''XML''}', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'AppLogNew', @level2type = N'COLUMN', @level2name = N'Type';

