if exists (select 1 from sysobjects where name = 'tri_VehicleTransfer_upd' and xtype='TR')
	drop trigger tri_VehicleTransfer_upd
go
create trigger tri_VehicleTransfer_upd
on t_ats_VehicleTransfer
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


	declare @issueStockId int; --出库仓库内码
	declare @inWarehsStockId int; --入库仓库内码

	declare cur cursor local for select FID,FMultiCheckStatus,FIssueStockId,FInWarehsStockId from inserted;
	open cur;
	fetch cur into @interId,@newStatus,@issueStockId,@inWarehsStockId
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
			if (@isAudit = 1) 
			begin
				if exists (select 1 from t_ats_vehicleTransferEntry a 
								inner join t_ats_vehicle b on a.FVehicleID=b.FID and b.FID<>0
							where b.FVehicleStatus <> '1' and b.FStatus='2' and a.FID=@interId)
				begin
					raiserror('存在非在售的车辆不允许调拨审核',16,1)
				end
				--更新仓库
				update a
				set FStockID=@inWarehsStockId
				from t_ats_vehicle a
				inner join t_ats_vehicleTransferEntry b on a.FID=b.FVehicleID and b.FVehicleID<>0
				where b.FID=@interId
				
				
				
			end
			
			if (@isUnAudit =1)
			begin
				if exists (select 1 from T_ATS_VehicleTransferEntry a
					inner join T_ATS_VehicleTransfer b on a.FID=b.FID and b.FID<>0
					left join t_ats_vehicle c on c.FID=a.FVehicleID and c.FID<>0
				where b.FInWarehsStockID <> c.FStockID and a.FID=@interId)
				begin
					raiserror('车辆已转移不允许调拨反审核',16,1)
				end
			
				if exists (select 1 from t_ats_vehicleTransferEntry a 
								inner join t_ats_vehicle b on a.FVehicleID=b.FID and b.FID<>0
							where b.FVehicleStatus <> '1' and b.FStatus='2' and a.FID=@interId)
				begin
					raiserror('存在非在售的车辆不允许调拨反审核',16,1)
				end
				
				--更新仓库
				update a
				set FStockID=@issueStockId
				from t_ats_vehicle a
				inner join t_ats_vehicleTransferEntry b on a.FID=b.FVehicleID and b.FVehicleID<>0
				where b.FID=@interId
				
			end

		end;

		set @isAudit = 0;
		set @isUnAudit = 0;
		fetch next from cur into @interId,@newStatus,@issueStockId,@inWarehsStockId
	end;
	close cur;
	deallocate cur;

end


