CREATE TABLE [dbo].[A_CommunicationMessagesReceptionConfirmationItems] (
    [A_ID]              INT             IDENTITY (1, 1) NOT NULL,
    [ID]                INT             NOT NULL,
    [CMSOId]            INT             NOT NULL,
    [ItemID]            INT             NOT NULL,
    [ItemDescription]   NVARCHAR (500)  NOT NULL,
    [ItemQuantity]      NUMERIC (18, 3) NOT NULL,
    [ItemUnitOfMeasure] VARCHAR (50)    NOT NULL,
    [ItemQualityId]     INT             NOT NULL,
    [NDReceipt]         NVARCHAR (100)  NULL,
    [ItemSNs]           VARCHAR (MAX)   NULL,
    [IsActive]          BIT             CONSTRAINT [DF_A_CommunicationMessagesReceptionConfirmationItems_IsActive] DEFAULT ((1)) NOT NULL,
    [ModifyDate]        DATETIME        CONSTRAINT [DF_A_CommunicationMessagesReceptionConfirmationItems_ModifyDate] DEFAULT (getdate()) NOT NULL,
    [ModifyUserId]      INT             CONSTRAINT [DF_A_CommunicationMessagesReceptionConfirmationItems_ModifyUserId] DEFAULT ((0)) NOT NULL,
    [A_ModifyDate]      DATETIME        CONSTRAINT [DF_A_CommunicationMessagesReceptionConfirmationItems_A_ModifyDate] DEFAULT (getdate()) NOT NULL,
    [SNExportedFlag]    INT             CONSTRAINT [DF_A_CommunicationMessagesReceptionConfirmationItems_SNExported] DEFAULT ((0)) NOT NULL,
    [SNExportedDate]    DATETIME        NULL,
    CONSTRAINT [PK_A_CommunicationMessagesReceptionConfirmationItems] PRIMARY KEY CLUSTERED ([A_ID] ASC) WITH (FILLFACTOR = 85)
);

