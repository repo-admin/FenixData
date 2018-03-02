
CREATE VIEW [dbo].[vwListOurMessage]
AS
SELECT * FROM
(
SELECT ID,[MessageId],'R0' AS x,[MessageDateOfShipment] DatumOdeslani FROM [dbo].[CommunicationMessagesReceptionSent]
UNION ALL
SELECT ID,[MessageId],'S0' AS x,[MessageDateOfShipment] DatumOdeslani FROM [dbo].[CommunicationMessagesShipmentOrdersSent]
UNION ALL
SELECT ID,[MessageId],'K0' AS x,[MessageDateOfShipment] DatumOdeslani FROM [dbo].[CommunicationMessagesKittingsSent]
UNION ALL
SELECT ID,[MessageId],'RF0' AS x,[MessageDateOfShipment] DatumOdeslani FROM [dbo].[CommunicationMessagesRefurbishedOrder]
UNION ALL
SELECT ID,[MessageId],'KApproval' AS x,[MessageDateOfShipment] DatumOdeslani  FROM [dbo].[CommunicationMessagesKittingsApprovalSent]
) xx --ORDER BY 2

