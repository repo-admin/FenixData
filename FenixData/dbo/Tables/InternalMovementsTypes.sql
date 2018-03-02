CREATE TABLE [dbo].[InternalMovementsTypes] (
    [ID]           INT           IDENTITY (1, 1) NOT NULL,
    [Description]  NVARCHAR (50) NOT NULL,
    [IsActive]     BIT           CONSTRAINT [DF_InternalMovementsTypes_IsActive] DEFAULT ((1)) NOT NULL,
    [ModifyDate]   DATETIME      CONSTRAINT [DF_InternalMovementsTypes_ModifyDate] DEFAULT (getdate()) NOT NULL,
    [ModifyUserId] INT           CONSTRAINT [DF_InternalMovementsTypes_ModifyUserId] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_InternalMovementsTypes] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 85)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Manko, Přebytek', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'InternalMovementsTypes', @level2type = N'COLUMN', @level2name = N'Description';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Datum editace', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'InternalMovementsTypes', @level2type = N'COLUMN', @level2name = N'ModifyDate';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'ID uživatele, který jako poslední záznam editoval', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'InternalMovementsTypes', @level2type = N'COLUMN', @level2name = N'ModifyUserId';

