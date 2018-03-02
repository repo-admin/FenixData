CREATE TABLE [dbo].[CommunicationMessagesShipmentOrdersConfirmationItems] (
    [ID]                       INT             IDENTITY (1, 1) NOT NULL,
    [CMSOId]                   INT             NOT NULL,
    [SingleOrMaster]           INT             NOT NULL,
    [HeliosOrderRecordID]      INT             NULL,
    [ItemVerKit]               INT             CONSTRAINT [DF_CommunicationMessagesShipmentOrdersConfirmationItems_ItemVerKit] DEFAULT ((0)) NOT NULL,
    [ItemOrKitID]              INT             NOT NULL,
    [ItemOrKitDescription]     NVARCHAR (100)  NOT NULL,
    [ItemOrKitQuantity]        NUMERIC (18, 3) NOT NULL,
    [ItemOrKitUnitOfMeasureId] INT             NOT NULL,
    [ItemOrKitUnitOfMeasure]   NVARCHAR (50)   NOT NULL,
    [ItemOrKitQualityId]       INT             NOT NULL,
    [ItemOrKitQualityCode]     NVARCHAR (50)   NOT NULL,
    [IncotermsId]              INT             NULL,
    [IncotermDescription]      NVARCHAR (50)   NOT NULL,
    [RealDateOfDelivery]       DATETIME        NULL,
    [RealItemOrKitQuantity]    NUMERIC (18, 3) NULL,
    [RealItemOrKitQualityID]   INT             NULL,
    [RealItemOrKitQuality]     NVARCHAR (50)   NOT NULL,
    [Status]                   INT             NULL,
    [KitSNs]                   VARCHAR (MAX)   NULL,
    [IsActive]                 BIT             CONSTRAINT [DF_CommunicationMessagesShipmentOrdersConfirmationItems_IsActive] DEFAULT ((1)) NOT NULL,
    [ModifyDate]               DATETIME        CONSTRAINT [DF_CommunicationMessagesShipmentOrdersConfirmationItems_ModifyDate] DEFAULT (getdate()) NOT NULL,
    [ModifyUserId]             INT             CONSTRAINT [DF_CommunicationMessagesShipmentOrdersConfirmationItems_ModifyUserId] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_CommunicationMessagesShipmentOrdersConfirmationItems] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 85)
);


GO


CREATE  TRIGGER [dbo].[trCommunicationMessagesShipmentOrdersConfirmationItemsUpd]
   ON  [dbo].[CommunicationMessagesShipmentOrdersConfirmationItems] 
   AFTER UPDATE
AS 
BEGIN
-- =============================================
-- Author:		   Weczerek
-- Create date:   2014-11-14
-- Description:	
-- =============================================
SET NOCOUNT ON;

INSERT INTO [dbo].[A_CommunicationMessagesShipmentOrdersConfirmationItems]
           ([ID]
           ,[CMSOId]
           ,[SingleOrMaster]
           ,[HeliosOrderRecordID]
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
           ,[RealDateOfDelivery]
           ,[RealItemOrKitQuantity]
           ,[RealItemOrKitQualityID]
           ,[RealItemOrKitQuality]
           ,[Status]
           ,[KitSNs]
           ,[IsActive]
           ,[ModifyDate]
           ,[ModifyUserId]
)
     SELECT [ID]
           ,[CMSOId]
           ,[SingleOrMaster]
           ,[HeliosOrderRecordID]
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
           ,[RealDateOfDelivery]
           ,[RealItemOrKitQuantity]
           ,[RealItemOrKitQualityID]
           ,[RealItemOrKitQuality]
           ,[Status]
           ,[KitSNs]
           ,[IsActive]
           ,[ModifyDate]
           ,[ModifyUserId]
FROM DELETED


END


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Požadujeme xpedovat ---  0... Item,    1 ...Kit', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CommunicationMessagesShipmentOrdersConfirmationItems', @level2type = N'COLUMN', @level2name = N'ItemVerKit';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Id z tabulky cdlItems nebo cdlKits', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CommunicationMessagesShipmentOrdersConfirmationItems', @level2type = N'COLUMN', @level2name = N'ItemOrKitID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'bylo požadováno', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CommunicationMessagesShipmentOrdersConfirmationItems', @level2type = N'COLUMN', @level2name = N'ItemOrKitQuantity';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'bylo skutečně odvezeno', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CommunicationMessagesShipmentOrdersConfirmationItems', @level2type = N'COLUMN', @level2name = N'RealItemOrKitQuantity';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'0 ... nebylo vyvezeno, 1 ... bylo odvezeno (cancel)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CommunicationMessagesShipmentOrdersConfirmationItems', @level2type = N'COLUMN', @level2name = N'Status';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Dá se předpokládat, že při automatické kontrole a vytvoření záznamu bude uživatel nějaký, třeba 0', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CommunicationMessagesShipmentOrdersConfirmationItems', @level2type = N'COLUMN', @level2name = N'ModifyUserId';

