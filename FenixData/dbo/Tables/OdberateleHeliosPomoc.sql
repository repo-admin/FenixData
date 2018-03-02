CREATE TABLE [dbo].[OdberateleHeliosPomoc] (
    [ID]                    INT            IDENTITY (1, 1) NOT NULL,
    [CisloOrg]              INT            NOT NULL,
    [Nazev]                 NVARCHAR (100) NOT NULL,
    [Misto]                 NVARCHAR (100) NOT NULL,
    [Ulice]                 NVARCHAR (100) NOT NULL,
    [PSC]                   NVARCHAR (10)  NULL,
    [DIC]                   NVARCHAR (15)  NULL,
    [ICO]                   NVARCHAR (20)  NULL,
    [idZeme]                NVARCHAR (3)   NULL,
    [Popis-Jméno - telefon] NVARCHAR (255) NULL,
    [Telefon]               NVARCHAR (255) NULL,
    [Popis-Jméno - Mail]    NVARCHAR (255) NULL,
    [Mail]                  NVARCHAR (255) NULL
);

