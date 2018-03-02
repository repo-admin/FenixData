CREATE TABLE [dbo].[Counter] (
    [ID]          INT          IDENTITY (1, 1) NOT NULL,
    [CounterName] VARCHAR (50) NOT NULL,
    [IntValue]    INT          NULL,
    [ResetValue]  INT          NULL,
    CONSTRAINT [PK__APP_Counter] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 85)
);

