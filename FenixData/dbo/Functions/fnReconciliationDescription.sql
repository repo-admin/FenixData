-- =============================================
-- Author     :	Rezler Michal	 
-- Create date: 2015-10-26
-- Description: vrací popis reconcilace
-- =============================================
CREATE FUNCTION [dbo].[fnReconciliationDescription]
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
			WHEN 1 THEN 'Schváleno'
			WHEN 2 THEN 'Zamítnuto'
			WHEN 3 THEN 'D0 odeslána'
			ELSE '???'
		END;
		
	RETURN @ReconciliationDescription

END

