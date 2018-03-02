CREATE TABLE [dbo].[TrrMessages] (
    [Id]                INT  IDENTITY (1, 1) NOT NULL,
    [MsgId]             INT  NOT NULL,
    [MsgType]           INT  NULL,
    [MsgXml]            XML  NULL,
    [MsgDateOfShipment] DATE NOT NULL,
    [CustomerId]        INT  NOT NULL,
    [DateOfDelivery]    DATE NOT NULL,
    [MsgStatus]         INT  NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC) WITH (FILLFACTOR = 85),
    FOREIGN KEY ([MsgStatus]) REFERENCES [dbo].[TrrMessageStatuses] ([Id]),
    FOREIGN KEY ([MsgType]) REFERENCES [dbo].[TrrMessageTypes] ([Id])
);

