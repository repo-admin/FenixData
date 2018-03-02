

CREATE VIEW [dbo].[vwListTheirMessage]
AS
SELECT * FROM
(
SELECT ID,[MessageId],'R1' AS x,[ModifyDate] DatumPrijmuMessage FROM [dbo].[CommunicationMessagesReceptionConfirmation]
UNION ALL
SELECT ID,[MessageId],'RF1' AS x,[ModifyDate] DatumPrijmuMessage FROM [dbo].[CommunicationMessagesRefurbishedOrderConfirmation]
UNION ALL
SELECT ID,[MessageId],'S1' AS x,[ModifyDate] DatumPrijmuMessage FROM [dbo].[CommunicationMessagesShipmentOrdersConfirmation]
UNION ALL
SELECT ID,[MessageId],'K1' AS x,[ModifyDate] DatumPrijmuMessage FROM [dbo].[CommunicationMessagesKittingsConfirmation]
UNION ALL
SELECT ID,[MessageId],'VR1' AS x,[ModifyDate] DatumPrijmuMessage FROM [dbo].[CommunicationMessagesReturn]
UNION ALL
SELECT ID,[MessageId],'VR2' AS x,[ModifyDate] DatumPrijmuMessage  FROM [dbo].[CommunicationMessagesReturnedItem]
UNION ALL
SELECT ID,[MessageId],'VR3' AS x,[ModifyDate] DatumPrijmuMessage  FROM [dbo].[CommunicationMessagesReturnedShipment]
) xx --ORDER BY 2


