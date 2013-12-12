if exists (select 1 from sysobjects where name = 'tri_Delivery_upd' and xtype='TR')
	drop trigger tri_Delivery_upd
go
create trigger tri_Delivery_upd
on t_ats_Delivery
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
	declare @sourceInterId int; --来源单内码
	declare @sourceEntryId int; --来源单分录内码
	declare @sourceTranType int; --来源单据类型 200000028->整车销售订单
	declare @isIssue bit; --是否已出库
	declare @isDelivery bit; --是否已交车
	declare @vehicleId int; --车辆ID
	
	declare cur cursor local for select FID,FMultiCheckStatus from inserted;
	open cur;
	fetch cur into @interId,@newStatus
	while (@@FETCH_STATUS=0)
	begin
		select @oldStatus = isnull(FMultiCheckStatus,'') from deleted where FID = @interId;
		if (@newStatus = '16' and @oldStatus <> '16') 
		begin 
			set @isAudit = 1; 
			--更新交车单审核日期
			update t_ats_Delivery
			set FAuditTime = GETDATE()
			where FID = @interId;
		end;
		if (@newStatus <> '16' and @oldStatus = '16')
		begin
			set @isUnAdit = 1;
			--更新交车单审核日期
			update t_ats_Delivery
			set FAuditTime = null
			where FID = @interId;
		end;
		
		--来源自[整车销售订单]的[交车单]审核与反审核操作后反写[整车销售订单]、[车辆]
		if (@isAudit = 1 or @isUnAdit = 1)--审核或反审核
		begin
			declare cur1 cursor local for select FID_Src,FEntryID_Src,FClassID_Src,FVehicleId from t_ats_DeliveryEntry where FID=@interId;
			open cur1;
			fetch cur1 into @sourceInterId,@sourceEntryId,@sourceTranType,@vehicleId
			while (@@FETCH_STATUS = 0)
			begin
				if (@isAudit=1 and @sourceTranType = 200000028 ) --审核
				begin
					select @isDelivery = FIsDelivery from T_ATS_VehicleSaleOrderEntry where FID=@sourceInterId and FEntryID=@sourceEntryId;
					if (@isDelivery=1) raiserror('车辆已交车，不允许审核交车单',16,1)
					--反写整车销售订单交车状态为“已交车”
					update T_ATS_VehicleSaleOrderEntry
					set FIsDelivery = 1
					where FID=@sourceInterId and FEntryID=@sourceEntryId;
					--更新车辆状态为“已交车”
					update t_ats_vehicle
					set FVehicleStatus = '4'
					where FID=@vehicleId;
				end
				else if (@isUnAdit = 1 and @sourceTranType = 200000028 ) --反审核
				begin
					--反写整车销售订单交车状态为“未交车”
					update T_ATS_VehicleSaleOrderEntry
					set FIsDelivery = 0
					where FID=@sourceInterId and FEntryID=@sourceEntryId 
					--更新车辆状态为“已出库”
					update t_ats_vehicle
					set FVehicleStatus = '3'
					where FID=@vehicleId;
				end

				fetch next from cur1 into @sourceInterId,@sourceEntryId,@sourceTranType,@vehicleId
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


