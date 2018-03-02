CREATE TABLE [dbo].[A_CommunicationMessagesRefurbishedOrder] (
    [A_ID]                  INT            IDENTITY (1, 1) NOT NULL,
    [ID]                    INT            NOT NULL,
    [MessageId]             INT            NOT NULL,
    [MessageTypeId]         INT            NOT NULL,
    [MessageDescription]    NVARCHAR (200) NOT NULL,
    [MessageDateOfShipment] DATETIME       NULL,
    [MessageStatusId]       INT            NOT NULL,
    [CustomerID]            INT            NOT NULL,
    [CustomerDescription]   NVARCHAR (500) NOT NULL,
    [DateOfDelivery]        DATETIME       NOT NULL,
    [IsManually]            BIT            NOT NULL,
    [StockId]               INT            NOT NULL,
    [Notice]                NVARCHAR (MAX) NULL,
    [IsActive]              BIT            NOT NULL,
    [ModifyDate]            DATETIME       NOT NULL,
    [ModifyUserId]          INT            NOT NULL,
    [A_ModifyDate]          DATETIME       CONSTRAINT [DF_A_CommunicationMessagesRefurbishedOrder_ModifyDate] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_A_CommunicationMessagesRefurbishedOrder] PRIMARY KEY CLUSTERED ([A_ID] ASC) WITH (FILLFACTOR = 85)
);

