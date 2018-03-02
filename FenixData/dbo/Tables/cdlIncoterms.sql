CREATE TABLE [dbo].[cdlIncoterms] (
    [ID]             INT           IDENTITY (1, 1) NOT NULL,
    [DescriptionCz]  NVARCHAR (50) NOT NULL,
    [DescriptionEng] NVARCHAR (50) NOT NULL,
    [IsSent]         BIT           CONSTRAINT [DF_cdlIncoterms_IsSent] DEFAULT ((0)) NOT NULL,
    [SentDate]       DATETIME      NULL,
    [IsActive]       BIT           CONSTRAINT [DF_cdlIncoterms_IsActive] DEFAULT ((1)) NOT NULL,
    [ModifyDate]     DATETIME      CONSTRAINT [DF_cdlIncoterms_ModifyDate] DEFAULT (getdate()) NOT NULL,
    [ModifyUserId]   INT           CONSTRAINT [DF_cdlIncoterms_ModifyUserId] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_cdlIncoterms] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 85)
);

