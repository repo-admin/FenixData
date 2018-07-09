CREATE TABLE [dbo].[IdentityUsers] (
    [Id]    INT            IDENTITY (1, 1) NOT NULL,
    [Value] NVARCHAR (100) NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 85)
);

