if exists (select 1 from sysobjects where name = 'tri_AgentService_upd' and xtype='TR')
	drop trigger tri_AgentService_upd
go
create trigger tri_AgentService_upd
on t_ats_AgentService
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
	declare @yearExamineExpireDate datetime; --车辆年审到期日
	

	declare cur cursor local for select FID,FMultiCheckStatus,FVehicleId,FYearExamineExpireDate from inserted;
	open cur;
	fetch cur into @interId,@newStatus,@vehicleId,@yearExamineExpireDate
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
				update T_ATS_Vehicle
				set FYearExamineExpireDate=@yearExamineExpireDate
				where FID=@vehicleId;
			end
			
			if (@isUnAudit =1)
			begin
				if exists (select 1 from t_RP_NewReceiveBill where FClassID_Binding=200000045 and FID_Binding=@interId)
				begin
					raiserror('已关联现金收款单或现金付款单,不能驳回审核',16,1)
				end

				if exists (select 1 from t_RP_ARPBillEntry where FClassID_SRC=200000045 and FID_SRC=@interId)
				begin
					raiserror('已生成下游其他应收单,不能驳回审核',16,1)
				end

				if exists (select 1 from inserted where FID=@interId and (FIsHangTag=1 or FIsInsurance=1 or FIsMortgage=1))
				begin
					raiserror('已生成下游单据,不允许反审核',16,1);
				end



			end

			--更新整车销售订单的代办应收金额
			update a
			set FARAgentAmount=(select isnull(sum(aa.FTotalARAmount),0) from T_ATS_AgentServiceEntry aa
									inner join T_ATS_AgentService bb on bb.FID=aa.FID and bb.FID <>0
									inner join T_ATS_AgentServiceSource cc on cc.FID = aa.FID and cc.FID <> 0 
									where aa.fid=@interId and cc.FClassID_SRC=200000028 and cc.FID_SRC=a.FID 
										and cc.FEntryID_SRC =a.FEntryID and bb.FMultiCheckStatus = '16' )
			from T_ATS_VehicleSaleOrderEntry a
			where exists (select 1 from T_ATS_AgentServiceSource a1 where 
				a1.FID = @interId and a1.FClassID_SRC=200000028 and a1.FID_SRC=a.FID and a1.FEntryID_SRC =a.FEntryID)



		end;

		set @isAudit = 0;
		set @isUnAudit = 0;
		fetch next from cur into @interId,@newStatus,@vehicleId,@yearExamineExpireDate
	end
	close cur;
	deallocate cur;

end


