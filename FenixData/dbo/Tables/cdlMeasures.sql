CREATE TABLE [dbo].[cdlMeasures] (
    [ID]             INT            IDENTITY (1, 1) NOT NULL,
    [Code]           VARCHAR (50)   NOT NULL,
    [DescriptionCz]  NVARCHAR (250) NOT NULL,
    [DescriptionEng] NVARCHAR (250) NOT NULL,
    [IsSent]         BIT            CONSTRAINT [DF_cdlMeasures_IsSent] DEFAULT ((0)) NOT NULL,
    [SentDate]       DATETIME       NULL,
    [IsActive]       BIT            CONSTRAINT [DF_cdlMeasures_IsActive] DEFAULT ((1)) NOT NULL,
    [ModifyDate]     DATETIME       CONSTRAINT [DF_cdlMeasures_ModifyDate] DEFAULT (getdate()) NOT NULL,
    [ModifyUserId]   INT            CONSTRAINT [DF_cdlMeasures_ModifyUserId] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_Measures] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 85)
);


GO
GRANT SELECT
    ON OBJECT::[dbo].[cdlMeasures] TO [mis]
    AS [dbo];


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'kód stejný pro všechny jazyky', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'cdlMeasures', @level2type = N'COLUMN', @level2name = N'Code';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Popis česky', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'cdlMeasures', @level2type = N'COLUMN', @level2name = N'DescriptionCz';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Popis anglicky', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'cdlMeasures', @level2type = N'COLUMN', @level2name = N'DescriptionEng';

