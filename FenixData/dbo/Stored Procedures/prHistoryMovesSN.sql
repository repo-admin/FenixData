CREATE PROCEDURE [dbo].[prHistoryMovesSN]
(
	@SNtoFind nvarchar(50),	
	@ReturnValue int = -1 OUTPUT,
	@ReturnMessage nvarchar(2048) = NULL OUTPUT
)
AS
-- =========================================================================================================
-- Created by   : Rezler Michal
-- Created date : 2015-04-08
-- Description  : historie pohybů zadaného sériového čísla  (hledá se v tabulkách pro K1, S1, RF1, VR1, VR3)
-- Returns      : 0 je-li hledání úspěšné, jinak číslo chyby
--               -1 = nespecifikovana chyba
-- Used by      : 
-- History		    : 1.0.0       M. Rezler
--              : 2015-11-03  M. Rezler .. DecisionText určováno voláním funkce
-- =========================================================================================================
SET NOCOUNT ON
--
SET @ReturnValue = -1
SET @ReturnMessage = ''

DECLARE @SerialNumber nvarchar(50)
SET @SerialNumber = @SNtoFind

BEGIN TRY
		--
		SELECT [ID]
					,[MessageID]
					,[ItemID]
					,[TypeShortcut]
					,[TypeDescription]
					,[ReceiptDate]
					,[Decision]

					,(SELECT [dbo].[fnReconciliationDescriptionUpperWD]([Decision])) AS DecisionText

					--,CASE [Decision]							--2015-11-03
					-- WHEN 1 THEN 'SCHVÁLENO'			--2015-11-03
					-- WHEN 2 THEN 'ZAMÍTNUTO'			--2015-11-03
					-- Else 'BEZ ROZHODNUTÍ'				--2015-11-03
					-- END DecisionText						--2015-11-03

		FROM
		(

				-------------------------------------------------------------------------------------------------------------
				-- K1 start
				-------------------------------------------------------------------------------------------------------------
				SELECT	k1.ID										as 'ID'
							 ,k1.MessageId						as 'MessageID'
							 ,k1Items.[ID]						as 'ItemID'
							 ,'K1'										as 'TypeShortcut'
							 ,'KittingConfirmation'		as 'TypeDescription'
							 ,k1Items.[ModifyDate]		as 'ReceiptDate'
							 ,k1.Reconciliation       as 'Decision'
				FROM [dbo].[CommunicationMessagesKittingsConfirmationItems] k1Items
				LEFT OUTER JOIN [dbo].[CommunicationMessagesKittingsConfirmation] k1
						ON k1Items.CMSOId = k1.ID
				WHERE k1Items.[KitSNs] LIKE '%' + @SerialNumber + '%' 
					AND k1Items.IsActive = 1
					AND k1.IsActive = 1
				-------------------------------------------------------------------------------------------------------------
				-- K1 End
				-------------------------------------------------------------------------------------------------------------

				UNION ALL

				-------------------------------------------------------------------------------------------------------------
				-- S1 start
				-------------------------------------------------------------------------------------------------------------
				SELECT	s1.ID											as 'ID'
								,s1.MessageId							as 'MessageID'
								,s1Items.ID								as 'ItemID'      
								,'S1'											as 'TypeShortcut'
								,'ShipmentOrder'					as 'TypeDescription'
								,s1SerNum.[ModifyDate]		as 'ReceiptDate'
								,s1.Reconciliation				as 'Decision'      
				FROM [dbo].[CommunicationMessagesShipmentOrdersConfirmationSerNumSent] s1SerNum
				LEFT OUTER JOIN [dbo].[CommunicationMessagesShipmentOrdersConfirmationItems] s1Items
					ON s1SerNum.ShipmentOrdersItemsOrKitsID = s1Items.ID
				LEFT OUTER JOIN [dbo].[CommunicationMessagesShipmentOrdersConfirmation] s1
					ON s1Items.CMSOId = s1.ID
				WHERE s1SerNum.[SN1] LIKE '%' + @SerialNumber + '%' OR s1SerNum.[SN2] LIKE '%' + @SerialNumber + '%'
					AND s1SerNum.IsActive = 1
					AND s1Items.IsActive = 1
					AND s1.IsActive = 1
				-------------------------------------------------------------------------------------------------------------
				-- S1 end
				-------------------------------------------------------------------------------------------------------------

				UNION ALL

				-------------------------------------------------------------------------------------------------------------
				-- RF1 start
				-------------------------------------------------------------------------------------------------------------
				SELECT	rf1.ID											as 'ID'
								,rf1.MessageId							as 'MessageID'      
								,rf1Items.ID								as 'ItemID'
								,'RF1'											as 'TypeShortcut'
								,'RefurbishedConfirmation'	as 'TypeDescription'
								,rf1SerNum.ModifyDate				as 'ReceiptDate'
								,rf1.Reconciliation					as 'Decision'
				FROM [dbo].[CommunicationMessagesRefurbishedOrderConfirmationSerNumSent] rf1SerNum
				LEFT OUTER JOIN [dbo].[CommunicationMessagesRefurbishedOrderConfirmationItems] rf1Items
					ON rf1SerNum.RefurbishedItemsOrKitsID = rf1Items.ID
				LEFT OUTER JOIN [dbo].[CommunicationMessagesRefurbishedOrderConfirmation] rf1
					ON rf1Items.CMSOId = rf1.ID
				WHERE rf1SerNum.[SN1] LIKE '%' + @SerialNumber + '%' OR rf1SerNum.[SN2] LIKE '%' + @SerialNumber + '%'
					AND rf1SerNum.IsActive = 1
				-------------------------------------------------------------------------------------------------------------
				-- RF1 end
				-------------------------------------------------------------------------------------------------------------

				UNION ALL

				-------------------------------------------------------------------------------------------------------------
				-- VR1 start
				-------------------------------------------------------------------------------------------------------------
				SELECT vr1.ID										as 'ID'
							,vr1.MessageId						as 'MessageID'
							,vr1Items.ID							as 'ItemID'
							,'VR1'										as 'TypeShortcut'
							,'ReturnedEquipment'			as 'TypeDescription'			
							,vr1Items.ModifyDate			as 'ReceiptDate'
							,vr1.Reconciliation       as 'Decision'
				FROM [dbo].[CommunicationMessagesReturnItems] vr1Items
				LEFT OUTER JOIN [dbo].[CommunicationMessagesReturn] vr1
					ON vr1Items.CMSOId = vr1.ID
				WHERE vr1Items.[SN1] LIKE '%' + @SerialNumber + '%' OR vr1Items.[SN2] LIKE '%' + @SerialNumber + '%'
					AND vr1Items.IsActive = 1
					AND vr1.IsActive = 1
				-------------------------------------------------------------------------------------------------------------
				-- VR1 end
				-------------------------------------------------------------------------------------------------------------

				UNION ALL

				-------------------------------------------------------------------------------------------------------------
				-- VR3 start
				-------------------------------------------------------------------------------------------------------------
				SELECT vr3.ID												as 'ID'
							,vr3.MessageId								as 'MessageID'
							,vr3Items.ID									as 'ItemID'
							,'VR3'												as 'TypeShortcut'
							,'ReturnedShipment'						as 'TypeDescription'
							,vr3Items.[ModifyDate]				as 'ReceiptDate'
							,vr3.Reconciliation						as 'Decision'
				FROM [dbo].[CommunicationMessagesReturnedShipmentItems] vr3Items
				LEFT OUTER JOIN [dbo].[CommunicationMessagesReturnedShipment] vr3
					ON vr3Items.CMSOId = vr3.ID
				WHERE vr3Items.[KitSNs] LIKE '%' + @SerialNumber + '%'
					AND vr3Items.IsActive = 1
				-------------------------------------------------------------------------------------------------------------
				-- VR3 end
				-------------------------------------------------------------------------------------------------------------
		) tab
		ORDER BY tab.ReceiptDate DESC

		--
		SET @ReturnValue = 0
END TRY
BEGIN CATCH
   DECLARE @errTask nvarchar (126), @errLine int, @errNumb int
   SET @errTask = ERROR_PROCEDURE()
   SET @errLine = ERROR_LINE()
   SET @errNumb = ERROR_NUMBER()
   SET @ReturnMessage  = ERROR_MESSAGE()
   SET @ReturnValue = CASE WHEN ISNULL(@errNumb,-1) > 0 THEN @errNumb ELSE -1 END
END CATCH
--
RETURN @ReturnValue


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[prHistoryMovesSN] TO [FenixW]
    AS [dbo];

