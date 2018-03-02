CREATE TABLE [dbo].[SparePartsExport] (
    [ID]           INT      IDENTITY (1, 1) NOT NULL,
    [ItemOrKitID]  INT      NOT NULL,
    [IsActive]     BIT      CONSTRAINT [DF__SparePartsExport__IsActive] DEFAULT ((1)) NOT NULL,
    [ModifyDate]   DATETIME CONSTRAINT [DF__SparePartsExport__InsertedOn] DEFAULT (getdate()) NOT NULL,
    [ModifyUserId] INT      CONSTRAINT [DF__SparePartsExport__ModifyUserId] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK__SparePartsExport] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 85)
);

