CREATE FUNCTION [dbo].[fnHistoryMovesSN] (@SerialNumber nvarchar(50))
RETURNS TABLE
AS
-- ===============================================================================================
-- Created by   : Rezler Michal
-- Created date : 2015-04-16
--                2015-10-22, 2015-11-03
-- Used by      : 
-- Description  : Historie pohybů zadaného sériového čísla (K1, S1, RF1, VR1, VR3)
-- Parameters   : 
-- History      : 2015-10-22 M. Rezler .. Reconciliation rozšířeno o {D0 odeslána}
--              : 2015-11-03 M. Rezler .. DecisionText určováno voláním funkce
-- ===============================================================================================
RETURN
				
		-- K1
		SELECT	k1.ID										  as 'ID'
						,k1.MessageId						  as 'MessageID'
						,k1Items.[ID]						  as 'ItemID'
						,'K1'										  as 'TypeShortcut'
						,'KittingConfirmation'		as 'TypeDescription'
						,k1Items.[ModifyDate]		  as 'ReceiptDate'
						,k1.Reconciliation        as 'Decision'
						,(SELECT [dbo].[fnReconciliationDescriptionUpperWD](k1.Reconciliation)) AS DecisionText

						--,CASE k1.Reconciliation						--2015-11-03
						--WHEN 0 THEN 'BEZ VYJÁDŘENÍ'				--2015-11-03, 2015-10-22
						--	WHEN 1 THEN 'SCHVÁLENO'						--2015-11-03
						--	WHEN 2 THEN 'ZAMÍTNUTO'						--2015-11-03
						--	WHEN 3 THEN 'D0 ODESLÁNA'					--2015-11-03, 2015-10-22							
						--	--Else 'BEZ ROZHODNUTÍ'						--2015-11-03, 2015-10-22
						--	END       as 'DecisionText'				--2015-11-03

		FROM [dbo].[CommunicationMessagesKittingsConfirmationItems] k1Items
		LEFT OUTER JOIN [dbo].[CommunicationMessagesKittingsConfirmation] k1
			ON k1Items.CMSOId = k1.ID
		WHERE k1Items.[KitSNs] LIKE '%' + @SerialNumber + '%' 
			AND k1Items.IsActive = 1
			AND k1.IsActive = 1
		
		UNION ALL
				
		-- S1 		
		SELECT	s1.ID											as 'ID'
						,s1.MessageId							as 'MessageID'
						,s1Items.ID								as 'ItemID'      
						,'S1'											as 'TypeShortcut'
						,'ShipmentOrder'					as 'TypeDescription'
						,s1SerNum.[ModifyDate]		as 'ReceiptDate'
						,s1.Reconciliation				as 'Decision' 

						,(SELECT [dbo].[fnReconciliationDescriptionUpperWD](s1.Reconciliation)) AS DecisionText
						
						--,CASE s1.Reconciliation							--2015-11-03
						--WHEN 0 THEN 'BEZ VYJÁDŘENÍ'					--2015-11-03, 2015-10-22
						--	WHEN 1 THEN 'SCHVÁLENO'							--2015-11-03
						--	WHEN 2 THEN 'ZAMÍTNUTO'							--2015-11-03
						--	WHEN 3 THEN 'D0 ODESLÁNA'						--2015-11-03, 2015-10-22							
						--	--Else 'BEZ ROZHODNUTÍ'							--2015-11-03, 2015-10-22
						--	END           as 'DecisionText'			--2015-11-03

		FROM [dbo].[CommunicationMessagesShipmentOrdersConfirmationSerNumSent] s1SerNum
		LEFT OUTER JOIN [dbo].[CommunicationMessagesShipmentOrdersConfirmationItems] s1Items
			ON s1SerNum.ShipmentOrdersItemsOrKitsID = s1Items.ID
		LEFT OUTER JOIN [dbo].[CommunicationMessagesShipmentOrdersConfirmation] s1
			ON s1Items.CMSOId = s1.ID
		WHERE s1SerNum.[SN1] LIKE '%' + @SerialNumber + '%' OR s1SerNum.[SN2] LIKE '%' + @SerialNumber + '%'
			AND s1SerNum.IsActive = 1
			AND s1Items.IsActive = 1
			AND s1.IsActive = 1
		
		UNION ALL
				
		-- RF1 		
		SELECT	rf1.ID											as 'ID'
						,rf1.MessageId							as 'MessageID'      
						,rf1Items.ID								as 'ItemID'
						,'RF1'											as 'TypeShortcut'
						,'RefurbishedConfirmation'	as 'TypeDescription'
						,rf1SerNum.ModifyDate				as 'ReceiptDate'
						,rf1.Reconciliation					as 'Decision'

						,(SELECT [dbo].[fnReconciliationDescriptionUpperWD](rf1.Reconciliation)) AS DecisionText

						--,CASE rf1.Reconciliation						--2015-11-03
						--WHEN 0 THEN 'BEZ VYJÁDŘENÍ'				--2015-11-03, 2015-10-22
						--	WHEN 1 THEN 'SCHVÁLENO'						--2015-11-03
						--	WHEN 2 THEN 'ZAMÍTNUTO'						--2015-11-03
						--	WHEN 3 THEN 'D0 ODESLÁNA'					--2015-11-03, 2015-10-22							
						--	--Else 'BEZ ROZHODNUTÍ'						--2015-11-03, 2015-10-22
						--	END           as 'DecisionText'

		FROM [dbo].[CommunicationMessagesRefurbishedOrderConfirmationSerNumSent] rf1SerNum
		LEFT OUTER JOIN [dbo].[CommunicationMessagesRefurbishedOrderConfirmationItems] rf1Items
			ON rf1SerNum.RefurbishedItemsOrKitsID = rf1Items.ID
		LEFT OUTER JOIN [dbo].[CommunicationMessagesRefurbishedOrderConfirmation] rf1
			ON rf1Items.CMSOId = rf1.ID
		WHERE rf1SerNum.[SN1] LIKE '%' + @SerialNumber + '%' OR rf1SerNum.[SN2] LIKE '%' + @SerialNumber + '%'
			AND rf1SerNum.IsActive = 1

		UNION ALL

		-- VR1		
		SELECT vr1.ID										as 'ID'
					,vr1.MessageId						as 'MessageID'
					,vr1Items.ID							as 'ItemID'
					,'VR1'										as 'TypeShortcut'
					,'ReturnedEquipment'			as 'TypeDescription'			
					,vr1Items.ModifyDate			as 'ReceiptDate'
					,vr1.Reconciliation       as 'Decision'

					,(SELECT [dbo].[fnReconciliationDescriptionUpperWD](vr1.Reconciliation)) AS DecisionText

 					--,CASE vr1.Reconciliation						--2015-11-03
					--WHEN 0 THEN 'BEZ VYJÁDŘENÍ'				--2015-11-03, 2015-10-22
					--WHEN 1 THEN 'SCHVÁLENO'						--2015-11-03
					--WHEN 2 THEN 'ZAMÍTNUTO'						--2015-11-03
					--WHEN 3 THEN 'D0 ODESLÁNA'					--2015-11-03, 2015-10-22						
					----Else 'BEZ ROZHODNUTÍ'						--2015-11-03, 2015-10-22
					--END           as 'DecisionText'		--2015-11-03

		FROM [dbo].[CommunicationMessagesReturnItems] vr1Items
		LEFT OUTER JOIN [dbo].[CommunicationMessagesReturn] vr1
			ON vr1Items.CMSOId = vr1.ID
		WHERE vr1Items.[SN1] LIKE '%' + @SerialNumber + '%' OR vr1Items.[SN2] LIKE '%' + @SerialNumber + '%'
			AND vr1Items.IsActive = 1
			AND vr1.IsActive = 1

		UNION ALL

		-- VR3
		SELECT vr3.ID												as 'ID'
					,vr3.MessageId								as 'MessageID'
					,vr3Items.ID									as 'ItemID'
					,'VR3'												as 'TypeShortcut'
					,'ReturnedShipment'						as 'TypeDescription'
					,vr3Items.[ModifyDate]				as 'ReceiptDate'
					,vr3.Reconciliation						as 'Decision'

					,(SELECT [dbo].[fnReconciliationDescriptionUpperWD](vr3.Reconciliation)) AS DecisionText

					--,CASE vr3.Reconciliation						--2015-11-03
					--WHEN 0 THEN 'BEZ VYJÁDŘENÍ'				--2015-11-03, 2015-10-22
					--WHEN 1 THEN 'SCHVÁLENO'						--2015-11-03
					--WHEN 2 THEN 'ZAMÍTNUTO'						--2015-11-03
					--WHEN 3 THEN 'D0 ODESLÁNA'					--2015-11-03, 2015-10-22						
					----Else 'BEZ ROZHODNUTÍ'						--2015-11-03, 2015-10-22
					--END           as 'DecisionText'		--2015-11-03

		FROM [dbo].[CommunicationMessagesReturnedShipmentItems] vr3Items
		LEFT OUTER JOIN [dbo].[CommunicationMessagesReturnedShipment] vr3
			ON vr3Items.CMSOId = vr3.ID
		WHERE vr3Items.[KitSNs] LIKE '%' + @SerialNumber + '%'
			AND vr3Items.IsActive = 1	

