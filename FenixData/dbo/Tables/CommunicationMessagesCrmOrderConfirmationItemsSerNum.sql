CREATE TABLE [dbo].[CommunicationMessagesCrmOrderConfirmationItemsSerNum] (
    [ID]                          INT           IDENTITY (1, 1) NOT NULL,
    [CrmOrderConfirmationItemsID] INT           NOT NULL,
    [SN1]                         NVARCHAR (20) NULL,
    [SN2]                         NVARCHAR (20) NULL,
    [IsActive]                    BIT           DEFAULT ((1)) NOT NULL,
    [ModifyDate]                  DATETIME      NOT NULL,
    [ModifyUserID]                INT           DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_CommunicationMessagesCrmOrderConfirmationItemsSerNum] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 85),
    FOREIGN KEY ([CrmOrderConfirmationItemsID]) REFERENCES [dbo].[CommunicationMessagesCrmOrderConfirmationItems] ([ID])
);

