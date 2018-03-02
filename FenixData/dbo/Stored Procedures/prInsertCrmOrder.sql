-- =============================================
-- Author:		David Johanovsky
-- Create date: 07.07.2016
-- Description:	Insertion, validation and logic behind creation of a new order and related entities from CRM
-- =============================================
CREATE PROCEDURE [dbo].[prInsertCrmOrder]

	-- CrmContract required
	@zl_cislo_smlouvy INT,
	@zl_jmeno_a_prijmeni NVARCHAR(100),

	-- CrmContractHistory required
	@zl_ulice NVARCHAR(100),
	@zl_cislo_pop_or NVARCHAR(20),
	@zl_patro_prip_bod NVARCHAR(50),
	@f_typ_klienta NVARCHAR(30),
	@zl_obec NVARCHAR(100),

	-- CrmContractHistory not-required
	@zl_telefon_domu_zamest NVARCHAR(50) = NULL,
	@zl_mobil NVARCHAR(20) = NULL,
	@zl_email_info1 NVARCHAR(80) = NULL,
	@zl_email_info2 NVARCHAR(50) = NULL,
	@zl_email NVARCHAR(100) = NULL,
	@zl_heslo NVARCHAR(20) = NULL,
	@zl_line1 NVARCHAR(15) = NULL,
	@zl_line2 NVARCHAR(15) = NULL,

	-- CrmContractOrder required
	@zl_cislo_objednavky NVARCHAR(20),
	@zl_zadano DATE,
	@zl_cas_prislibu_od DATE,
	@zl_cas_prislibu_do DATE,
	@zl_typ_objednavky NVARCHAR(40),
	@f_typ_pr TINYINT, -- 1 = INET / 2 = DTV / 3 = TEL

	-- CrmContractOrder not-required
	@zl_cpe_back NVARCHAR(255) = NULL,
	@zl_instrukce NVARCHAR(150) = NULL,
	@f_pronajem NVARCHAR(255) = NULL,
	@f_prodej NVARCHAR(255) = NULL,
	@f_inet_core_number INT = NULL, -- product number, not name !!!

	-- user in ZiCys who started the procedure
	@ZiCysId INT

AS
BEGIN
	
	SET NOCOUNT ON;

	-- 00.SECTION : basic validations
	IF (@f_typ_pr = 1 AND @f_inet_core_number IS NULL) RETURN -1; -- if INET type, inet_core_number is required
	IF (@f_prodej IS NULL AND @f_pronajem IS NULL) RETURN -2; -- at least one of the following is required
	IF (@f_typ_pr < 1 OR @f_typ_pr > 3) RETURN -3; -- if order type is outside specified range

	-- 01.SECTION : declaring used variables and getting Ids from reusable tables
	DECLARE @contractId INT = (SELECT Id FROM dbo.CrmContracts WHERE zl_cislo_smlouvy = @zl_cislo_smlouvy),
			@clientTypeId INT = (SELECT Id FROM dbo.CrmContractClientTypes WHERE f_typ_klienta = @f_typ_klienta),
			@inetTypeId INT = (SELECT Id FROM dbo.CrmContractInetTypes WHERE f_inet_core_number = @f_inet_core_number),
			@orderTypeId INT = (SELECT Id FROM dbo.CrmContractOrderTypes WHERE zl_typ_objednavky = @zl_typ_objednavky),
			@contractHistoryMappingId INT = 0,
			@contractHistoryId INT = 0;

	-- if contract does not exist
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

	-- 03.SECTION : dbo.CrmContractOrders operations
	INSERT INTO dbo.CrmContractOrders(HistoryMappingId, zl_cislo_objednavky, zl_zadano, zl_cas_prislibu_od, zl_cas_prislibu_do, OrderTypeId, zl_cpe_back, zl_instrukce, ProductTypeId, f_pronajem, f_prodej, InetTypeId, CreatedBy)
	VALUES (@contractHistoryMappingId, @zl_cislo_objednavky, @zl_zadano, @zl_cas_prislibu_od, @zl_cas_prislibu_do, @orderTypeId, @zl_cpe_back, @zl_instrukce, @f_typ_pr, @f_pronajem, @f_prodej, @inetTypeId, @ZiCysId);

	RETURN 1;
		
END
