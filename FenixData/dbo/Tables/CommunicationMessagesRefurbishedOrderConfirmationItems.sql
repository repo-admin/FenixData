CREATE TABLE [dbo].[CommunicationMessagesRefurbishedOrderConfirmationItems] (
    [ID]                       INT             IDENTITY (1, 1) NOT NULL,
    [CMSOId]                   INT             NOT NULL,
    [ItemVerKit]               INT             CONSTRAINT [DF_CommunicationMessagesRefurbishedOrderConfirmationItems_ItemVerKit] DEFAULT ((0)) NOT NULL,
    [ItemOrKitID]              INT             NOT NULL,
    [ItemOrKitDescription]     NVARCHAR (100)  NOT NULL,
    [ItemOrKitQuantity]        NUMERIC (18, 3) NOT NULL,
    [ItemOrKitUnitOfMeasureId] INT             NOT NULL,
    [ItemOrKitUnitOfMeasure]   NVARCHAR (50)   NOT NULL,
    [ItemOrKitQualityId]       INT             NOT NULL,
    [ItemOrKitQualityCode]     NVARCHAR (50)   NOT NULL,
    [IncotermsId]              INT             NULL,
    [IncotermDescription]      NVARCHAR (50)   NULL,
    [NDReceipt]                NVARCHAR (50)   NULL,
    [KitSNs]                   VARCHAR (MAX)   NULL,
    [IsActive]                 BIT             CONSTRAINT [DF_CommunicationMessagesRefurbishedOrderConfirmationItems_IsActive] DEFAULT ((1)) NOT NULL,
    [ModifyDate]               DATETIME        CONSTRAINT [DF_CommunicationMessagesRefurbishedOrderConfirmationItems_ModifyDate] DEFAULT (getdate()) NOT NULL,
    [ModifyUserId]             INT             CONSTRAINT [DF_CommunicationMessagesRefurbishedOrderConfirmationItems_ModifyUserId] DEFAULT ((0)) NOT NULL,
    [SN1]                      NVARCHAR (50)   NULL,
    [SN2]                      NVARCHAR (50)   NULL,
    CONSTRAINT [PK_CommunicationMessagesRefurbishedOrderConfirmationItems] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 85)
);




GO

CREATE TRIGGER [dbo].[trCommunicationMessagesRefurbishedOrderConfirmationItemsUpd]
   ON  [dbo].[CommunicationMessagesRefurbishedOrderConfirmationItems]
   AFTER UPDATE
AS 
BEGIN
-- =============================================
-- Author:		   Weczerek
-- Create date:   2015-02-12
-- Description:	
-- =============================================
	SET NOCOUNT ON;

INSERT INTO [dbo].[A_CommunicationMessagesRefurbishedOrderConfirmationItems]
           ([ID]
           ,[CMSOId]
           ,[ItemVerKit]
           ,[ItemOrKitID]
           ,[ItemOrKitDescription]
           ,[ItemOrKitQuantity]
           ,[ItemOrKitUnitOfMeasureId]
           ,[ItemOrKitUnitOfMeasure]
           ,[ItemOrKitQualityId]
           ,[ItemOrKitQualityCode]
           ,[IncotermsId]
           ,[IncotermDescription]
           ,[NDReceipt]
           ,[KitSNs]
           ,[IsActive]
           ,[ModifyDate]
           ,[ModifyUserId]
)
SELECT      [ID]
           ,[CMSOId]
           ,[ItemVerKit]
           ,[ItemOrKitID]
           ,[ItemOrKitDescription]
           ,[ItemOrKitQuantity]
           ,[ItemOrKitUnitOfMeasureId]
           ,[ItemOrKitUnitOfMeasure]
           ,[ItemOrKitQualityId]
           ,[ItemOrKitQualityCode]
           ,[IncotermsId]
           ,[IncotermDescription]
           ,[NDReceipt]
           ,[KitSNs]
           ,[IsActive]
           ,[ModifyDate]
           ,[ModifyUserId]
FROM deleted

END




GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Požadujeme xpedovat ---  0... Item,    1 ...Kit', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CommunicationMessagesRefurbishedOrderConfirmationItems', @level2type = N'COLUMN', @level2name = N'ItemVerKit';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Id z tabulky cdlItems nebo cdlKits', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CommunicationMessagesRefurbishedOrderConfirmationItems', @level2type = N'COLUMN', @level2name = N'ItemOrKitID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'bylo požadováno', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CommunicationMessagesRefurbishedOrderConfirmationItems', @level2type = N'COLUMN', @level2name = N'ItemOrKitQuantity';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Dá se předpokládat, že při automatické kontrole a vytvoření záznamu bude uživatel nějaký, třeba 0', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CommunicationMessagesRefurbishedOrderConfirmationItems', @level2type = N'COLUMN', @level2name = N'ModifyUserId';

