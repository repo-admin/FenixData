CREATE PROCEDURE [dbo].[prGetOrderNumber]
       @HeliosOrderIDin   INT = -1
      ,@OrderNumberOut AS   INT = -1  OUTPUT
AS
-- ===============================================================================================
-- Created by   : Weczerek Max
-- Created date : 2014-09-05
-- Used by      : 
-- Description  : Vrací  číslo objednávky generované systémem
-- Parameters   : @HeliosOrderIDin ... HeliosOrderID
-- History :
-- ===============================================================================================
BEGIN
--
   DECLARE @OrderNumber int 
   SET @OrderNumber = @HeliosOrderIDin
--
   IF @OrderNumber<1 OR @OrderNumber IS NULL
   BEGIN
        SELECT @OrderNumber = LastFreeNumber FROM [dbo].[cdlOrderNumber] --WHERE [Code]='1'
        UPDATE [dbo].[cdlOrderNumber] SET LastFreeNumber = ISNULL(LastFreeNumber,-4000000) -1
   END
   --SELECT  @OrderNumber
   SET @OrderNumberOut = @OrderNumber
END

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[prGetOrderNumber] TO [FenixW]
    AS [dbo];

