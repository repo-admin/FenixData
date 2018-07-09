
-- =============================================
-- Author:		David Johanovsky, Petr Celner
-- Create date: 08.07.2016
-- Edit date:	07.06.2018
-- Description:	Creates accessory record related to the specified order in CRM section
-- =============================================
CREATE PROCEDURE [dbo].[prInsertCrmOrderAccessory] 
	@wo_pr_number NVARCHAR(20),
	@accessorycode NVARCHAR(30)
AS
BEGIN
	
	SET NOCOUNT ON;

    DECLARE @orderId INT = (SELECT Id FROM dbo.CommunicationMessagesCrmOrder WHERE wo_pr_number = @wo_pr_number);
	DECLARE @accessoryId INT = (SELECT Id FROM dbo.cdlCrmHardwareAndServices WHERE Code = @accessorycode);
	-- order record does not exist, return 0
	IF (@orderId IS NULL) RETURN 0;
	-- order exists, checking accessory, if not exist, return 0
	ELSE IF(@accessoryId IS NULL) RETURN 0;
	-- order and accesorry exist, create new record
	ELSE 
		BEGIN
			INSERT INTO dbo.CommunicationMessagesCrmOrderAccessories(wo_pr_number, AccessoryCode) VALUES (@wo_pr_number, @accessorycode);
			RETURN 1;
		END
		
	 
END
