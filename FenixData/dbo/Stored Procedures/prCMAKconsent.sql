-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[prCMAKconsent] 

	@myKitOrderID AS INT =-1,  -- toto je id z tabulky [dbo].[CommunicationMessagesKittingsConfirmation], my musíme zpracovat tabulku [dbo].[CommunicationMessagesKittingsConfirmationItems]
	@Error      AS int            = -1 OUTPUT
AS
DECLARE @myDatabaseName  nvarchar(100)
BEGIN TRY
	SET NOCOUNT ON;
   SET @Error = 0
 
    SELECT @myDatabaseName = DB_NAME() 

   DECLARE @myID AS INT,@myCMSOId AS INT,@myKitID AS INT, @myKitDescription AS nvarchar(500)
          ,@myKitQuantity numeric (18,3),@myKitUnitOfMeasure nvarchar(50),@myKitQualityId as INT 
          ,@myKitSNs AS nvarchar(max)
          ,@myKitSNoba AS nvarchar(max)
          ,@myKitSN1 AS nvarchar(max)
          ,@myKitSN2 AS nvarchar(max)
          ,@myKeyRequiredReleaseDate AS DATETIME
          ,@myIdentity  AS   [int]
          ,@myError     AS   [int]
   SET @myError = 0
   DECLARE @myCardStockItemsId AS INT,@myKeyCardStockItemsId AS INT,
           @myIdentityKitSent  AS   [int],
           @myKitQuality       AS   [int],
           @FreeNumber         AS   [int],
           @MessageDescription AS   [nvarchar](500),
           @KitUnitOfMeasureID AS   [int],
           @KitUnitOfMeasure   AS   [nvarchar](500),
           @KitQualityId       AS   [int],
           @KitQuality         AS   [nvarchar](500),
           @KitDescription     AS   [nvarchar](500)

   SET @myKeyCardStockItemsId = -1
   SET @myKeyRequiredReleaseDate = GetDate()

   IF (SELECT CURSOR_STATUS('global','myCursorKittingsConfirmation')) >= -1
   BEGIN
             DEALLOCATE myCursorKittingsConfirmation
   END
--SELECT @myKitOrderID '@myKitOrderIDx'
   DECLARE myCursorKittingsConfirmation CURSOR 
   FOR SELECT  [ID],[CMSOId],[KitID],[KitDescription],[KitQuantity],[KitUnitOfMeasure],[KitQualityId],[KitSNs]   
       FROM [dbo].[CommunicationMessagesKittingsConfirmationItems] WHERE IsActive=1 AND CMSOId=@myKitOrderID  ORDER BY [CMSOId],[KitID]
 
   OPEN myCursorKittingsConfirmation
   FETCH NEXT FROM myCursorKittingsConfirmation INTO @myID, @myCMSOId, @myKitID, @myKitDescription ,@myKitQuantity,@myKitUnitOfMeasure,@myKitQualityId,@myKitSNs  
--SELECT @myID '@myID', @myCMSOId '@myCMSOId', @myKitID '@myKitID', @myKitDescription '@myKitDescription',@myKitQuantity '@myKitQuantity',@myKitUnitOfMeasure '@myKitUnitOfMeasure',@myKitQualityId '@myKitQualityId',@myKitSNs '@myKitSNs' 
   WHILE @@FETCH_STATUS = 0
   BEGIN -- FETCH_STATUS
        SELECT @myCardStockItemsId = Id  FROM [dbo].[CardStockItems] WHERE IsActive=1 AND [ItemOrKitId] = @myKitID
