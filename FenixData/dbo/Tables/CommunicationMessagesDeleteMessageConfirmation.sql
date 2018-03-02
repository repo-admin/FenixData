CREATE TABLE [dbo].[CommunicationMessagesDeleteMessageConfirmation] (
    [ID]                           INT            IDENTITY (100, 1) NOT NULL,
    [StockId]                      INT            NOT NULL,
    [MessageId]                    INT            NOT NULL,
    [MessageTypeId]                INT            NOT NULL,
    [MessageTypeDescription]       NVARCHAR (200) NOT NULL,
    [DeleteId]                     INT            NOT NULL,
    [DeleteMessageId]              INT            NOT NULL,
    [DeleteMessageTypeId]          INT            NOT NULL,
    [DeleteMessageTypeDescription] NVARCHAR (200) NOT NULL,
    [DeleteMessageDate]            DATETIME       NULL,
    [Notice]                       NVARCHAR (MAX) NULL,
    [SentDate]                     DATETIME       NOT NULL,
    [IsActive]                     BIT            CONSTRAINT [DF_CommunicationMessagesDeleteMessageConfirmation_IsActive] DEFAULT ((1)) NOT NULL,
    [ModifyDate]                   DATETIME       CONSTRAINT [DF_CommunicationMessagesDeleteMessageConfirmation_ModifyDate] DEFAULT (getdate()) NOT NULL,
    [ModifyUserId]                 INT            CONSTRAINT [DF_CommunicationMessagesDeleteMessageConfirmation_ModifyUserId] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_CommunicationMessagesDeleteMessageConfirmation] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 85)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'číslo typu message - musí být z číselníku', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CommunicationMessagesDeleteMessageConfirmation', @level2type = N'COLUMN', @level2name = N'MessageTypeId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'popis typu message - musí být z číselníku', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CommunicationMessagesDeleteMessageConfirmation', @level2type = N'COLUMN', @level2name = N'MessageTypeDescription';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'D0  ID', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CommunicationMessagesDeleteMessageConfirmation', @level2type = N'COLUMN', @level2name = N'DeleteId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'D0  MessageID', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CommunicationMessagesDeleteMessageConfirmation', @level2type = N'COLUMN', @level2name = N'DeleteMessageId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'D0  MessageTypeId', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CommunicationMessagesDeleteMessageConfirmation', @level2type = N'COLUMN', @level2name = N'DeleteMessageTypeId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'D0  MessageTypeDescription', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CommunicationMessagesDeleteMessageConfirmation', @level2type = N'COLUMN', @level2name = N'DeleteMessageTypeDescription';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'D0  SentDate', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CommunicationMessagesDeleteMessageConfirmation', @level2type = N'COLUMN', @level2name = N'DeleteMessageDate';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'datum odeslání message z ND', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CommunicationMessagesDeleteMessageConfirmation', @level2type = N'COLUMN', @level2name = N'SentDate';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Datum editace', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CommunicationMessagesDeleteMessageConfirmation', @level2type = N'COLUMN', @level2name = N'ModifyDate';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'ID uživatele, který jako poslední záznam editoval', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CommunicationMessagesDeleteMessageConfirmation', @level2type = N'COLUMN', @level2name = N'ModifyUserId';

