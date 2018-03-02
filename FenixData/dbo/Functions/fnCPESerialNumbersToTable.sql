CREATE FUNCTION [dbo].[fnCPESerialNumbersToTable]
( 
				@ID int        
) 
RETURNS @OutputTable TABLE (ID int, SN NVARCHAR(30)) 
AS 
-- ==========================================================================================================
-- Created by   : Rezler Michal
-- Created date : 2015-05-22
-- Used by      : 
-- Description  : Seznam sériových čísel pro zadané ID (tab. CommunicationMessagesReceptionConfirmationItems)
-- Parameters   : 
-- History      :
-- ==========================================================================================================
BEGIN 

		DECLARE @StringInput NVARCHAR(MAX) 
		SELECT @StringInput = RCI.ItemSNs
		FROM [dbo].[CommunicationMessagesReceptionConfirmationItems] RCI
		WHERE RCI.ID = @ID
		
    DECLARE @StringValue NVARCHAR(30) 
    SET @StringInput = RTRIM(LTRIM(@StringInput)) 
      
    WHILE LEN(@StringInput) > 0 
    BEGIN 
        SET @StringValue = LEFT(@StringInput,  
                          ISNULL(NULLIF(CHARINDEX(',', @StringInput) - 1, -1), 
                          LEN(@StringInput))) 
      
        SET @StringInput = SUBSTRING(@StringInput, 
                          ISNULL(NULLIF(CHARINDEX(',', @StringInput), 0), 
                          LEN(@StringInput)) + 1, LEN(@StringInput)) 
      
        SET @StringInput = RTRIM(LTRIM(@StringInput)) 
      
        INSERT INTO @OutputTable (ID, SN ) 
                          VALUES (@ID, @StringValue ) 
    END 
      
    RETURN 
END 

GO
GRANT SELECT
    ON OBJECT::[dbo].[fnCPESerialNumbersToTable] TO [mis]
    AS [dbo];

