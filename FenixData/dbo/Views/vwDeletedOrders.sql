
CREATE VIEW [dbo].[vwDeletedOrders]
AS

/*
-- ==================================================================================================================
-- Description  : zobrazuje Deleted Orders (Zrušené/smazané objednávky), pro které přišlo emailové potvrzení z ND/XPO
-- Created by   : Rezler Michal
-- Created date : 2015-08-26
-- Edited date  : 
-- ==================================================================================================================
*/

SELECT IM.[ID]
      ,IM.[MessageId]
      ,IM.[MessageTypeId]
      ,IM.[MessageDescription]
      ,IM.[MessageStatusId]
      ,IM.[DeleteId]
      ,IM.[DeleteMessageId]
      ,IM.[DeleteMessageTypeId]
      ,IM.[DeleteMessageDescription]
      ,IM.[Notice]
      ,IM.[SentDate]
      ,IM.[SentUserId]
      ,IM.[ReceivedDate]
      ,IM.[ReceivedUserId]
      ,IM.[IsActive]
      ,IM.[ModifyDate]
      ,IM.[ModifyUserId]
			,CASE WHEN zicUser.ZC_ID IS NULL THEN ' ' ELSE zicUser.LAST_NAME END	as 'DeletedUserLastName'
			,CASE WHEN zicUser.ZC_ID IS NULL THEN ' ' ELSE zicUser.FIRST_NAME END as 'DeletedUserFirstName'
  FROM [dbo].[DeleteMessageSent] IM
	LEFT OUTER JOIN (SELECT [ZC_ID], [LAST_NAME], [FIRST_NAME] FROM zicyz.dbo.VW_EMPLOYEES) zicUser
			ON IM.[ModifyUserId] = zicUser.ZC_ID
	WHERE IM.IsActive = 1
		AND IM.[MessageStatusId] = 12

