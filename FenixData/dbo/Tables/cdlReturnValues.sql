CREATE TABLE [dbo].[cdlReturnValues] (
    [ID]             INT            NOT NULL,
    [DescriptionCz]  NVARCHAR (150) NOT NULL,
    [DescriptionEng] NVARCHAR (150) NOT NULL,
    [IsSent]         BIT            CONSTRAINT [DF_cdlReturnValues_IsSent] DEFAULT ((0)) NOT NULL,
    [SentDate]       DATETIME       NULL,
    [IsActive]       BIT            CONSTRAINT [DF_cdlReturnValues_IsActive] DEFAULT ((1)) NOT NULL,
    [ModifyDate]     DATETIME       CONSTRAINT [DF_cdlReturnValues_ModifyDate] DEFAULT (getdate()) NOT NULL,
    [ModifyUserId]   INT            CONSTRAINT [DF_cdlReturnValues_ModifyUserId] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_cdlReturnValues] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 85)
);

