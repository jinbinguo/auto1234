if exists (select 1 from sysobjects where name = 'tri_VehicleAlterCfg_upd' and xtype='TR')
	drop trigger tri_VehicleAlterCfg_upd
go
create trigger tri_VehicleAlterCfg_upd
on T_ATS_VehicleAlterCfg
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


	

	declare cur cursor local for select FID,FMultiCheckStatus,FVehicleId from inserted;
	open cur;
	fetch cur into @interId,@newStatus,@vehicleId
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
				if exists (select 1 from T_ATS_Vehicle where FID =@vehicleId and FVehicleStatus >='4')
				begin
					raiserror('车辆已交车，不允许反审核车辆配置变更',16,1)
				end

				--如果车辆配置配置再次变更时，不允许反审核
				if not exists (				
						select 1 from t_ats_vehicle a
						inner join inserted b on a.fid=b.FVehicleID 
										and b.FVehicleID<>0 
										and a.FModelID = b.FNewModelID
										and a.FColorID = b.FNewColorID
										and a.FInteriorID = b.FNewInteriorID
										and a.FOptional = b.FNewOptional
										and a.FCfgDesc = b.FNewCfgDesc
						where a.fid=@vehicleID )
				begin
					raiserror('车辆配置已变更，不允许反审核车辆配置变更',16,1)
				end

				--还原配置
				update a
				set a.FModelID = b.FOldModelID,
					a.FColorID = b.FOldColorID,
					a.FInteriorID = b.FOldInteriorID,
					a.FOptional = b.FOldOptional,
					a.FCfgDesc = b.FOldCfgDesc
				from T_ATS_Vehicle a
				inner join inserted b on a.fid=b.FVehicleID and a.fid<>0
				where b.FID = @interId and a.fid=@vehicleID

			end

			if (@isAudit =1 )
			begin
				--如果车辆配置配置再次变更时，不允许反审核
				if not exists (				
						select 1 from t_ats_vehicle a
						inner join inserted b on a.fid=b.FVehicleID 
										and b.FVehicleID<>0 
										and a.FModelID = b.FOldModelID 
										and a.FColorID = b.FOldColorID
										and a.FInteriorID = b.FOldInteriorID
										and a.FOptional = b.FOldOptional 
										and a.FCfgDesc = b.FOldCfgDesc 
						where a.fid=@vehicleID )
				begin
					raiserror('车辆配置已变更，不允许审核车辆配置变更',16,1)
				end

				--更新配置
				update a
				set a.FModelID = b.FNewModelID,
					a.FColorID = b.FNewColorID,
					a.FInteriorID = b.FNewInteriorID,
					a.FOptional = b.FNewOptional,
					a.FCfgDesc = b.FNewCfgDesc
				from T_ATS_Vehicle a
				inner join inserted b on a.fid=b.FVehicleID and a.fid<>0
				where b.FID = @interId and a.fid=@vehicleID

				
			end 

			


		end;

		set @isAudit = 0;
		set @isUnAudit = 0;
		fetch next from cur into @interId,@newStatus,@vehicleId
	end
	close cur;
	deallocate cur;

end


