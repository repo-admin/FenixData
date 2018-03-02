CREATE TABLE [dbo].[InternalMovements] (
    [ID]                       INT             IDENTITY (1, 1) NOT NULL,
    [ItemVerKit]               BIT             NOT NULL,
    [ItemOrKitID]              INT             NOT NULL,
    [ItemOrKitDescription]     NVARCHAR (100)  NOT NULL,
    [IternalMovementQuantity]  NUMERIC (18, 3) NOT NULL,
    [ItemOrKitUnitOfMeasureId] INT             NOT NULL,
    [ItemOrKitQuality]         INT             NOT NULL,
    [CardStockItemID]          INT             NOT NULL,
    [MovementsTypeID]          INT             NOT NULL,
    [MovementsDecisionID]      INT             NOT NULL,
    [CreatedDate]              DATETIME        CONSTRAINT [DF_InternalMovements_CreatedDate] DEFAULT (getdate()) NOT NULL,
    [CreatedUserId]            INT             CONSTRAINT [DF_InternalMovements_CreatedUserId] DEFAULT ((0)) NOT NULL,
    [IsActive]                 BIT             CONSTRAINT [DF_InternalMovements_IsActive] DEFAULT ((1)) NOT NULL,
    [ModifyDate]               DATETIME        CONSTRAINT [DF_InternalMovements_ModifyDate] DEFAULT (getdate()) NOT NULL,
    [ModifyUserId]             INT             CONSTRAINT [DF_InternalMovements_ModifyUserId] DEFAULT ((0)) NOT NULL,
    [Remark]                   NVARCHAR (512)  NULL,
    [MovementsAddSubBaseID]    INT             DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_InternalMovements] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 85)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'ID jednotky měření', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'InternalMovements', @level2type = N'COLUMN', @level2name = N'ItemOrKitUnitOfMeasureId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'ID kvality', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'InternalMovements', @level2type = N'COLUMN', @level2name = N'ItemOrKitQuality';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Typ interního pohybu {''Manko'', ''Přebytek''}', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'InternalMovements', @level2type = N'COLUMN', @level2name = N'MovementsTypeID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Datum vytvoření', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'InternalMovements', @level2type = N'COLUMN', @level2name = N'CreatedDate';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'ID uživatele, který záznam vytvořil', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'InternalMovements', @level2type = N'COLUMN', @level2name = N'CreatedUserId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Datum editace', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'InternalMovements', @level2type = N'COLUMN', @level2name = N'ModifyDate';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'ID uživatele, který jako poslední záznam editoval', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'InternalMovements', @level2type = N'COLUMN', @level2name = N'ModifyUserId';

