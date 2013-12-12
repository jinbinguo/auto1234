if exists (select 1 from sysobjects where name = 'tri_VehicleInWarehs_upd' and xtype='TR')
	drop trigger tri_VehicleInWarehs_upd
go
create trigger tri_VehicleInWarehs_upd
on t_ats_vehicleInWarehs
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
	--declare @vehicleNo varchar(80); --车辆编码
	declare @stockId int; --仓库内码
	declare @taxAmount float; --价税合计
	declare @date datetime;--采购日期

	declare cur cursor local for select FID,FMultiCheckStatus,FDate from inserted;
	open cur;
	fetch cur into @interId,@newStatus,@date
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
			declare cur1 cursor local for select FID_SRC,FEntryID_SRC,FVehicleID,FEntryID,FStockID,FTaxAmount from t_ats_vehicleInWarehsEntry where FID=@interId
			open cur1;
			fetch cur1 into @sourceInterId,@sourceEntryId,@vehicleId,@entryId,@stockId,@taxAmount
			while (@@FETCH_STATUS = 0)
			begin
				if (@isAudit=1) --审核
				begin
					--更新整车采购订单
					update a
					set a.FOnRoadStatus='2'
					from T_ATS_VehiclePurOrderEntry a
					left join t_ats_vehicleInWarehsEntry b on b.FID_SRC=a.FID and b.FEntryID_SRC=a.FEntryID 
						and b.FClassID_SRC=200000023 and b.FID<>0
					where a.FID=@sourceInterId AND a.FEntryId=@sourceEntryId
					
					--更新车辆
					update t_ats_vehicle
					set FStockID = @stockId,
						FVehicleStatus = '1',
						FPurDate = @date,
						FPurAmount = @taxAmount
					where fid=@vehicleID
					
				end
				if (@isUnAudit = 1) --反审核
				begin
					if not exists (select 1 from t_ats_vehicle where FID=@vehicleId and FStockID=@stockId)
					begin
						raiserror('车辆已转移仓库，不允许反审核入库单',16,1)
					end
					
					
					if exists (select 1 from t_ats_vehicle where fid=@vehicleId and FVehicleStatus<>'1')
					begin
						raiserror('非在售状态的车辆,不允许反审核入库单',16,1);
					end
					
					--是否生成下游采购增值发票
					if exists (select 1 from ICPurchaseEntry where FClassID_SRC=200000059 and FSourceInterId=@interId)
					begin
						raiserror('已生成下游采购增值发票单,不允许反审核!',16,1);
					end
				
					--更新整车采购订单
					update a
					set a.FOnRoadStatus='1'
					from T_ATS_VehiclePurOrderEntry a
					left join t_ats_vehicleInWarehsEntry b on b.FID_SRC=a.FID and b.FEntryID_SRC=a.FEntryID 
						and b.FClassID_SRC=200000023 and b.FID<>0
					where a.FID=@sourceInterId AND a.FEntryId=@sourceEntryId
					
					--更新车辆
					update t_ats_vehicle
					set FStockID = 0,
						FVehicleStatus = '0',
						FPurAmount = 0,
						FPurDate = null
					where fid=@vehicleID
				end
				fetch next from cur1 into @sourceInterId,@sourceEntryId,@vehicleId,@entryId,@stockId,@taxAmount
			end;
			close cur1;
			deallocate cur1;

		end;

		set @isAudit = 0;
		set @isUnAudit = 0;
		fetch next from cur into @interId,@newStatus,@date
	end;
	close cur;
	deallocate cur;

end


