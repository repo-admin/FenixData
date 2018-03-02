CREATE VIEW vwCPESerialNumbers
AS
			SELECT RC.[ID]                              AS ID
						,RC.[MessageId]                       AS MessageId
						,RC.[MessageTypeId]                   AS MessageTypeId
						,RC.[MessageDescription]              AS MessageDescription
						,RC.[MessageDateOfReceipt]            AS MessageDateOfReceipt 
						,RC.[CommunicationMessagesSentId]     AS CommunicationMessagesSentId
						,RC.[ItemSupplierId]                  AS ItemSupplierId
						,RC.[ItemSupplierDescription]         AS ItemSupplierDescription 
						,RC.[Reconciliation]						      AS Reconciliation
						,RC.[ModifyDate]                      AS ModifyDate
						,RCI.[ID]                             AS ItemID
						,RCI.[CMSOId]                         AS CMSOId
						,ITEMS.[DescriptionCz]                AS ItemDescription 
						,RCI.[ItemQuantity]                   AS ItemQuantity
						--,RCI.[ItemSNs]                        AS ItemSNs  
						,RCI.ModifyDate                       AS ItemModifyDate
						,f.SN                                 AS SN 
						,ITYPES.Code                          AS ItemTypeCode
						,RCI.[SNExportedFlag]                 AS SNExportedFlag
						,RCI.[SNExportedDate]									AS SNExportedDate
			FROM [dbo].[CommunicationMessagesReceptionConfirmation] RC
			LEFT OUTER JOIN [dbo].[CommunicationMessagesReceptionConfirmationItems] RCI
					ON RC.ID = RCI.CMSOId
			LEFT OUTER JOIN [dbo].[CommunicationMessagesReceptionSent] RS
					ON RC.[CommunicationMessagesSentId] = RS.[ID]
			LEFT OUTER JOIN [dbo].[CommunicationMessagesReceptionSentItems] RSI
					ON RS.ID = RSI.CMSOId
			LEFT OUTER JOIN [dbo].[cdlItems] ITEMS
					ON RSI.ItemID = ITEMS.[ID]
			LEFT OUTER JOIN [dbo].[cdlItemTypes] ITYPES
					ON ITEMS.[ItemTypesId] = ITYPES.[ID]
			CROSS APPLY [dbo].[fnCPESerialNumbersToTable](RCI.ID) f			
			WHERE RC.IsActive = 1 AND RCI.IsActive = 1
						AND RC.Reconciliation = 1 
						AND ITYPES.Code = 'CPE' AND RCI.SNExportedFlag = 0


GO
GRANT SELECT
    ON OBJECT::[dbo].[vwCPESerialNumbers] TO [mis]
    AS [dbo];

