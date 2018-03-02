CREATE TABLE [dbo].[CardStockItemsChange] (
    [ID]                             INT             IDENTITY (1, 1) NOT NULL,
    [ItemVerKit]                     BIT             CONSTRAINT [DF_CardStockItemsChange_ItemVerKit] DEFAULT ((0)) NOT NULL,
    [ItemOrKitId]                    INT             NULL,
    [ItemOrKitUnitOfMeasureId]       INT             NULL,
    [ItemOrKitQuantity]              INT             NULL,
    [ItemOrKitQuality]               INT             NULL,
    [ItemOrKitFree]                  NUMERIC (18, 3) NOT NULL,
    [ItemOrKitUnConsilliation]       NUMERIC (18, 3) NULL,
    [ItemOrKitReserved]              NUMERIC (18, 3) NULL,
    [ItemOrKitReleasedForExpedition] NUMERIC (18, 3) NULL,
    [ItemOrKitExpedited]             NUMERIC (18, 3) NULL,
    [StockId]                        INT             CONSTRAINT [DF_CardStockItemsChange_StockId] DEFAULT ((2)) NULL,
    [Popis]                          NVARCHAR (50)   NOT NULL,
    [IsActive]                       BIT             CONSTRAINT [DF_CardStockItemsChange_IsActive] DEFAULT ((1)) NOT NULL,
    [ModifyUserId]                   INT             CONSTRAINT [DF_CardStockItemsChange_ModifyUserId] DEFAULT ((452)) NOT NULL,
    [ModifyDate]                     DATETIME        CONSTRAINT [DF_CardStockItemsChange_ModifyDate] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_CardStockItemsChange] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 85)
);

