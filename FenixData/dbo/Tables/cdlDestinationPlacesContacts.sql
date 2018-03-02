CREATE TABLE [dbo].[cdlDestinationPlacesContacts] (
    [ID]                  INT            IDENTITY (1, 1) NOT NULL,
    [DestinationPlacesId] INT            NULL,
    [PhoneNumber]         NVARCHAR (15)  NULL,
    [FirstName]           NVARCHAR (35)  NULL,
    [LastName]            NVARCHAR (35)  NULL,
    [Title]               CHAR (1)       NULL,
    [ContactName]         NVARCHAR (150) NULL,
    [ContactEmail]        NVARCHAR (150) NULL,
    [Type]                NCHAR (10)     NULL,
    [IsSent]              BIT            CONSTRAINT [DF_cdlDestinationPlacesContacts_IsSent] DEFAULT ((0)) NOT NULL,
    [SentDate]            DATETIME       NULL,
    [IsActive]            BIT            CONSTRAINT [DF_cdlDestinationPlaceContacts_IsActive] DEFAULT ((1)) NOT NULL,
    [ModifyDate]          DATETIME       CONSTRAINT [DF_cdlDestinationPlaceContacts_ModifyDate] DEFAULT (getdate()) NOT NULL,
    [ModifyUserId]        INT            CONSTRAINT [DF_cdlDestinationPlaceContacts_ModifyUserId] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_cdlDestinationPlaceContacts] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 85),
    CONSTRAINT [FK_cdlDestinationPlacesContacts_cdlDestinationPlaces] FOREIGN KEY ([DestinationPlacesId]) REFERENCES [dbo].[cdlDestinationPlaces] ([ID])
);


GO



CREATE TRIGGER [dbo].[trCdlDestinationPlacesContactsUpd]
   ON [dbo].[cdlDestinationPlacesContacts]
   AFTER UPDATE
AS 
BEGIN
-- =============================================
-- Author:		   Weczerek
-- Create date:   2014-12-09
-- Description:	
-- =============================================

	SET NOCOUNT ON;

INSERT INTO [dbo].[A_cdlDestinationPlacesContacts]
           ([ID]
           ,[DestinationPlacesId]
           ,[PhoneNumber]
           ,[FirstName]
           ,[LastName]
           ,[Title]
           ,[ContactName]
           ,[ContactEmail]
           ,[Type]
           ,[IsSent]
           ,[SentDate]
           ,[IsActive]
           ,[ModifyDate]
           ,[ModifyUserId]
           )
SELECT      [ID]
           ,[DestinationPlacesId]
           ,[PhoneNumber]
           ,[FirstName]
           ,[LastName]
           ,[Title]
           ,[ContactName]
           ,[ContactEmail]
           ,[Type]
           ,[IsSent]
           ,[SentDate]
           ,[IsActive]
           ,[ModifyDate]
           ,[ModifyUserId]
FROM DELETED


END

GO
GRANT SELECT
    ON OBJECT::[dbo].[cdlDestinationPlacesContacts] TO [VydejkySprRWD]
    AS [dbo];

