CREATE TABLE [dbo].[cdlMessageTypes] (
    [ID]             INT           NOT NULL,
    [DescriptionCz]  NVARCHAR (50) NOT NULL,
    [DescriptionEng] NVARCHAR (50) NOT NULL,
    [IsSent]         BIT           CONSTRAINT [DF_cdlMessageTypes_IsSent] DEFAULT ((0)) NOT NULL,
    [SentDate]       DATETIME      NULL,
    [IsActive]       BIT           CONSTRAINT [DF_cdlMessageTypes_IsActive] DEFAULT ((1)) NOT NULL,
    [ModifyDate]     DATETIME      CONSTRAINT [DF_cdlMessageTypes_ModifyDate] DEFAULT (getdate()) NOT NULL,
    [ModifyUserId]   INT           CONSTRAINT [DF_cdlMessageTypes_ModifyUserId] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_MessageTypes] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 85)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Popis česky', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'cdlMessageTypes', @level2type = N'COLUMN', @level2name = N'DescriptionCz';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Popis anglicky', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'cdlMessageTypes', @level2type = N'COLUMN', @level2name = N'DescriptionEng';

