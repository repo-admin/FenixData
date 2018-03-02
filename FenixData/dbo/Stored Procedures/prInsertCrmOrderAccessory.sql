-- =============================================
-- Author:		David Johanovsky
-- Create date: 08.07.2016
-- Description:	Creates accessory record related to the specified order in CRM section
-- =============================================
CREATE PROCEDURE [dbo].[prInsertCrmOrderAccessory] 
	@cislo_obj NVARCHAR(20),
	@nazev_prislusenstvi NVARCHAR(255)
AS
BEGIN
	
	SET NOCOUNT ON;

    DECLARE @orderId INT = (SELECT Id FROM dbo.CrmContractOrders WHERE zl_cislo_objednavky = @cislo_obj);
	
	-- order record does not exist, return 0
	IF (@orderId IS NULL) RETURN 0;
	-- order exists, create new record and return 1
	ELSE 
		BEGIN
			INSERT INTO dbo.CrmContractOrderAccessories(OrderId, nazev_prislusenstvi) VALUES (@orderId, @nazev_prislusenstvi);
			RETURN 1;
		END
		
	 
END