--SELECT @myCardStockItemsId '@myCardStockItemsId', @myKeyCardStockItemsId '@myKeyCardStockItemsId'
        IF @myCardStockItemsId <> @myKeyCardStockItemsId
        BEGIN
                      SELECT @KitUnitOfMeasureID=MeasuresId,@KitUnitOfMeasure = MeasuresCode, @KitQualityId = KitQualitiesId
                            ,@KitQuality = KitQualitiesCode, @KitDescription=DescriptionCz   FROM [dbo].[cdlKits] WHERE ID = @myKitID
                      SELECT @FreeNumber = [LastFreeNumber] FROM [dbo].[cdlMessageNumber]        WHERE [Code]=1 
                      UPDATE [dbo].[cdlMessageNumber] SET [LastFreeNumber] = @FreeNumber + 1     WHERE [Code]=1
                      SELECT @MessageDescription = [DescriptionEng] FROM [dbo].[cdlMessageTypes] WHERE [ID]  =5

                      INSERT INTO [dbo].[CommunicationMessagesKittingsApprovalSent]
                            ([MessageId]
                            ,[MessageTypeID]
                            ,[MessageDescription]
                            ,[MessageDateOfShipment]
                            ,[RequiredReleaseDate]
                            ,[HeliosOrderID]
                            ,[Released]
                            ,[IsActive]
                            ,[ModifyUserId])
                      VALUES
                            (@FreeNumber               -- <MessageId, int,>
                            ,5                         -- <MessageTypeID, int,>
                            ,@MessageDescription       -- <MessageDescription, nvarchar(200),>
                            ,NULL                      -- <MessageDateOfShipment, datetime,>
                            ,@myKeyRequiredReleaseDate -- <RequiredReleaseDate, datetime,>
                            ,NULL                      -- <HeliosOrderID, int,>
                            ,1                         -- Released     automaticky se bude posílat
                            ,1                         -- <IsActive, bit,>
                            ,0                         -- <ModifyUserId, int,>
                            )
                     SET @myError = @myError + @@ERROR
                     SET @myIdentity = @@IDENTITY

                     IF (@myError=0 AND @myIdentity>0) 
                     BEGIN
                     SELECT @myIdentity                       -- <ApprovalID, int,>
                                    ,@myKitID                          -- <KitID, int,>
                                    ,@KitDescription                   -- <KitDescription, nvarchar(500),>
                                    ,@myKitQuantity                    -- <KitQuantity, numeric(18,3),>
                                    ,@KitUnitOfMeasureID               -- KitUnitOfMeasureID
                                    ,@KitUnitOfMeasure                 -- <KitUnitOfMeasure, varchar(50),>
                                    ,@KitQualityId
                                    ,@KitQuality    


                         INSERT INTO [dbo].[CommunicationMessagesKittingsApprovalKitsSent]
                                    ([ApprovalID]
                                    ,[KitID]
                                    ,[KitDescription]
                                    ,[KitQuantity]
                                    ,[KitUnitOfMeasureID]
                                    ,[KitUnitOfMeasure]
                                    ,KitQualityId
                                    ,[KitQuality]
                                    ,[IsActive]
                                    ,[ModifyUserId])
                              VALUES
                                    (@myIdentity                       -- <ApprovalID, int,>
                                    ,@myKitID                          -- <KitID, int,>
                                    ,@KitDescription                   -- <KitDescription, nvarchar(500),>
                                    ,@myKitQuantity                    -- <KitQuantity, numeric(18,3),>
                                    ,@KitUnitOfMeasureID               -- KitUnitOfMeasureID
                                    ,@KitUnitOfMeasure                 -- <KitUnitOfMeasure, varchar(50),>
                                    ,@KitQualityId
                                    ,@KitQuality                       -- <KitQuality, int,>
                                    ,1                                 -- <IsActive, bit,>
                                    ,0 --<ModifyUserId, int,>
                                    )
                     SET @myError = @myError + @@ERROR
                     SET @myIdentityKitSent = @@IDENTITY
--SELECT @myError '@myError', @myIdentityKitSent '@myIdentityKitSent'

                     IF (@myError=0 AND @myIdentityKitSent>0) 
                     BEGIN
                         DECLARE @delka as int
                         SET @delka = LEN(@myKitSNs)   -- celkova delka všech dvojic SN1 a SN2
                         DECLARE @StartDvojice AS INT,  @EndDvojice AS INT
                         SELECT @StartDvojice = 0, @EndDvojice = 0
                         DECLARE @ii AS INT
--SELECT @delka '@delka', @myKitSNs
                         While @EndDvojice<@delka
                         BEGIN
--SELECT @EndDvojice,@StartDvojice+1
                             SET @EndDvojice = Charindex(';',@myKitSNs, @StartDvojice+1)
--SELECT @StartDvojice, @EndDvojice
                             IF @EndDvojice=0 BEGIN SET @EndDvojice = @delka+1  END 

                             SET @myKitSNoba = SUBSTRING(@myKitSNs,@StartDvojice+1, @EndDvojice-@StartDvojice-1)
--SELECT @myKitSNoba
                             SET @ii = Charindex(',',@myKitSNoba,0)
                             SET @myKitSN1 = SUBSTRING(@myKitSNoba,1, @ii-1)
                             SET @myKitSN2 = SUBSTRING(@myKitSNoba,@ii+1, LEN(@myKitSNoba)-@ii)

                             INSERT INTO [dbo].[CommunicationMessagesKittingsApprovalKitsSerNumSent]
                                        ([ApprovalKitsID]
                                        ,[SN1]
                                        ,[SN2]
                                        ,[IsActive]
                                        ,[ModifyDate]
                                        ,[ModifyUserId])
                                  VALUES
                                        (@myIdentityKitSent   -- <ApprovalKitsID, int,>
                                        ,@myKitSN1            -- <SN1, nvarchar(20),>
                                        ,@myKitSN2            -- <SN2, nvarchar(20),>
                                        ,1                    -- <IsActive, bit,>
                                        ,@myKeyRequiredReleaseDate -- <ModifyDate, datetime,>
                                        ,0                    -- <ModifyUserId, int,>
                                        )
                             SET @myError = @myError + @@ERROR
                             IF @myError = 0  SET @StartDvojice = @EndDvojice 
                             ELSE
                             BEGIN
                               SET @Error = @myError
                               RETURN
                             END

                         END
                     END
               FETCH NEXT FROM myCursorKittingsConfirmation INTO @myID, @myCMSOId, @myKitID, @myKitDescription ,@myKitQuantity,@myKitUnitOfMeasure,@myKitQualityId,@myKitSNs  
        END


        END
   END
   CLOSE myCursorKittingsConfirmation
   DEALLOCATE myCursorKittingsConfirmation

END TRY
BEGIN CATCH
   SET @Error = @@ERROR
   IF (SELECT CURSOR_STATUS('global','myCursorKittingsConfirmation')) >= -1
   BEGIN
             DEALLOCATE myCursorKittingsConfirmation
   END
END CATCH







GO
GRANT EXECUTE
    ON OBJECT::[dbo].[prCMAKconsent] TO [FenixW]
    AS [dbo];

