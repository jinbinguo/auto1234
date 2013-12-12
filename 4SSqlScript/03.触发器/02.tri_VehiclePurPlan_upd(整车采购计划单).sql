if exists (select 1 from sysobjects where name = 'tri_VehiclePurPlan_upd' and xtype='TR')
	drop trigger tri_VehiclePurPlan_upd
go
create trigger tri_VehiclePurPlan_upd
on t_ats_VehiclePurPlan
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
	declare @entryId int; --单据分录内码
	declare @sourceInterId int; --源单内码
	declare @sourceEntryId int; --源单分录内码
	declare @vehicleId int; --车辆内码
	declare @vehicleNo varchar(80); --车辆编码
	declare @stockId int; --仓库内码

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
		
		if (@isAudit = 1 or @isUnAudit = 1)--审核或反审核
		begin
			if (@isUnAudit =1)
			begin
				if exists (select 1 from T_ATS_VehiclePurOrderEntry where FClassID_SRC=200000066 and FID_SRC=@interId)
				begin
					raiserror('已生成下游整车采购订单,不能驳回审核',16,1)
				end
			end

		end;

		set @isAudit = 0;
		set @isUnAudit = 0;
		fetch next from cur into @interId,@newStatus
	end;
	close cur;
	deallocate cur;

end


