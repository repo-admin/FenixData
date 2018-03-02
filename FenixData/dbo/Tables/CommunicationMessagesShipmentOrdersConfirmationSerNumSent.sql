CREATE TABLE [dbo].[CommunicationMessagesShipmentOrdersConfirmationSerNumSent] (
    [ID]                          INT           IDENTITY (1, 1) NOT NULL,
    [ShipmentOrdersItemsOrKitsID] INT           NOT NULL,
    [SN1]                         NVARCHAR (20) NULL,
    [SN2]                         NVARCHAR (20) NULL,
    [IsActive]                    BIT           NOT NULL,
    [ModifyDate]                  DATETIME      NOT NULL,
    [ModifyUserId]                INT           NOT NULL,
    CONSTRAINT [PK_CommunicationMessagesShipmentOrdersConfirmationSerNumSent] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 85)
);

