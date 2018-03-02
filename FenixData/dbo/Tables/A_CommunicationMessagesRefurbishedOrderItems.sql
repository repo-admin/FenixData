CREATE TABLE [dbo].[A_CommunicationMessagesRefurbishedOrderItems] (
    [A_ID]                       INT             IDENTITY (1, 1) NOT NULL,
    [ID]                         INT             NOT NULL,
    [CMSOId]                     INT             NOT NULL,
    [ItemVerKit]                 INT             NOT NULL,
    [ItemOrKitID]                INT             NOT NULL,
    [ItemOrKitDescription]       NVARCHAR (100)  NOT NULL,
    [ItemOrKitQuantity]          NUMERIC (18, 3) NOT NULL,
    [ItemOrKitQuantityDelivered] NUMERIC (18, 3) NULL,
    [ItemOrKitUnitOfMeasureId]   INT             NOT NULL,
    [ItemOrKitUnitOfMeasure]     NVARCHAR (50)   NOT NULL,
    [ItemOrKitQualityId]         INT             NOT NULL,
    [ItemOrKitQualityCode]       NVARCHAR (50)   NOT NULL,
    [IsActive]                   BIT             NULL,
    [ModifyDate]                 DATETIME        NULL,
    [ModifyUserId]               INT             NULL,
    [A_ModifyDate]               DATETIME        CONSTRAINT [DF_A_CommunicationMessagesRefurbishedOrderItems_A_ModifyDate] DEFAULT (getdate()) NULL,
    CONSTRAINT [PK_A_CommunicationMessagesRefurbishedOrderItems] PRIMARY KEY CLUSTERED ([A_ID] ASC) WITH (FILLFACTOR = 85)
);

