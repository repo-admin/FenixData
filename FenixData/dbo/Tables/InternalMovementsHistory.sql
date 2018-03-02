CREATE TABLE [dbo].[InternalMovementsHistory] (
    [ID]                                   INT             IDENTITY (1, 1) NOT NULL,
    [InternalMovementsID]                  INT             NOT NULL,
    [ItemVerKit]                           BIT             NOT NULL,
    [ItemOrKitID]                          INT             NOT NULL,
    [IternalMovementQuantity]              NUMERIC (18, 3) NOT NULL,
    [ItemOrKitUnitOfMeasureId]             INT             NOT NULL,
    [ItemOrKitQuality]                     INT             NOT NULL,
    [ItemOrKitFreeBefore]                  NUMERIC (18, 3) NOT NULL,
    [ItemOrKitFreeAfter]                   NUMERIC (18, 3) NOT NULL,
    [ItemOrKitReleasedForExpeditionBefore] NUMERIC (18, 3) NOT NULL,
    [ItemOrKitReleasedForExpeditionAfter]  NUMERIC (18, 3) NOT NULL,
    [IsActive]                             BIT             CONSTRAINT [DF_InternalMovementsHistory_IsActive] DEFAULT ((1)) NOT NULL,
    [ModifyDate]                           DATETIME        CONSTRAINT [DF_InternalMovementsHistory_ModifyDate] DEFAULT (getdate()) NOT NULL,
    [ModifyUserId]                         INT             CONSTRAINT [DF_InternalMovementsHistory_ModifyUserId] DEFAULT ((0)) NOT NULL,
    [ItemOrKitReservedBefore]              NUMERIC (18, 3) DEFAULT ((0)) NOT NULL,
    [ItemOrKitReservedAfter]               NUMERIC (18, 3) DEFAULT ((0)) NOT NULL,
    [AddSubBase]                           INT             DEFAULT ((1)) NOT NULL
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'ID záznamu z tabulky InternalMovements', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'InternalMovementsHistory', @level2type = N'COLUMN', @level2name = N'InternalMovementsID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Množství, které se bude přičítat (přebytek), nebo odečítat (manko)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'InternalMovementsHistory', @level2type = N'COLUMN', @level2name = N'IternalMovementQuantity';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'ID jednotky měření', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'InternalMovementsHistory', @level2type = N'COLUMN', @level2name = N'ItemOrKitUnitOfMeasureId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Množství volné před přičtením/odečtením', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'InternalMovementsHistory', @level2type = N'COLUMN', @level2name = N'ItemOrKitFreeBefore';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Množství volné po přičtení/odečtení', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'InternalMovementsHistory', @level2type = N'COLUMN', @level2name = N'ItemOrKitFreeAfter';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Množství uvolněno k expedici před přičtením/odečtením', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'InternalMovementsHistory', @level2type = N'COLUMN', @level2name = N'ItemOrKitReleasedForExpeditionBefore';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Množství uvolněno k expedici po přičtení/odečtení', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'InternalMovementsHistory', @level2type = N'COLUMN', @level2name = N'ItemOrKitReleasedForExpeditionAfter';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Datum editace', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'InternalMovementsHistory', @level2type = N'COLUMN', @level2name = N'ModifyDate';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'ID uživatele, který jako poslední záznam editoval', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'InternalMovementsHistory', @level2type = N'COLUMN', @level2name = N'ModifyUserId';

