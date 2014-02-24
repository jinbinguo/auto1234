if exists (select 1 from sysobjects where name = 'tri_Assign_upd' and xtype='TR')
	drop trigger tri_Assign_upd
go
create trigger tri_Assign_upd
on t_ats_Assign
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
	declare @sourceTranType int; --源单类型
	declare @sourceInterId int; --源单内码
	declare @sourceEntryId int; --源单分录内码
	declare @vehicleId int; --车辆内码
	declare @strOptional varchar(200); --选装
	--declare @vehicleNo varchar(80); --车辆编码
	declare @stockId int; --仓库内码

	declare @rsCount int; --数据查询记录数

	declare cur cursor local for select FID,FMultiCheckStatus,FVehicleID,FOptional from inserted;
	open cur;
	fetch cur into @interId,@newStatus,@vehicleId,@strOptional
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
		select @sourceTranType=FClassID_SRC,@sourceInterId=FID_SRC,@sourceEntryId=FEntryID_SRC from T_ATS_AssignSource where FID=@interId
		if (@isAudit = 1 or @isUnAudit = 1)--审核或反审核
		begin	
			if (@isAudit=1 and @sourceTranType=200000028) --审核，来源为销售订单
		    begin
				if exists (select 1 from T_ATS_VehicleSaleOrderEntry where FID=@sourceInterId and FEntryID=@sourceEntryId and FIsAssign =1)
				begin
					raiserror('来源销售订单已配车，不允许重复配车',16,1)
				end
				
				--更新销售订单配车信息
				update a  
				  set a.FIsAssign=1, 
				  a.FAssignDate = c.FDate, 
				  a.FVehicleID = c.FVehicleID ,  
				  a.FAssignBillID=c.FID , 
				  a.FAssignBillNo=c.FBillNo, 
				  a.FVin=d.FVin, 
				  a.FStockId=d.FStockID, 
				  a.FOptional =c.FOptional
				from  T_ATS_VehicleSaleOrderEntry a
				inner join T_ATS_AssignSource b on b.FClassID_SRC=200000028 and b.FID_SRC=a.FID and b.FEntryID_SRC=a.FEntryID and b.FID<>0
				inner join t_ats_Assign c on c.FID=b.FID and c.FID<>0
				left join  t_ats_vehicle d on d.FID=c.FVehicleID  and d.FID<>0
				  where a.FID=@sourceInterId and a.FEntryID=@sourceEntryId;
				--更新车辆状态为已配车
				update a  
				 set a.FVehicleStatus=2, 
					a.FCustomerID=(select FCustomerID from T_ATS_VehicleSaleOrder where fid=@sourceInterId),  
					a.FCarOwner = (select FCarOwner from T_ATS_VehicleSaleOrder where fid=@sourceInterId),
					a.FOptional= @strOptional
				from t_ats_vehicle a  		
				where fid= @vehicleId;

				--更新代办服务单车信息
				
				select @rsCount = count(FID) from T_ATS_AgentServiceSource where FID_SRC=@sourceInterId and FEntryID_SRC= @sourceEntryId and FClassID_SRC=200000028;
				if (@rsCount > 1)
					raiserror('整车销售订单下推了多张的代办服务单，不允许配车，请先删除多余代办服务单或合并',16,1)

				update T_ATS_AgentService  
				set FVehicleID=@vehicleId 
				where FID=(select FID from T_ATS_AgentServiceSource 
						where FID_SRC=@sourceInterId and FEntryID_SRC= @sourceEntryId and FClassID_SRC=200000028)

				--更新精品配件订单车辆信息
				select @rsCount = count(FID) from T_ATS_DecorationOrderSource where FID_SRC=@sourceInterId and FEntryID_SRC=@sourceEntryId and FClassID_SRC=200000028
				if (@rsCount > 1)
					raiserror('整车销售订单下推了多张的精品配件订单，不允许配车，请先删除多余精品配件订单或合并',16,1)

				update T_ATS_DecorationOrder
				set FVehicleID = @vehicleId 
				where fid = (select fid from T_ATS_DecorationOrderSource 
					where FID_SRC=@sourceInterId and FEntryID_SRC=@sourceEntryId and FClassID_SRC=200000028)

		    end;
		    
		    if (@isUnAudit=1 and @sourceTranType=200000028) --反审核，来源为销售订单
		    begin
				if exists (select 1 from T_ATS_VehicleSaleOrderEntry where FCheckStatus<>'1' and FID=@sourceInterId and FEntryID=@sourceEntryId)
				begin
					raiserror('已结算检查，若需重新配车，请先取消结算检查',16,1)
				end

				if exists (select 1 from T_ATS_DecorationOrderSource a
							where a.FID_SRC=@sourceInterId and a.FEntryID_SRC=@sourceEntryId and a.FClassID_SRC=200000028
						and exists (select 1 from T_ATS_DecorateWOGift b where b.FClassID_SRC=200000054 and b.FID_SRC=a.FID))
				begin
					raiserror('下游精品销售订单已生成精品加装单，不允许重新配车',16,1)
				end

				if exists (select 1 from T_ATS_VehicleHangtag where FVehicleSEOrderClassID=200000028 and FVehicleSEOrderID=@sourceInterId and FVehicleSEOrderEntryID=@sourceEntryId)
				begin
					raiserror('下游代办服务已生成上牌登记，不允许重新配车',16,1)
				end

				if exists (select 1 from T_ATS_VehicleInsurance where FVehicleSEOrderClassID=200000028 and FVehicleSEOrderID=@sourceInterId and FVehicleSEOrderEntryID=@sourceEntryId)
				begin
					raiserror('下游代办服务已生成保险登记单，不允许重新配车',16,1)
				end
				if exists (select 1 from T_ATS_VehicleMortgage where FVehicleSEOrderClassID=200000028 and FVehicleSEOrderID=@sourceInterId and FVehicleSEOrderEntryID=@sourceEntryId)
				begin
					raiserror('下游代办服务已生成按揭登记，不允许重新配车',16,1)
				end


				-- 更新车辆状态为在售中
				update t_ats_vehicle
				 set FVehicleStatus=1,
				 FCustomerId=0,
				 FCarOwner=''
				 where fid=@vehicleId;
				 
				 --清除销售订单的配车标记
				update a  
				set a.FIsAssign=0, 
					  a.FAssignDate = null, 
					  a.FVehicleID = 0, 
					  a.FVin='', 
					  a.FStockId=0
				from  T_ATS_VehicleSaleOrderEntry a
				inner join T_ATS_AssignSource b on b.FClassID_SRC=200000028 and b.FID_SRC=a.FID and b.FEntryID_SRC=a.FEntryID and b.FID<>0
				inner join t_ats_Assign c on c.FID=b.FID and c.FID<>0
				  where a.FID=@sourceInterId and a.FEntryID=@sourceEntryId;

				--清除代办服务单车辆信息
				select @rsCount = count(FID) from T_ATS_AgentServiceSource where FID_SRC=@sourceInterId and FEntryID_SRC= @sourceEntryId and FClassID_SRC=200000028;
				if (@rsCount > 1)
					raiserror('整车销售订单下推了多张的代办服务单，不允许反配车，请先删除多余代办服务单或合并',16,1)

				 update T_ATS_AgentService  
				 set FVehicleID=0 
				 where FID=(select FID from T_ATS_AgentServiceSource 
						where FID_SRC=@sourceInterId and FEntryID_SRC= @sourceEntryId and FClassID_SRC=200000028)
				--清除精品配件订单车辆信息
				select @rsCount = count(FID) from T_ATS_DecorationOrderSource where FID_SRC=@sourceInterId and FEntryID_SRC=@sourceEntryId and FClassID_SRC=200000028
				if (@rsCount > 1)
					raiserror('整车销售订单下推了多张的精品配件订单，不允许反配车，请先删除多余精品配件订单或合并',16,1)
				update T_ATS_DecorationOrder
				set FVehicleID = 0 
				where fid = (select fid from T_ATS_DecorationOrderSource 
					where FID_SRC=@sourceInterId and FEntryID_SRC=@sourceEntryId and FClassID_SRC=200000028)


				
		    end;
		end;

		set @isAudit = 0;
		set @isUnAudit = 0;
		fetch next from cur into @interId,@newStatus,@vehicleId,@strOptional
	end;
	close cur;
	deallocate cur;

end


