CREATE TABLE [dbo].[ProcedureDescriptions] (
    [id]          INT            NOT NULL,
    [Name]        VARCHAR (50)   NOT NULL,
    [Description] NVARCHAR (MAX) NOT NULL,
    [Stranka]     NVARCHAR (500) NULL,
    [Edit_Date]   SMALLDATETIME  NOT NULL
);

