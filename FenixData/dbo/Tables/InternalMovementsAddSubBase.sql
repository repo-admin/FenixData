CREATE TABLE [dbo].[InternalMovementsAddSubBase] (
    [ID]           INT           IDENTITY (1, 1) NOT NULL,
    [Description]  NVARCHAR (50) NOT NULL,
    [Abbreviation] NVARCHAR (25) NOT NULL,
    [IsActive]     BIT           CONSTRAINT [DF_InternalMovementsAddSubBase_IsActive] DEFAULT ((1)) NOT NULL,
    [ModifyDate]   DATETIME      CONSTRAINT [DF_InternalMovementsAddSubBase_ModifyDate] DEFAULT (getdate()) NOT NULL,
    [ModifyUserId] INT           CONSTRAINT [DF_InternalMovementsAddSubBase_ModifyUserId] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_InternalMovementsAddSubBase] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 85)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Volné/uvolněné, Rezervované', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'InternalMovementsAddSubBase', @level2type = N'COLUMN', @level2name = N'Description';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'(U)VOL, REZERV', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'InternalMovementsAddSubBase', @level2type = N'COLUMN', @level2name = N'Abbreviation';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Datum editace', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'InternalMovementsAddSubBase', @level2type = N'COLUMN', @level2name = N'ModifyDate';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'ID uživatele, který jako poslední záznam editoval', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'InternalMovementsAddSubBase', @level2type = N'COLUMN', @level2name = N'ModifyUserId';

