CREATE TABLE [dbo].[CommunicationMessagesKittingsConfirmationItems] (
    [ID]               INT             IDENTITY (1, 1) NOT NULL,
    [CMSOId]           INT             NOT NULL,
    [KitID]            INT             NOT NULL,
    [KitDescription]   NVARCHAR (500)  NOT NULL,
    [KitQuantity]      NUMERIC (18, 3) NOT NULL,
    [KitUnitOfMeasure] VARCHAR (50)    NOT NULL,
    [KitQualityId]     INT             NOT NULL,
    [KitSNs]           VARCHAR (MAX)   NULL,
    [IsActive]         BIT             CONSTRAINT [DF_CommunicationMessagesKittingsConfirmationItems_IsActive] DEFAULT ((1)) NOT NULL,
    [ModifyDate]       DATETIME        CONSTRAINT [DF_CommunicationMessagesKittingsConfirmationItems_ModifyDate] DEFAULT (getdate()) NOT NULL,
    [ModifyUserId]     INT             CONSTRAINT [DF_CommunicationMessagesKittingsConfirmationItems_ModifyUserId] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_CommunicationMessagesKittingsConfirmationItems] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 85),
    CONSTRAINT [FK_CommunicationMessagesKittingsConfirmationItems_cdlQualities] FOREIGN KEY ([KitQualityId]) REFERENCES [dbo].[cdlQualities] ([ID])
);




GO




CREATE TRIGGER [dbo].[trCommunicationMessagesKittingsConfirmationItemsUpd]
   ON  [dbo].[CommunicationMessagesKittingsConfirmationItems]
   AFTER UPDATE
AS 
BEGIN
-- =============================================
-- Author:		   Weczerek
-- Create date:   2016-06-10
-- Description:	
-- =============================================
	SET NOCOUNT ON;

INSERT INTO [dbo].[A_CommunicationMessagesKittingsConfirmationItems]
           ([ID]
           ,[CMSOId]
           ,[KitID]
           ,[KitDescription]
           ,[KitQuantity]
           ,[KitUnitOfMeasure]
           ,[KitQualityId]
           ,[KitSNs]
           ,[IsActive]
           ,[ModifyDate]
           ,[ModifyUserId]
)
SELECT      [ID]
           ,[CMSOId]
           ,[KitID]
           ,[KitDescription]
           ,[KitQuantity]
           ,[KitUnitOfMeasure]
           ,[KitQualityId]
           ,[KitSNs]
           ,[IsActive]
           ,[ModifyDate]
           ,[ModifyUserId]

FROM deleted

END




GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'ID produktu, který byl nakoupen a který by měl být stejný, jaký jsme objednali ke koupi; 2140616 - ne všechno zboží bude v Heliosu=>svůj číselník ve Fenixu', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CommunicationMessagesKittingsConfirmationItems', @level2type = N'COLUMN', @level2name = N'KitID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'popis produktu', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CommunicationMessagesKittingsConfirmationItems', @level2type = N'COLUMN', @level2name = N'KitDescription';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'skutečné množství zboží, materiálu, služeb, které by mělo být stejné, jako požadované ', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CommunicationMessagesKittingsConfirmationItems', @level2type = N'COLUMN', @level2name = N'KitQuantity';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'měrná jednotka - měl by být číselník a pak přidat ID sloupec', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CommunicationMessagesKittingsConfirmationItems', @level2type = N'COLUMN', @level2name = N'KitUnitOfMeasure';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'musí být číselník: new nový, Returned vrácený, Refurbished,...', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CommunicationMessagesKittingsConfirmationItems', @level2type = N'COLUMN', @level2name = N'KitQualityId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Serial Number1 - seriálové číslo zařízení', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CommunicationMessagesKittingsConfirmationItems', @level2type = N'COLUMN', @level2name = N'KitSNs';


GO
GRANT UPDATE
    ON OBJECT::[dbo].[CommunicationMessagesKittingsConfirmationItems] TO [FenixR]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[CommunicationMessagesKittingsConfirmationItems] TO [FenixR]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[CommunicationMessagesKittingsConfirmationItems] TO [FenixR]
    AS [dbo];


GO
GRANT DELETE
    ON OBJECT::[dbo].[CommunicationMessagesKittingsConfirmationItems] TO [FenixR]
    AS [dbo];

