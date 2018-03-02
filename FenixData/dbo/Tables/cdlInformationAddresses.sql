CREATE TABLE [dbo].[cdlInformationAddresses] (
    [ID]           INT            IDENTITY (1, 1) NOT NULL,
    [Code]         NVARCHAR (3)   NOT NULL,
    [Description]  NVARCHAR (50)  NOT NULL,
    [FirstName]    NVARCHAR (50)  NOT NULL,
    [LastName]     NVARCHAR (50)  NOT NULL,
    [Email]        NVARCHAR (150) NOT NULL,
    [IsActive]     BIT            CONSTRAINT [DF_cdlInformationAddresses_IsActive] DEFAULT ((1)) NOT NULL,
    [ModifyDate]   DATETIME       CONSTRAINT [DF_cdlInformationAddresses_ModifyDate] DEFAULT (getdate()) NOT NULL,
    [ModifyUserID] INT            CONSTRAINT [DF_cdlInformationAddresses_ModifyUserID] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_cdlInformationAddresses] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 85)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Kod, podle kterého se vybírá', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'cdlInformationAddresses', @level2type = N'COLUMN', @level2name = N'Code';

