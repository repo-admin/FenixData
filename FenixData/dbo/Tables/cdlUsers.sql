CREATE TABLE [dbo].[cdlUsers] (
    [ID]           INT            IDENTITY (1, 1) NOT NULL,
    [ZiCyzId]      INT            NOT NULL,
    [FirstName]    NVARCHAR (50)  NOT NULL,
    [LastName]     NVARCHAR (50)  NOT NULL,
    [LogOn]        VARCHAR (50)   NOT NULL,
    [Description]  NVARCHAR (MAX) NULL,
    [IsActive]     BIT            CONSTRAINT [DF_cdlUsers_IsActive] DEFAULT ((1)) NOT NULL,
    [ModifyDate]   DATETIME       CONSTRAINT [DF_cdlUsers_ModifyDate] DEFAULT (getdate()) NOT NULL,
    [ModifyUserId] INT            CONSTRAINT [DF_cdlUsers_ModifyUserId] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_cdlUsers] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 85)
);

