CREATE TABLE [dbo].[DeleteMessageSent] (
    [ID]                       INT            IDENTITY (1, 1) NOT NULL,
    [MessageId]                INT            NOT NULL,
    [MessageTypeId]            INT            NOT NULL,
    [MessageDescription]       NVARCHAR (200) NOT NULL,
    [MessageStatusId]          INT            NOT NULL,
    [DeleteId]                 INT            NOT NULL,
    [DeleteMessageId]          INT            NOT NULL,
    [DeleteMessageTypeId]      INT            NOT NULL,
    [DeleteMessageDescription] NVARCHAR (200) NOT NULL,
    [Notice]                   NVARCHAR (MAX) NULL,
    [SentDate]                 DATETIME       NULL,
    [SentUserId]               INT            NULL,
    [ReceivedDate]             DATETIME       NULL,
    [ReceivedUserId]           INT            NULL,
    [IsActive]                 BIT            CONSTRAINT [DF_DeleteMessageSent_IsActive] DEFAULT ((1)) NOT NULL,
    [ModifyDate]               DATETIME       CONSTRAINT [DF_DeleteMessageSent_ModifyDate] DEFAULT (getdate()) NOT NULL,
    [ModifyUserId]             INT            CONSTRAINT [DF_DeleteMessageSent_ModifyUserId] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_DeleteMessageSent] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 85)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Pořadové číslo message', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'DeleteMessageSent', @level2type = N'COLUMN', @level2name = N'MessageId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'ID typu message .. 14', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'DeleteMessageSent', @level2type = N'COLUMN', @level2name = N'MessageTypeId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Popis typu message .. DeleteMessageSent', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'DeleteMessageSent', @level2type = N'COLUMN', @level2name = N'MessageDescription';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'ID statusu message (1 .. záznam čeká na odeslání, 11 .. záznam odeslán emailem, 12 .. příchozí email úspěšně zpracován, záznam úspěšně aktualizován ve Fenixu)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'DeleteMessageSent', @level2type = N'COLUMN', @level2name = N'MessageStatusId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'ID zrušené zprávy', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'DeleteMessageSent', @level2type = N'COLUMN', @level2name = N'DeleteId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'MessageId zrušené zprávy', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'DeleteMessageSent', @level2type = N'COLUMN', @level2name = N'DeleteMessageId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Typ zrušené zprávy (1 .. ReceptionOrder, 3 .. KittingOrder, 6 .. ShipmentOrder, 12 .. RefurbishedOrder)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'DeleteMessageSent', @level2type = N'COLUMN', @level2name = N'DeleteMessageTypeId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Popis typu zrušené zprávy (ReceptionOrder, ReceptionConfirmation, KittingOrder ...)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'DeleteMessageSent', @level2type = N'COLUMN', @level2name = N'DeleteMessageDescription';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Poznámka', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'DeleteMessageSent', @level2type = N'COLUMN', @level2name = N'Notice';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Datum úspěšného odeslání', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'DeleteMessageSent', @level2type = N'COLUMN', @level2name = N'SentDate';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Datum editace', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'DeleteMessageSent', @level2type = N'COLUMN', @level2name = N'ModifyDate';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'ID uživatele, který jako poslední záznam editoval', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'DeleteMessageSent', @level2type = N'COLUMN', @level2name = N'ModifyUserId';

