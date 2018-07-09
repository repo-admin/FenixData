CREATE TABLE [dbo].[B2cExpedition] (
    [Id]            INT           IDENTITY (1, 1) NOT NULL,
    [OrderType]     NVARCHAR (50) NULL,
    [CpeType]       NVARCHAR (50) NULL,
    [Rental]        NVARCHAR (50) NULL,
    [Client]        NVARCHAR (50) NULL,
    [Internet]      NVARCHAR (50) NULL,
    [ClientName]    NVARCHAR (50) NULL,
    [ClientAddress] NVARCHAR (50) NULL,
    [ComSwap]       BIT           NULL,
    [OrderNo]       NVARCHAR (50) NULL,
    [MsgStatus]     NVARCHAR (50) NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 85)
);




GO
GRANT UPDATE
    ON OBJECT::[dbo].[B2cExpedition] TO [FenixW]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[B2cExpedition] TO [FenixR]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[B2cExpedition] TO [FenixW]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[B2cExpedition] TO [FenixR]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[B2cExpedition] TO [FenixW]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[B2cExpedition] TO [FenixR]
    AS [dbo];


GO
GRANT DELETE
    ON OBJECT::[dbo].[B2cExpedition] TO [FenixW]
    AS [dbo];

