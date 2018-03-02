CREATE TABLE [dbo].[CommunicationMessagesReturnItemsSN] (
    [ID]                 INT           IDENTITY (1, 1) NOT NULL,
    [CMSOId]             INT           NOT NULL,
    [ItemOrKitQualityId] INT           NOT NULL,
    [ItemOrKitQuality]   VARCHAR (50)  NOT NULL,
    [KitSNs]             VARCHAR (MAX) NULL,
    [IsActive]           BIT           CONSTRAINT [DF_CommunicationMessagesReturnItemsSN_IsActive] DEFAULT ((1)) NOT NULL,
    [ModifyDate]         DATETIME      CONSTRAINT [DF_CommunicationMessagesReturnItemsSN_ModifyDate] DEFAULT (getdate()) NOT NULL,
    [ModifyUserId]       INT           CONSTRAINT [DF_CommunicationMessagesReturnItemsSN_ModifyUserId] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_CommunicationMessagesReturnItemsSN] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 85),
    CONSTRAINT [FK_CommunicationMessagesReturnItemsSN_cdlQualities] FOREIGN KEY ([ItemOrKitQualityId]) REFERENCES [dbo].[cdlQualities] ([ID])
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'musí být číselník: new nový, Returned vrácený, Refurbished,...', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CommunicationMessagesReturnItemsSN', @level2type = N'COLUMN', @level2name = N'ItemOrKitQualityId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Serial Number1 - seriálové číslo zařízení', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CommunicationMessagesReturnItemsSN', @level2type = N'COLUMN', @level2name = N'KitSNs';

