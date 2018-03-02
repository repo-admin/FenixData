
CREATE PROCEDURE [dbo].[prDestinationPlaces]
      @ID                              int =-1,
      @OrganisationNumber              int =-1,
      @CompanyName                     nvarchar(100),
      @City                            nvarchar(150),
      @StreetName                      nvarchar(100),
      @StreetOrientationNumber         nvarchar(15),
      @StreetHouseNumber               nvarchar(35),
      @ZipCode                         nvarchar(10),
      @IdCountry                       nvarchar(3),
      @ICO                             nvarchar(20),
      @DIC                             nvarchar(15),
      @Type                            nvarchar(10),
      @CountryISO                      nvarchar(13),
      @chkbIsActive                    bit,
      @ModifyUserId                    int = 0,
	   @ReturnValue     int            = -1   OUTPUT,
	   @ReturnMessage   nvarchar(2048) = null OUTPUT
AS
BEGIN
-- ===============================================================================================
-- Created by   : Weczerek Max
-- Created date : 2014-08-12
--                2014-09-30
-- Description  : Mění resp. přidávají záznamy do tabulky [dbo].[cdlDestinationPlaces]
-- ===============================================================================================
	SET NOCOUNT ON;


   DECLARE  @myError     int
           ,@myIdentity  int

DECLARE @myDatabaseName  nvarchar(100)
BEGIN TRY

    SELECT @myDatabaseName = DB_NAME() 

   BEGIN TRAN

   IF @ID = -1
   BEGIN
      -- NOVY
         INSERT INTO [dbo].[cdlDestinationPlaces]
                    ([OrganisationNumber]
                    ,[CompanyName]
                    ,[City]
                    ,[StreetName]
                    ,[StreetOrientationNumber]
                    ,[StreetHouseNumber]
                    ,[ZipCode]
                    ,[IdCountry]
                    ,[ICO]
                    ,[DIC]
                    ,[Type]
                    ,[IsSent]
                    ,[SentDate]
                    ,[CountryISO]
                    ,[IsActive]
                    ,[ModifyDate]
                    ,[ModifyUserId])
              VALUES
                    ( @OrganisationNumber      -- <OrganisationNumber, int,>
                    , @CompanyName             -- <CompanyName, nvarchar(100),>
                    , @City                    -- <City, nvarchar(150),>
                    , @StreetName              -- <StreetName, nvarchar(100),>
                    , @StreetOrientationNumber -- <StreetOrientationNumber, nvarchar(15),>
                    , @StreetHouseNumber       -- <StreetHouseNumber, nvarchar(35),>
                    , @ZipCode                 -- <ZipCode, nvarchar(10),>
                    , @IdCountry               -- <IdCountry, nvarchar(3),>
                    , @ICO                     -- <ICO, nvarchar(20),>
                    , @DIC                     -- <DIC, nvarchar(15),>
                    , @Type                    -- <Type, nvarchar(10),>
                    , 0                        -- <IsSent, bit,>
                    , NULL                     -- 
                    , @CountryISO              -- 
                    , @chkbIsActive            -- <SentDate, datetime,>
                    , GetDate()                -- <CountryISO, char(3),>
                    , @ModifyUserId            -- <IsActive, bit,>
              )
              SET @myError = @@ERROR

   END
   ELSE
   BEGIN
      -- UPDATE
      UPDATE [dbo].[cdlDestinationPlaces]   
        SET [OrganisationNumber]      =     @OrganisationNumber           -- <OrganisationNumber, int,>
           ,[CompanyName]             =     @CompanyName                  -- <CompanyName, nvarchar(100),>
           ,[City]                    =     @City                         -- <City, nvarchar(150),>
           ,[StreetName]              =     @StreetName                   -- <StreetName, nvarchar(100),>
           ,[StreetOrientationNumber] =     @StreetOrientationNumber      -- <StreetOrientationNumber, nvarchar(15),>
           ,[StreetHouseNumber]       =     @StreetHouseNumber            -- <StreetHouseNumber, nvarchar(35),>
           ,[ZipCode]                 =     @ZipCode                      -- <ZipCode, nvarchar(10),>
           ,[IdCountry]               =     @IdCountry                    -- <IdCountry, nvarchar(3),>
           ,[ICO]                     =     @ICO                          -- <ICO, nvarchar(20),>
           ,[DIC]                     =     @DIC                          -- <DIC, nvarchar(15),>
           ,[Type]                    =     @Type                         -- <Type, nvarchar(10),>
           ,IsSent                    =     0
           ,SentDate                  =     NULL
           ,[CountryISO]              =     @CountryISO                   -- <CountryISO, char(3),>
           ,[IsActive]                =     @chkbIsActive                 -- <IsActive, bit,>
           ,[ModifyDate]              =     GetDate()                     -- <ModifyDate, datetime,>
           ,[ModifyUserId]            =     @ModifyUserId                 -- <ModifyUserId, int,>
      WHERE ID = @ID
      SET @myError = @@ERROR
   END
   IF @myError = 0 
   BEGIN
                         IF @@TRANCOUNT > 0 COMMIT TRAN 
                         SET @ReturnMessage = ISNULL(ERROR_MESSAGE(),'OK')  -- 'OK'
                         SET @ReturnValue = @myError
   END
   ELSE
   BEGIN
    IF @@TRANCOUNT>0 ROLLBACK TRAN
    SET @ReturnValue   = @myError
    SET @ReturnMessage = ISNULL(ERROR_MESSAGE(),'')

   END
   IF @@TRANCOUNT>0 ROLLBACK TRAN
END TRY
BEGIN CATCH
    IF @@TRANCOUNT>0 ROLLBACK TRAN
    SET @ReturnValue  = @@ERROR
    SET @ReturnMessage = ISNULL(ERROR_MESSAGE(),'')
END CATCH
 
	
END



GO
GRANT EXECUTE
    ON OBJECT::[dbo].[prDestinationPlaces] TO [FenixW]
    AS [dbo];

