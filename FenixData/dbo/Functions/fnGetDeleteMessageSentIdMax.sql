CREATE FUNCTION [dbo].[fnGetDeleteMessageSentIdMax]
(
)
RETURNS int AS
-- ===============================================================================================
-- Created by   : Rezler Michal
-- Created date : 2015-11-25
-- Used by      : 
-- Description  : vrací maximální ID z tabulky DeleteMessageSent
-- Parameters   : 
-- History :
-- ===============================================================================================
BEGIN

    DECLARE @DeleteMessageSentIdMax int 
    
		SELECT @DeleteMessageSentIdMax = ISNULL(MAX(ID), 0) FROM [dbo].[DeleteMessageSent]
    
    RETURN @DeleteMessageSentIdMax

END

