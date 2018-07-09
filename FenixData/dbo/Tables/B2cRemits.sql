CREATE TABLE [dbo].[B2cRemits] (
    [Id]             INT           IDENTITY (1, 1) NOT NULL,
    [MsgId]          INT           NULL,
    [MsgDescription] NVARCHAR (50) NULL,
    [ReceivedDate]   DATE          NULL,
    [MsgStatus]      NVARCHAR (50) NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 85)
);




GO
GRANT UPDATE
    ON OBJECT::[dbo].[B2cRemits] TO [FenixW]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[B2cRemits] TO [FenixW]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[B2cRemits] TO [FenixW]
    AS [dbo];


GO
GRANT DELETE
    ON OBJECT::[dbo].[B2cRemits] TO [FenixW]
    AS [dbo];

