-- =============================================
-- Author:		David Johanovsky
-- Create date: 22.09.2016
-- Description:	Procedure for refreshing enumeration of hardware and services 
-- =============================================
CREATE PROCEDURE [dbo].[prInsertCrmHardwareOrService]
	@code NVARCHAR(30),
	@description NVARCHAR(255)
AS
BEGIN

	SET NOCOUNT ON;

	DECLARE @typeId INT = 0;
    DECLARE @resultId INT = (SELECT Id FROM [dbo].[CrmHardwareAndServices] WHERE Code = @code);

	IF (@code LIKE '%[a-zA-Z]%') SET @typeId = 1;
	ELSE IF (ISNUMERIC(@code) = 1)
		BEGIN
			DECLARE @tempNoCode INT = CAST(@code AS INT);
			IF (@tempNoCode > 0) SET @typeId = 3;
			ELSE SET @typeId = 2;
		END
	
	-- record already exists, return 0
	IF (@resultId > 0) RETURN 0;
	-- record does not exist yet, return 1 after insert statement
	ELSE
		BEGIN
			INSERT INTO [dbo].[CrmHardwareAndServices](Code, [Description], TypeId) VALUES (@code, @description, @typeId);
			RETURN 1;
		END

END
