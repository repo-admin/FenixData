CREATE TABLE [dbo].[CommunicationMessagesKittingsApprovalSent] (
    [ID]                    INT            IDENTITY (1, 1) NOT NULL,
    [MessageId]             INT            NOT NULL,
    [MessageTypeID]         INT            NOT NULL,
    [MessageDescription]    NVARCHAR (200) NOT NULL,
    [MessageDateOfShipment] DATETIME       NULL,
    [RequiredReleaseDate]   DATETIME       NULL,
    [MessageStatusID]       INT            CONSTRAINT [DF_CommunicationMessagesKittingsApprovalSent_MessageStatusID] DEFAULT ((1)) NOT NULL,
    [Released]              BIT            CONSTRAINT [DF_CommunicationMessagesKittingsApprovalSent_Released] DEFAULT ((0)) NOT NULL,
    [HeliosOrderID]         INT            NULL,
    [IsActive]              BIT            CONSTRAINT [DF_CommunicationMessagesKittingsApprovalSent_IsActive] DEFAULT ((1)) NOT NULL,
    [ModifyDate]            DATETIME       CONSTRAINT [DF_CommunicationMessagesKittingsApprovalSent_ModifyDate] DEFAULT (getdate()) NOT NULL,
    [ModifyUserId]          INT            CONSTRAINT [DF_CommunicationMessagesKittingsApprovalSent_ModifyUserId] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_CommunicationMessagesKittingsApprovalSent] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 85)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'pořadové číslo message; ', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CommunicationMessagesKittingsApprovalSent', @level2type = N'COLUMN', @level2name = N'MessageId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'1 neodesláno   viz číselník', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CommunicationMessagesKittingsApprovalSent', @level2type = N'COLUMN', @level2name = N'MessageStatusID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'0 nevyjádřeno, 1 odsouhlaseno k uvolnění', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CommunicationMessagesKittingsApprovalSent', @level2type = N'COLUMN', @level2name = N'Released';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'múže být více objednávek, proto varchar', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CommunicationMessagesKittingsApprovalSent', @level2type = N'COLUMN', @level2name = N'HeliosOrderID';

