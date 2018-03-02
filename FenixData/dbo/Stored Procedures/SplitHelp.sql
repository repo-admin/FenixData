/****** Script for SelectTopNRows command from SSMS  ******/
CREATE PROCEDURE [dbo].[SplitHelp]
AS
/*
2014-09-29
*/
DECLARE @myDatabaseName  nvarchar(100)
SELECT @myDatabaseName = DB_NAME()
DECLARE 
       @RowData nvarchar(MAX),
       @SplitOn nvarchar(MAX),
       @myID  INT,
       @myKitSNs nvarchar(MAX),
       @myKitSNsG  nvarchar(MAX),
       @Cnt int,
       @dvojice AS nvarchar(500),
       @mySN1 AS nvarchar(50),
       @mySN2 AS nvarchar(50),
       @icomma AS INT,
       @cComma AS char(1),
       @myFault as int
SET @SplitOn =';'
SET @cComma = ','
SET @myFault = 0
    DECLARE myCursor CURSOR 
    FOR SELECT [ID]  ,[KitSNs]
    FROM [dbo].[CommunicationMessagesShipmentOrdersConfirmationItems] WHERE [IsActive] = 1 
    AND ID NOT IN (SELECT [ShipmentOrdersItemsOrKitsID] FROM [dbo].[CommunicationMessagesShipmentOrdersConfirmationSerNumSent] WHERE [IsActive] = 1 AND LEN(LTRIM(RTRIM(KitSNs)))>0 )
    OPEN myCursor
    FETCH NEXT FROM myCursor INTO @myID  ,@myKitSNs
 
      WHILE @@FETCH_STATUS = 0
      BEGIN -- FETCH_STATUS
              SET @myKitSNsG = @myKitSNs + ';'
              Set @Cnt = 1
              IF LEN(LTRIM(RTRIM(@myKitSNs)))>0
              BEGIN
              While (Charindex(@SplitOn,@myKitSNsG)>0)
              Begin
                  Select @dvojice = ltrim(rtrim(Substring(@myKitSNsG,1,Charindex(@SplitOn,@myKitSNsG)-1)))

                  SET @icomma = Charindex(@cComma,@dvojice,0)

                  BEGIN TRY
                     SET @mySN1 = LEFT(@dvojice,@icomma-1)
                  END TRY
                  BEGIN CATCH
                      SET @mySN1 = NULL
                  END CATCH
                  BEGIN TRY
                  SET @mySN2 = RIGHT(@dvojice,LEN(@dvojice)-@icomma)
                  END TRY
                  BEGIN CATCH
                      SET @mySN2 = NULL
                  END CATCH

                  SELECT @myID,@cComma, @icomma, @myKitSNsG 'KitSNsG' , @dvojice 'dvojice', @mySN1, @mySN2

                  IF @mySN1 IS NOT NULL OR @mySN2 IS NOT NULL OR LEN(RTRIM(@mySN1))>1 OR LEN(RTRIM(@mySN2)) > 1 
                  BEGIN
                         INSERT INTO [dbo].[CommunicationMessagesShipmentOrdersConfirmationSerNumSent] (
                                [ShipmentOrdersItemsOrKitsID],[SN1],[SN2],[IsActive],[ModifyUserId],[ModifyDate])
                         VALUES(@myID,@mySN1,@mySN2,1,0, GetDate() )
                  END 
                  BEGIN TRY
                      Set @myKitSNsG = Substring(@myKitSNsG,Charindex(@SplitOn,@myKitSNsG)+1,len(@myKitSNsG))
                  END TRY
                  BEGIN CATCH
                   SET @myFault = @myFault + 1
                  END CATCH
                  Set @Cnt = @Cnt + 1
              End
              END

      FETCH NEXT FROM myCursor INTO @myID  ,@myKitSNs
      END    -- FETCH_STATUS
 
    CLOSE myCursor
	 DEALLOCATE myCursor



