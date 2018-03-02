CREATE TABLE [dbo].[CommunicationMessagesReturnedItemItems] (
    [ID]                  INT             IDENTITY (1, 1) NOT NULL,
    [CMSOId]              INT             NOT NULL,
    [ItemId]              INT             NOT NULL,
    [ItemDescription]     NVARCHAR (50)   NOT NULL,
    [ItemQuantity]        NUMERIC (18, 3) NULL,
    [ItemOrKitQualityId]  INT             NOT NULL,
    [ItemOrKitQuality]    NVARCHAR (50)   NOT NULL,
    [ItemUnitOfMeasureId] INT             NOT NULL,
    [ItemUnitOfMeasure]   NVARCHAR (50)   NOT NULL,
    [SN]                  NVARCHAR (MAX)  NULL,
    [NDReceipt]           NVARCHAR (100)  NULL,
    [ReturnedFrom]        NVARCHAR (MAX)  NOT NULL,
    [IsActive]            BIT             CONSTRAINT [DF_CommunicationMessagesReturnedItemItems_IsActive] DEFAULT ((1)) NOT NULL,
    [ModifyDate]          DATETIME        CONSTRAINT [DF_CommunicationMessagesReturnedItemItems_ModifyDate] DEFAULT (getdate()) NOT NULL,
    [ModifyUserId]        INT             CONSTRAINT [DF_CommunicationMessagesReturnedItemItems_ModifyUserId] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_CommunicationMessagesReturnedItemItems] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 85)
);


GO




CREATE  TRIGGER [dbo].[trCommunicationMessagesReturnedItemItemsUpd]
   ON  [dbo].[CommunicationMessagesReturnedItemItems] 
   AFTER UPDATE
AS 
BEGIN
-- =============================================
-- Author:		   Weczerek
-- Create date:   2014-11-14
-- Description:	
-- =============================================
SET NOCOUNT ON;

INSERT INTO [dbo].[A_CommunicationMessagesReturnedItemItems]
           ([ID]
           ,[CMSOId]
           ,[ItemId]
           ,[ItemDescription]
           ,[ItemQuantity]
           ,[ItemOrKitQualityId]
           ,[ItemOrKitQuality]
           ,[ItemUnitOfMeasureId]
           ,[ItemUnitOfMeasure]
           ,[SN]
           ,[NDReceipt]
           ,[ReturnedFrom]
           ,[IsActive]
           ,[ModifyDate]
           ,[ModifyUserId]
)     

     SELECT [ID]
           ,[CMSOId]
           ,[ItemId]
           ,[ItemDescription]
           ,[ItemQuantity]
           ,[ItemOrKitQualityId]
           ,[ItemOrKitQuality]
           ,[ItemUnitOfMeasureId]
           ,[ItemUnitOfMeasure]
           ,[SN]
           ,[NDReceipt]
           ,[ReturnedFrom]
           ,[IsActive]
           ,[ModifyDate]
           ,[ModifyUserId]
FROM DELETED


END



GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'musí být číselník: new nový, Returned vrácený, Refurbished,...', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CommunicationMessagesReturnedItemItems', @level2type = N'COLUMN', @level2name = N'ItemOrKitQualityId';

