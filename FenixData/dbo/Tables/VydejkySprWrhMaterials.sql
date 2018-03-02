CREATE TABLE [dbo].[VydejkySprWrhMaterials] (
    [Id]                 INT          IDENTITY (1, 1) NOT NULL,
    [RequiredQuantities] DECIMAL (18) NOT NULL,
    [SuppliedQuantities] DECIMAL (18) CONSTRAINT [DF_VydejkySprWrhMaterials_SuppliedQuantities] DEFAULT ((0)) NOT NULL,
    [IssueType]          INT          NOT NULL,
    [IdWf]               INT          NOT NULL,
    [MaterialCode]       INT          NOT NULL,
    [Subscribers]        INT          NOT NULL,
    [SubscribersContact] INT          NOT NULL,
    [Done]               BIT          CONSTRAINT [DF_VydejkySprWrhMaterials_Done] DEFAULT ((0)) NOT NULL,
    [DateStamp]          DATETIME     CONSTRAINT [DF_VydejkySprWrhMaterials_DateStamp] DEFAULT (getdate()) NOT NULL,
    [Hit]                BIT          NULL,
    [IsActive]           BIT          CONSTRAINT [DF_VydejkySprWrhMaterials_IsActive] DEFAULT ((1)) NOT NULL,
    [MessageId]          INT          NULL,
    [DeliveryDate]       DATETIME     NOT NULL,
    [S0Id]               INT          NULL,
    [S1Id]               INT          NULL,
    CONSTRAINT [PK_VydejkySprWrhMaterials] PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 85)
);


GO



CREATE  TRIGGER [dbo].[trVydejkySprWrhMaterialsUpd]
   ON  [dbo].[VydejkySprWrhMaterials] 
   AFTER UPDATE, DELETE
AS 
BEGIN
-- =============================================
-- Author:		   Weczerek
-- Create date:   2014-11-14
-- Updated date:  2015-10-21
-- Description:	
-- =============================================
SET NOCOUNT ON;

INSERT INTO [dbo].[A_VydejkySprWrhMaterials]
           ([ID]
           ,[RequiredQuantities]
           ,[SuppliedQuantities]
           ,[IssueType]
           ,[IdWf]
           ,[MaterialCode]
           ,[Subscribers]
           ,[SubscribersContact]
           ,[Done]
           ,[DateStamp]
           ,[Hit]
           ,[IsActive]
           ,[MessageId]
           ,[DeliveryDate]
           ,[S0Id]
           ,[S1Id]
)     

     SELECT [ID]
           ,[RequiredQuantities]
           ,[SuppliedQuantities]
           ,[IssueType]
           ,[IdWf]
           ,[MaterialCode]
           ,[Subscribers]
           ,[SubscribersContact]
           ,[Done]
           ,[DateStamp]
           ,[Hit]
           ,[IsActive]
           ,[MessageId]
           ,[DeliveryDate]
           ,[S0Id]
           ,[S1Id]
FROM DELETED


END




GO
GRANT INSERT
    ON OBJECT::[dbo].[VydejkySprWrhMaterials] TO [VydejkySprRWD]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[VydejkySprWrhMaterials] TO [VydejkySprRWD]
    AS [dbo];


GO
GRANT UPDATE
    ON OBJECT::[dbo].[VydejkySprWrhMaterials] TO [VydejkySprRWD]
    AS [dbo];


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'incremental id', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'VydejkySprWrhMaterials', @level2type = N'COLUMN', @level2name = N'Id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'pozadovane mnozstvi daneho materialu', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'VydejkySprWrhMaterials', @level2type = N'COLUMN', @level2name = N'RequiredQuantities';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'mnozstvi dodaneho materialu ND, nutno doplnit  ( pri zapisu z vydejek je vychozi hodnota 0)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'VydejkySprWrhMaterials', @level2type = N'COLUMN', @level2name = N'SuppliedQuantities';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'oznacuje typ vydejky', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'VydejkySprWrhMaterials', @level2type = N'COLUMN', @level2name = N'IssueType';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'oznacuje spolecny identifikator vydejkky (stejne cislo pro material prislusejici k jedne vydejce)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'VydejkySprWrhMaterials', @level2type = N'COLUMN', @level2name = N'IdWf';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'identifikator materialu z tabulky cdlItems', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'VydejkySprWrhMaterials', @level2type = N'COLUMN', @level2name = N'MaterialCode';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'ID z tabulky cdlDestinationPlaces oznacujici odbereate', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'VydejkySprWrhMaterials', @level2type = N'COLUMN', @level2name = N'Subscribers';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'ID z tabulky cdlDestinationPlacesContacts oznacujici kontakt odbereatele', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'VydejkySprWrhMaterials', @level2type = N'COLUMN', @level2name = N'SubscribersContact';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'oznacuje zda doslo k vyrizeni, nutno zadat hodnotu true pri vyrizeni  (vychozi hodnota false, )', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'VydejkySprWrhMaterials', @level2type = N'COLUMN', @level2name = N'Done';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'casove razitko', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'VydejkySprWrhMaterials', @level2type = N'COLUMN', @level2name = N'DateStamp';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'0... meaktivni, 1...aktivní', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'VydejkySprWrhMaterials', @level2type = N'COLUMN', @level2name = N'IsActive';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'messageId NAŠE', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'VydejkySprWrhMaterials', @level2type = N'COLUMN', @level2name = N'MessageId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'požadované datum dodání', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'VydejkySprWrhMaterials', @level2type = N'COLUMN', @level2name = N'DeliveryDate';

