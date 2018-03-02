CREATE TABLE [dbo].[A_CommunicationMessagesReturn] (
    [A_ID]                 INT            IDENTITY (1, 1) NOT NULL,
    [ID]                   INT            NOT NULL,
    [MessageId]            INT            NOT NULL,
    [MessageTypeId]        INT            NOT NULL,
    [MessageDescription]   NVARCHAR (200) NOT NULL,
    [MessageDateOfReceipt] DATETIME       NOT NULL,
    [Reconciliation]       INT            NOT NULL,
    [IsActive]             BIT            NOT NULL,
    [ModifyDate]           DATETIME       NOT NULL,
    [ModifyUserId]         INT            NOT NULL,
    [A_ModifyDate]         DATETIME       CONSTRAINT [DF_A_CommunicationMessagesReturn_A_ModifyDate] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_A_CommunicationMessagesReturn] PRIMARY KEY CLUSTERED ([A_ID] ASC) WITH (FILLFACTOR = 85)
);

