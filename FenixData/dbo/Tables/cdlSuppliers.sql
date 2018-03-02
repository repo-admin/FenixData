CREATE TABLE [dbo].[cdlSuppliers] (
    [ID]                      INT            IDENTITY (1, 1) NOT NULL,
    [OrganisationNumber]      INT            NOT NULL,
    [CompanyName]             NVARCHAR (100) NOT NULL,
    [City]                    NVARCHAR (100) NOT NULL,
    [StreetName]              NVARCHAR (100) NOT NULL,
    [StreetOrientationNumber] NVARCHAR (15)  NULL,
    [StreetHouseNumber]       NVARCHAR (15)  NULL,
    [ZipCode]                 NVARCHAR (10)  NULL,
    [IdCountry]               NVARCHAR (3)   NULL,
    [ICO]                     NVARCHAR (20)  NULL,
    [DIC]                     NVARCHAR (15)  NULL,
    [IsSent]                  BIT            CONSTRAINT [DF_cdlSuppliers_IsSent] DEFAULT ((0)) NOT NULL,
    [SentDate]                DATETIME       NULL,
    [IsActive]                BIT            CONSTRAINT [DF_cdlSuppliers_IsActive] DEFAULT ((1)) NOT NULL,
    [ModifyDate]              DATETIME       CONSTRAINT [DF_cdlSuppliers_ModifyDate] DEFAULT (getdate()) NOT NULL,
    [ModifyUserId]            INT            CONSTRAINT [DF_cdlSuppliers_ModifyUserId] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_Suppliers] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 85)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [NonClusteredIndex-20140912-084825]
    ON [dbo].[cdlSuppliers]([OrganisationNumber] ASC) WITH (FILLFACTOR = 85);

