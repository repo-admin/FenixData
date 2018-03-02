CREATE TABLE [dbo].[cdlStatuses] (
    [ID]             INT            NOT NULL,
    [Code]           INT            NOT NULL,
    [DescriptionCz]  NVARCHAR (100) NOT NULL,
    [DescriptionEng] NVARCHAR (100) NULL,
    [IsSent]         BIT            CONSTRAINT [DF_cdlStatuses_IsSent] DEFAULT ((0)) NOT NULL,
    [SentDate]       DATETIME       NULL,
    [ModifyDate]     DATETIME       CONSTRAINT [DF_cdlStatuses_ModifyDate] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_cdlStatuses] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 85)
);

