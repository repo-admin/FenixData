-- =============================================
-- Author:		David Johanovsky, Petr Celner
-- Create date: 07.07.2016
-- Edit:		07.06.2018
-- Description:	Insertion, validation and logic behind creation of a new order and related entities from CRM
-- =============================================
CREATE PROCEDURE [dbo].[prInsertCrmOrder]

	-- CrmContract required
	@wo_cid INT,									-- zl_cislo_smlouvy
	@wo_first_last_name NVARCHAR(100),				-- zl_jmeno_a_prijmeni

	-- CrmContractHistory required
	@wo_street_name NVARCHAR(100),					-- zl_ulice
	@wo_house_number NVARCHAR(20),					-- zl_cislo_pop_or
	@wo_floor_flat NVARCHAR(50),					-- zl_patro_prip_bod
	@f_customer_type NVARCHAR(30),					-- f_typ_klienta
	@wo_city NVARCHAR(100),							-- zl_obec
	@wo_zip	NVARCHAR(20),							-- zl_psc

	-- CrmContractHistory not-required
--	@zl_telefon_domu_zamest NVARCHAR(50) = NULL,	-- nepouzito
	@wo_phone NVARCHAR(20) = NULL,					-- zl_mobil
	@wo_email_info1 NVARCHAR(80) = NULL,			-- zl_email_info1
--	@zl_email_info2 NVARCHAR(50) = NULL,			-- nepouzito
	@wo_email NVARCHAR(100) = NULL,					-- zl_email
	@wo_password NVARCHAR(20) = NULL,				-- zl_heslo
	@wo_upc_tel1 NVARCHAR(15) = NULL,				-- zl_line1
	@wo_upc_tel2 NVARCHAR(15) = NULL,				-- zl_line2

	-- CrmContractOrder required
	@wo_pr_number NVARCHAR(20),						-- zl_cislo_objednavky
	@wo_pr_create_date NVARCHAR(30),						-- zl_zadano
	@wo_delivery_date_from NVARCHAR(30),					-- zl_cas_prislibu_od
	@wo_delivery_date_to NVARCHAR(30),						-- zl_cas_prislibu_do
	@wo_pr_type NVARCHAR(40),						-- zl_typ_objednavky
	@f_pr_type INT,		-- 1 = INET / 2 = DTV / 3 = TEL / 4 = INET+TEL / 5 = ACCESSORY


	-- CrmContractOrder not-required
	@wo_cpe_back NVARCHAR(30) = NULL,				-- zl_cpe_back
	@wo_note NVARCHAR(100) = NULL,					-- zl_instrukce
	@f_rental NVARCHAR(30) = NULL,					-- f_pronajem
	@f_sale NVARCHAR(30) = NULL,					-- f_prodej
	@f_inet_core_product INT = NULL -- product number, not name !!!


	-- user in ZiCys who started the procedure
--	@f_zicyz_id INT									-- ZiCysId

AS
BEGIN
	
	SET NOCOUNT ON;

	-- 00.SECTION : basic validations
--	IF (@f_pr_type = 1 AND @f_inet_core_product IS NULL) RETURN -1;  nebo typ 4  -- if INET type, inet_core_number is required
--  IF (@f_sale IS NULL AND @f_rental IS NULL) RETURN -2; -- at least one of the following is required platí pokud se nejedná o příslušenství

	-- Zjisteni posledniho cisla zpravy
	DECLARE @myMessageId int
    SELECT @myMessageId = [LastFreeNumber]  FROM [dbo].[cdlMessageNumber] WHERE CODE = 1
    UPDATE [dbo].[cdlMessageNumber] SET [LastFreeNumber] = [LastFreeNumber] + 1  WHERE CODE = 1

	-- Zjisteni aktualniho data
	DECLARE @modifyDate datetime

	-- Konverze datumu z textu do datetime
	DECLARE @wo_pr_create_datetime datetime
	DECLARE @wo_delivery_datetime_from datetime
	DECLARE @wo_delivery_datetime_to datetime	
	SELECT @wo_pr_create_datetime = CONVERT(datetime, @wo_pr_create_date, 104)
	SELECT @wo_delivery_datetime_from = CONVERT(datetime, @wo_delivery_date_from, 104)
	SELECT @wo_delivery_datetime_to = CONVERT(datetime, @wo_delivery_date_to, 104)

	-- 01.SECTION : declaring used variables and getting Ids from reusable tables
