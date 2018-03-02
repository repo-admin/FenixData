CREATE TABLE [dbo].[A_CommunicationMessagesKittingsApprovalKitsSent] (
    [A_ID]               INT             IDENTITY (1, 1) NOT NULL,
    [ID]                 INT             NOT NULL,
    [ApprovalID]         INT             NOT NULL,
    [KitID]              INT             NOT NULL,
    [KitDescription]     NVARCHAR (500)  NOT NULL,
    [KitQuantity]        NUMERIC (18, 3) NOT NULL,
    [KitUnitOfMeasureID] INT             NOT NULL,
    [KitUnitOfMeasure]   VARCHAR (50)    NOT NULL,
    [KitQualityId]       INT             NOT NULL,
    [KitQuality]         NVARCHAR (150)  NOT NULL,
    [IsActive]           BIT             CONSTRAINT [DF_A_CommunicationMessagesKittingsApprovalKitsSent_IsActive] DEFAULT ((1)) NOT NULL,
    [ModifyDate]         DATETIME        CONSTRAINT [DF_A_CommunicationMessagesKittingsApprovalKitsSent_ModifyDate] DEFAULT (getdate()) NOT NULL,
    [ModifyUserId]       INT             CONSTRAINT [DF_A_CommunicationMessagesKittingsApprovalKitsSent_ModifyUserId] DEFAULT ((0)) NOT NULL,
    [A_ModifyDate]       DATETIME        CONSTRAINT [DF_A_CommunicationMessagesKittingsApprovalKitsSent_A_ModifyDate] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_A_CommunicationMessagesKittingsApprovalKitsSent] PRIMARY KEY CLUSTERED ([A_ID] ASC) WITH (FILLFACTOR = 85)
);

