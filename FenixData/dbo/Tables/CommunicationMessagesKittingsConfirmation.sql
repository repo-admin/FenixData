CREATE TABLE [dbo].[CommunicationMessagesKittingsConfirmation] (
    [ID]                   INT            IDENTITY (1, 1) NOT NULL,
    [MessageId]            INT            NOT NULL,
    [MessageTypeId]        INT            NOT NULL,
    [MessageDescription]   NVARCHAR (200) NOT NULL,
    [MessageDateOfReceipt] DATETIME       NULL,
    [KitOrderID]           INT            NOT NULL,
    [Reconciliation]       INT            CONSTRAINT [DF_CommunicationMessagesKittingsConfirmation_Reconciliation] DEFAULT ((0)) NOT NULL,
    [IsActive]             BIT            CONSTRAINT [DF_CommunicationMessagesKittingsConfirmation_IsActive] DEFAULT ((1)) NOT NULL,
    [ModifyDate]           DATETIME       CONSTRAINT [DF_CommunicationMessagesKittingsConfirmation_ModifyDate] DEFAULT (getdate()) NOT NULL,
    [ModifyUserId]         INT            CONSTRAINT [DF_CommunicationMessagesKittingsConfirmation_ModifyUserId] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_CommunicationMessagesKittingsConfirmation] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 85)
);




GO


CREATE  TRIGGER [dbo].[trCommunicationMessagesKittingsConfirmationUpd]
   ON  [dbo].[CommunicationMessagesKittingsConfirmation] 
   AFTER UPDATE
AS 
BEGIN
-- =============================================
-- Author:		   Weczerek
-- Create date:   2014-10-24
-- Description:	
-- =============================================
SET NOCOUNT ON;

INSERT INTO [dbo].[A_CommunicationMessagesKittingsConfirmation]
           ([ID]
           ,[MessageId]
           ,[MessageTypeId]
           ,[MessageDescription]
           ,[MessageDateOfReceipt]
           ,[KitOrderID]
           ,[Reconciliation]
           ,[IsActive]
           ,[ModifyDate]
           ,[ModifyUserId]
)
SELECT      [ID]
           ,[MessageId]
           ,[MessageTypeId]
           ,[MessageDescription]
           ,[MessageDateOfReceipt]
           ,[KitOrderID]
           ,[Reconciliation]
           ,[IsActive]
           ,[ModifyDate]
           ,[ModifyUserId]
FROM deleted
END


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'pořadové číslo message; ', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CommunicationMessagesKittingsConfirmation', @level2type = N'COLUMN', @level2name = N'MessageId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'typ message - musí být číselník', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CommunicationMessagesKittingsConfirmation', @level2type = N'COLUMN', @level2name = N'MessageTypeId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Datum, kdy byla položka prijata z ND', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CommunicationMessagesKittingsConfirmation', @level2type = N'COLUMN', @level2name = N'MessageDateOfReceipt';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'zde je ID z tabulky CommunicationMessagesSent Orders-> zde umíme získat údaje od objednávky z Heliosu', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CommunicationMessagesKittingsConfirmation', @level2type = N'COLUMN', @level2name = N'KitOrderID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'0...Neodsouhlaseno, 1... Odsouhlaseno, 2... Zamítnuto', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CommunicationMessagesKittingsConfirmation', @level2type = N'COLUMN', @level2name = N'Reconciliation';


GO
GRANT UPDATE
    ON OBJECT::[dbo].[CommunicationMessagesKittingsConfirmation] TO [FenixR]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[CommunicationMessagesKittingsConfirmation] TO [FenixR]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[CommunicationMessagesKittingsConfirmation] TO [FenixR]
    AS [dbo];


GO
GRANT DELETE
    ON OBJECT::[dbo].[CommunicationMessagesKittingsConfirmation] TO [FenixR]
    AS [dbo];

