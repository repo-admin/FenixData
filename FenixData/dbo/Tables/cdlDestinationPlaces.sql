CREATE TABLE [dbo].[cdlDestinationPlaces] (
    [ID]                      INT            IDENTITY (1, 1) NOT NULL,
    [OrganisationNumber]      INT            NULL,
    [CompanyName]             NVARCHAR (100) NOT NULL,
    [City]                    NVARCHAR (150) NOT NULL,
    [StreetName]              NVARCHAR (100) NULL,
    [StreetOrientationNumber] NVARCHAR (15)  NULL,
    [StreetHouseNumber]       NVARCHAR (35)  NOT NULL,
    [ZipCode]                 NVARCHAR (10)  NOT NULL,
    [IdCountry]               NVARCHAR (3)   NULL,
    [ICO]                     NVARCHAR (20)  NULL,
    [DIC]                     NVARCHAR (15)  NULL,
    [Type]                    NVARCHAR (10)  NULL,
    [IsSent]                  BIT            CONSTRAINT [DF_cdlDestinationPlaces_IsSent] DEFAULT ((0)) NOT NULL,
    [SentDate]                SMALLDATETIME  NULL,
    [CountryISO]              CHAR (3)       NOT NULL,
    [IsActive]                BIT            NOT NULL,
    [ModifyDate]              SMALLDATETIME  NOT NULL,
    [ModifyUserId]            INT            NOT NULL,
    CONSTRAINT [PK_cdlDestinationPlaces] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 85)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [NonClusteredIndex-20140922-175058]
    ON [dbo].[cdlDestinationPlaces]([CompanyName] ASC, [City] ASC, [StreetName] ASC, [StreetOrientationNumber] ASC, [ZipCode] ASC, [IdCountry] ASC, [ICO] ASC, [Type] ASC, [CountryISO] ASC, [IsActive] ASC, [StreetHouseNumber] ASC) WITH (FILLFACTOR = 85);


GO


CREATE TRIGGER [dbo].[trCdlDestinationPlacesUpd]
   ON [dbo].[cdlDestinationPlaces]
   AFTER UPDATE
AS 
BEGIN
-- =============================================
-- Author:		   Weczerek
-- Create date:   2014-12-09
-- Description:	
-- =============================================
	SET NOCOUNT ON;

INSERT INTO [dbo].[A_cdlDestinationPlaces]
           ([ID]
           ,[OrganisationNumber]
           ,[CompanyName]
           ,[City]
           ,[StreetName]
           ,[StreetOrientationNumber]
           ,[StreetHouseNumber]
           ,[ZipCode]
           ,[IdCountry]
           ,[ICO]
           ,[DIC]
           ,[Type]
           ,[IsSent]
           ,[SentDate]
           ,[CountryISO]
           ,[IsActive]
           ,[ModifyDate]
           ,[ModifyUserId]
           ,[A_ModifyDate])


SELECT      [ID]
           ,[OrganisationNumber]
           ,[CompanyName]
           ,[City]
           ,[StreetName]
           ,[StreetOrientationNumber]
           ,[StreetHouseNumber]
           ,[ZipCode]
           ,[IdCountry]
           ,[ICO]
           ,[DIC]
           ,[Type]
           ,[IsSent]
           ,[SentDate]
           ,[CountryISO]
           ,[IsActive]
           ,[ModifyDate]
           ,[ModifyUserId]
           ,GetDate()

FROM deleted

END


GO
GRANT SELECT
    ON OBJECT::[dbo].[cdlDestinationPlaces] TO [VydejkySprRWD]
    AS [dbo];

