CREATE VIEW [dbo].[vwDeleteMessage]
AS
-- =============================================================================================================
-- Description  : zobrazuje Přehled smazaných zpráv - odeslaných (D0)
-- Created by   : Rezler Michal
-- Created date : 
-- Edited date  : 2015-11-25  M. Rezler
--                2015-12-17  M. Rezler odstraněna chyba v joinu tabulek [CommunicationMessagesDeleteMessage]
--                            a [CommunicationMessagesDeleteMessageConfirmation]
-- =============================================================================================================
SELECT T.[ID]
      ,T.[MessageId]
      ,T.[DeleteId]
      ,T.[DeleteMessageId]
      ,T.[DeleteMessageTypeId]
      ,T.[DeleteMessageTypeDescription]      
      ,T.[SentDate]
			,T.[DeleteMessageDate]
      ,T.[SentUserId]
      ,T.[IsActive]
      ,T.[ModifyDate]
      ,T.[ModifyUserId]
			,T.[Source]			
			,T.[Notice]
			,CASE WHEN zicUser.ZC_ID IS NULL THEN ' ' ELSE zicUser.LAST_NAME END	as 'DeletedByUserLastName'
			,CASE WHEN zicUser.ZC_ID IS NULL THEN ' ' ELSE zicUser.FIRST_NAME END as 'DeletedByUserFirstName'
FROM 
(
	SELECT DM.ID + [dbo].[fnGetDeleteMessageSentIdMax]() AS [ID]
				,DM.[MessageId]
				,DM.[DeleteId]
				,DM.[DeleteMessageId]
				,DM.[DeleteMessageTypeId]
				,DM.[DeleteMessageTypeDescription]				
				,DM.[SentDate]
				,DMC.DeleteMessageDate AS [DeleteMessageDate]
				,DM.[SentUserId]
				,DM.[IsActive]
				,DM.[ModifyDate]
				,DM.[ModifyUserId]
				,'XML' as [Source]
				,DM.[Notice]				
	FROM [dbo].[CommunicationMessagesDeleteMessage] DM
	LEFT OUTER JOIN [dbo].[CommunicationMessagesDeleteMessageConfirmation] DMC
			ON DMC.DeleteMessageId = DM.MessageId

	UNION ALL

	SELECT [ID]
				,[MessageId]
				,[DeleteId]
				,[DeleteMessageId]
				,[DeleteMessageTypeId]
				,[DeleteMessageDescription]				
				,[SentDate]
				,[ReceivedDate] AS [DeleteMessageDate]
				,[SentUserId]
				,[IsActive]
				,[ModifyDate]
				,[ModifyUserId]
				,'Email' as [Source]
				,[Notice]
	FROM [dbo].[DeleteMessageSent]
) T

LEFT OUTER JOIN (SELECT [ZC_ID], [LAST_NAME], [FIRST_NAME] FROM zicyz.dbo.VW_EMPLOYEES) zicUser
			ON T.[ModifyUserId] = zicUser.ZC_ID

