CREATE TABLE [dbo].[FenixHeliosObjPol] (
    [ID]            INT             NOT NULL,
    [IDDoklad]      INT             NOT NULL,
    [SkupZbo]       NVARCHAR (3)    NOT NULL,
    [RegCis]        NVARCHAR (30)   NOT NULL,
    [Nazev1]        NVARCHAR (100)  NOT NULL,
    [MJ]            NVARCHAR (10)   NULL,
    [MJEvidence]    NVARCHAR (10)   NULL,
    [Mnozstvi]      NUMERIC (19, 6) NOT NULL,
    [ItemTypeDesc1] NVARCHAR (50)   NULL,
    [ItemTypeDesc2] NVARCHAR (50)   NULL,
    [IsActive]      BIT             CONSTRAINT [DF_FenixHeliosObjPol_IsActive] DEFAULT ((1)) NOT NULL,
    [ModifyDate]    DATETIME        CONSTRAINT [DF_FenixHeliosObjPol_MidifyDate] DEFAULT (getdate()) NULL,
    CONSTRAINT [PK_FenixHeliosObjPol] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 85)
);


GO
CREATE TRIGGER [dbo].[trFenixHeliosObjPolUpd]
   ON  dbo.FenixHeliosObjPol
   AFTER UPDATE
AS 
BEGIN
-- =============================================
-- Author:		   Weczerek
-- Create date:   2014-10-15
-- Description:	
-- =============================================
	SET NOCOUNT ON;


INSERT INTO [dbo].[A_FenixHeliosObjPol]
           ([ID]
           ,[IDDoklad]
           ,[SkupZbo]
           ,[RegCis]
           ,[Nazev1]
           ,[MJ]
           ,[MJEvidence]
           ,[Mnozstvi]
           ,[ItemTypeDesc1]
           ,[ItemTypeDesc2]
)
            SELECT [ID]
           ,[IDDoklad]
           ,[SkupZbo]
           ,[RegCis]
           ,[Nazev1]
           ,[MJ]
           ,[MJEvidence]
           ,[Mnozstvi]
           ,[ItemTypeDesc1]
           ,[ItemTypeDesc2]
FROM deleted

END
