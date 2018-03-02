CREATE TABLE [dbo].[cdlKitGroups] (
    [ID]             INT            IDENTITY (1, 1) NOT NULL,
    [Code]           NVARCHAR (50)  NOT NULL,
    [DescriptionCz]  NVARCHAR (100) NULL,
    [DescriptionEng] NVARCHAR (100) NULL,
    [IsSent]         BIT            CONSTRAINT [DF_cdlKitGroups_IsSent] DEFAULT ((0)) NOT NULL,
    [SentDate]       DATETIME       NULL,
    [IsActive]       BIT            CONSTRAINT [DF_cdlKitGroups_IsActive] DEFAULT ((1)) NOT NULL,
    [ModifyDate]     DATETIME       CONSTRAINT [DF_cdlKitGroups_ModifyDate] DEFAULT (getdate()) NOT NULL,
    [ModifyUserId]   INT            CONSTRAINT [DF_cdlKitGroups_ModifyUserId] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_cdlKitGroups] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 85)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_cdlKitGroupsCode]
    ON [dbo].[cdlKitGroups]([Code] ASC) WITH (FILLFACTOR = 85);


GO
GRANT SELECT
    ON OBJECT::[dbo].[cdlKitGroups] TO [mis]
    AS [dbo];

