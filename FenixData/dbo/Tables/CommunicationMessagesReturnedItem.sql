CREATE TABLE [dbo].[CommunicationMessagesReturnedItem] (
    [ID]                   INT            IDENTITY (1, 1) NOT NULL,
    [MessageId]            INT            NOT NULL,
    [MessageTypeId]        INT            NOT NULL,
    [MessageDescription]   NVARCHAR (200) NOT NULL,
    [MessageDateOfReceipt] DATETIME       NULL,
    [Reconciliation]       INT            CONSTRAINT [DF_CommunicationMessagesReturnedItem_Reconciliation] DEFAULT ((0)) NOT NULL,
    [IsActive]             BIT            CONSTRAINT [DF_CommunicationMessagesReturnedItem_IsActive] DEFAULT ((1)) NOT NULL,
    [ModifyDate]           DATETIME       CONSTRAINT [DF_CommunicationMessagesReturnedItem_ModifyDate] DEFAULT (getdate()) NOT NULL,
    [ModifyUserId]         INT            CONSTRAINT [DF_CommunicationMessagesReturnedItem_ModifyUserId] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_CommunicationMessagesReturnedItem] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 85)
);


GO


CREATE TRIGGER [dbo].[trCommunicationMessagesReturnedItemUpd]
   ON  [dbo].[CommunicationMessagesReturnedItem]
   AFTER UPDATE
AS 
BEGIN
-- =============================================
-- Author:		   Weczerek
-- Create date:   2015-02-11
-- Description:	
-- =============================================
	SET NOCOUNT ON;

INSERT INTO [dbo].[A_CommunicationMessagesReturnedItem]
           ([ID]
           ,[MessageId]
           ,[MessageTypeId]
           ,[MessageDescription]
           ,[MessageDateOfReceipt]
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
           ,[Reconciliation]
           ,[IsActive]
           ,[ModifyDate]
           ,[ModifyUserId]
FROM deleted

END




GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'pořadové číslo message; ', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CommunicationMessagesReturnedItem', @level2type = N'COLUMN', @level2name = N'MessageId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'typ message - musí být číselník', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CommunicationMessagesReturnedItem', @level2type = N'COLUMN', @level2name = N'MessageTypeId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Datum, kdy byla položka prijata na ND', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CommunicationMessagesReturnedItem', @level2type = N'COLUMN', @level2name = N'MessageDateOfReceipt';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'0...Neodsouhlaseno, 1... Odsouhlaseno, 2... Zamítnuto', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CommunicationMessagesReturnedItem', @level2type = N'COLUMN', @level2name = N'Reconciliation';

