CREATE TABLE [dbo].[CommunicationMessagesShipmentOrdersSent] (
    [ID]                     INT             IDENTITY (1, 1) NOT NULL,
    [MessageId]              INT             NOT NULL,
    [MessageTypeId]          INT             NOT NULL,
    [MessageDescription]     NVARCHAR (200)  NOT NULL,
    [MessageDateOfShipment]  DATETIME        NULL,
    [RequiredDateOfShipment] DATETIME        NOT NULL,
    [MessageStatusId]        INT             NOT NULL,
    [HeliosOrderId]          INT             CONSTRAINT [DF_CommunicationMessagesShipmentOrdersSent_HeliosOrderId] DEFAULT ((0)) NOT NULL,
    [CustomerID]             INT             NOT NULL,
    [CustomerName]           NVARCHAR (100)  NOT NULL,
    [CustomerAddress1]       NVARCHAR (100)  NOT NULL,
    [CustomerAddress2]       NVARCHAR (50)   NOT NULL,
    [CustomerAddress3]       NVARCHAR (50)   NULL,
    [CustomerCity]           NVARCHAR (150)  NOT NULL,
    [CustomerZipCode]        NVARCHAR (10)   NULL,
    [CustomerCountryISO]     CHAR (3)        NULL,
    [ContactID]              INT             NOT NULL,
    [ContactTitle]           CHAR (1)        NOT NULL,
    [ContactFirstName]       NVARCHAR (35)   NULL,
    [ContactLastName]        NVARCHAR (35)   NOT NULL,
    [ContactPhoneNumber1]    NVARCHAR (15)   NOT NULL,
    [ContactPhoneNumber2]    NVARCHAR (15)   NULL,
    [ContactFaxNumber]       NVARCHAR (15)   NULL,
    [ContactEmail]           NVARCHAR (150)  NOT NULL,
    [IsManually]             BIT             CONSTRAINT [DF_CommunicationMessagesShipmentOrdersSent_IsManually] DEFAULT ((1)) NULL,
    [StockId]                INT             NOT NULL,
    [IsActive]               BIT             CONSTRAINT [DF_CommunicationMessagesShipmentOrdersSent_IsActive] DEFAULT ((1)) NOT NULL,
    [ModifyDate]             DATETIME        CONSTRAINT [DF_CommunicationMessagesShipmentOrdersSent_ModifyDate] DEFAULT (getdate()) NOT NULL,
    [ModifyUserId]           INT             CONSTRAINT [DF_CommunicationMessagesShipmentOrdersSent_ModifyUserId] DEFAULT ((0)) NOT NULL,
    [IdWf]                   INT             NULL,
    [Remark]                 NVARCHAR (4000) NULL,
    CONSTRAINT [PK_CommunicationMessagesShipmentOrdersSent] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 85)
);


GO
CREATE NONCLUSTERED INDEX [NonClusteredIndex-IsActiveID]
    ON [dbo].[CommunicationMessagesShipmentOrdersSent]([IsActive] ASC, [ID] ASC, [MessageDateOfShipment] ASC, [RequiredDateOfShipment] ASC, [ModifyUserId] ASC, [IdWf] ASC) WITH (FILLFACTOR = 85);


GO

CREATE TRIGGER [dbo].[trCommunicationMessagesShipmentOrdersSentUpd]
   ON  [dbo].[CommunicationMessagesShipmentOrdersSent]
   AFTER UPDATE
AS 
BEGIN
-- =============================================
-- Author:		   Weczerek
-- Create date:   2015-02-11
-- Modify date:   2015-05-26 M.Rezler
--                pridan sloupec [Remark]
-- Description:	
-- =============================================
	SET NOCOUNT ON;

