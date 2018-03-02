CREATE TABLE [dbo].[A_CommunicationMessagesReturnedItemItems] (
    [A_ID]                INT             IDENTITY (1, 1) NOT NULL,
    [ID]                  INT             NOT NULL,
    [CMSOId]              INT             NOT NULL,
    [ItemId]              INT             NOT NULL,
    [ItemDescription]     NVARCHAR (50)   NOT NULL,
    [ItemQuantity]        NUMERIC (18, 3) NULL,
    [ItemOrKitQualityId]  INT             NOT NULL,
    [ItemOrKitQuality]    NVARCHAR (50)   NOT NULL,
    [ItemUnitOfMeasureId] INT             NOT NULL,
    [ItemUnitOfMeasure]   NVARCHAR (50)   NOT NULL,
    [SN]                  NVARCHAR (MAX)  NULL,
    [NDReceipt]           NVARCHAR (100)  NULL,
    [ReturnedFrom]        NVARCHAR (MAX)  NOT NULL,
    [IsActive]            BIT             CONSTRAINT [DF_A_CommunicationMessagesReturnedItemItems_IsActive] DEFAULT ((1)) NOT NULL,
    [ModifyDate]          DATETIME        CONSTRAINT [DF_A_CommunicationMessagesReturnedItemItems_ModifyDate] DEFAULT (getdate()) NOT NULL,
    [ModifyUserId]        INT             CONSTRAINT [DF_A_CommunicationMessagesReturnedItemItems_ModifyUserId] DEFAULT ((0)) NOT NULL,
    [A_ModifyDate]        DATETIME        CONSTRAINT [DF_A_CommunicationMessagesReturnedItemItems_A_ModifyDate] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_A_CommunicationMessagesReturnedItemItems] PRIMARY KEY CLUSTERED ([A_ID] ASC) WITH (FILLFACTOR = 85)
);

