if exists (select 1 from sysobjects where name = 'tri_VehiclePurOrder_upd' and xtype='TR')
	drop trigger tri_VehiclePurOrder_upd
go
create trigger tri_VehiclePurOrder_upd
on t_ats_VehiclePurOrder
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
			if (@isAudit =1)
			begin
				--更新采购计划单已下订单数
	     		update aa
				set aa.FTotalPurQty=aa.FTotalPurQty+bb.totalQty
				from T_ATS_VehiclePurPlanEntry aa
				inner join (
				select FID_SRC,FEntryID_SRC,sum(FQty) totalQty 
					from T_ATS_VehiclePurOrderEntry a 
				where a.FClassID_SRC=200000066 and a.FID=@interId 
				group by FID_SRC,FEntryID_SRC) bb on aa.FID=bb.FID_SRC and aa.FEntryID=bb.FEntryID_SRC
				where exists (select 1 from T_ATS_VehiclePurOrderEntry c where c.FID=@interId and c.FID_SRC=aa.FID)
			end

			if (@isUnAudit =1)
			begin
				if exists (select 1 from t_RP_NewReceiveBill where FClassID_Binding=200000023 and FID_Binding=@interId)
				begin
					raiserror('已关联现金付款单,不能驳回审核',16,1)
				end

				if exists (select 1 from t_ats_vehiclePurCheckEntry where FClassID_SRC=200000023 and FID_SRC=@interId)
				begin
					raiserror('已生成下游整车验收单,不允许反审核!',16,1);
				end
				--是否生成下游采购增值发票
				if exists (select 1 from ICPurchaseEntry where FClassID_SRC=200000023 and FSourceInterId=@interId)
				begin
					raiserror('已生成下游采购增值发票单,不允许反审核!',16,1);
				end

				--更新采购计划单已下订单数
				update aa
				set aa.FTotalPurQty=aa.FTotalPurQty-bb.totalQty
				from T_ATS_VehiclePurPlanEntry aa
				inner join (
				select FID_SRC,FEntryID_SRC,sum(FQty) totalQty 
					from T_ATS_VehiclePurOrderEntry a 
				where a.FClassID_SRC=200000066 and a.FID=@interId 
				group by FID_SRC,FEntryID_SRC) bb on aa.FID=bb.FID_SRC and aa.FEntryID=bb.FEntryID_SRC
				where exists (select 1 from T_ATS_VehiclePurOrderEntry c where c.FID=@interId and c.FID_SRC=aa.FID)
			end

		end;

		set @isAudit = 0;
		set @isUnAudit = 0;
		fetch next from cur into @interId,@newStatus
	end;
	close cur;
	deallocate cur;

end


