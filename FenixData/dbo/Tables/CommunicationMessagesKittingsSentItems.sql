CREATE TABLE [dbo].[CommunicationMessagesKittingsSentItems] (
    [ID]                   INT             IDENTITY (1, 1) NOT NULL,
    [CMSOId]               INT             NOT NULL,
    [HeliosOrderID]        INT             CONSTRAINT [DF_CommunicationMessagesKittingsSentItems_HeliosOrderID] DEFAULT ((0)) NOT NULL,
    [HeliosOrderRecordId]  INT             CONSTRAINT [DF_CommunicationMessagesKittingsSentItems_HeliosOrderRecordId] DEFAULT ((0)) NOT NULL,
    [KitId]                INT             NOT NULL,
    [KitDescription]       NVARCHAR (500)  NOT NULL,
    [KitQuantity]          NUMERIC (18, 3) NOT NULL,
    [KitQuantityDelivered] NUMERIC (18, 3) NULL,
    [MeasuresID]           INT             NOT NULL,
    [KitUnitOfMeasure]     NVARCHAR (50)   NOT NULL,
    [KitQualityId]         INT             NOT NULL,
    [KitQualityCode]       NVARCHAR (50)   NULL,
    [CardStockItemsId]     INT             NOT NULL,
    [IsActive]             BIT             CONSTRAINT [DF_CommunicationMessagesKittingsSentItems_IsActive] DEFAULT ((1)) NOT NULL,
    [ModifyDate]           DATETIME        CONSTRAINT [DF_CommunicationMessagesKittingsSentItems_ModifyDate] DEFAULT (getdate()) NOT NULL,
    [ModifyUserId]         INT             CONSTRAINT [DF_CommunicationMessagesKittingsSentItems_ModifyUserId] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_CommunicationMessagesKittingsSentItems] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 85)
);


GO
CREATE TRIGGER trCommunicationMessagesKittingsSentItemsUpd
   ON  [dbo].[CommunicationMessagesKittingsSentItems]
   AFTER UPDATE
AS 
BEGIN
-- =============================================
-- Author:		   Weczerek
-- Create date:   2014-10-01
-- Description:	
-- =============================================

	SET NOCOUNT ON;

INSERT INTO [dbo].[A_CommunicationMessagesKittingsSentItems]
           ([ID]
           ,[CMSOId]
           ,[HeliosOrderID]
           ,[HeliosOrderRecordId]
           ,[KitId]
           ,[KitDescription]
           ,[KitQuantity]
           ,[KitQuantityDelivered]
           ,[MeasuresID]
           ,[KitUnitOfMeasure]
           ,[KitQualityId]
           ,[KitQualityCode]
           ,[CardStockItemsId]
           ,[IsActive]
           ,[ModifyDate]
           ,[ModifyUserId]
           )
     SELECT [ID]
           ,[CMSOId]
           ,[HeliosOrderID]
           ,[HeliosOrderRecordId]
           ,[KitId]
           ,[KitDescription]
           ,[KitQuantity]
           ,[KitQuantityDelivered]
           ,[MeasuresID]
           ,[KitUnitOfMeasure]
           ,[KitQualityId]
           ,[KitQualityCode]
           ,[CardStockItemsId]
           ,[IsActive]
           ,[ModifyDate]
           ,[ModifyUserId]
       FROM DELETED


END

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'ID z číselníků cdlKittings - objednáváme předem definovanou sestavu', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CommunicationMessagesKittingsSentItems', @level2type = N'COLUMN', @level2name = N'KitId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'popis předem definované sestavy', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CommunicationMessagesKittingsSentItems', @level2type = N'COLUMN', @level2name = N'KitDescription';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'požadované množství zboží, materiálu, služeb ', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CommunicationMessagesKittingsSentItems', @level2type = N'COLUMN', @level2name = N'KitQuantity';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'měrná jednotka - měl by být číselník a pak přidat ID sloupec', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CommunicationMessagesKittingsSentItems', @level2type = N'COLUMN', @level2name = N'KitUnitOfMeasure';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Dá se předpokládat, že při automatické kontrole a vytvoření záznamu bude uživatel nějaký, třeba 0', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CommunicationMessagesKittingsSentItems', @level2type = N'COLUMN', @level2name = N'ModifyUserId';

