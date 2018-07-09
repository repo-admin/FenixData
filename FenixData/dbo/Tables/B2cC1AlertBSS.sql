CREATE TABLE [dbo].[B2cC1AlertBSS] (
    [ID]             INT           NOT NULL,
    [WO_CID]         INT           NOT NULL,
    [WO_PHONE]       NVARCHAR (20) NOT NULL,
    [Insert_date]    DATETIME      DEFAULT (getdate()) NOT NULL,
    [Take_over_BSS]  BIT           DEFAULT ((0)) NOT NULL,
    [Take_over_date] DATETIME      NULL,
    [Sent_by_BSS]    BIT           DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_B2cC1AlertBSS] PRIMARY KEY CLUSTERED ([ID] ASC)
);

