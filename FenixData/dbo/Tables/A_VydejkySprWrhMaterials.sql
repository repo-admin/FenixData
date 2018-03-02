CREATE TABLE [dbo].[A_VydejkySprWrhMaterials] (
    [A_ID]               INT          IDENTITY (1, 1) NOT NULL,
    [ID]                 INT          NOT NULL,
    [RequiredQuantities] DECIMAL (18) NOT NULL,
    [SuppliedQuantities] DECIMAL (18) NOT NULL,
    [IssueType]          INT          NOT NULL,
    [IdWf]               INT          NOT NULL,
    [MaterialCode]       INT          NOT NULL,
    [Subscribers]        INT          NOT NULL,
    [SubscribersContact] INT          NOT NULL,
    [Done]               BIT          NOT NULL,
    [DateStamp]          DATETIME     NOT NULL,
    [Hit]                BIT          NULL,
    [IsActive]           BIT          CONSTRAINT [DF_A_VydejkySprWrhMaterials_IsActive] DEFAULT ((1)) NOT NULL,
    [MessageId]          INT          NULL,
    [DeliveryDate]       DATETIME     NULL,
    [S0Id]               INT          NULL,
    [S1Id]               INT          NULL,
    [A_ModifyDate]       DATETIME     CONSTRAINT [DF_A_VydejkySprWrhMaterials_A_ModifyDate] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_A_VydejkySprWrhMaterials] PRIMARY KEY CLUSTERED ([A_ID] ASC) WITH (FILLFACTOR = 85)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'oznacuje typ vydejky  0...výstavba, 1...logistika', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'A_VydejkySprWrhMaterials', @level2type = N'COLUMN', @level2name = N'IssueType';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'0... meaktivni, 1...aktivní', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'A_VydejkySprWrhMaterials', @level2type = N'COLUMN', @level2name = N'IsActive';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'messageId NAŠE', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'A_VydejkySprWrhMaterials', @level2type = N'COLUMN', @level2name = N'MessageId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'požadované datum dodání', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'A_VydejkySprWrhMaterials', @level2type = N'COLUMN', @level2name = N'DeliveryDate';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'ID S0hlavicky', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'A_VydejkySprWrhMaterials', @level2type = N'COLUMN', @level2name = N'S0Id';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'S1 hlavicky', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'A_VydejkySprWrhMaterials', @level2type = N'COLUMN', @level2name = N'S1Id';

