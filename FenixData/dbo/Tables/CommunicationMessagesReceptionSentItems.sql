CREATE TABLE [dbo].[CommunicationMessagesReceptionSentItems] (
    [ID]                    INT             IDENTITY (1, 1) NOT NULL,
    [CMSOId]                INT             NOT NULL,
    [HeliosOrderId]         INT             NULL,
    [HeliosOrderRecordId]   INT             NULL,
    [ItemID]                INT             NOT NULL,
    [GroupGoods]            NVARCHAR (3)    NOT NULL,
    [ItemCode]              NVARCHAR (50)   NOT NULL,
    [ItemDescription]       NVARCHAR (500)  NOT NULL,
    [ItemQuantity]          NUMERIC (18, 3) NOT NULL,
    [ItemQuantityDelivered] NUMERIC (18, 3) NULL,
    [MeasuresID]            INT             NOT NULL,
    [ItemUnitOfMeasure]     NVARCHAR (50)   NOT NULL,
    [ItemQualityId]         INT             CONSTRAINT [DF_CommunicationMessagesReceptionSentItems_ItemQualityId] DEFAULT ((1)) NOT NULL,
    [ItemQualityCode]       NVARCHAR (50)   CONSTRAINT [DF_CommunicationMessagesReceptionSentItems_ItemQualityCode] DEFAULT (N'New') NOT NULL,
    [SourceId]              INT             NULL,
    [IsActive]              BIT             CONSTRAINT [DF_CommunicationMessagesReceptionSentItems_IsActive] DEFAULT ((1)) NOT NULL,
    [ModifyDate]            DATETIME        CONSTRAINT [DF_CommunicationMessagesReceptionSentItems_ModifyDate] DEFAULT (getdate()) NOT NULL,
    [ModifyUserId]          INT             CONSTRAINT [DF_CommunicationMessagesReceptionSentItems_ModifyUserId] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_CommunicationMessagesReceptionSentItems] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 85)
);


GO

CREATE  TRIGGER trCommunicationMessagesReceptionSentItemsUpd
   ON  [dbo].[CommunicationMessagesReceptionSentItems] 
   AFTER UPDATE
AS 
BEGIN
-- =============================================
-- Author:		   Weczerek
-- Create date:   2014-10-01
-- Description:	
-- =============================================
SET NOCOUNT ON;
INSERT INTO [dbo].[A_CommunicationMessagesReceptionSentItems]
           ([ID]
           ,[CMSOId]
           ,[HeliosOrderId]
           ,[HeliosOrderRecordId]
           ,[ItemId]
           ,[GroupGoods]
           ,[ItemCode]
           ,[ItemDescription]
           ,[ItemQuantity]
           ,[ItemQuantityDelivered]
           ,[MeasuresID]
           ,[ItemUnitOfMeasure]
           ,[ItemQualityId]
           ,[ItemQualityCode]
           ,[SourceId]
           ,[IsActive]
           ,[ModifyDate]
           ,[ModifyUserId]
            )
     SELECT [ID]
           ,[CMSOId]
           ,[HeliosOrderId]
           ,[HeliosOrderRecordId]
           ,[ItemID]
           ,[GroupGoods]
           ,[ItemCode]
           ,[ItemDescription]
           ,[ItemQuantity]
           ,[ItemQuantityDelivered]
           ,[MeasuresID]
           ,[ItemUnitOfMeasure]
           ,[ItemQualityId]
           ,[ItemQualityCode]
           ,[SourceId]
           ,[IsActive]
           ,[ModifyDate]
           ,[ModifyUserId]
FROM DELETED


END

GO
GRANT SELECT
    ON OBJECT::[dbo].[CommunicationMessagesReceptionSentItems] TO [mis]
    AS [dbo];


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'vazební id na tabulku CommunicationMessagesReceptionSent', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CommunicationMessagesReceptionSentItems', @level2type = N'COLUMN', @level2name = N'CMSOId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'ID objednávky z Heliosu - hlavička - toto ID spojuje záznamy z tělíčka objednávky', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CommunicationMessagesReceptionSentItems', @level2type = N'COLUMN', @level2name = N'HeliosOrderId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'ID záznamu z tělíčka Objednávky - ', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CommunicationMessagesReceptionSentItems', @level2type = N'COLUMN', @level2name = N'HeliosOrderRecordId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'ID produktu, který objednáváme; vazba na číselník cdlItems', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CommunicationMessagesReceptionSentItems', @level2type = N'COLUMN', @level2name = N'ItemID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'kód Item - je přebírán z tabulky cdlItems (z Heliosu)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CommunicationMessagesReceptionSentItems', @level2type = N'COLUMN', @level2name = N'ItemCode';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'popis produktu', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CommunicationMessagesReceptionSentItems', @level2type = N'COLUMN', @level2name = N'ItemDescription';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'požadované množství zboží, materiálu, služeb ', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CommunicationMessagesReceptionSentItems', @level2type = N'COLUMN', @level2name = N'ItemQuantity';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'dodané množství - objednané množství může být dodáváno postupně', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CommunicationMessagesReceptionSentItems', @level2type = N'COLUMN', @level2name = N'ItemQuantityDelivered';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'vazba načíselník cdlMeasures', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CommunicationMessagesReceptionSentItems', @level2type = N'COLUMN', @level2name = N'MeasuresID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'měrná jednotka - popis , měl by být číselník a pak přidat ID sloupec', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CommunicationMessagesReceptionSentItems', @level2type = N'COLUMN', @level2name = N'ItemUnitOfMeasure';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Dá se předpokládat, že při automatické kontrole a vytvoření záznamu bude uživatel nějaký, třeba 0', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CommunicationMessagesReceptionSentItems', @level2type = N'COLUMN', @level2name = N'ModifyUserId';