INSERT INTO [dbo].[A_CommunicationMessagesShipmentOrdersSent]
           ([ID]
           ,[MessageId]
           ,[MessageTypeId]
           ,[MessageDescription]
           ,[MessageDateOfShipment]
           ,[RequiredDateOfShipment]
           ,[MessageStatusId]
           ,[HeliosOrderId]
           ,[CustomerID]
           ,[CustomerName]
           ,[CustomerAddress1]
           ,[CustomerAddress2]
           ,[CustomerAddress3]
           ,[CustomerCity]
           ,[CustomerZipCode]
           ,[CustomerCountryISO]
           ,[ContactID]
           ,[ContactTitle]
           ,[ContactFirstName]
           ,[ContactLastName]
           ,[ContactPhoneNumber1]
           ,[ContactPhoneNumber2]
           ,[ContactFaxNumber]
           ,[ContactEmail]
           ,[IsManually]
           ,[StockId]
           ,[IsActive]
           ,[ModifyDate]
           ,[ModifyUserId]
           ,[IdWf]
					 ,[Remark]
)
SELECT      [ID]
           ,[MessageId]
           ,[MessageTypeId]
           ,[MessageDescription]
           ,[MessageDateOfShipment]
           ,[RequiredDateOfShipment]
           ,[MessageStatusId]
           ,[HeliosOrderId]
           ,[CustomerID]
           ,[CustomerName]
           ,[CustomerAddress1]
           ,[CustomerAddress2]
           ,[CustomerAddress3]
           ,[CustomerCity]
           ,[CustomerZipCode]
           ,[CustomerCountryISO]
           ,[ContactID]
           ,[ContactTitle]
           ,[ContactFirstName]
           ,[ContactLastName]
           ,[ContactPhoneNumber1]
           ,[ContactPhoneNumber2]
           ,[ContactFaxNumber]
           ,[ContactEmail]
           ,[IsManually]
           ,[StockId]
           ,[IsActive]
           ,[ModifyDate]
           ,[ModifyUserId]
           ,[IdWf]
					 ,[Remark]
FROM deleted

END



GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'pořadové číslo message; ', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CommunicationMessagesShipmentOrdersSent', @level2type = N'COLUMN', @level2name = N'MessageId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Datum, kdy byla položka odeslána ND', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CommunicationMessagesShipmentOrdersSent', @level2type = N'COLUMN', @level2name = N'MessageDateOfShipment';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'požadované datum dodání servisní firmě', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CommunicationMessagesShipmentOrdersSent', @level2type = N'COLUMN', @level2name = N'RequiredDateOfShipment';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'0... záznam nebyl odeslán na ND, 1 ... záznam byl odeslán na ND, 2...    -- číselník', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CommunicationMessagesShipmentOrdersSent', @level2type = N'COLUMN', @level2name = N'MessageStatusId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Tady bude vždy 0', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CommunicationMessagesShipmentOrdersSent', @level2type = N'COLUMN', @level2name = N'HeliosOrderId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'id z tabulky cdlDestinationPlaces', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CommunicationMessagesShipmentOrdersSent', @level2type = N'COLUMN', @level2name = N'CustomerID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'CompanyName z tabulky cdlDestinationPlaces', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CommunicationMessagesShipmentOrdersSent', @level2type = N'COLUMN', @level2name = N'CustomerName';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'StreetName', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CommunicationMessagesShipmentOrdersSent', @level2type = N'COLUMN', @level2name = N'CustomerAddress1';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'StreetHouseNumber', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CommunicationMessagesShipmentOrdersSent', @level2type = N'COLUMN', @level2name = N'CustomerAddress2';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'nepoužívá se', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CommunicationMessagesShipmentOrdersSent', @level2type = N'COLUMN', @level2name = N'CustomerAddress3';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'City', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CommunicationMessagesShipmentOrdersSent', @level2type = N'COLUMN', @level2name = N'CustomerCity';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'ZipCode', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CommunicationMessagesShipmentOrdersSent', @level2type = N'COLUMN', @level2name = N'CustomerZipCode';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'CountryISO... 3 písmenná zkratka státu dle ISO', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CommunicationMessagesShipmentOrdersSent', @level2type = N'COLUMN', @level2name = N'CustomerCountryISO';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'cdlDestinationPlacesContactsId ', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CommunicationMessagesShipmentOrdersSent', @level2type = N'COLUMN', @level2name = N'ContactID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'1...Mr, 2...Mrs', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CommunicationMessagesShipmentOrdersSent', @level2type = N'COLUMN', @level2name = N'ContactTitle';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'PhoneNumber', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CommunicationMessagesShipmentOrdersSent', @level2type = N'COLUMN', @level2name = N'ContactPhoneNumber1';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'defaultně 2 - ND', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CommunicationMessagesShipmentOrdersSent', @level2type = N'COLUMN', @level2name = N'StockId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Dá se předpokládat, že při automatické kontrole a vytvoření záznamu bude uživatel nějaký, třeba 0', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CommunicationMessagesShipmentOrdersSent', @level2type = N'COLUMN', @level2name = N'ModifyUserId';

