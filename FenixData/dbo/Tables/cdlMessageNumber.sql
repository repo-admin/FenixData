CREATE TABLE [dbo].[cdlMessageNumber] (
    [ID]             INT         NOT NULL,
    [Code]           NCHAR (3)   NOT NULL,
    [Description]    NCHAR (100) NOT NULL,
    [LastFreeNumber] INT         NOT NULL,
    CONSTRAINT [PK_cdlMessageNumber] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 85)
);

