CREATE PROCEDURE [dbo].[prDMD0SentIns] 
( 
       @DeleteId												int,
       @DeleteMessageId									int,
       @DeleteMessageTypeId							int,
       @DeleteMessageDescription				nvarchar(200),
			 @ModifyUserID							      int,
       @ReturnValue     int            = -1 OUTPUT,
       @ReturnMessage   nvarchar(2048) = null OUTPUT	  
) 
AS 
-- ===============================================================================================
-- Created by   : Rezler Michal
-- Created date : 2015-08-18
--                
-- Description  : 
-- Edited       : 2015-08-26 Rezler Michal  přidán parametr @ModifyUserID
-- ===============================================================================================

BEGIN 

DECLARE @myMessageId int
DECLARE @aktErr INT
DECLARE @errorMessage nvarchar(2048)

SET @aktErr = 0
SET @ReturnValue = 0

BEGIN TRANSACTION
    
    SELECT @myMessageId = [LastFreeNumber]  FROM [dbo].[cdlMessageNumber] WHERE CODE = 1
    UPDATE [dbo].[cdlMessageNumber] SET [LastFreeNumber] = [LastFreeNumber] + 1  WHERE CODE = 1

    IF (@aktErr = 0) 
		BEGIN
			SET @aktErr = @@ERROR
			SET @errorMessage = ISNULL(ERROR_MESSAGE(),'')
		END
    IF (@aktErr <> 0) GOTO ErrHandler

		INSERT INTO [dbo].[DeleteMessageSent]
							 ([MessageId], [MessageTypeId]
							 ,[MessageDescription], [MessageStatusId]
							 ,[DeleteId], [DeleteMessageId]
							 ,[DeleteMessageTypeId], [DeleteMessageDescription]
							 ,[Notice], [SentDate]
							 ,[SentUserId], [ReceivedDate]
							 ,[ReceivedUserId], [IsActive]
							 ,[ModifyDate], [ModifyUserId])
				 VALUES
							 (@myMessageId, 14
							 ,'DeleteMessageSent', 1
							 ,@DeleteId, @DeleteMessageId
							 ,@DeleteMessageTypeId, @DeleteMessageDescription
							 ,NULL, NULL 
							 ,NULL, NULL 
							 ,NULL, 1
							 ,getdate(), @ModifyUserID)
							 
    IF (@aktErr = 0) 
		BEGIN
			SET @aktErr = @@ERROR
			SET @errorMessage = ISNULL(ERROR_MESSAGE(),'')
		END
    IF (@aktErr <> 0) GOTO ErrHandler

  COMMIT TRANSACTION
    
  ErrHandler:

  IF (@aktErr <> 0)
  BEGIN
    ROLLBACK TRANSACTION      
  END

  SET @ReturnValue = @aktErr
	SET @ReturnMessage = @errorMessage

END



/*
USE [FenixRezlerTesty]
GO


					DECLARE @myMessageId int

          SELECT @myMessageId = [LastFreeNumber]  FROM [dbo].[cdlMessageNumber] WHERE CODE = 1
          UPDATE [dbo].[cdlMessageNumber] SET [LastFreeNumber] = [LastFreeNumber] + 1  WHERE CODE = 1



INSERT INTO [dbo].[DeleteMessageSent]
           ([MessageId]
           ,[MessageTypeId]
           ,[MessageDescription]
           ,[MessageStatusId]
           ,[DeleteId]
           ,[DeleteMessageId]
           ,[DeleteMessageTypeId]
           ,[DeleteMessageDescription]
           ,[Notice]
           ,[SentDate]
           ,[SentUserId]
           ,[ReceivedDate]
           ,[ReceivedUserId]
           ,[IsActive]
           ,[ModifyDate]
           ,[ModifyUserId])
     VALUES
           (<MessageId, int,>
           ,<MessageTypeId, int,>
           ,<MessageDescription, nvarchar(200),>
           ,<MessageStatusId, int,>
           ,<DeleteId, int,>
           ,<DeleteMessageId, int,>
           ,<DeleteMessageTypeId, int,>
           ,<DeleteMessageDescription, nvarchar(200),>
           ,<Notice, nvarchar(max),>
           ,<SentDate, datetime,>
           ,<SentUserId, int,>
           ,<ReceivedDate, datetime,>
           ,<ReceivedUserId, int,>
           ,<IsActive, bit,>
           ,<ModifyDate, datetime,>
           ,<ModifyUserId, int,>)
GO


*/
GO
GRANT EXECUTE
    ON OBJECT::[dbo].[prDMD0SentIns] TO [FenixW]
    AS [dbo];

