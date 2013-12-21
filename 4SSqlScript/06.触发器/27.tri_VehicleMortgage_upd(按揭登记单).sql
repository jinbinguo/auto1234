if exists (select 1 from sysobjects where name = 'tri_VehicleMortgage_upd' and xtype='TR')
	drop trigger tri_VehicleMortgage_upd
go
create trigger tri_VehicleMortgage_upd
on t_ats_VehicleMortgage
for update
as
begin
/**
逻辑:

*/
	set nocount on;
	declare @isAudit bit = 0; --是否审核操作
	declare @isUnAudit bit = 0; --是否反审核操作
	declare @oldStatus nvarchar(255); --旧单据状态
	declare @newStatus nvarchar(255); --新单据状态
	declare @interId int; --单据内码

	declare cur cursor local for select FID,FMultiCheckStatus from inserted;
	open cur;
	fetch cur into @interId,@newStatus
	while (@@FETCH_STATUS=0)
	begin
		select @oldStatus = isnull(FMultiCheckStatus,'') from deleted where FID = @interId;
		if (@newStatus = '16' and @oldStatus <> '16') 
		begin 
			set @isAudit = 1; 
		end;
		if (@newStatus <> '16' and @oldStatus = '16')
		begin
			set @isUnAudit = 1;
		end;

		if (@isAudit = 1)--审核
		begin	
			select 1
		end;
		if (@isUnAudit = 1) --反审核
		begin
			if exists (select 1 from t_RP_ARPBillEntry where FClassID_SRC=200000048 and FID_SRC=@interId)
			begin
				raiserror('已生成下游其他应付单,不能驳回审核',16,1)
			end
		end

		set @isAudit = 0;
		set @isUnAudit = 0;
		fetch next from cur into @interId,@newStatus
	end;
	close cur;
	deallocate cur;

end


