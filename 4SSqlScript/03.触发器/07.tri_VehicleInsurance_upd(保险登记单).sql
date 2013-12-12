if exists (select 1 from sysobjects where name = 'tri_VehicleInsurance_upd' and xtype='TR')
	drop trigger tri_VehicleInsurance_upd
go
create trigger tri_VehicleInsurance_upd
on t_ats_VehicleInsurance
for update
as
begin
/**
�߼�:

*/
	set nocount on;
	declare @isAudit bit = 0; --�Ƿ���˲���
	declare @isUnAudit bit = 0; --�Ƿ���˲���
	declare @oldStatus nvarchar(255); --�ɵ���״̬
	declare @newStatus nvarchar(255); --�µ���״̬
	declare @interId int; --��������
	declare @vehicleId int; --��������
	declare @insuCompanyID int; --���չ�˾
	declare @forcedNum varchar(100); --ǿ���ձ�����
	declare @businessNum varchar(100); --��ҵ�ձ�����
	declare @insuInvalidDate datetime; --�ձ�����
	declare @isSettle int; --�Ƿ��ս���


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
/*		if (@oldStatus = '2' and @newStatus = '4') --���ö༶���
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
				raiserror('���յǼǵĸ������������񵥵ĸ�������Ŀ����Ӧ�ս���,�������������',16,1)
			end;
			
		end;
*/	
		if (@isAudit = 1)--���
		begin	
			update t_ats_vehicle
			set FInsuCompanyID=@insuCompanyID,
				FForcedNum =@forcedNum,
				FBusinessNum=@businessNum,
				FInsuInvalidDate=@insuInvalidDate
			where FID=@vehicleId
		end;
		if (@isUnAudit = 1) --�����
		begin
			if exists (select 1 from t_RP_ARPBillEntry where FClassID_SRC=200000047 and FID_SRC=@interId)
			begin
				raiserror('��������������Ӧ����,���ܲ������',16,1)
			end

			if @isSettle = 1 
			begin
				raiserror('�ѱ��ս��㣬���������',16,1)
			end
		end

		set @isAudit = 0;
		set @isUnAudit = 0;
		fetch next from cur into @interId,@newStatus,@vehicleId,@insuCompanyID,@forcedNum,@businessNum,@insuInvalidDate,@isSettle
	end;
	close cur;
	deallocate cur;

end


