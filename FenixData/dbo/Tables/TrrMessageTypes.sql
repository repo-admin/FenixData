﻿CREATE TABLE [dbo].[TrrMessageTypes] (
    [Id]   INT           IDENTITY (1, 1) NOT NULL,
    [Name] NVARCHAR (50) NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 85)
);




GO
GRANT UPDATE
    ON OBJECT::[dbo].[TrrMessageTypes] TO [FenixW]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[TrrMessageTypes] TO [FenixW]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[TrrMessageTypes] TO [FenixW]
    AS [dbo];


GO
GRANT DELETE
    ON OBJECT::[dbo].[TrrMessageTypes] TO [FenixW]
    AS [dbo];

