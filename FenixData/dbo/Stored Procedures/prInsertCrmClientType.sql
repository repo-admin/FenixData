-- =============================================
-- Author:		David Johanovsky
-- Create date: 11.07.2016
-- Description:	Procedure for regular update of client types from CRM
-- =============================================
CREATE PROCEDURE [dbo].[prInsertCrmClientType] 
	@f_typ_klienta NVARCHAR(30)
AS
BEGIN
	SET NOCOUNT ON;

    DECLARE @resultId INT = (SELECT Id FROM dbo.CrmContractClientTypes WHERE f_typ_klienta = @f_typ_klienta); 

    -- record already exists, return 0
	IF (COUNT(@resultId) > 0) RETURN 0;
	-- record does not exist yet, return 1 after insert statement
	ELSE
		BEGIN
			INSERT INTO dbo.CrmContractClientTypes(f_typ_klienta) VALUES (@f_typ_klienta); 
			RETURN 1;
		END

END
