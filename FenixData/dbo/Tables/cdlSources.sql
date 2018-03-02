CREATE TABLE [dbo].[cdlSources] (
    [id]            INT           NOT NULL,
    [SourceCode]    NVARCHAR (10) NOT NULL,
    [DescriptionCZ] NVARCHAR (50) NOT NULL,
    [IsActive]      BIT           CONSTRAINT [DF_cdlSources_IsActive] DEFAULT ((1)) NOT NULL,
    [ModifyDate]    DATETIME      CONSTRAINT [DF_cdlSources_ModifyDate] DEFAULT (getdate()) NOT NULL,
    [ModifyUserId]  INT           CONSTRAINT [DF_cdlSources_ModifyUserId] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_cdlSources] PRIMARY KEY CLUSTERED ([id] ASC) WITH (FILLFACTOR = 85)
);

