CREATE TABLE [dbo].[CommunicationMessagesReceptionConfirmationItems] (
    [ID]                INT             IDENTITY (1, 1) NOT NULL,
    [CMSOId]            INT             NOT NULL,
    [ItemID]            INT             NOT NULL,
    [ItemDescription]   NVARCHAR (500)  NOT NULL,
    [ItemQuantity]      NUMERIC (18, 3) NOT NULL,
    [ItemUnitOfMeasure] VARCHAR (50)    NOT NULL,
    [ItemQualityId]     INT             NOT NULL,
    [NDReceipt]         NVARCHAR (100)  NULL,
    [ItemSNs]           VARCHAR (MAX)   NULL,
    [IsActive]          BIT             CONSTRAINT [DF_CommunicationMessagesReceptionConfirmationItems_IsActive] DEFAULT ((1)) NOT NULL,
    [ModifyDate]        DATETIME        CONSTRAINT [DF_CommunicationMessagesReceptionConfirmationItems_ModifyDate] DEFAULT (getdate()) NOT NULL,
    [ModifyUserId]      INT             CONSTRAINT [DF_CommunicationMessagesReceptionConfirmationItems_ModifyUserId] DEFAULT ((0)) NOT NULL,
    [SNExportedFlag]    INT             CONSTRAINT [DF_CommunicationMessagesReceptionConfirmationItems_SNExported] DEFAULT ((0)) NOT NULL,
    [SNExportedDate]    DATETIME        NULL,
    CONSTRAINT [PK_CommunicationMessagesReceptionConfirmationItems] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 85),
    CONSTRAINT [FK_CommunicationMessagesReceptionConfirmationItems_cdlQualities] FOREIGN KEY ([ItemQualityId]) REFERENCES [dbo].[cdlQualities] ([ID])
);


GO



CREATE  TRIGGER [dbo].[trCommunicationMessagesReceptionConfirmationItemsUpd]
   ON  [dbo].[CommunicationMessagesReceptionConfirmationItems] 
   AFTER UPDATE
AS 
BEGIN
-- =============================================
-- Author:		   Weczerek
-- Create date:   2014-11-14, 2015-05-22
-- Description:	
-- =============================================
SET NOCOUNT ON;

INSERT INTO [dbo].[A_CommunicationMessagesReceptionConfirmationItems]
           ([ID]
           ,[CMSOId]
           ,[ItemID]
           ,[ItemDescription]
           ,[ItemQuantity]
           ,[ItemUnitOfMeasure]
           ,[ItemQualityId]
           ,[NDReceipt]
           ,[ItemSNs]
           ,[IsActive]
           ,[ModifyDate]
           ,[ModifyUserId]
           ,[SNExportedFlag]
           ,[SNExportedDate])     

     SELECT [ID]
           ,[CMSOId]
           ,[ItemID]
           ,[ItemDescription]
           ,[ItemQuantity]
           ,[ItemUnitOfMeasure]
           ,[ItemQualityId]
           ,[NDReceipt]
           ,[ItemSNs]
           ,[IsActive]
           ,[ModifyDate]
           ,[ModifyUserId]
           ,[SNExportedFlag]
           ,[SNExportedDate]     

FROM DELETED


END



GO
GRANT INSERT
    ON OBJECT::[dbo].[CommunicationMessagesReceptionConfirmationItems] TO [mis]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[CommunicationMessagesReceptionConfirmationItems] TO [mis]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[CommunicationMessagesReceptionConfirmationItems] TO [mis]
    AS [dbo];


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'ID produktu, který byl nakoupen a který by měl být stejný, jaký jsme objednali ke koupi; 2140616 - ne všechno zboží bude v Heliosu=>svůj číselník ve Fenixu', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CommunicationMessagesReceptionConfirmationItems', @level2type = N'COLUMN', @level2name = N'ItemID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'popis produktu', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CommunicationMessagesReceptionConfirmationItems', @level2type = N'COLUMN', @level2name = N'ItemDescription';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'skutečné množství zboží, materiálu, služeb, které by mělo být stejné, jako požadované ', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CommunicationMessagesReceptionConfirmationItems', @level2type = N'COLUMN', @level2name = N'ItemQuantity';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'měrná jednotka - měl by být číselník a pak přidat ID sloupec', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CommunicationMessagesReceptionConfirmationItems', @level2type = N'COLUMN', @level2name = N'ItemUnitOfMeasure';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'musí být číselník: new nový, Returned vrácený, Refurbished,...', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CommunicationMessagesReceptionConfirmationItems', @level2type = N'COLUMN', @level2name = N'ItemQualityId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Serial Number1 - seriálové číslo zařízení', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CommunicationMessagesReceptionConfirmationItems', @level2type = N'COLUMN', @level2name = N'ItemSNs';

