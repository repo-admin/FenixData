CREATE TABLE [dbo].[A_cdlDestinationPlacesContacts] (
    [A_ID]                INT            IDENTITY (1, 1) NOT NULL,
    [ID]                  INT            NULL,
    [DestinationPlacesId] INT            NULL,
    [PhoneNumber]         NVARCHAR (15)  NULL,
    [FirstName]           NVARCHAR (35)  NULL,
    [LastName]            NVARCHAR (35)  NULL,
    [Title]               CHAR (1)       NULL,
    [ContactName]         NVARCHAR (150) NULL,
    [ContactEmail]        NVARCHAR (150) NULL,
    [Type]                NCHAR (10)     NULL,
    [IsSent]              BIT            NULL,
    [SentDate]            DATETIME       NULL,
    [IsActive]            BIT            NOT NULL,
    [ModifyDate]          DATETIME       NOT NULL,
    [ModifyUserId]        INT            NOT NULL,
    [A_ModifyDate]        DATETIME       CONSTRAINT [DF_A_cdlDestinationPlaceContacts_A_ModifyDate] DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_A_cdlDestinationPlaceContacts] PRIMARY KEY CLUSTERED ([A_ID] ASC) WITH (FILLFACTOR = 85)
);

