CREATE TABLE [dbo].[TableComments] (
    [id]            INT            NOT NULL,
    [TableName]     NVARCHAR (100) NOT NULL,
    [TableRecordId] INT            NOT NULL,
    [Comment]       NVARCHAR (MAX) NOT NULL,
    [EditDate]      DATETIME       CONSTRAINT [DF_TableComments_EditDate] DEFAULT (getdate()) NOT NULL,
    [Author]        NVARCHAR (50)  NOT NULL,
    CONSTRAINT [PK_TableComments] PRIMARY KEY CLUSTERED ([id] ASC) WITH (FILLFACTOR = 85)
);

