CREATE TABLE [dbo].[CommunicationMessagesCrmOrderApprovalItemsSerNum] (
    [ID]                      INT           IDENTITY (1, 1) NOT NULL,
    [CrmOrderApprovalItemsID] INT           NOT NULL,
    [SN1]                     NVARCHAR (20) NULL,
    [SN2]                     NVARCHAR (20) NULL,
    [IsActive]                BIT           DEFAULT ((1)) NOT NULL,
    [ModifyDate]              DATETIME      NOT NULL,
    [ModifyUserID]            INT           DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_CommunicationMessagesCrmOrderApprovalItemsSerNum] PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 85),
    FOREIGN KEY ([CrmOrderApprovalItemsID]) REFERENCES [dbo].[CommunicationMessagesCrmOrderApprovalItems] ([ID])
);

