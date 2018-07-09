CREATE TABLE [dbo].[CommunicationMessagesCrmOrderReturnedEquipmentParcelItemsSerNum] (
    [ID]                                     INT           IDENTITY (1, 1) NOT NULL,
    [CrmOrderReturnedEquipmentParcelItemsID] INT           NOT NULL,
    [SN1]                                    NVARCHAR (20) NULL,
    [SN2]                                    NVARCHAR (20) NULL,
    [IsActive]                               BIT           DEFAULT ((1)) NOT NULL,
    [ModifyDate]                             DATETIME      NOT NULL,
    [ModifyUserID]                           INT           DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_CommunicationMessagesCrmOrderReturnedEquipmentParcelItemsSerNum] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 85),
    FOREIGN KEY ([CrmOrderReturnedEquipmentParcelItemsID]) REFERENCES [dbo].[CommunicationMessagesCrmOrderReturnedEquipmentParcelItems] ([ID])
);

