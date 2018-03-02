
CREATE PROCEDURE [dbo].[prGetIntValueFromCounter]
	@CounterName varchar(50),
	@NewValue int out
/*
	Vrátí novou hodnotu z pocitadla
*/
AS

set xact_abort on

declare @RowCount int
declare @CurrentIntValue int
declare @ResetValue int

set @NewValue = null

BEGIN TRAN

select 
	@CurrentIntValue = IntValue,
	@ResetValue = ResetValue
from 
	[dbo].[Counter] with (TABLOCKX HOLDLOCK)
where 
	CounterName = @CounterName
	

set @RowCount = @@ROWCOUNT


if @RowCount = 0 -- Počítadlo ještě neexistuje, jedná se o první požadavek. Musíme založit počítadlo
begin
	set @NewValue = 1
		
	insert into [dbo].[Counter] (CounterName, IntValue) values (@CounterName, @NewValue)
end

else -- Počítadlo již existuje
begin
	set @NewValue = IsNull(@CurrentIntValue,0) + 1
	
	if @ResetValue is NOT NULL and @CurrentIntValue = @ResetValue set @NewValue = 1


	update 
		[dbo].[Counter]
	set 
		IntValue = @NewValue
	where 
		CounterName = @CounterName
end
	
COMMIT







GO
GRANT EXECUTE
    ON OBJECT::[dbo].[prGetIntValueFromCounter] TO [FenixW]
    AS [dbo];

