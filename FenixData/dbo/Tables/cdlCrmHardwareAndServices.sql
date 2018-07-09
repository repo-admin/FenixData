CREATE TABLE [dbo].[cdlCrmHardwareAndServices] (
    [Id]           INT            IDENTITY (1, 1) NOT NULL,
    [Code]         NVARCHAR (30)  NOT NULL,
    [Description]  NVARCHAR (255) NOT NULL,
    [IsActive]     BIT            DEFAULT ((1)) NOT NULL,
    [ModifyDate]   DATETIME       DEFAULT (getdate()) NOT NULL,
    [ModifyUserId] INT            DEFAULT ((0)) NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 85),
    UNIQUE NONCLUSTERED ([Code] ASC) WITH (FILLFACTOR = 85)
);

