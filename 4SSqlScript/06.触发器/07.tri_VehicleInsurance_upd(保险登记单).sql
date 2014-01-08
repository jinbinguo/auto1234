if exists (select 1 from sysobjects where name = 'tri_VehicleInsurance_upd' and xtype='TR')
	drop trigger tri_VehicleInsurance_upd
go
create trigger tri_VehicleInsurance_upd
on t_ats_VehicleInsurance
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
	declare @insuCompanyID int; --保险公司
	declare @forcedNum varchar(100); --强制险保单号
	declare @businessNum varchar(100); --商业险保单号
	declare @insuInvalidDate datetime; --终保日期
	declare @isSettle int; --是否保险结算


	declare cur cursor local for select FID,FMultiCheckStatus,FVehicleId,FInsuCompanyID,FForcedNum,FBusinessNum,FInvalidDate,FIsInsuranceSettle from inserted;
	open cur;
	fetch cur into @interId,@newStatus,@vehicleId,@insuCompanyID,@forcedNum,@businessNum,@insuInvalidDate,@isSettle
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
/*		if (@oldStatus = '2' and @newStatus = '4') --启用多级审核
		begin
			if exists (
			select 1 from (
				select c.FAgentItemID,SUM(b.FPremium) insuPremium from T_ATS_VehicleInsurance a
				inner join T_ATS_VehicleInsuranceEntry b on b.FID=a.FID and b.FID<>0 
				left join T_ATS_InsuranceProduct c on b.FInsuProductID=c.FID and c.FID<>0
				where a.FClassID_SRC=200000045 and a.FID=@interId
				group by c.FAgentItemID) aa
				inner join (
				select a1.FAgentItemID, sum(a1.FTotalARAmount) agentPremium from T_ATS_AgentServiceEntry a1 
				where a1.FID=(select b1.FID_SRC from T_ATS_VehicleInsurance b1 where b1.FClassID_SRC=200000045 and b1.FID=@interId)
				group by a1.FAgentItemID ) bb on aa.FAgentItemID=bb.FAgentItemID and aa.FAgentItemID<>0
				where aa.insuPremium <> bb.agentPremium)
			begin
				raiserror('保险登记的各保费与代办服务单的各保险项目的总应收金额不符,不允许启用审核',16,1)
			end;
			
		end;
*/	
		if (@isAudit = 1)--审核
		begin	
			--更新车辆保险信息
			update t_ats_vehicle
			set FInsuCompanyID=@insuCompanyID,
				FForcedNum =@forcedNum,
				FBusinessNum=@businessNum,
				FInsuInvalidDate=@insuInvalidDate
			where FID=@vehicleId

			--更新代办服务单，保险信息
			update a
			set FInsuCompanyID=b.FInsuCompanyID,
				FInsuranEffectDate = b.FEffectDate,
				FInsuranInvalidDate=b.FInvalidDate
			from T_ATS_AgentService a
			inner join inserted b on b.FID_SRC=a.FID 
			where a.FID=b.FID_SRC and b.FClassID_SRC=200000045
		end;
		if (@isUnAudit = 1) --反审核
		begin
			if exists (select 1 from t_RP_ARPBillEntry where FClassID_SRC=200000047 and FID_SRC=@interId)
			begin
				raiserror('已生成下游其他应付单,不能驳回审核',16,1)
			end

			if @isSettle = 1 
			begin
				raiserror('已保险结算，不允许反审核',16,1)
			end
		end

		set @isAudit = 0;
		set @isUnAudit = 0;
		fetch next from cur into @interId,@newStatus,@vehicleId,@insuCompanyID,@forcedNum,@businessNum,@insuInvalidDate,@isSettle
	end;
	close cur;
	deallocate cur;

end


