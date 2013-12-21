if exists (select 1 from sysobjects where name='proc_getModelICItemNum' and xtype='P')
	drop procedure proc_getModelICItemNum
go
create PROCEDURE proc_getModelICItemNum
	@icitemClassID int, --物料分类ID
	@icitemNum varchar(80) output, --物料代码
	@icitemShortNum varchar(80) output, --物料短代码
	@shortNumLength int =4 --物料短代码长度
AS
BEGIN
	SET NOCOUNT ON;
	declare @currentValue int;
	declare @currentShortNumLength int
	declare @icitemClassNum varchar(80);
	begin tran
	begin try
	if OBJECT_ID('T_ATS_ModelICItemMaxNum') is null 
	begin
		create table T_ATS_ModelICItemMaxNum(
			FICItemClassID int, --物料分类ID
			FValue	int, --分类代码最大值
			FShortNumLength int) --物料短代码长度
	end;
	select @icitemClassNum=FNumber from V_ATS_ICItemClass where FID=@icitemClassID;
	select @currentValue=FValue,@currentShortNumLength=FShortNumLength from T_ATS_ModelICItemMaxNum where FICItemClassID=@icitemClassID;
	if @currentValue is null
	begin 
		set @currentShortNumLength = @shortNumLength
		set @currentValue =  1
		insert into T_ATS_ModelICItemMaxNum(FICItemClassID,FValue,FShortNumLength)
			values(@icitemClassID,@currentValue,@currentShortNumLength);
	end;
	else
	begin
		if @currentShortNumLength <> @shortNumLength
		begin 
			raiserror ('参数调用异常,短代码长度前后不一致',16,1);
		end;	
		set @currentValue = @currentValue + 1;
		update T_ATS_ModelICItemMaxNum
		set FValue = @currentValue
		where FICItemClassID = @icitemClassID;
	end;
	
	declare @currentValueLength int
	set @currentValueLength = LEN(@currentValue);
	set @icitemShortNum = REPLICATE('0',@currentShortNumLength-@currentValueLength) + cast(@currentValue as varchar(10));
	select @icitemNum = @icitemClassNum + '.' + @icitemShortNum
	
	if @@ERROR = 0
		commit;
	else rollback;
	
	end try
	begin catch
		declare @errorMsg varchar(4000);
		select @errorMsg=ERROR_MESSAGE();
		raiserror (@errorMsg,16,1)
		rollback;
	end catch
END




