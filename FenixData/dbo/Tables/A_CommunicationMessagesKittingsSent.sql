CREATE TABLE [dbo].[A_CommunicationMessagesKittingsSent] (
    [A_ID]                  INT            IDENTITY (1, 1) NOT NULL,
    [ID]                    INT            NOT NULL,
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
    [IsActive]              BIT            NOT NULL,
    [ModifyDate]            DATETIME       NOT NULL,
    [ModifyUserId]          INT            NOT NULL,
    [A_ModifyDate]          DATETIME       CONSTRAINT [DF_A_CommunicationMessagesKittingsSent_A_ModifyDate] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_A_CommunicationMessagesKittingsSent] PRIMARY KEY CLUSTERED ([A_ID] ASC) WITH (FILLFACTOR = 85)
);

