CREATE TABLE [dbo].[A_FenixHeliosObjHla] (
    [A_ID]          INT            IDENTITY (1, 1) NOT NULL,
    [ID]            INT            NOT NULL,
    [DruhPohybuZbo] TINYINT        NOT NULL,
    [IDSklad]       NVARCHAR (30)  NULL,
    [RadaDokladu]   NVARCHAR (3)   NOT NULL,
    [PoradoveCislo] INT            NOT NULL,
    [CisloOrg]      INT            NULL,
    [Prijemce]      INT            NULL,
    [MistoUrceni]   INT            NULL,
    [Autor]         NVARCHAR (128) NOT NULL,
    [DatPorizeni]   DATETIME       NOT NULL,
    [Poznamka]      NTEXT          NULL,
    [CisloZakazky]  NVARCHAR (15)  NULL,
    [PopisDodavky]  NVARCHAR (40)  NULL,
    [TerminDodavky] NVARCHAR (20)  NULL,
    [Splatnost]     DATETIME       NULL,
    [DodFak]        NVARCHAR (20)  NOT NULL,
    [KontaktZam]    INT            NULL,
    [IdObdobiStavu] INT            NULL,
    [KontaktOsoba]  INT            NULL,
    [DIC]           NVARCHAR (15)  NULL,
    [Hit]           BIT            CONSTRAINT [DF_A_FenixHeliosObjHla_Hit] DEFAULT ((0)) NOT NULL,
    [EndDataFenix]  DATETIME       NULL,
    [A_ModifyDate]  DATETIME       CONSTRAINT [DF_A_FenixHeliosObjHla_A_ModifyDate] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_A_FenixHeliosObjHla_1] PRIMARY KEY CLUSTERED ([A_ID] ASC) WITH (FILLFACTOR = 85)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'ID z Heliosu', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'A_FenixHeliosObjHla', @level2type = N'COLUMN', @level2name = N'ID';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'druh pohybu vyžaduje číselník', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'A_FenixHeliosObjHla', @level2type = N'COLUMN', @level2name = N'DruhPohybuZbo';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'sklad vyžaduje číselník', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'A_FenixHeliosObjHla', @level2type = N'COLUMN', @level2name = N'IDSklad';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'0... záznam ještě nebyl Fenixem zpracován (nebylo na něj šáhnuto), 1...záznam byl zkontrolován a byl"přetvořen" do tabulek messages', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'A_FenixHeliosObjHla', @level2type = N'COLUMN', @level2name = N'Hit';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Toto je poslední datum v cyklu zpracování objednávky z Heliosu - po obdržení potvrzení o přijetí objednávky ze strany ND ', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'A_FenixHeliosObjHla', @level2type = N'COLUMN', @level2name = N'EndDataFenix';

