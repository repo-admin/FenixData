CREATE TABLE [dbo].[B2cRemits] (
    [Id]             INT           IDENTITY (1, 1) NOT NULL,
    [MsgId]          INT           NULL,
    [MsgDescription] NVARCHAR (50) NULL,
    [ReceivedDate]   DATE          NULL,
    [MsgStatus]      NVARCHAR (50) NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 85)
);

