if exists (select 1 from sysobjects where name = 'tri_VehiclePurCheck_upd' and xtype='TR')
	drop trigger tri_VehiclePurCheck_upd
go
create trigger tri_VehiclePurCheck_upd
on t_ats_vehiclePurCheck
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
			declare cur1 cursor local for select FID_SRC,FEntryID_SRC,FVehicleID,FEntryID from t_ats_vehiclePurCheckEntry where FID=@interId
			open cur1;
			fetch cur1 into @sourceInterId,@sourceEntryId,@vehicleId,@entryId
			while (@@FETCH_STATUS = 0)
			begin
				if (@isAudit=1) --审核
				begin
					--新增/更新车辆
					if @vehicleId is not null and @vehicleId >0
					begin
					   update a
					   set a.FModelID = b.FModelID,
					   a.FCfgDesc=c.FCfgDesc,
					   a.FVIN=b.FVin,
					   a.FEngineNum=b.FEngineNum,
					   a.FInteriorID=b.FInteriorID,
					   a.FColorID=b.FColorID,
					   a.FOptional=b.FOptional,
					   a.FProductDate=b.FProductDate,
					   a.FKeyNum=b.FKeyNum
					   from t_ats_vehicle a
					   left join t_ats_vehiclePurCheckEntry b on b.FVehicleID=a.FID
					   left join T_ATS_Model c on c.FID=b.FModelID and c.FID<>0
					   where a.FID=@vehicleId 
					end else begin				
						exec GetICMaxNum 't_ats_vehicle',@vehicleId output
						exec p_BM_GetBillNo 200000022,@vehicleNo output,0,0
						--新增车辆
						
						insert into t_ats_vehicle(FID,FClassTypeID,FModelID,FCfgDesc,FVehicleStatus,
						FVIN,FEngineNum,FBillNo,FPlateNum,FPlateColor,
						FNOTE,FVehicleCreateType,FOptional,FInteriorID,FColorID,
						FStatus,FStockID,FVehicleSource,FProductDate,FKeyNum)
						select @vehicleId,200000022,FModelID,b.FCfgDesc,'0',
						a.FVin,a.FEngineNum,@vehicleNo,'','1',
						'','2',a.FOptional,a.FInteriorID,a.FColorID,
						'2',0,1,FProductDate,FKeyNum
						from t_ats_vehiclePurCheckEntry a 
						left join t_ats_model b on b.fid=a.FModelID and b.FID<>0
						  where a.FID=@interId and a.FEntryID=@entryId;
					end
					--更新验收单
					update t_ats_vehiclePurCheckEntry 
					set FVehicleID = @vehicleId
					where FID=@interId AND FEntryId=@entryId
					 
					--更新采购订单
					update a
					set a.FVehicleID=b.FVehicleID,
						a.FModelID=b.FModelID,
						a.FSeriesID=c.FSeriesID,
						a.FInteriorID=b.FInteriorID,
						a.FColorID=b.FColorID,
						a.FOptional=b.FOptional,
						a.FVin=b.FVin,
						a.FEngineNum=b.FEngineNum,
						a.FIsAccept = 1
					from T_ATS_VehiclePurOrderEntry a
					left join t_ats_vehiclePurCheckEntry b on b.FID_SRC=a.FID and b.FEntryID_SRC=a.FEntryID 
						and b.FClassID_SRC=200000023 and b.FID<>0
					left join v_ats_model c on c.FID=b.FModelID and c.FID<>0
					where a.FID=@sourceInterId AND a.FEntryId=@sourceEntryId
				end
				if (@isUnAudit = 1) --反审核
				begin
					if exists (select 1 from t_ats_vehicleInWarehsEntry where fclassid_src= 200000023 and FID_SRC=@interId)
					begin
						raiserror('已生成下游整车入库单,不允许反审核!',16,1)
					end
					
					update a
					set a.FIsAccept = 0
					from T_ATS_VehiclePurOrderEntry a
					left join t_ats_vehiclePurCheckEntry b on b.FID_SRC=a.FID and b.FEntryID_SRC=a.FEntryID 
						and b.FClassID_SRC=200000023 and b.FID<>0
					left join v_ats_model c on c.FID=b.FModelID and c.FID<>0
					where a.FID=@sourceInterId AND a.FEntryId=@sourceEntryId
				end
				fetch next from cur1 into @sourceInterId,@sourceEntryId,@vehicleId,@entryId
			end;
			close cur1;
			deallocate cur1;

		end;

		set @isAudit = 0;
		set @isUnAudit = 0;
		fetch next from cur into @interId,@newStatus
	end;
	close cur;
	deallocate cur;

end


