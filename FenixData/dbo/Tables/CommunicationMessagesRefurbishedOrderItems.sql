CREATE TABLE [dbo].[CommunicationMessagesRefurbishedOrderItems] (
    [ID]                         INT             IDENTITY (1, 1) NOT NULL,
    [CMSOId]                     INT             NOT NULL,
    [ItemVerKit]                 INT             CONSTRAINT [DF_CommunicationMessagesRefurbishedOrderItems_ItemVerKit] DEFAULT ((0)) NOT NULL,
    [ItemOrKitID]                INT             NOT NULL,
    [ItemOrKitDescription]       NVARCHAR (100)  NOT NULL,
    [ItemOrKitQuantity]          NUMERIC (18, 3) NOT NULL,
    [ItemOrKitQuantityDelivered] NUMERIC (18, 3) NULL,
    [ItemOrKitUnitOfMeasureId]   INT             NOT NULL,
    [ItemOrKitUnitOfMeasure]     NVARCHAR (50)   NOT NULL,
    [ItemOrKitQualityId]         INT             NOT NULL,
    [ItemOrKitQualityCode]       NVARCHAR (50)   NOT NULL,
    [IsActive]                   BIT             CONSTRAINT [DF_CommunicationMessagesRefurbishedOrderItems_IsActive] DEFAULT ((1)) NOT NULL,
    [ModifyDate]                 DATETIME        CONSTRAINT [DF_CommunicationMessagesRefurbishedOrderItems_ModifyDate] DEFAULT (getdate()) NOT NULL,
    [ModifyUserId]               INT             CONSTRAINT [DF_CommunicationMessagesRefurbishedOrderItems_ModifyUserId] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_CommunicationMessagesRefurbishedOrderItems] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 85)
);


GO

CREATE TRIGGER trCommunicationMessagesRefurbishedOrderItemsUpd
   ON  [dbo].[CommunicationMessagesRefurbishedOrderItems]
   AFTER UPDATE
AS 
BEGIN
-- =============================================
-- Author:		   Weczerek
-- Create date:   2014-10-01
-- Description:	
-- =============================================
SET NOCOUNT ON;

INSERT INTO [dbo].[A_CommunicationMessagesRefurbishedOrderItems]
           ([ID]
           ,[CMSOId]
           ,[ItemVerKit]
           ,[ItemOrKitID]
           ,[ItemOrKitDescription]
           ,[ItemOrKitQuantity]
           ,[ItemOrKitQuantityDelivered]
           ,[ItemOrKitUnitOfMeasureId]
           ,[ItemOrKitUnitOfMeasure]
           ,[ItemOrKitQualityId]
           ,[ItemOrKitQualityCode]
           ,[IsActive]
           ,[ModifyDate]
           ,[ModifyUserId]
           )
     SELECT [ID]
           ,[CMSOId]
           ,[ItemVerKit]
           ,[ItemOrKitID]
           ,[ItemOrKitDescription]
           ,[ItemOrKitQuantity]
           ,[ItemOrKitQuantityDelivered]
           ,[ItemOrKitUnitOfMeasureId]
           ,[ItemOrKitUnitOfMeasure]
           ,[ItemOrKitQualityId]
           ,[ItemOrKitQualityCode]
           ,[IsActive]
           ,[ModifyDate]
           ,[ModifyUserId]
     FROM DELETED
END

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Požadujeme xpedovat ---  0... Item,    1 ...Kit', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CommunicationMessagesRefurbishedOrderItems', @level2type = N'COLUMN', @level2name = N'ItemVerKit';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Id z tabulky cdlItems nebo cdlKits', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CommunicationMessagesRefurbishedOrderItems', @level2type = N'COLUMN', @level2name = N'ItemOrKitID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Dá se předpokládat, že při automatické kontrole a vytvoření záznamu bude uživatel nějaký, třeba 0', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CommunicationMessagesRefurbishedOrderItems', @level2type = N'COLUMN', @level2name = N'ModifyUserId';

