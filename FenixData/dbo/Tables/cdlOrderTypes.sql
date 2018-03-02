CREATE TABLE [dbo].[cdlOrderTypes] (
    [ID]           INT           IDENTITY (1, 1) NOT NULL,
    [Description]  NVARCHAR (50) NOT NULL,
    [IsActive]     BIT           CONSTRAINT [DF_cdlOrderTypes_IsActive] DEFAULT ((1)) NOT NULL,
    [ModifyDate]   DATETIME      CONSTRAINT [DF_cdlOrderTypes_ModifyDate] DEFAULT (getdate()) NOT NULL,
    [ModifyUserId] INT           NOT NULL,
    CONSTRAINT [PK_cdlOrderTypes] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 85)
);

