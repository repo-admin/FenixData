
CREATE PROCEDURE [dbo].[prCMSOIins]
      @CMSOId                  int,
      @SingleOrMaster          int,
	   @ItemVerKit              bit,
	   @ItemOrKitID             varchar(50),
	   @ItemOrKitDescription    nvarchar(500),
	   @ItemOrKitQuantity       numeric(18, 3),
      @ItemOrKitUnitOfMeasureId int,
	   @ItemOrKitUnitOfMeasure  varchar(50),
	   @ItemOrKitQualityId      int,
      @ItemOrKitQualityCode    varchar(50),
	   @ItemOrKitDateOfDelivery datetime,
      @ItemType                nvarchar(50),
	   @IncotermsId             int,
      @Incoterms               nvarchar(50),
      @PackageValue            int,
      @ShipmentOrderSource     int,
      @VydejkyId               int,
      @ModifyDate              DateTime,
      @ModifyUserId            int = 0,
      @CardStockItemsId        int,
	   @Error      AS int            = -1 OUTPUT
AS

-- =============================================
-- Author:		 Weczerek Max
-- Create date: 2014-08-28
-- Description: voláno z procedury [dbo].[prKiSHins]
--              zapisuje do tabulky [dbo].[CommunicationMessagesShipmentOrdersSentItems]
--              aktualizuje skladové karty  CardStockItems
-- =============================================
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.

DECLARE @myDatabaseName  nvarchar(100)
BEGIN TRY

    SELECT @myDatabaseName = DB_NAME() 

   DECLARE @myError    AS INT        SET @myError = 0
   DECLARE  @myIdetity AS INT        SET @myError = 0
   INSERT INTO [dbo].[CommunicationMessagesShipmentOrdersSentItems]
              ([CMSOId]
              ,[SingleOrMaster]
              ,[ItemVerKit]
              ,[ItemOrKitID]
              ,[ItemOrKitDescription]
              ,[ItemOrKitQuantity]
              ,[ItemOrKitUnitOfMeasureId]
              ,[ItemOrKitUnitOfMeasure]
              ,[ItemOrKitQualityId]
              ,[ItemOrKitQualityCode]
              ,[ItemType]
              ,[IncotermsId]
              ,[Incoterms]
              ,[PackageValue]
              ,[ShipmentOrderSource]
              ,[VydejkyId]
              ,CardStockItemsId
              --,[IsActive]
              ,[ModifyDate]
              ,[ModifyUserId])
        VALUES
              (@CMSOId                   --<CMSOId, int,>
              ,@SingleOrMaster           --<SingleOrMaster, int,>
              ,@ItemVerKit               --<ItemVerKit, bit,>
              ,@ItemOrKitID              --<ItemOrKitID, varchar(50),>
              ,@ItemOrKitDescription     --<ItemOrKitDescription, nvarchar(100),>
              ,@ItemOrKitQuantity        --<ItemOrKitQuantity, numeric(18,3),>  !!
              ,@ItemOrKitUnitOfMeasureId --<ItemOrKitUnitOfMeasureId, int,>
              ,@ItemOrKitUnitOfMeasure   --<ItemOrKitUnitOfMeasure, nvarchar(50),>
              ,@ItemOrKitQualityId       --<ItemOrKitQualityId, int,>
              ,@ItemOrKitQualityCode     --<ItemOrKitQualityCode, nvarchar(50),>
              ,@ItemType                 --<ItemType, nvarchar(50),>  NW atd
              ,@IncotermsId              --<IncotermsId, int,>
              ,@Incoterms                --<Incoterms, nvarchar(50),>
              ,@PackageValue             --<PackageValue, int,>
              ,@ShipmentOrderSource      --<ShipmentOrderSource, int,>
              ,@VydejkyId                --<VydejkyId, int,>
              ,@CardStockItemsId
              ,@ModifyDate               --<ModifyDate, datetime,>
              ,@ModifyUserId             --<ModifyUserId, int,>
              )

              SET @myError   = @@ERROR
              SET @myIdetity = @@IDENTITY

              IF @ItemVerKit = 0 
              BEGIN
                   UPDATE [dbo].[CardStockItems]
                   SET [ItemOrKitFree] = ISNULL(ItemOrKitFree,0) - @ItemOrKitQuantity
                      ,[ItemOrKitReserved] = ISNULL(ItemOrKitReserved,0) + @ItemOrKitQuantity
                   WHERE ItemOrKitID = @ItemOrKitID AND [ItemOrKitQuality] = @ItemOrKitQualityId AND ItemOrKitUnitOfMeasureId = @ItemOrKitUnitOfMeasureId
                   --WHERE id = @CardStockItemsId    2015-02-16
                   SET @myError = @myError + @@ERROR
              END
              ELSE
              BEGIN

                   UPDATE [dbo].[CardStockItems]
                   SET [ItemOrKitReleasedForExpedition] = ISNULL(ItemOrKitReleasedForExpedition,0) - @ItemOrKitQuantity
                      ,[ItemOrKitReserved] = ISNULL(ItemOrKitReserved,0) + @ItemOrKitQuantity
                   WHERE ItemOrKitID = @ItemOrKitID AND [ItemOrKitQuality] = @ItemOrKitQualityId AND ItemOrKitUnitOfMeasureId = @ItemOrKitUnitOfMeasureId
                   --WHERE id = @CardStockItemsId    2015-02-16

                   SET @myError   = @myError + @@ERROR
-- 8.9.2014   2014-11-04  -- START
                  --UPDATE [dbo].[CardStockItems]
                  -- SET [ItemOrKitReleasedForExpedition] = ISNULL(ItemOrKitReleasedForExpedition,0) - @ItemOrKitQuantity*aa.ItemOrKitQuantity
                  --    ,[ItemOrKitReserved] = ISNULL(ItemOrKitReserved,0) + @ItemOrKitQuantity*aa.ItemOrKitQuantity

                  -- FROM [dbo].[CardStockItems]          CI
                  -- INNER JOIN (
                  --     SELECT KI.* FROM [dbo].[cdlKits] K
                  --     INNER JOIN [dbo].[cdlKitsItems]  KI
                  --     ON K.ID = KI.[cdlKitsId]
                  --     WHERE K.ID = @ItemOrKitID 
                  -- ) aa
                  -- ON CI.ItemOrKitId = aa.ItemOrKitId  AND CI.[ItemOrKitQuality] = @ItemOrKitQualityId 
-- 8.9.2014   2014-11-04   -- END

              END
              --SET @myError = @myError + @@ERROR
              SET @Error = @myError
END TRY
BEGIN CATCH
    SET @Error = -1
END CATCH









GO
GRANT EXECUTE
    ON OBJECT::[dbo].[prCMSOIins] TO [FenixW]
    AS [dbo];

