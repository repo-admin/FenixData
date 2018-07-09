CREATE TABLE [dbo].[cdlProductTypes] (
    [ID]    INT           IDENTITY (1, 1) NOT NULL,
    [Value] NVARCHAR (20) NOT NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 85)
);

