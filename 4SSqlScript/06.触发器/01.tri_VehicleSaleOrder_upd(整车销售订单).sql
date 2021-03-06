if exists (select 1 from sysobjects where name = 'tri_VehicleSaleOrder_upd' and xtype='TR')
	drop trigger tri_VehicleSaleOrder_upd
go
create trigger tri_VehicleSaleOrder_upd
on T_ATS_VehicleSaleOrder
for update
as
begin
/**
逻辑:
	1. 交车单审核时，反写来源整车销售订单的交车状态，更新车辆状态为”已交车“
	2. 交车单反审核时，反写来源整车销售订单的交车状态，更新车辆状态为”已出库“
*/
	set nocount on;
	declare @isAudit bit = 0; --是否审核操作
	declare @isUnAdit bit = 0; --是否反审核操作
	declare @oldStatus nvarchar(255); --旧单据状态
	declare @newStatus nvarchar(255); --新单据状态
	declare @interId int; --单据内码
	declare @entryId int; --单据分录内码
	declare @isAssign bit; --是否配车
	
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
			set @isUnAdit = 1;
		end;
		
		--来源自[整车销售订单]的[交车单]审核与反审核操作后反写[整车销售订单]、[车辆]
		if (@isAudit = 1 or @isUnAdit = 1)--审核或反审核
		begin	
			declare cur1 cursor local for select FIsAssign,FEntryID from T_ATS_VehicleSaleOrderEntry where FID=@interId
			open cur1;
			fetch cur1 into @isAssign,@entryId
			while (@@FETCH_STATUS = 0)
			begin
				if (@isUnAdit=1) --反审核
				begin
					--是否已绑定现金收款单或现金付款单
					if exists (select 1 from t_RP_NewReceiveBill where FClassID_Binding=200000028 and FID_Binding=@interId)
					begin
						raiserror('已关联现金收款单或现金付款单,不能驳回审核',16,1)
					end
/*
					--是否已生成精品配件销售订单，若已生成，不允许反审核
					if exists (select 1 from T_ATS_DecorationOrderSource where FID_SRC=@interId and FClassID_SRC=200000028)
					begin
						raiserror('已生成代办服务单,不能驳回审核',16,1)
					end;
					--是否已生成代办服务单，若已生成，不允许反审核
					if exists (select 1 from T_ATS_AgentServiceSource where FID_SRC=@interId and FClassID_SRC=200000028)
					begin
						raiserror('已生成代办服务单,不能驳回审核',16,1)
					end;
*/

					--是否生成销售增值发票单，若生成，不允许反审核
					if exists (select 1 from ICSaleEntry where FSourceInterId=@interId and FClassID_SRC=200000028)
					begin
						raiserror('已生成销售增值发票单,不能驳回审核',16,1)
					end;
					
					if (@isAssign = 1) raiserror('已配车,不能驳回审核',16,1)
					--删除来源为整车销售订单的结算单
					delete from t_ats_SettlementCheck where FID_SRC=@interId and FEntryID_SRC=@entryId and  FCLassID_SRC=200000028;
					--删除来源为整车销售订单的配车单
					delete from T_ATS_Assign where FID in (select fid from T_ATS_AssignSource where FID_SRC=@interId and FEntryID_SRC=@entryId and FCLassID_SRC=200000028);
					delete from T_ATS_AssignSource where FID_SRC=@interId and FEntryID_SRC=@entryId and FCLassID_SRC=200000028;
					--更新整车销售订单
					update T_ATS_VehicleSaleOrderEntry 
					set FIsAssign = 0, --是否配车
					  FAssignDate = null, --配车日期 
					  FVehicleID = 0,  --车辆
					  FAssignBillID=0, --配车单内码
					  FAssignBillNo='', --配车单号
					  FCheckStatus = '1', --结算检查状态,1:未检查
					  FSettlementCheckID = 0 --结算检查单号
					where FID=@interId;	
				end
				fetch next from cur1 into @isAssign,@entryId
			end;
			close cur1;
			deallocate cur1;

		end;

		set @isAudit = 0;
		set @isUnAdit = 0;
		fetch next from cur into @interId,@newStatus
	end;
	close cur;
	deallocate cur;

end


