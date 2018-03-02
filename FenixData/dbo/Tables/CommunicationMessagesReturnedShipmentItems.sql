CREATE TABLE [dbo].[CommunicationMessagesReturnedShipmentItems] (
    [ID]                   INT           IDENTITY (1, 1) NOT NULL,
    [CMSOId]               INT           NOT NULL,
    [ItemOrKitQualityId]   INT           NOT NULL,
    [ItemOrKitQualityCode] NVARCHAR (50) NOT NULL,
    [IncotermsId]          INT           NULL,
    [IncotermDescription]  NVARCHAR (50) NULL,
    [KitSNs]               VARCHAR (MAX) NULL,
    [IsActive]             BIT           CONSTRAINT [DF_CommunicationMessagesReturnedShipmentItems_IsActive] DEFAULT ((1)) NOT NULL,
    [ModifyDate]           DATETIME      CONSTRAINT [DF_CommunicationMessagesReturnedShipmentItems_ModifyDate] DEFAULT (getdate()) NOT NULL,
    [ModifyUserId]         INT           CONSTRAINT [DF_CommunicationMessagesReturnedShipmentItems_ModifyUserId] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_CommunicationMessagesReturnedShipmentItems] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 85)
);


GO


CREATE  TRIGGER [dbo].[trCommunicationMessagesReturnedShipmentItemsUpd]
   ON  [dbo].[CommunicationMessagesReturnedShipmentItems] 
   AFTER UPDATE
AS 
BEGIN
-- =============================================
-- Author:		   Weczerek
-- Create date:   2014-11-14
-- Description:	
-- =============================================
SET NOCOUNT ON;


INSERT INTO [dbo].[A_CommunicationMessagesReturnedShipmentItems]
           ([ID]
           ,[CMSOId]
           ,[ItemOrKitQualityId]
           ,[ItemOrKitQualityCode]
           ,[IncotermsId]
           ,[IncotermDescription]
           ,[KitSNs]
           ,[IsActive]
           ,[ModifyDate]
           ,[ModifyUserId]
)     

     SELECT [ID]
           ,[CMSOId]
           ,[ItemOrKitQualityId]
           ,[ItemOrKitQualityCode]
           ,[IncotermsId]
           ,[IncotermDescription]
           ,[KitSNs]
           ,[IsActive]
           ,[ModifyDate]
           ,[ModifyUserId]
FROM DELETED


END



GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Dá se předpokládat, že při automatické kontrole a vytvoření záznamu bude uživatel nějaký, třeba 0', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CommunicationMessagesReturnedShipmentItems', @level2type = N'COLUMN', @level2name = N'ModifyUserId';

