CREATE TABLE [dbo].[IdentityUserRoles] (
    [Id]     INT IDENTITY (1, 1) NOT NULL,
    [UserId] INT NULL,
    [RoleId] INT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 85),
    FOREIGN KEY ([RoleId]) REFERENCES [dbo].[IdentityRoles] ([Id]),
    FOREIGN KEY ([UserId]) REFERENCES [dbo].[IdentityUsers] ([Id])
);

