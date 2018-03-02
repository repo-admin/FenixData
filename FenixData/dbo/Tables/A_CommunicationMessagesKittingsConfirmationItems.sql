CREATE TABLE [dbo].[A_CommunicationMessagesKittingsConfirmationItems] (
    [A_ID]             INT             IDENTITY (1, 1) NOT NULL,
    [ID]               INT             NOT NULL,
    [CMSOId]           INT             NOT NULL,
    [KitID]            INT             NOT NULL,
    [KitDescription]   NVARCHAR (500)  NOT NULL,
    [KitQuantity]      NUMERIC (18, 3) NOT NULL,
    [KitUnitOfMeasure] VARCHAR (50)    NOT NULL,
    [KitQualityId]     INT             NOT NULL,
    [KitSNs]           VARCHAR (MAX)   NULL,
    [IsActive]         BIT             NOT NULL,
    [ModifyDate]       DATETIME        NOT NULL,
    [ModifyUserId]     INT             NOT NULL,
    [A_ModifyDate]     DATETIME        CONSTRAINT [DF_A_CommunicationMessagesKittingsConfirmationItems_A_ModifyDate] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_A_CommunicationMessagesKittingsConfirmationItems] PRIMARY KEY CLUSTERED ([A_ID] ASC) WITH (FILLFACTOR = 85)
);

