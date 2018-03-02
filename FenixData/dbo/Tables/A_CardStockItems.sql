CREATE TABLE [dbo].[A_CardStockItems] (
    [A_ID]                           INT             IDENTITY (1, 1) NOT NULL,
    [ID]                             INT             NOT NULL,
    [ItemVerKit]                     BIT             NOT NULL,
    [ItemOrKitId]                    INT             NULL,
    [ItemOrKitUnitOfMeasureId]       INT             NULL,
    [ItemOrKitQuantity]              INT             NULL,
    [ItemOrKitQuality]               INT             NULL,
    [ItemOrKitFree]                  NUMERIC (18, 3) NOT NULL,
    [ItemOrKitUnConsilliation]       NUMERIC (18, 3) NULL,
    [ItemOrKitReserved]              NUMERIC (18, 3) NULL,
    [ItemOrKitReleasedForExpedition] NUMERIC (18, 3) NULL,
    [ItemOrKitExpedited]             NUMERIC (18, 3) NULL,
    [StockId]                        INT             NULL,
    [IsActive]                       BIT             NOT NULL,
    [ModifyDate]                     DATETIME        NOT NULL,
    [ModifyUserId]                   INT             NOT NULL,
    [A_ModifyDate]                   DATETIME        CONSTRAINT [DF_A_CardStockItems_A_ModifyDate] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_A_CardStockItems] PRIMARY KEY CLUSTERED ([A_ID] ASC) WITH (FILLFACTOR = 85)
);

