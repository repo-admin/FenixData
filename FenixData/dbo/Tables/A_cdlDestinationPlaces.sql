CREATE TABLE [dbo].[A_cdlDestinationPlaces] (
    [A_ID]                    INT            IDENTITY (1, 1) NOT NULL,
    [ID]                      INT            NOT NULL,
    [OrganisationNumber]      INT            NULL,
    [CompanyName]             NVARCHAR (100) NOT NULL,
    [City]                    NVARCHAR (150) NOT NULL,
    [StreetName]              NVARCHAR (100) NULL,
    [StreetOrientationNumber] NVARCHAR (15)  NULL,
    [StreetHouseNumber]       NVARCHAR (35)  NULL,
    [ZipCode]                 NVARCHAR (10)  NULL,
    [IdCountry]               NVARCHAR (3)   NULL,
    [ICO]                     NVARCHAR (20)  NULL,
    [DIC]                     NVARCHAR (15)  NULL,
    [Type]                    NVARCHAR (10)  NULL,
    [IsSent]                  BIT            NULL,
    [SentDate]                SMALLDATETIME  NULL,
    [CountryISO]              CHAR (3)       NULL,
    [IsActive]                BIT            NOT NULL,
    [ModifyDate]              SMALLDATETIME  NOT NULL,
    [ModifyUserId]            INT            NOT NULL,
    [A_ModifyDate]            SMALLDATETIME  CONSTRAINT [DF_A_cdlDestinationPlaces_A_ModifyDate] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_A_cdlDestinationPlaces] PRIMARY KEY CLUSTERED ([A_ID] ASC) WITH (FILLFACTOR = 85)
);

