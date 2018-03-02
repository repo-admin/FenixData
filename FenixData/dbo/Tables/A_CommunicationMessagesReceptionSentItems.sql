CREATE TABLE [dbo].[A_CommunicationMessagesReceptionSentItems] (
    [A_ID]                  INT             IDENTITY (1, 1) NOT NULL,
    [ID]                    INT             NULL,
    [CMSOId]                INT             NOT NULL,
    [HeliosOrderId]         INT             NULL,
    [HeliosOrderRecordId]   INT             NULL,
    [ItemId]                INT             NOT NULL,
    [GroupGoods]            NVARCHAR (3)    NOT NULL,
    [ItemCode]              NVARCHAR (50)   NOT NULL,
    [ItemDescription]       NVARCHAR (500)  NOT NULL,
    [ItemQuantity]          NUMERIC (18, 3) NOT NULL,
    [ItemQuantityDelivered] NUMERIC (18, 3) NULL,
    [MeasuresID]            INT             NOT NULL,
    [ItemUnitOfMeasure]     NVARCHAR (50)   NOT NULL,
    [ItemQualityId]         INT             NULL,
    [ItemQualityCode]       NVARCHAR (50)   NULL,
    [SourceId]              INT             NULL,
    [IsActive]              BIT             NOT NULL,
    [ModifyDate]            DATETIME        NOT NULL,
    [ModifyUserId]          INT             NOT NULL,
    [A_ModifyDate]          DATETIME        CONSTRAINT [DF_A_CommunicationMessagesReceptionSentItems_ModifyDate] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_A_CommunicationMessagesReceptionSentItems] PRIMARY KEY CLUSTERED ([A_ID] ASC) WITH (FILLFACTOR = 85)
);

