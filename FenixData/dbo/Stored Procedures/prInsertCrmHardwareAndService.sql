
-- =============================================
-- Author:		David Johanovsky, Petr Celner
-- Create date: 22.09.2016
-- Edit date:	07.06.2018
-- Description:	Procedure for refreshing enumeration of hardware and services 
-- =============================================
CREATE PROCEDURE [dbo].[prInsertCrmHardwareAndService]
	@code NVARCHAR(30),
	@description NVARCHAR(255)
AS
BEGIN

	SET NOCOUNT ON;

/**   *** Pro oznaceni typu (1 = CPE, 2 = OneTime, 3 = Subscription) - nebylo pouzito  ***
	DECLARE @typeId INT = 0;
	IF (@code LIKE '%[a-zA-Z]%') SET @typeId = 1;
	ELSE IF (ISNUMERIC(@code) = 1)
		BEGIN
			DECLARE @tempNoCode INT = CAST(@code AS INT);
			IF (@tempNoCode > 0) SET @typeId = 3;
			ELSE SET @typeId = 2;
		END
**/
	
    DECLARE @resultId INT = (SELECT Id FROM [dbo].[cdlCrmHardwareAndServices] WHERE Code = @code);
	-- record already exists, return 0
	IF (@resultId > 0) RETURN 0;
	-- record does not exist yet, return 1 after insert statement
	ELSE
		BEGIN
			INSERT INTO [dbo].[cdlCrmHardwareAndServices](Code, [Description]) VALUES (@code, @description);
			RETURN 1;
		END

END