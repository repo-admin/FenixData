CREATE TABLE [dbo].[CommunicationMessagesKittingsApprovalKitsSent] (
    [ID]                 INT             IDENTITY (1, 1) NOT NULL,
    [ApprovalID]         INT             NOT NULL,
    [KitID]              INT             NOT NULL,
    [KitDescription]     NVARCHAR (500)  NOT NULL,
    [KitQuantity]        NUMERIC (18, 3) NOT NULL,
    [KitUnitOfMeasureID] INT             NOT NULL,
    [KitUnitOfMeasure]   VARCHAR (50)    NOT NULL,
    [KitQualityId]       INT             NOT NULL,
    [KitQuality]         NVARCHAR (150)  NOT NULL,
    [IsActive]           BIT             CONSTRAINT [DF_CommunicationMessagesKittingsApprovalKitsSent_IsActive] DEFAULT ((1)) NOT NULL,
    [ModifyDate]         DATETIME        CONSTRAINT [DF_CommunicationMessagesKittingsApprovalKitsSent_ModifyDate] DEFAULT (getdate()) NOT NULL,
    [ModifyUserId]       INT             CONSTRAINT [DF_CommunicationMessagesKittingsApprovalKitsSent_ModifyUserId] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_[CommunicationMessagesKittingsApprovalKitsSent] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 85)
);


GO


CREATE  TRIGGER [dbo].[trCommunicationMessagesKittingsApprovalKitsSentUpd]
   ON  [dbo].[CommunicationMessagesKittingsApprovalKitsSent] 
   AFTER UPDATE
AS 
BEGIN
-- =============================================
-- Author:		   Weczerek
-- Create date:   2014-11-14
-- Description:	
-- =============================================
SET NOCOUNT ON;

INSERT INTO [dbo].[A_CommunicationMessagesKittingsApprovalKitsSent]
           ([ID]
           ,[ApprovalID]
           ,[KitID]
           ,[KitDescription]
           ,[KitQuantity]
           ,[KitUnitOfMeasureID]
           ,[KitUnitOfMeasure]
           ,[KitQualityId]
           ,[KitQuality]
           ,[IsActive]
           ,[ModifyDate]
           ,[ModifyUserId]
)     

     SELECT [ID]
           ,[ApprovalID]
           ,[KitID]
           ,[KitDescription]
           ,[KitQuantity]
           ,[KitUnitOfMeasureID]
           ,[KitUnitOfMeasure]
           ,[KitQualityId]
           ,[KitQuality]
           ,[IsActive]
           ,[ModifyDate]
           ,[ModifyUserId]
FROM DELETED


END



GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'ID z číselníku cdlKitings   ?', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CommunicationMessagesKittingsApprovalKitsSent', @level2type = N'COLUMN', @level2name = N'KitID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'popis z číselníku cdlKitings', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CommunicationMessagesKittingsApprovalKitsSent', @level2type = N'COLUMN', @level2name = N'KitDescription';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'množství uvolněné k expedici - není to vždy 1?', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CommunicationMessagesKittingsApprovalKitsSent', @level2type = N'COLUMN', @level2name = N'KitQuantity';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'měrná jednotka - měl by být číselník a pak přidat ID sloupec; není vždy ks?', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CommunicationMessagesKittingsApprovalKitsSent', @level2type = N'COLUMN', @level2name = N'KitUnitOfMeasure';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'musí být číselník: new nový, Returned vrácený, Refurbished,...', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CommunicationMessagesKittingsApprovalKitsSent', @level2type = N'COLUMN', @level2name = N'KitQuality';

