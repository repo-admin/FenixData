CREATE TABLE [dbo].[SkladPolozkyHeliosPomoc] (
    [SkupZbo]       NVARCHAR (3)   NOT NULL,
    [RegCis]        NVARCHAR (30)  NOT NULL,
    [Nazev1]        NVARCHAR (100) NOT NULL,
    [MJ]            NVARCHAR (10)  NULL,
    [itemType]      NCHAR (3)      NULL,
    [Packaging]     INT            NULL,
    [ItemTypeDesc1] NVARCHAR (50)  NULL,
    [ItemTypeDesc2] NVARCHAR (50)  NULL,
    [ItemTypeId]    INT            NULL
);

