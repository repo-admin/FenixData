
-- =============================================
-- Author:		David Johanovsky, Petr Celner
-- Create date: 11.07.2016
-- Edit date:	07.06.2018
-- Description:	Procedure for regular updates of inet types from CRM
-- =============================================
CREATE PROCEDURE [dbo].[prInsertCrmInetType]
	@inetCode INT,
	@inetProduct NVARCHAR(255)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @resultId INT = (SELECT Id FROM dbo.cdlCrmContractInetTypes WHERE f_inet_core_number = @inetCode);

	-- record already exists, return 0
	IF (@resultId > 0) RETURN 0;
	-- record does not exist yet, return 1 after insert statement
	ELSE
		BEGIN
			INSERT INTO dbo.cdlCrmContractInetTypes(f_inet_core_number, f_inet_core_product) VALUES (@inetCode, @inetProduct);
			RETURN 1;
		END

END
