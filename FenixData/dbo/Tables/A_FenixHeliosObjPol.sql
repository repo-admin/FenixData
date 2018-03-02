CREATE TABLE [dbo].[A_FenixHeliosObjPol] (
    [A_ID]          INT             IDENTITY (1, 1) NOT NULL,
    [ID]            INT             NOT NULL,
    [IDDoklad]      INT             NOT NULL,
    [SkupZbo]       NVARCHAR (3)    NOT NULL,
    [RegCis]        NVARCHAR (30)   NOT NULL,
    [Nazev1]        NVARCHAR (100)  NOT NULL,
    [MJ]            NVARCHAR (10)   NULL,
    [MJEvidence]    NVARCHAR (10)   NULL,
    [Mnozstvi]      NUMERIC (19, 6) NOT NULL,
    [ItemTypeDesc1] NVARCHAR (50)   NULL,
    [ItemTypeDesc2] NVARCHAR (50)   NULL,
    [A_ModifyDate]  DATETIME        CONSTRAINT [DF_A_FenixHeliosObjPol_A_ModifyDate] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_A_FenixHeliosObjPol_1] PRIMARY KEY CLUSTERED ([A_ID] ASC) WITH (FILLFACTOR = 85)
);

