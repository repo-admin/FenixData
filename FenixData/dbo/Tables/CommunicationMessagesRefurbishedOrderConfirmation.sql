CREATE TABLE [dbo].[CommunicationMessagesRefurbishedOrderConfirmation] (
    [ID]                 INT            IDENTITY (1, 1) NOT NULL,
    [MessageId]          INT            NOT NULL,
    [MessageTypeId]      INT            NOT NULL,
    [MessageDescription] NVARCHAR (200) NOT NULL,
    [DateOfShipment]     DATETIME       NULL,
    [RefurbishedOrderID] INT            NOT NULL,
    [CustomerID]         INT            NOT NULL,
    [Reconciliation]     INT            CONSTRAINT [DF_CommunicationMessagesRefurbishedOrderConfirmation_Reconciliation] DEFAULT ((0)) NOT NULL,
    [IsActive]           BIT            CONSTRAINT [DF_CommunicationMessagesRefurbishedOrderConfirmation_IsActive] DEFAULT ((1)) NOT NULL,
    [ModifyDate]         DATETIME       CONSTRAINT [DF_CommunicationMessagesRefurbishedOrderConfirmation_ModifyDate] DEFAULT (getdate()) NOT NULL,
    [ModifyUserId]       INT            CONSTRAINT [DF_CommunicationMessagesRefurbishedOrderConfirmation_ModifyUserId] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_CommunicationMessagesRefurbishedOrderConfirmation] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 85)
);


GO


CREATE TRIGGER [dbo].[trCommunicationMessagesRefurbishedOrderConfirmationUpd]
   ON  [dbo].[CommunicationMessagesRefurbishedOrderConfirmation]
   AFTER UPDATE
AS 
BEGIN
-- =============================================
-- Author:		   Weczerek
-- Create date:   2014-10-24
-- Description:	
-- =============================================

	SET NOCOUNT ON;


INSERT INTO [dbo].[A_CommunicationMessagesRefurbishedOrderConfirmation]
           ([ID]
           ,[MessageId]
           ,[MessageTypeId]
           ,[MessageDescription]
           ,[DateOfShipment]
           ,[RefurbishedOrderID]
           ,[CustomerID]
           ,[Reconciliation]
           ,[IsActive]
           ,[ModifyDate]
)
SELECT      [ID]
           ,[MessageId]
           ,[MessageTypeId]
           ,[MessageDescription]
           ,[DateOfShipment]
           ,[RefurbishedOrderID]
           ,[CustomerID]
           ,[Reconciliation]
           ,[IsActive]
           ,[ModifyDate]
FROM deleted
END



GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'pořadové číslo message; ', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CommunicationMessagesRefurbishedOrderConfirmation', @level2type = N'COLUMN', @level2name = N'MessageId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'id z tabulky cdlDestinationPlaces', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CommunicationMessagesRefurbishedOrderConfirmation', @level2type = N'COLUMN', @level2name = N'CustomerID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'0...Neodsouhlaseno, 1... Odsouhlaseno, 2... Zamítnuto', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CommunicationMessagesRefurbishedOrderConfirmation', @level2type = N'COLUMN', @level2name = N'Reconciliation';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Dá se předpokládat, že při automatické kontrole a vytvoření záznamu bude uživatel nějaký, třeba 0', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CommunicationMessagesRefurbishedOrderConfirmation', @level2type = N'COLUMN', @level2name = N'ModifyUserId';

