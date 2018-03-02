CREATE TABLE [dbo].[CommunicationMessagesRefurbishedOrder] (
    [ID]                    INT            IDENTITY (1, 1) NOT NULL,
    [MessageId]             INT            NOT NULL,
    [MessageTypeId]         INT            NOT NULL,
    [MessageDescription]    NVARCHAR (200) NOT NULL,
    [MessageDateOfShipment] DATETIME       NULL,
    [MessageStatusId]       INT            NOT NULL,
    [CustomerID]            INT            NOT NULL,
    [CustomerDescription]   NVARCHAR (500) NOT NULL,
    [DateOfDelivery]        DATETIME       NOT NULL,
    [IsManually]            BIT            CONSTRAINT [DF_CommunicationMessagesRefurbishedOrder_IsManually] DEFAULT ((1)) NOT NULL,
    [StockId]               INT            CONSTRAINT [DF_CommunicationMessagesRefurbishedOrder_StockId] DEFAULT ((2)) NOT NULL,
    [Notice]                NVARCHAR (MAX) NULL,
    [IsActive]              BIT            CONSTRAINT [DF_CommunicationMessagesRefurbishedOrder_IsActive] DEFAULT ((1)) NOT NULL,
    [ModifyDate]            DATETIME       CONSTRAINT [DF_CommunicationMessagesRefurbishedOrder_ModifyDate] DEFAULT (getdate()) NOT NULL,
    [ModifyUserId]          INT            CONSTRAINT [DF_CommunicationMessagesRefurbishedOrder_ModifyUserId] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_CommunicationMessagesRefurbishedOrder] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 85)
);


GO


CREATE TRIGGER [dbo].[trCommunicationMessagesRefurbishedOrderUpd]
   ON  [dbo].[CommunicationMessagesRefurbishedOrder]
   AFTER UPDATE
AS 
BEGIN
-- =============================================
-- Author:		   Weczerek
-- Create date:   2015-02-11
-- Description:	
-- =============================================
	SET NOCOUNT ON;

INSERT INTO [dbo].[A_CommunicationMessagesRefurbishedOrder]
           ([ID]
           ,[MessageId]
           ,[MessageTypeId]
           ,[MessageDescription]
           ,[MessageDateOfShipment]
           ,[MessageStatusId]
           ,[CustomerID]
           ,[CustomerDescription]
           ,[DateOfDelivery]
           ,[IsManually]
           ,[StockId]
           ,[Notice]
           ,[IsActive]
           ,[ModifyDate]
           ,[ModifyUserId]
)
SELECT      [ID]
           ,[MessageId]
           ,[MessageTypeId]
           ,[MessageDescription]
           ,[MessageDateOfShipment]
           ,[MessageStatusId]
           ,[CustomerID]
           ,[CustomerDescription]
           ,[DateOfDelivery]
           ,[IsManually]
           ,[StockId]
           ,[Notice]
           ,[IsActive]
           ,[ModifyDate]
           ,[ModifyUserId]
FROM deleted

END




GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'pořadové číslo message; ', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CommunicationMessagesRefurbishedOrder', @level2type = N'COLUMN', @level2name = N'MessageId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'typ message - musí být číselník', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CommunicationMessagesRefurbishedOrder', @level2type = N'COLUMN', @level2name = N'MessageTypeId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Datum, kdy bylo CPE zasláno k repasi', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'CommunicationMessagesRefurbishedOrder', @level2type = N'COLUMN', @level2name = N'MessageDateOfShipment';

