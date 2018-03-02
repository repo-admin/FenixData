CREATE TABLE [dbo].[EmailSent] (
    [ID]               INT             IDENTITY (1, 1) NOT NULL,
    [Type]             NVARCHAR (40)   NOT NULL,
    [EmailSubject]     NVARCHAR (2048) CONSTRAINT [DF__EmailSent__EmailSubject] DEFAULT ('') NOT NULL,
    [EmailMessage]     NVARCHAR (MAX)  NULL,
    [EmailMessageHash] VARCHAR (128)   NOT NULL,
    [IsActive]         BIT             CONSTRAINT [DF__EmailSent__IsActive] DEFAULT ((1)) NOT NULL,
    [ModifyDate]       DATETIME        CONSTRAINT [DF__EmailSent__InsertedOn] DEFAULT (getdate()) NOT NULL,
    [ModifyUserId]     INT             CONSTRAINT [DF__EmailSent__ModifyUserId] DEFAULT ((0)) NOT NULL,
    [Source]           NVARCHAR (200)  NULL,
    [EmailFrom]        NVARCHAR (1024) NULL,
    [EmailTo]          NVARCHAR (1024) NULL,
    [EmbededPicture]   VARCHAR (1024)  NULL,
    [IsInternal]       BIT             DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK__EmailSent] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 85)
);


GO
CREATE NONCLUSTERED INDEX [IDX_EmailMessageHash]
    ON [dbo].[EmailSent]([EmailMessageHash] ASC) WITH (FILLFACTOR = 85);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Typ uloženého emailu {''FenixControl''}', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'EmailSent', @level2type = N'COLUMN', @level2name = N'Type';

