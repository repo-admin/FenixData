CREATE TABLE [dbo].[CommunicationMessagesCrmOrderReturnedEquipment] (
    [ID]                     INT           IDENTITY (1, 1) NOT NULL,
    [MessageID]              INT           NOT NULL,
    [MessageTypeID]          INT           NOT NULL,
    [MessageTypeDescription] NVARCHAR (50) NOT NULL,
    [MessageDate]            DATETIME      NOT NULL,
    [IsActive]               BIT           DEFAULT ((1)) NOT NULL,
    [ModifyDate]             DATETIME      NOT NULL,
    [ModifyUserID]           INT           DEFAULT ((0)) NOT NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 85),
    FOREIGN KEY ([MessageTypeID]) REFERENCES [dbo].[cdlMessageTypes] ([ID])
);

