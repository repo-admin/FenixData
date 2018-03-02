CREATE TABLE [dbo].[cdlQualities] (
    [ID]             INT           IDENTITY (1, 1) NOT NULL,
    [Code]           NVARCHAR (50) NOT NULL,
    [DescriptionCz]  NVARCHAR (50) NOT NULL,
    [DescriptionEng] NVARCHAR (50) NOT NULL,
    [IsSent]         BIT           CONSTRAINT [DF_cdlQualities_IsSent] DEFAULT ((0)) NOT NULL,
    [SentDate]       DATETIME      NULL,
    [IsActive]       BIT           CONSTRAINT [DF_cdlQualities_IsActive] DEFAULT ((1)) NOT NULL,
    [ModifyDate]     DATETIME      CONSTRAINT [DF_cdlQualities_ModifyDate] DEFAULT (getdate()) NOT NULL,
    [ModifyUserId]   INT           CONSTRAINT [DF_cdlQualities_ModifyUserId] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_Qualities] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 85)
);


GO
GRANT SELECT
    ON OBJECT::[dbo].[cdlQualities] TO [mis]
    AS [dbo];


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'kód stejný pro všechny jazyky', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'cdlQualities', @level2type = N'COLUMN', @level2name = N'Code';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Popis česky', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'cdlQualities', @level2type = N'COLUMN', @level2name = N'DescriptionCz';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Popis anglicky', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'cdlQualities', @level2type = N'COLUMN', @level2name = N'DescriptionEng';