/**	DECLARE @contractId INT = (SELECT Id FROM dbo.CrmContracts WHERE zl_cislo_smlouvy = @zl_cislo_smlouvy),
			@clientTypeId INT = (SELECT Id FROM dbo.CrmContractClientTypes WHERE f_typ_klienta = @f_typ_klienta),
			@inetTypeId INT = (SELECT Id FROM dbo.CrmContractInetTypes WHERE f_inet_core_number = @f_inet_core_number),
			@orderTypeId INT = (SELECT Id FROM dbo.CrmContractOrderTypes WHERE zl_typ_objednavky = @zl_typ_objednavky),
			@contractHistoryMappingId INT = 0,
			@contractHistoryId INT = 0;

	 if contract does not exist
	IF (@contractId IS NULL) 
		BEGIN

			-- create new record in dbo.CrmContracts table and set contractId variable to the newly created Id
			INSERT INTO dbo.CrmContracts(zl_cislo_smlouvy, zl_jmeno_a_prijmeni, CreatedBy) 
			VALUES (@zl_cislo_smlouvy, @zl_jmeno_a_prijmeni, @ZiCysId);
			SET @contractId = (SELECT Id FROM dbo.CrmContracts WHERE zl_cislo_smlouvy = @zl_cislo_smlouvy);

			-- create new record in dbo.CrmContractHistory and set contractHistoryId variable to the newly created Id
			INSERT INTO dbo.CrmContractHistories(zl_ulice, zl_cislo_pop_or, zl_patro_prip_bod, zl_telefon_domu_zamest, zl_mobil, zl_email_info1, zl_email_info2, zl_email, zl_heslo, ClientTypeId, zl_line1, zl_line2, CreatedBy, zl_obec)
			VALUES (@zl_ulice, @zl_cislo_pop_or, @zl_patro_prip_bod, @zl_telefon_domu_zamest, @zl_mobil, @zl_email_info1, @zl_email_info2, @zl_email, @zl_heslo, @clientTypeId, @zl_line1, @zl_line2, @ZiCysId, @zl_obec);
			SET @contractHistoryId = (SELECT TOP 1 Id FROM dbo.CrmContractHistories ORDER BY Id DESC);

			-- create new record in dbo.CrmContractHistoryMappings and set contractHistoryMappingId to the newly created Id	
			INSERT INTO dbo.CrmContractHistoryMappings(ContractId, ContractHistoryId) 
			VALUES (@contractId, @contractHistoryId);
			SET @contractHistoryMappingId = (SELECT TOP 1 Id FROM dbo.CrmContractHistoryMappings ORDER BY Id DESC);

		END
	ELSE
		BEGIN

			-- set relevant contractHistoryMappingId and contractHistoryId variables
			SET @contractHistoryId = (SELECT ContractHistoryId FROM dbo.CrmContractHistoryMappings WHERE ContractId = @contractId AND IsRelevant = 1);
			SET @contractHistoryMappingId = (SELECT Id FROM dbo.CrmContractHistoryMappings WHERE ContractId = @contractId AND IsRelevant = 1);

			-- create temporary variables from contractHistory record for comparison purposes
			DECLARE @zl_ulice_temp NVARCHAR(100) = (SELECT zl_ulice FROM dbo.CrmContractHistories WHERE Id = @contractHistoryId),
					@zl_cislo_pop_or_temp NVARCHAR(20) = (SELECT zl_cislo_pop_or FROM dbo.CrmContractHistories WHERE Id = @contractHistoryId),
					@zl_patro_prip_bod_temp NVARCHAR(50) = (SELECT zl_patro_prip_bod FROM dbo.CrmContractHistories WHERE Id = @contractHistoryId),
					@zl_telefon_domu_zamest_temp NVARCHAR(50) = (SELECT zl_telefon_domu_zamest FROM dbo.CrmContractHistories WHERE Id = @contractHistoryId),
					@zl_mobil_temp NVARCHAR(20) = (SELECT zl_mobil FROM dbo.CrmContractHistories WHERE Id = @contractHistoryId),
					@zl_email_info1_temp NVARCHAR(80) = (SELECT zl_email_info1 FROM dbo.CrmContractHistories WHERE Id = @contractHistoryId),
					@zl_email_info2_temp NVARCHAR(50) = (SELECT zl_email_info2 FROM dbo.CrmContractHistories WHERE Id = @contractHistoryId),
					@zl_email_temp NVARCHAR(100) = (SELECT zl_email FROM dbo.CrmContractHistories WHERE Id = @contractHistoryId),
					@zl_heslo_temp NVARCHAR(20) = (SELECT zl_heslo FROM dbo.CrmContractHistories WHERE Id = @contractHistoryId),
					@clientTypeIdTemp INT = (SELECT ClientTypeId FROM dbo.CrmContractHistories WHERE Id = @contractHistoryId),
					@zl_line1_temp NVARCHAR(15) = (SELECT zl_line1 FROM dbo.CrmContractHistories WHERE Id = @contractHistoryId),
					@zl_line2_temp NVARCHAR(15) = (SELECT zl_line2 FROM dbo.CrmContractHistories WHERE Id = @contractHistoryId);

		
			-- check if there are any differences between the current contractHistory and the last stored one
			IF (@zl_ulice != @zl_ulice_temp OR @zl_cislo_pop_or != @zl_cislo_pop_or_temp OR @zl_patro_prip_bod != @zl_patro_prip_bod_temp OR
				@zl_telefon_domu_zamest != @zl_telefon_domu_zamest_temp OR @zl_mobil != @zl_mobil_temp OR @zl_email_info1 != @zl_email_info1_temp OR
				@zl_email_info2 != @zl_email_info2_temp OR @zl_email != @zl_email_temp OR @zl_heslo != @zl_heslo_temp OR @clientTypeId != @clientTypeIdTemp OR
				@zl_line1 != @zl_line1_temp OR @zl_line2 != @zl_line2_temp)
				BEGIN

					-- create new record in dbo.CrmContractHistories and set contractHistoryId variable to newly created Id
					INSERT INTO dbo.CrmContractHistories(zl_ulice, zl_cislo_pop_or, zl_patro_prip_bod, zl_telefon_domu_zamest, zl_mobil, zl_email_info1, zl_email_info2, zl_email, zl_heslo, ClientTypeId, zl_line1, zl_line2, CreatedBy, zl_obec)
					VALUES (@zl_ulice, @zl_cislo_pop_or, @zl_patro_prip_bod, @zl_telefon_domu_zamest, @zl_mobil, @zl_email_info1, @zl_email_info2, @zl_email, @zl_heslo, @clientTypeId, @zl_line1, @zl_line2, @ZiCysId, @zl_obec);
					SET @contractHistoryId = (SELECT TOP 1 Id FROM dbo.CrmContractHistories ORDER BY Id DESC);

					-- change IsRelevant to false in the dbo.CrmContractHistoryMappings record
					UPDATE dbo.CrmContractHistoryMappings SET IsRelevant = 0 WHERE Id = @contractHistoryMappingId;

					-- create new record in the dbo.CrmContractHistoryMappings and set contractHistoryMappingId to newly created Id
					INSERT INTO dbo.CrmContractHistoryMappings(ContractId, ContractHistoryId)
					VALUES (@contractId, @contractHistoryId);
					SET @contractHistoryMappingId = (SELECT TOP 1 Id FROM dbo.CrmContractHistoryMappings ORDER BY Id DESC);
					
				END
		END
**/

	-- 03.SECTION : dbo.CrmContractOrders operations
	--INSERT INTO dbo.CrmContractOrders(HistoryMappingId, zl_cislo_objednavky, zl_zadano, zl_cas_prislibu_od, zl_cas_prislibu_do, OrderTypeId, zl_cpe_back, zl_instrukce, ProductTypeId, f_pronajem, f_prodej, InetTypeId, CreatedBy)
	--VALUES (@contractHistoryMappingId, @zl_cislo_objednavky, @zl_zadano, @zl_cas_prislibu_od, @zl_cas_prislibu_do, @orderTypeId, @zl_cpe_back, @zl_instrukce, @f_typ_pr, @f_pronajem, @f_prodej, @inetTypeId, @ZiCysId);

	-- Plneni tabulky pro C0
	INSERT INTO dbo.CommunicationMessagesCrmOrder(MessageID, WO_PR_NUMBER, WO_PR_CREATE_DATE, WO_DELIVERY_DATE_FROM, WO_DELIVERY_DATE_TO, WO_CID, WO_FIRST_LAST_NAME, WO_STREET_NAME, WO_HOUSE_NUMBER, WO_CITY, WO_ZIP, WO_PHONE, WO_EMAIL_INFO1, WO_PR_TYPE, WO_FLOOR_FLAT, WO_UPC_TEL1, WO_UPC_TEL2, WO_EMAIL, WO_PASSWORD, WO_CPE_BACK, WO_NOTE, F_CUSTOMER_TYPE, F_PR_TYPE, F_RENTAL, F_SALE, F_INET_CORE_PRODUCT )
	VALUES (@myMessageId, @wo_pr_number, @wo_pr_create_datetime, @wo_delivery_datetime_from, @wo_delivery_datetime_to, @wo_cid, @wo_first_last_name, @wo_street_name, @wo_house_number, @wo_city, @wo_zip, @wo_phone, @wo_email_info1, @wo_pr_type, @wo_floor_flat, @wo_upc_tel1, @wo_upc_tel2, @wo_email, @wo_password, @wo_cpe_back, @wo_note, @f_customer_type, @f_pr_type, @f_rental, @f_sale, @f_inet_core_product)

	--RETURN 1;
		
END
