CREATE TABLE [dbo].[CommunicationMessagesKittingsSent] (
    [ID]                    INT            IDENTITY (1, 1) NOT NULL,
    [MessageId]             INT            NOT NULL,
    [MessageType]           INT            NOT NULL,
    [MessageDescription]    NVARCHAR (200) NOT NULL,
    [MessageDateOfShipment] DATETIME       NULL,
    [MessageStatusId]       INT            NOT NULL,
    [HeliosOrderId]         INT            NOT NULL,
    [KitDateOfDelivery]     DATETIME       NOT NULL,
    [IsManually]            BIT            NULL,
    [Notice]                NVARCHAR (MAX) NULL,
    [StockId]               INT            NOT NULL,
    [IsActive]              BIT            CONSTRAINT [DF_CommunicationMessagesKittingsSent_IsActive] DEFAULT ((1)) NOT NULL,
    [ModifyDate]            DATETIME       CONSTRAINT [DF_CommunicationMessagesKittingsSent_ModifyDate] DEFAULT (getdate()) NOT NULL,
    [ModifyUserId]          INT            CONSTRAINT [DF_CommunicationMessagesKittingsSent_ModifyUserId] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_CommunicationMessagesKittingsSent] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 85)
);


GO



CREATE TRIGGER [dbo].[trCommunicationMessagesKittingsSentUpd]
   ON  [dbo].[CommunicationMessagesKittingsSent]
   AFTER UPDATE
AS 
BEGIN
-- =============================================
-- Author:		   Weczerek
-- Create date:   2015-02-11
-- Description:	
-- =============================================
	SET NOCOUNT ON;

INSERT INTO [dbo].[A_CommunicationMessagesKittingsSent]
           ([ID]
           ,[MessageId]
           ,[MessageType]
           ,[MessageDescription]
           ,[MessageDateOfShipment]
           ,[MessageStatusId]
           ,[HeliosOrderId]
           ,[KitDateOfDelivery]
           ,[IsManually]
           ,[Notice]
           ,[StockId]
           ,[IsActive]
           ,[ModifyDate]
           ,[ModifyUserId]
)
SELECT      [ID]
           ,[MessageId]
           ,[MessageType]
           ,[MessageDescription]
           ,[MessageDateOfShipment]
           ,[MessageStatusId]
           ,[HeliosOrderId]
           ,[KitDateOfDelivery]
           ,[IsManually]
           ,[Notice]
           ,[StockId]
           ,[IsActive]
           ,[ModifyDate]
           ,[ModifyUserId]
FROM deleted

END



GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'pořadové číslo message; ', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CommunicationMessagesKittingsSent', @level2type = N'COLUMN', @level2name = N'MessageId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'typ message - musí být číselník', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CommunicationMessagesKittingsSent', @level2type = N'COLUMN', @level2name = N'MessageType';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Datum, kdy byla položka odeslána ND', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CommunicationMessagesKittingsSent', @level2type = N'COLUMN', @level2name = N'MessageDateOfShipment';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'0... záznam nebyl odeslán na ND, 1 ... záznam byl odeslán na ND, 2...    -- číselník', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CommunicationMessagesKittingsSent', @level2type = N'COLUMN', @level2name = N'MessageStatusId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'defaultně 2 - ND', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CommunicationMessagesKittingsSent', @level2type = N'COLUMN', @level2name = N'StockId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Dá se předpokládat, že při automatické kontrole a vytvoření záznamu bude uživatel nějaký, třeba 0', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CommunicationMessagesKittingsSent', @level2type = N'COLUMN', @level2name = N'ModifyUserId';

