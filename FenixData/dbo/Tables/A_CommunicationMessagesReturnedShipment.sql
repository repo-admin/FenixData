CREATE TABLE [dbo].[A_CommunicationMessagesReturnedShipment] (
    [A_ID]               INT            IDENTITY (1, 1) NOT NULL,
    [ID]                 INT            NOT NULL,
    [MessageId]          INT            NOT NULL,
    [MessageTypeId]      INT            NOT NULL,
    [MessageDescription] NVARCHAR (200) NOT NULL,
    [CustomerID]         INT            NOT NULL,
    [ContactID]          INT            NOT NULL,
    [Reconciliation]     INT            NOT NULL,
    [IsActive]           BIT            NOT NULL,
    [ModifyDate]         DATETIME       NOT NULL,
    [ModifyUserId]       INT            NOT NULL,
    [A_ModifyDate]       DATETIME       CONSTRAINT [DF_A_CommunicationMessagesReturnedShipment_A_ModifyDate] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_A_CommunicationMessagesReturnedShipment] PRIMARY KEY CLUSTERED ([A_ID] ASC) WITH (FILLFACTOR = 85)
);

