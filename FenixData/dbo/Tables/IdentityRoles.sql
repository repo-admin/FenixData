CREATE TABLE [dbo].[IdentityRoles] (
    [Id]    INT           IDENTITY (1, 1) NOT NULL,
    [Value] NVARCHAR (20) NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 85)
);

