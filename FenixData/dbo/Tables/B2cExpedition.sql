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

