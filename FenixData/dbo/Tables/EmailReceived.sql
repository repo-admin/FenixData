CREATE TABLE [dbo].[EmailReceived] (
    [ID]                     INT             IDENTITY (1, 1) NOT NULL,
    [Type]                   NVARCHAR (40)   NOT NULL,
    [EmailSubject]           NVARCHAR (2048) NOT NULL,
    [EmailParsedSubject]     NVARCHAR (2048) NOT NULL,
    [EmailParsedSubjectHash] VARCHAR (128)   NOT NULL,
    [EmailMessage]           NVARCHAR (MAX)  NULL,
    [EmailFrom]              NVARCHAR (1024) NULL,
    [Source]                 NVARCHAR (200)  NULL,
    [IsExternal]             BIT             DEFAULT ((1)) NOT NULL,
    [IsActive]               BIT             CONSTRAINT [DF__EmailReceived__IsActive] DEFAULT ((1)) NOT NULL,
    [ModifyDate]             DATETIME        CONSTRAINT [DF__EmailReceived__InsertedOn] DEFAULT (getdate()) NOT NULL,
    [ModifyUserId]           INT             CONSTRAINT [DF__EmailReceived__ModifyUserId] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK__EmailReceived] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 85)
);


GO
CREATE NONCLUSTERED INDEX [IDX_EmailParsedSubjectHash]
    ON [dbo].[EmailReceived]([EmailParsedSubjectHash] ASC) WITH (FILLFACTOR = 85);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Typ uloženého emailu {''FenixAutomat''}', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'EmailReceived', @level2type = N'COLUMN', @level2name = N'Type';

