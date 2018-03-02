CREATE TABLE [dbo].[A_CommunicationMessagesKittingsConfirmation] (
    [A_ID]                 INT            IDENTITY (1, 1) NOT NULL,
    [ID]                   INT            NOT NULL,
    [MessageId]            INT            NOT NULL,
    [MessageTypeId]        INT            NOT NULL,
    [MessageDescription]   NVARCHAR (200) NOT NULL,
    [MessageDateOfReceipt] DATETIME       NULL,
    [KitOrderID]           INT            NOT NULL,
    [Reconciliation]       INT            CONSTRAINT [DF_A_CommunicationMessagesKittingsConfirmation_Reconciliation] DEFAULT ((0)) NOT NULL,
    [IsActive]             BIT            CONSTRAINT [DF_A_CommunicationMessagesKittingsConfirmation_IsActive] DEFAULT ((1)) NOT NULL,
    [ModifyDate]           DATETIME       NOT NULL,
    [ModifyUserId]         INT            CONSTRAINT [DF_A_CommunicationMessagesKittingsConfirmation_ModifyUserId] DEFAULT ((0)) NOT NULL,
    [A_ModifyDate]         DATETIME       CONSTRAINT [DF_A_CommunicationMessagesKittingsConfirmation_A_ModifyDate] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_A_CommunicationMessagesKittingsConfirmation] PRIMARY KEY CLUSTERED ([A_ID] ASC) WITH (FILLFACTOR = 85)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'pořadové číslo message; ', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'A_CommunicationMessagesKittingsConfirmation', @level2type = N'COLUMN', @level2name = N'MessageId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'typ message - musí být číselník', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'A_CommunicationMessagesKittingsConfirmation', @level2type = N'COLUMN', @level2name = N'MessageTypeId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Datum, kdy byla položka prijata z ND', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'A_CommunicationMessagesKittingsConfirmation', @level2type = N'COLUMN', @level2name = N'MessageDateOfReceipt';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'zde je ID z tabulky CommunicationMessagesSent Orders-> zde umíme získat údaje od objednávky z Heliosu', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'A_CommunicationMessagesKittingsConfirmation', @level2type = N'COLUMN', @level2name = N'KitOrderID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'0...Neodsouhlaseno, 1... Odsouhlaseno, 2... Zamítnuto', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'A_CommunicationMessagesKittingsConfirmation', @level2type = N'COLUMN', @level2name = N'Reconciliation';

