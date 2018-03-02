CREATE TABLE [dbo].[A_CommunicationMessagesKittingsSentItems] (
    [A_ID]                 INT             IDENTITY (1, 1) NOT NULL,
    [ID]                   INT             NOT NULL,
    [CMSOId]               INT             NOT NULL,
    [HeliosOrderID]        INT             NOT NULL,
    [HeliosOrderRecordId]  INT             NOT NULL,
    [KitId]                INT             NOT NULL,
    [KitDescription]       NVARCHAR (500)  NOT NULL,
    [KitQuantity]          NUMERIC (18, 3) NOT NULL,
    [KitQuantityDelivered] NUMERIC (18, 3) NULL,
    [MeasuresID]           INT             NOT NULL,
    [KitUnitOfMeasure]     NVARCHAR (50)   NOT NULL,
    [KitQualityId]         INT             NOT NULL,
    [KitQualityCode]       NVARCHAR (50)   NULL,
    [CardStockItemsId]     INT             NOT NULL,
    [IsActive]             BIT             NOT NULL,
    [ModifyDate]           DATETIME        NOT NULL,
    [ModifyUserId]         INT             NOT NULL,
    [A_ModifyDate]         DATETIME        CONSTRAINT [DF_A_CommunicationMessagesKittingsSentItems_A_ModifyDate] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_A_CommunicationMessagesKittingsSentItems] PRIMARY KEY CLUSTERED ([A_ID] ASC) WITH (FILLFACTOR = 85)
);

