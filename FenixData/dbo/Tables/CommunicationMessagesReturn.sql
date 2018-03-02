CREATE TABLE [dbo].[CommunicationMessagesReturn] (
    [ID]                   INT            IDENTITY (1, 1) NOT NULL,
    [MessageId]            INT            NOT NULL,
    [MessageTypeId]        INT            NOT NULL,
    [MessageDescription]   NVARCHAR (200) NOT NULL,
    [MessageDateOfReceipt] DATETIME       NOT NULL,
    [Reconciliation]       INT            CONSTRAINT [DF_CommunicationMessagesReturn_Reconciliation] DEFAULT ((0)) NOT NULL,
    [IsActive]             BIT            CONSTRAINT [DF_CommunicationMessagesReturn_IsActive] DEFAULT ((1)) NOT NULL,
    [ModifyDate]           DATETIME       CONSTRAINT [DF_CommunicationMessagesReturn_ModifyDate] DEFAULT (getdate()) NOT NULL,
    [ModifyUserId]         INT            CONSTRAINT [DF_CommunicationMessagesReturn_ModifyUserId] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_CommunicationMessagesReturn] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 85)
);


GO
  
CREATE TRIGGER [dbo].[trCommunicationMessagesReturnUpd]
   ON  [dbo].[CommunicationMessagesReturn]
   AFTER UPDATE
AS 
BEGIN
-- ================================================================================
-- Author:					Weczerek
-- Create date:   2015-02-11
-- Description:
-- Edit       :   M. Rezler  2015-06-05 .. přidány sloupce 	ItemID, ItemDescription
--                M. Rezler  2015-06-08 .. odebrány sloupce 	ItemID, ItemDescription

-- ================================================================================
SET NOCOUNT ON;

INSERT INTO [dbo].[A_CommunicationMessagesReturn]
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
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'pořadové číslo message; ', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CommunicationMessagesReturn', @level2type = N'COLUMN', @level2name = N'MessageId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'typ message - musí být číselník', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CommunicationMessagesReturn', @level2type = N'COLUMN', @level2name = N'MessageTypeId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Datum, kdy byla položka prijata z ND', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CommunicationMessagesReturn', @level2type = N'COLUMN', @level2name = N'MessageDateOfReceipt';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'0...Neodsouhlaseno, 1... Odsouhlaseno, 2... Zamítnuto', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CommunicationMessagesReturn', @level2type = N'COLUMN', @level2name = N'Reconciliation';

