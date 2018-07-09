CREATE TABLE [dbo].[CommunicationMessagesCrmOrderConfirmation] (
    [ID]                    INT             IDENTITY (1, 1) NOT NULL,
    [MessageID]             INT             NOT NULL,
    [MessageTypeID]         INT             NOT NULL,
    [MessageDescription]    NVARCHAR (50)   NOT NULL,
    [MessageDateOfShipment] DATETIME        NOT NULL,
    [CrmOrderID]            INT             NOT NULL,
    [X_SHIPMENT_REAL]       DATETIME        NOT NULL,
    [X_PARCEL_NUMBER]       NVARCHAR (100)  NOT NULL,
    [X_PARCEL_WEIGHT]       NUMERIC (18, 3) NULL,
    [X_DELIVERY]            BIT             NULL,
    [X_RECONCILIATION]      INT             DEFAULT ((0)) NOT NULL,
    [IsActive]              BIT             DEFAULT ((1)) NOT NULL,
    [ModifyDate]            DATETIME        NOT NULL,
    [ModifyUserID]          INT             DEFAULT ((0)) NOT NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 85),
    FOREIGN KEY ([MessageTypeID]) REFERENCES [dbo].[cdlMessageTypes] ([ID])
);

