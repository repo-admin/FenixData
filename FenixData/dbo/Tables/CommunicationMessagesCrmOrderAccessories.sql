CREATE TABLE [dbo].[CommunicationMessagesCrmOrderAccessories] (
    [ID]            INT           IDENTITY (1, 1) NOT NULL,
    [WO_PR_NUMBER]  NVARCHAR (20) NOT NULL,
    [AccessoryCode] NVARCHAR (30) NOT NULL,
    [IsActive]      BIT           DEFAULT ((1)) NOT NULL,
    [ModifyDate]    DATETIME      DEFAULT (getdate()) NOT NULL,
    [ModifyUserID]  INT           DEFAULT ((0)) NOT NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC) WITH (FILLFACTOR = 85)
);

