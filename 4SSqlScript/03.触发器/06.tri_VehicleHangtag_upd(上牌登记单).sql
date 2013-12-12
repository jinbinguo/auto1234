if exists (select 1 from sysobjects where name = 'tri_VehicleHangtag_upd' and xtype='TR')
	drop trigger tri_VehicleHangtag_upd
go
create trigger tri_VehicleHangtag_upd
on t_ats_vehicleHangtag
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
	declare @vehicleId int; --车辆内码
	declare @plateNum varchar(20); --车牌号
	declare @plateColor varchar(2); --车牌颜色
	declare @regionId int; --行驶证年检所属地
	declare @invalidDate datetime; --行驶证到期日期
	declare @effectDate datetime; --行驶证注册日期
	declare @completeDate datetime; --挂牌完成日期

	declare cur cursor local for select FID,FMultiCheckStatus,FVehicleId,FPlateNum,
			FPlateColor,FRegionID,FInvalidDate,FEffectDate,FCompleteDate from inserted;
	open cur;
	fetch cur into @interId,@newStatus,@vehicleId,@plateNum,@plateColor,@regionId,@invalidDate,@effectDate,@completeDate
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
			update t_ats_vehicle
			set FPlateNum=@plateNum,
				FPlateColor =@plateColor,
				FRegionID = @regionId,
				FInvalidDate = @invalidDate,
				FEffectDate = @effectDate,
				FCompleteDate = @completeDate
			where FID=@vehicleId
		end;
		if (@isUnAudit = 1) --反审核
		begin
			if exists (select 1 from t_RP_ARPBillEntry where FClassID_SRC=200000046 and FID_SRC=@interId)
			begin
				raiserror('已生成下游其他应付单,不能驳回审核',16,1)
			end

			set @plateNum=''
			select top 1 @plateNum=FPlateNum,@plateColor=FPlateColor,@regionId=FRegionID,
			@invalidDate=FInvalidDate,@effectDate=FEffectDate,@completeDate=FCompleteDate
			 from T_ATS_VehicleHangtag where FVehicleID=@vehicleId and FMultiCheckStatus=16 order by FDate desc
			if @plateNum <> ''
			begin
				update t_ats_vehicle
				set FPlateNum=@plateNum,
					FPlateColor =@plateColor,
					FRegionID = @regionId,
					FInvalidDate = @invalidDate,
					FEffectDate = @effectDate,
					FCompleteDate = @completeDate
				where FID=@vehicleId
			end 



		end

		set @isAudit = 0;
		set @isUnAudit = 0;
		fetch next from cur into @interId,@newStatus,@vehicleId,@plateNum,@plateColor,@regionId,@invalidDate,@effectDate,@completeDate
	end;
	close cur;
	deallocate cur;

end


