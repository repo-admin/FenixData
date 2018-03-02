CREATE TABLE [dbo].[B2cKitTransformations] (
    [Id]          INT            IDENTITY (1, 1) NOT NULL,
    [KitId]       INT            NOT NULL,
    [NewKitId]    INT            NULL,
    [IsIdentical] BIT            NOT NULL,
    [CreatedBy]   NVARCHAR (100) NOT NULL,
    [Created]     DATETIME       NOT NULL,
    [IsActive]    BIT            NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 85),
    FOREIGN KEY ([KitId]) REFERENCES [dbo].[cdlKits] ([ID]),
    FOREIGN KEY ([NewKitId]) REFERENCES [dbo].[cdlKits] ([ID])
);

