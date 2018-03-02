-- =============================================
-- Author     :	Rezler Michal	 
-- Create date: 2015-10-26
-- Description: vrací popis reconcilace (upper)
-- =============================================
CREATE FUNCTION [dbo].[fnReconciliationDescriptionUpper]
(
	@Reconciliation INT = -1
)
RETURNS nvarchar(500)
AS
BEGIN
	DECLARE @ReconciliationDescription nvarchar(500)

	SET @ReconciliationDescription = 
		CASE @Reconciliation 
			WHEN 0 THEN '?' 
			WHEN 1 THEN 'SCHVÁLENO'
			WHEN 2 THEN 'ZAMÍTNUTO'
			WHEN 3 THEN 'D0 ODESLÁNA'
			ELSE '???'
		END;
		
	RETURN @ReconciliationDescription

END

