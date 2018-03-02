CREATE TABLE [dbo].[A_CommunicationMessagesReturnedShipmentItems] (
    [A_ID]                 INT           IDENTITY (1, 1) NOT NULL,
    [ID]                   INT           NOT NULL,
    [CMSOId]               INT           NOT NULL,
    [ItemOrKitQualityId]   INT           NOT NULL,
    [ItemOrKitQualityCode] NVARCHAR (50) NOT NULL,
    [IncotermsId]          INT           NULL,
    [IncotermDescription]  NVARCHAR (50) NULL,
    [KitSNs]               VARCHAR (MAX) NULL,
    [IsActive]             BIT           NOT NULL,
    [ModifyDate]           DATETIME      NOT NULL,
    [ModifyUserId]         INT           NOT NULL,
    [A_ModifyDate]         DATETIME      CONSTRAINT [DF_A_CommunicationMessagesReturnedShipmentItems_A_ModifyDate] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_A_CommunicationMessagesReturnedShipmentItems] PRIMARY KEY CLUSTERED ([A_ID] ASC) WITH (FILLFACTOR = 85)
);

