CREATE TABLE [dbo].[CommunicationMessagesReceptionSent] (
    [ID]                      INT            IDENTITY (1, 1) NOT NULL,
    [MessageId]               INT            NOT NULL,
    [MessageType]             INT            NOT NULL,
    [MessageDescription]      NVARCHAR (200) NOT NULL,
    [MessageDateOfShipment]   DATETIME       NULL,
    [MessageStatusId]         INT            NOT NULL,
    [HeliosOrderId]           INT            NOT NULL,
    [ItemSupplierId]          INT            NOT NULL,
    [ItemSupplierDescription] NVARCHAR (500) NOT NULL,
    [ItemDateOfDelivery]      DATETIME       NOT NULL,
    [IsManually]              BIT            CONSTRAINT [DF_CommunicationMessagesReceptionSent_IsManually] DEFAULT ((0)) NOT NULL,
    [StockId]                 INT            NULL,
    [Notice]                  NVARCHAR (MAX) NULL,
    [RadaDokladu]             CHAR (3)       NULL,
    [PoradoveCislo]           INT            NULL,
    [RadaPlusPorCislo]        NVARCHAR (50)  NULL,
    [IsActive]                BIT            CONSTRAINT [DF_CommunicationMessagesReceptionSent_IsActive] DEFAULT ((1)) NOT NULL,
    [ModifyDate]              DATETIME       CONSTRAINT [DF_CommunicationMessagesReceptionSent_ModifyDate] DEFAULT (getdate()) NOT NULL,
    [ModifyUserId]            INT            CONSTRAINT [DF_CommunicationMessagesReceptionSent_ModifyUserId] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_CommunicationMessagesReceptionSent] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 85)
);


GO




CREATE TRIGGER [dbo].[trCommunicationMessagesReceptionSentUpd]
   ON  [dbo].[CommunicationMessagesReceptionSent]
   AFTER UPDATE
AS 
BEGIN
-- =============================================
-- Author:		   Weczerek
-- Create date:   2015-02-11
-- Description:	
-- =============================================
	SET NOCOUNT ON;

INSERT INTO [dbo].[A_CommunicationMessagesReceptionSent]
           ([ID]
           ,[MessageId]
           ,[MessageType]
           ,[MessageDescription]
           ,[MessageDateOfShipment]
           ,[MessageStatusId]
           ,[HeliosOrderId]
           ,[ItemSupplierId]
           ,[ItemSupplierDescription]
           ,[ItemDateOfDelivery]
           ,[IsManually]
           ,[StockId]
           ,[Notice]
           ,[RadaDokladu]
           ,[PoradoveCislo]
           ,[RadaPlusPorCislo]
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
           ,[ItemSupplierId]
           ,[ItemSupplierDescription]
           ,[ItemDateOfDelivery]
           ,[IsManually]
           ,[StockId]
           ,[Notice]
           ,[RadaDokladu]
           ,[PoradoveCislo]
           ,[RadaPlusPorCislo]
           ,[IsActive]
           ,[ModifyDate]
           ,[ModifyUserId]
FROM deleted

END



GO
GRANT SELECT
    ON OBJECT::[dbo].[CommunicationMessagesReceptionSent] TO [mis]
    AS [dbo];


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'pořadové číslo message; ', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CommunicationMessagesReceptionSent', @level2type = N'COLUMN', @level2name = N'MessageId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'typ message - musí být číselník', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CommunicationMessagesReceptionSent', @level2type = N'COLUMN', @level2name = N'MessageType';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Datum, kdy byla položka odeslána ND', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CommunicationMessagesReceptionSent', @level2type = N'COLUMN', @level2name = N'MessageDateOfShipment';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'1... záznam nebyl odeslán na ND, 2 ... záznam byl odeslán na ND,potvrzeno přijetí a aktualizováno ve Fenixu', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CommunicationMessagesReceptionSent', @level2type = N'COLUMN', @level2name = N'MessageStatusId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'ID objednávky z Heliosu - hlavička - toto ID spojuje záznamy z tělíčka objednávky', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CommunicationMessagesReceptionSent', @level2type = N'COLUMN', @level2name = N'HeliosOrderId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'ID dodavatele ze záznamu tělíčka objednávky - číselník dodavatelů', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CommunicationMessagesReceptionSent', @level2type = N'COLUMN', @level2name = N'ItemSupplierId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'název dodavatele ze záznamu tělíčka objednávky - číselník dodavatelů', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CommunicationMessagesReceptionSent', @level2type = N'COLUMN', @level2name = N'ItemSupplierDescription';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'datum očekáváného dodání', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CommunicationMessagesReceptionSent', @level2type = N'COLUMN', @level2name = N'ItemDateOfDelivery';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'0...objednávka z Heliosu, 1...objednávka zhotovena ve Fenixu ručně', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CommunicationMessagesReceptionSent', @level2type = N'COLUMN', @level2name = N'IsManually';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Poznámka k Reception- zobrazuje se Logistice;sem se budou zapisovat poznámky typu: Confirmace -  nesouhlasí počet objednaných a dodaných položek', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CommunicationMessagesReceptionSent', @level2type = N'COLUMN', @level2name = N'Notice';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Dá se předpokládat, že při automatické kontrole a vytvoření záznamu bude uživatel nějaký, třeba 0', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CommunicationMessagesReceptionSent', @level2type = N'COLUMN', @level2name = N'ModifyUserId';

