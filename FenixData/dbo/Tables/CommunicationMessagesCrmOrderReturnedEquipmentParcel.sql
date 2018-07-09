CREATE TABLE [dbo].[CommunicationMessagesCrmOrderReturnedEquipmentParcel] (
    [ID]                          INT            IDENTITY (1, 1) NOT NULL,
    [CrmOrderReturnedEquipmentID] INT            NOT NULL,
    [X_PARCEL_NUMBER]             NVARCHAR (100) NOT NULL,
    [X_RETURNED_DATE]             DATETIME       NOT NULL,
    [IsActive]                    BIT            DEFAULT ((1)) NOT NULL,
    [ModifyDate]                  DATETIME       NOT NULL,
    [ModifyUserID]                INT            DEFAULT ((0)) NOT NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 85),
    FOREIGN KEY ([CrmOrderReturnedEquipmentID]) REFERENCES [dbo].[CommunicationMessagesCrmOrderReturnedEquipment] ([ID])
);

