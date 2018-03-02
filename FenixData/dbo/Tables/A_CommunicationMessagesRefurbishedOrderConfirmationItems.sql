CREATE TABLE [dbo].[A_CommunicationMessagesRefurbishedOrderConfirmationItems] (
    [A_ID]                     INT             IDENTITY (1, 1) NOT NULL,
    [ID]                       INT             NOT NULL,
    [CMSOId]                   INT             NOT NULL,
    [ItemVerKit]               INT             NOT NULL,
    [ItemOrKitID]              INT             NOT NULL,
    [ItemOrKitDescription]     NVARCHAR (100)  NOT NULL,
    [ItemOrKitQuantity]        NUMERIC (18, 3) NOT NULL,
    [ItemOrKitUnitOfMeasureId] INT             NOT NULL,
    [ItemOrKitUnitOfMeasure]   NVARCHAR (50)   NOT NULL,
    [ItemOrKitQualityId]       INT             NOT NULL,
    [ItemOrKitQualityCode]     NVARCHAR (50)   NOT NULL,
    [IncotermsId]              INT             NULL,
    [IncotermDescription]      NVARCHAR (50)   NULL,
    [NDReceipt]                NVARCHAR (50)   NULL,
    [KitSNs]                   VARCHAR (MAX)   NULL,
    [IsActive]                 BIT             NOT NULL,
    [ModifyDate]               DATETIME        NOT NULL,
    [ModifyUserId]             INT             NOT NULL,
    [A_ModifyDate]             DATETIME        CONSTRAINT [DF_A_CommunicationMessagesRefurbishedOrderConfirmationItems_A_ModifyDate] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_A_CommunicationMessagesRefurbishedOrderConfirmationItems] PRIMARY KEY CLUSTERED ([A_ID] ASC) WITH (FILLFACTOR = 85)
);

