CREATE TABLE [dbo].[CommunicationMessagesCrmOrderItems] (
    [ID]                        INT             IDENTITY (1, 1) NOT NULL,
    [CommunicationMessageID]    INT             NOT NULL,
    [L_ITEM_VER_KIT]            BIT             DEFAULT ((0)) NOT NULL,
    [L_ITEM_OR_KIT_ID]          INT             NOT NULL,
    [L_ITEM_OR_KIT_DESCRIPTION] NVARCHAR (100)  NOT NULL,
    [L_ITEM_OR_KIT_QUALITY]     NVARCHAR (50)   NOT NULL,
    [L_ITEM_OR_KIT_QUALITY_ID]  INT             NOT NULL,
    [L_ITEM_OR_KIT_QUANTITY]    NUMERIC (18, 3) NOT NULL,
    [L_ITEM_OR_KIT_MEASURE_ID]  INT             NOT NULL,
    [L_ITEM_OR_KIT_MEASURE]     NVARCHAR (250)  NOT NULL,
    [IsActive]                  BIT             DEFAULT ((1)) NOT NULL,
    [ModifyDate]                DATETIME        NOT NULL,
    [ModifyUserID]              INT             DEFAULT ((0)) NOT NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 85),
    FOREIGN KEY ([CommunicationMessageID]) REFERENCES [dbo].[CommunicationMessagesCrmOrder] ([ID])
);

