CREATE TABLE [dbo].[CrmHardwareAndServices] (
    [Id]          INT            IDENTITY (1, 1) NOT NULL,
    [Code]        NVARCHAR (30)  NOT NULL,
    [Description] NVARCHAR (255) NOT NULL,
    [TypeId]      INT            NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 85),
    FOREIGN KEY ([TypeId]) REFERENCES [dbo].[CrmHardwareAndServiceTypes] ([Id]),
    UNIQUE NONCLUSTERED ([Code] ASC) WITH (FILLFACTOR = 85)
);

