CREATE TABLE [dbo].[cdlStocks] (
    [ID]           INT            IDENTITY (1, 1) NOT NULL,
    [DestPlacesID] INT            NULL,
    [Name]         NVARCHAR (100) NOT NULL,
    [HeliosID]     NCHAR (8)      NULL,
    [IsSent]       BIT            CONSTRAINT [DF_cdlStocks_IsSent] DEFAULT ((0)) NOT NULL,
    [SentDate]     DATETIME       NULL,
    [IsActive]     BIT            CONSTRAINT [DF_cdlStocks_IsActive] DEFAULT ((1)) NOT NULL,
    [ModifyDate]   DATETIME       CONSTRAINT [DF_cdlStocks_ModifyDate] DEFAULT (getdate()) NOT NULL,
    [ModifyUserId] INT            CONSTRAINT [DF_cdlStocks_ModifyUserId] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_cdlStocks] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 85)
);


GO
GRANT SELECT
    ON OBJECT::[dbo].[cdlStocks] TO [mis]
    AS [dbo];


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Pokud je sklad totožný s cílovým místem přesunu, je ID z tabulky DestinationPlaces', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'cdlStocks', @level2type = N'COLUMN', @level2name = N'DestPlacesID';

