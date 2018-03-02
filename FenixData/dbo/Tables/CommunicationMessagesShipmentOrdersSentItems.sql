CREATE TABLE [dbo].[CommunicationMessagesShipmentOrdersSentItems] (
    [ID]                       INT             IDENTITY (1, 1) NOT NULL,
    [CMSOId]                   INT             NOT NULL,
    [SingleOrMaster]           INT             NOT NULL,
    [ItemVerKit]               INT             CONSTRAINT [DF_CommunicationMessagesShipmentOrdersSentItems_ItemVerKit] DEFAULT ((0)) NOT NULL,
    [ItemOrKitID]              INT             NOT NULL,
    [ItemOrKitDescription]     NVARCHAR (100)  NOT NULL,
    [ItemOrKitQuantity]        NUMERIC (18, 3) NOT NULL,
    [ItemOrKitQuantityReal]    NUMERIC (18, 3) NULL,
    [ItemOrKitUnitOfMeasureId] INT             NOT NULL,
    [ItemOrKitUnitOfMeasure]   NVARCHAR (50)   NOT NULL,
    [ItemOrKitQualityId]       INT             NOT NULL,
    [ItemOrKitQualityCode]     NVARCHAR (50)   NOT NULL,
    [ItemType]                 NVARCHAR (50)   NOT NULL,
    [IncotermsId]              INT             NOT NULL,
    [Incoterms]                NVARCHAR (50)   NOT NULL,
    [PackageValue]             INT             NULL,
    [ShipmentOrderSource]      INT             CONSTRAINT [DF_CommunicationMessagesShipmentOrdersSentItems_SchipmentOrderSource] DEFAULT ((0)) NOT NULL,
    [VydejkyId]                INT             NULL,
    [CardStockItemsId]         INT             NULL,
    [HeliosOrderRecordId]      INT             CONSTRAINT [DF_CommunicationMessagesShipmentOrdersSentItems_HeliosOrderRecordId] DEFAULT ((0)) NOT NULL,
    [IsActive]                 BIT             CONSTRAINT [DF_CommunicationMessagesShipmentOrdersSentItems_IsActive] DEFAULT ((1)) NOT NULL,
    [ModifyDate]               DATETIME        CONSTRAINT [DF_CommunicationMessagesShipmentOrdersSentItems_ModifyDate] DEFAULT (getdate()) NOT NULL,
    [ModifyUserId]             INT             CONSTRAINT [DF_CommunicationMessagesShipmentOrdersSentItems_ModifyUserId] DEFAULT ((0)) NOT NULL,
    [IdRowReleaseNote]         INT             NULL,
    CONSTRAINT [PK_CommunicationMessagesShipmentOrdersSentItems] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 85)
);


GO
CREATE NONCLUSTERED INDEX [NonClusteredIndex-IsActive]
    ON [dbo].[CommunicationMessagesShipmentOrdersSentItems]([IsActive] ASC, [ID] ASC) WITH (FILLFACTOR = 85);


GO

CREATE TRIGGER trCommunicationMessagesShipmentOrdersSentItemsUpd
   ON  [dbo].[CommunicationMessagesShipmentOrdersSentItems]
   AFTER UPDATE
AS 
BEGIN
-- =============================================
-- Author:		   Weczerek
-- Create date:   2014-10-03
-- Description:	
-- =============================================
	SET NOCOUNT ON;

    INSERT INTO [dbo].[A_CommunicationMessagesShipmentOrdersSentItems]
           ([ID]
           ,[CMSOId]
           ,[SingleOrMaster]
           ,[ItemVerKit]
           ,[ItemOrKitID]
           ,[ItemOrKitDescription]
           ,[ItemOrKitQuantity]
           ,[ItemOrKitQuantityReal]
           ,[ItemOrKitUnitOfMeasureId]
           ,[ItemOrKitUnitOfMeasure]
           ,[ItemOrKitQualityId]
           ,[ItemOrKitQualityCode]
           ,[ItemType]
           ,[IncotermsId]
           ,[Incoterms]
           ,[PackageValue]
           ,[ShipmentOrderSource]
           ,[VydejkyId]
           ,[CardStockItemsId]
           ,[HeliosOrderRecordId]
           ,[IsActive]
           ,[ModifyDate]
           ,[ModifyUserId]
           ,[IdRowReleaseNote]
           )
           SELECT [ID]
           ,[CMSOId]
           ,[SingleOrMaster]
           ,[ItemVerKit]
           ,[ItemOrKitID]
           ,[ItemOrKitDescription]
           ,[ItemOrKitQuantity]
           ,[ItemOrKitQuantityReal]
           ,[ItemOrKitUnitOfMeasureId]
           ,[ItemOrKitUnitOfMeasure]
           ,[ItemOrKitQualityId]
           ,[ItemOrKitQualityCode]
           ,[ItemType]
           ,[IncotermsId]
           ,[Incoterms]
           ,[PackageValue]
           ,[ShipmentOrderSource]
           ,[VydejkyId]
           ,[CardStockItemsId]
           ,[HeliosOrderRecordId]
           ,[IsActive]
           ,[ModifyDate]
           ,[ModifyUserId]
           ,[IdRowReleaseNote]
FROM deleted

END

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Požadujeme xpedovat ---  0... Item,    1 ...Kit', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CommunicationMessagesShipmentOrdersSentItems', @level2type = N'COLUMN', @level2name = N'ItemVerKit';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Id z tabulky cdlItems nebo cdlKits', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CommunicationMessagesShipmentOrdersSentItems', @level2type = N'COLUMN', @level2name = N'ItemOrKitID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'NW /CPE / SPP / MKT;  v případě Kitu je  CPE', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CommunicationMessagesShipmentOrdersSentItems', @level2type = N'COLUMN', @level2name = N'ItemType';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'DAP / EXW    Nevíme nic bližšího', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CommunicationMessagesShipmentOrdersSentItems', @level2type = N'COLUMN', @level2name = N'Incoterms';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'pocet v jednom balení - slouží jen pro vytvoření počtu záznamů (řádků) a určení master nebo single', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CommunicationMessagesShipmentOrdersSentItems', @level2type = N'COLUMN', @level2name = N'PackageValue';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'0...Fenix, 1... výdejky od Jardy T.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CommunicationMessagesShipmentOrdersSentItems', @level2type = N'COLUMN', @level2name = N'ShipmentOrderSource';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'číslo výdejky od Jardy Tajbla', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CommunicationMessagesShipmentOrdersSentItems', @level2type = N'COLUMN', @level2name = N'VydejkyId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Dá se předpokládat, že při automatické kontrole a vytvoření záznamu bude uživatel nějaký, třeba 0', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CommunicationMessagesShipmentOrdersSentItems', @level2type = N'COLUMN', @level2name = N'ModifyUserId';

