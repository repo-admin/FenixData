CREATE VIEW [dbo].[vwDeleteMessageConfirmation]
AS
-- =============================================================================================================
-- Description  : zobrazuje Přehled smazaných zpráv - přijatých (D1)
-- Created by   : Rezler Michal
-- Created date : 
-- Edited date  : 2015-11-27  M. Rezler
-- =============================================================================================================
SELECT T.[ID]
      ,T.[MessageId]      
      ,T.[DeleteId] 
      ,T.[DeleteMessageId]
			,T.[DeleteMessageDate]
			,T.[DeleteMessageTypeDescription]			      
      ,T.[SentDate]
      ,T.[IsActive]
      ,T.[ModifyDate]
      ,T.[ModifyUserId]
			,T.[Source]
			,T.[Notice]
FROM
(
	SELECT DMC.ID + [dbo].[fnGetDeleteMessageSentIdMax]() AS [ID]      
				,DMC.[MessageId]

				,DM.[DeleteId] 
				,DM.[DeleteMessageId]

				,DMC.[DeleteMessageDate]      
				,DMC.[SentDate]
			  ,DM.[DeleteMessageTypeDescription]
				,DMC.[IsActive]
				,DMC.[ModifyDate]
				,DMC.[ModifyUserId]
				,'XML' as [Source]
				,DMC.[Notice]
	FROM [dbo].[CommunicationMessagesDeleteMessageConfirmation] DMC
	INNER JOIN [dbo].[CommunicationMessagesDeleteMessage] DM
		ON DM.Id = DMC.DeleteId AND DM.MessageId = DMC.DeleteMessageId

	UNION ALL

	SELECT [ID]
				,[MessageId]      
				,[DeleteId]
				,[DeleteMessageId]
				,[ReceivedDate] AS [DeleteMessageDate]			      
				,[SentDate]
				,[DeleteMessageDescription] AS 'DeleteMessageTypeDescription'
				,[IsActive]
				,[ModifyDate]
				,[ModifyUserId]
				,'Email' as [Source]
				,[Notice]
	FROM [dbo].[DeleteMessageSent]
) T
