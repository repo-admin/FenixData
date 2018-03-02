CREATE TABLE [dbo].[A_CommunicationMessagesReturnItems] (
    [A_ID]               INT            IDENTITY (1, 1) NOT NULL,
    [ID]                 INT            NOT NULL,
    [CMSOId]             INT            NOT NULL,
    [ItemOrKitQualityId] INT            NOT NULL,
    [ItemOrKitQuality]   VARCHAR (50)   NOT NULL,
    [SN1]                VARCHAR (50)   NULL,
    [SN2]                VARCHAR (50)   NULL,
    [NDReceipt]          NVARCHAR (100) NULL,
    [ReturnedFrom]       NVARCHAR (MAX) NOT NULL,
    [IsActive]           BIT            CONSTRAINT [DF_A_CommunicationMessagesReturnItems_IsActive] DEFAULT ((1)) NOT NULL,
    [ModifyDate]         DATETIME       CONSTRAINT [DF_A_CommunicationMessagesReturnItems_ModifyDate] DEFAULT (getdate()) NOT NULL,
    [ModifyUserId]       INT            CONSTRAINT [DF_A_CommunicationMessagesReturnItems_ModifyUserId] DEFAULT ((0)) NOT NULL,
    [A_ModifyDate]       DATETIME       CONSTRAINT [DF_A_CommunicationMessagesReturnItems_A_ModifyDate] DEFAULT (getdate()) NOT NULL,
    [ItemID]             INT            NULL,
    [ItemDescription]    NVARCHAR (100) NULL,
    CONSTRAINT [PK_A_CommunicationMessagesReturnItems] PRIMARY KEY CLUSTERED ([A_ID] ASC) WITH (FILLFACTOR = 85)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'musí být číselník: new nový, Returned vrácený, Refurbished,...', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'A_CommunicationMessagesReturnItems', @level2type = N'COLUMN', @level2name = N'ItemOrKitQualityId';

