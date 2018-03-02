CREATE TABLE [dbo].[CommunicationMessagesReceptionConfirmation] (
    [ID]                          INT            IDENTITY (1, 1) NOT NULL,
    [MessageId]                   INT            NOT NULL,
    [MessageTypeId]               INT            NOT NULL,
    [MessageDescription]          NVARCHAR (200) NOT NULL,
    [MessageDateOfReceipt]        DATETIME       NULL,
    [CommunicationMessagesSentId] INT            NOT NULL,
    [ItemSupplierId]              INT            NOT NULL,
    [ItemSupplierDescription]     NVARCHAR (500) NOT NULL,
    [Reconciliation]              INT            CONSTRAINT [DF_CommunicationMessagesReceptionConfirmation_Reconciliation] DEFAULT ((0)) NOT NULL,
    [IsActive]                    BIT            CONSTRAINT [DF_CommunicationMessagesReceptionConfirmation_IsActive] DEFAULT ((1)) NOT NULL,
    [ModifyDate]                  DATETIME       CONSTRAINT [DF_CommunicationMessagesReceptionConfirmation_ModifyDate] DEFAULT (getdate()) NOT NULL,
    [ModifyUserId]                INT            CONSTRAINT [DF_CommunicationMessagesReceptionConfirmation_ModifyUserId] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_CommunicationMessagesReceptionConfirmation] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 85),
    CONSTRAINT [FK_CommunicationMessagesReceptionConfirmation_cdlSuppliers] FOREIGN KEY ([ItemSupplierId]) REFERENCES [dbo].[cdlSuppliers] ([ID])
);


GO


CREATE  TRIGGER [dbo].[trCommunicationMessagesReceptionConfirmationUpd]
   ON  [dbo].[CommunicationMessagesReceptionConfirmation] 
   AFTER UPDATE
AS 
BEGIN
-- =============================================
-- Author:		   Weczerek
-- Create date:   2014-10-24
-- Description:	
-- =============================================
SET NOCOUNT ON;
INSERT INTO [dbo].[A_CommunicationMessagesReceptionConfirmation]
           ([ID]
           ,[MessageId]
           ,[MessageTypeId]
           ,[MessageDescription]
           ,[MessageDateOfReceipt]
           ,[CommunicationMessagesSentId]
           ,[ItemSupplierId]
           ,[ItemSupplierDescription]
           ,[Reconciliation]
           ,[IsActive]
           ,[ModifyDate]
           ,[ModifyUserId])
     SELECT [ID]
           ,[MessageId]
           ,[MessageTypeId]
           ,[MessageDescription]
           ,[MessageDateOfReceipt]
           ,[CommunicationMessagesSentId]
           ,[ItemSupplierId]
           ,[ItemSupplierDescription]
           ,[Reconciliation]
           ,[IsActive]
           ,[ModifyDate]
           ,[ModifyUserId]
FROM DELETED


END


GO
GRANT SELECT
    ON OBJECT::[dbo].[CommunicationMessagesReceptionConfirmation] TO [mis]
    AS [dbo];


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'pořadové číslo message; ', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CommunicationMessagesReceptionConfirmation', @level2type = N'COLUMN', @level2name = N'MessageId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'typ message - musí být číselník', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CommunicationMessagesReceptionConfirmation', @level2type = N'COLUMN', @level2name = N'MessageTypeId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Datum, kdy byla položka prijata z ND', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CommunicationMessagesReceptionConfirmation', @level2type = N'COLUMN', @level2name = N'MessageDateOfReceipt';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'zde je ID z tabulky CommunicationMessagesSent Orders-> zde umíme získat údaje od objednávky z Heliosu', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CommunicationMessagesReceptionConfirmation', @level2type = N'COLUMN', @level2name = N'CommunicationMessagesSentId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'0...Neodsouhlaseno, 1... Odsouhlaseno, 2... Zamítnuto', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CommunicationMessagesReceptionConfirmation', @level2type = N'COLUMN', @level2name = N'Reconciliation';

