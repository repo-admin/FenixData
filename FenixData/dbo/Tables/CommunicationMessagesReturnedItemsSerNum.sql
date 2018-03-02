CREATE TABLE [dbo].[CommunicationMessagesReturnedItemsSerNum] (
    [ID]                       INT           IDENTITY (1, 1) NOT NULL,
    [RefurbishedItemsOrKitsID] INT           NOT NULL,
    [SN]                       NVARCHAR (20) NULL,
    [IsActive]                 BIT           NOT NULL,
    [ModifyDate]               DATETIME      NOT NULL,
    [ModifyUserId]             INT           NOT NULL,
    CONSTRAINT [PK_CommunicationMessagesReturnedItemsSerNum] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 85)
);

