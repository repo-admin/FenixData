CREATE TABLE [dbo].[cdlKits] (
    [ID]               INT           IDENTITY (1, 1) NOT NULL,
    [Code]             NVARCHAR (5)  NULL,
    [DescriptionCz]    NVARCHAR (50) NOT NULL,
    [DescriptionEng]   NVARCHAR (50) NOT NULL,
    [MeasuresId]       INT           CONSTRAINT [DF_cdlKits_MeasuresId] DEFAULT ((1)) NOT NULL,
    [MeasuresCode]     NVARCHAR (50) CONSTRAINT [DF_cdlKits_MeasuresCode] DEFAULT (N'KS') NULL,
    [KitQualitiesId]   INT           NULL,
    [KitQualitiesCode] NVARCHAR (50) NULL,
    [IsSent]           BIT           CONSTRAINT [DF_cdlKits_IsSent] DEFAULT ((0)) NOT NULL,
    [SentDate]         DATETIME      NULL,
    [GroupsId]         INT           NULL,
    [Packaging]        INT           NULL,
    [IsActive]         BIT           CONSTRAINT [DF_cdlKits_IsActive] DEFAULT ((1)) NOT NULL,
    [ModifyDate]       DATETIME      CONSTRAINT [DF_cdlKits_ModifyDate] DEFAULT (getdate()) NOT NULL,
    [ModifyUserId]     INT           CONSTRAINT [DF_cdlKits_ModifyUserId] DEFAULT ((0)) NOT NULL,
    [Multiplayer]      INT           CONSTRAINT [DF_cdlKits_Multiplayer] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_cdlKits] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 85)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [NonClusteredIndex-20140922-174340]
    ON [dbo].[cdlKits]([Code] ASC, [DescriptionCz] ASC, [MeasuresId] ASC, [KitQualitiesId] ASC, [IsActive] ASC) WITH (FILLFACTOR = 85);


GO
GRANT SELECT
    ON OBJECT::[dbo].[cdlKits] TO [mis]
    AS [dbo];


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'kód ze CRM', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'cdlKits', @level2type = N'COLUMN', @level2name = N'Code';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'násobící koeficient pro počet CPE v Kitu (repasovaný kit obsahuje 1 CPE, ale ND posílá 2 ser. numbery => koeficient se rovná 2)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'cdlKits', @level2type = N'COLUMN', @level2name = N'Multiplayer';

