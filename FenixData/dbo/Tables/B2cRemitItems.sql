CREATE TABLE [dbo].[B2cRemitItems] (
    [Id]       INT           IDENTITY (1, 1) NOT NULL,
    [RemitId]  INT           NULL,
    [ParcelNr] NVARCHAR (50) NULL,
    [SN1]      NVARCHAR (50) NULL,
    [SN2]      NVARCHAR (50) NULL,
    [KitId]    INT           NULL,
    [NewKitId] INT           NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 85),
    FOREIGN KEY ([KitId]) REFERENCES [dbo].[cdlKits] ([ID]),
    FOREIGN KEY ([NewKitId]) REFERENCES [dbo].[cdlKits] ([ID]),
    FOREIGN KEY ([RemitId]) REFERENCES [dbo].[B2cRemits] ([Id])
);




GO
GRANT UPDATE
    ON OBJECT::[dbo].[B2cRemitItems] TO [FenixW]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[B2cRemitItems] TO [FenixW]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[B2cRemitItems] TO [FenixW]
    AS [dbo];


GO
GRANT DELETE
    ON OBJECT::[dbo].[B2cRemitItems] TO [FenixW]
    AS [dbo];

