CREATE TABLE [dbo].[cdlAppLogTypes] (
    [ID]             INT           IDENTITY (1, 1) NOT NULL,
    [DescriptionCz]  NVARCHAR (50) NOT NULL,
    [DescriptionEng] NVARCHAR (50) NOT NULL,
    [IsActive]       BIT           CONSTRAINT [DF_cdlAppLogTypes_IsActive] DEFAULT ((1)) NOT NULL,
    [ModifyDate]     DATETIME      CONSTRAINT [DF_cdlAppLogTypes_ModifyDate] DEFAULT (getdate()) NOT NULL,
    [ModifyUserId]   INT           CONSTRAINT [DF_cdlAppLogTypes_ModifyUserId] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_AppLogTypes] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 85)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Popis česky', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'cdlAppLogTypes', @level2type = N'COLUMN', @level2name = N'DescriptionCz';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Popis anglicky', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'cdlAppLogTypes', @level2type = N'COLUMN', @level2name = N'DescriptionEng';

