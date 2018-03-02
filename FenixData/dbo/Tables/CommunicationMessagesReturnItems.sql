CREATE TABLE [dbo].[CommunicationMessagesReturnItems] (
    [ID]                 INT            IDENTITY (1, 1) NOT NULL,
    [CMSOId]             INT            NOT NULL,
    [ItemOrKitQualityId] INT            NOT NULL,
    [ItemOrKitQuality]   VARCHAR (50)   NOT NULL,
    [SN1]                VARCHAR (50)   NULL,
    [SN2]                VARCHAR (50)   NULL,
    [NDReceipt]          NVARCHAR (100) NULL,
    [ReturnedFrom]       NVARCHAR (MAX) NOT NULL,
    [IsActive]           BIT            CONSTRAINT [DF_CommunicationMessagesReturnItems_IsActive] DEFAULT ((1)) NOT NULL,
    [ModifyDate]         DATETIME       CONSTRAINT [DF_CommunicationMessagesReturnItems_ModifyDate] DEFAULT (getdate()) NOT NULL,
    [ModifyUserId]       INT            CONSTRAINT [DF_CommunicationMessagesReturnItems_ModifyUserId] DEFAULT ((0)) NOT NULL,
    [ItemID]             INT            NULL,
    [ItemDescription]    NVARCHAR (100) NULL,
    CONSTRAINT [PK_CommunicationMessagesReturnItems] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 85)
);


GO

CREATE  TRIGGER [dbo].[trCommunicationMessagesReturnItemsUpd]
   ON  [dbo].[CommunicationMessagesReturnItems] 
   AFTER UPDATE
AS 
BEGIN
-- ==============================================================================
-- Author:		    M. Weczerek
-- Create date: 2014-11-14
-- Description:	
-- Edit       : M. Rezler  2015-06-05 .. přidány sloupce 	ItemID, ItemDescription
-- ==============================================================================
SET NOCOUNT ON;


INSERT INTO [dbo].[A_CommunicationMessagesReturnItems]
           ([ID]
           ,[CMSOId]
           ,[ItemOrKitQualityId]
           ,[ItemOrKitQuality]
           ,[SN1]
           ,[SN2]
           ,[NDReceipt]
           ,[ReturnedFrom]
           ,[IsActive]
           ,[ModifyDate]
           ,[ModifyUserId]
					 ,[ItemID]
					 ,[ItemDescription]

)     

     SELECT [ID]
           ,[CMSOId]
           ,[ItemOrKitQualityId]
           ,[ItemOrKitQuality]
           ,[SN1]
           ,[SN2]
           ,[NDReceipt]
           ,[ReturnedFrom]
           ,[IsActive]
           ,[ModifyDate]
           ,[ModifyUserId]
					 ,[ItemID]
					 ,[ItemDescription]
FROM DELETED


END

GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'musí být číselník: new nový, Returned vrácený, Refurbished,...', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CommunicationMessagesReturnItems', @level2type = N'COLUMN', @level2name = N'ItemOrKitQualityId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'číslo dokladu, kterým zařízení přijali', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CommunicationMessagesReturnItems', @level2type = N'COLUMN', @level2name = N'NDReceipt';

