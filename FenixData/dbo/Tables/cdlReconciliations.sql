CREATE TABLE [dbo].[cdlReconciliations] (
    [ID]              INT            IDENTITY (0, 1) NOT NULL,
    [DescriptionCz]   NVARCHAR (250) NOT NULL,
    [DescriptionEng]  NVARCHAR (250) NOT NULL,
    [AbbreviationCz]  NVARCHAR (50)  NOT NULL,
    [AbbreviationEng] NVARCHAR (50)  NOT NULL,
    [IsSent]          BIT            CONSTRAINT [DF_cdlReconciliations_IsSent] DEFAULT ((0)) NOT NULL,
    [SentDate]        DATETIME       NULL,
    [IsActive]        BIT            CONSTRAINT [DF_cdlReconciliations_IsActive] DEFAULT ((1)) NOT NULL,
    [ModifyDate]      DATETIME       CONSTRAINT [DF_cdlReconciliations_ModifyDate] DEFAULT (getdate()) NOT NULL,
    [ModifyUserId]    INT            CONSTRAINT [DF_cdlReconciliations_ModifyUserId] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_cdlReconciliations] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 85)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Popis česky', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'cdlReconciliations', @level2type = N'COLUMN', @level2name = N'DescriptionCz';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Popis anglicky', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'cdlReconciliations', @level2type = N'COLUMN', @level2name = N'DescriptionEng';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Zkratka česky', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'cdlReconciliations', @level2type = N'COLUMN', @level2name = N'AbbreviationCz';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Zkratka anglicky', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'cdlReconciliations', @level2type = N'COLUMN', @level2name = N'AbbreviationEng';

