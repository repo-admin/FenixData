CREATE TABLE [dbo].[A_CommunicationMessagesRefurbishedOrderConfirmation] (
    [A_ID]               INT            IDENTITY (1, 1) NOT NULL,
    [ID]                 INT            NOT NULL,
    [MessageId]          INT            NOT NULL,
    [MessageTypeId]      INT            NOT NULL,
    [MessageDescription] NVARCHAR (200) NOT NULL,
    [DateOfShipment]     DATETIME       NULL,
    [RefurbishedOrderID] INT            NOT NULL,
    [CustomerID]         INT            NOT NULL,
    [Reconciliation]     INT            CONSTRAINT [DF_A_CommunicationMessagesRefurbishedOrderConfirmation_Reconciliation] DEFAULT ((0)) NOT NULL,
    [IsActive]           BIT            CONSTRAINT [DF_A_CommunicationMessagesRefurbishedOrderConfirmation_IsActive] DEFAULT ((1)) NOT NULL,
    [ModifyDate]         DATETIME       CONSTRAINT [DF_A_CommunicationMessagesRefurbishedOrderConfirmation_ModifyDate] DEFAULT (getdate()) NOT NULL,
    [ModifyUserId]       INT            CONSTRAINT [DF_A_CommunicationMessagesRefurbishedOrderConfirmation_ModifyUserId] DEFAULT ((0)) NOT NULL,
    [A_ModifyDate]       DATETIME       CONSTRAINT [DF_A_CommunicationMessagesRefurbishedOrderConfirmation_A_ModifyUserId] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_A_CommunicationMessagesRefurbishedOrderConfirmation] PRIMARY KEY CLUSTERED ([A_ID] ASC) WITH (FILLFACTOR = 85)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'pořadové číslo message; ', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'A_CommunicationMessagesRefurbishedOrderConfirmation', @level2type = N'COLUMN', @level2name = N'MessageId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'id z tabulky cdlDestinationPlaces', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'A_CommunicationMessagesRefurbishedOrderConfirmation', @level2type = N'COLUMN', @level2name = N'CustomerID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'0...Neodsouhlaseno, 1... Odsouhlaseno, 2... Zamítnuto', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'A_CommunicationMessagesRefurbishedOrderConfirmation', @level2type = N'COLUMN', @level2name = N'Reconciliation';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Dá se předpokládat, že při automatické kontrole a vytvoření záznamu bude uživatel nějaký, třeba 0', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'A_CommunicationMessagesRefurbishedOrderConfirmation', @level2type = N'COLUMN', @level2name = N'ModifyUserId';

