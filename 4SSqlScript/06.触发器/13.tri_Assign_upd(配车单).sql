if exists (select 1 from sysobjects where name = 'tri_Assign_upd' and xtype='TR')
	drop trigger tri_Assign_upd
go
create trigger tri_Assign_upd
on t_ats_Assign
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
	declare @entryId int; --���ݷ�¼����
	declare @sourceTranType int; --Դ������
	declare @sourceInterId int; --Դ������
	declare @sourceEntryId int; --Դ����¼����
	declare @vehicleId int; --��������
	declare @strOptional varchar(200); --ѡװ
	--declare @vehicleNo varchar(80); --��������
	declare @stockId int; --�ֿ�����

	declare @rsCount int; --���ݲ�ѯ��¼��

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
		if (@isAudit = 1 or @isUnAudit = 1)--��˻����
		begin	
			if (@isAudit=1 and @sourceTranType=200000028) --��ˣ���ԴΪ���۶���
		    begin
				if exists (select 1 from T_ATS_VehicleSaleOrderEntry where FID=@sourceInterId and FEntryID=@sourceEntryId and FIsAssign =1)
				begin
					raiserror('��Դ���۶������䳵���������ظ��䳵',16,1)
				end
				
				--�������۶����䳵��Ϣ
				update a  
				  set a.FIsAssign=1, 
				  a.FAssignDate = c.FDate, 
				  a.FVehicleID = c.FVehicleID ,  
				  a.FAssignBillID=c.FID , 
				  a.FAssignBillNo=c.FBillNo, 
				  a.FVin=d.FVin, 
				  a.FStockId=d.FStockID, 
				  a.FOptional =c.FOptional,
				  a.FInteriorID=c.FInteriorID
				from  T_ATS_VehicleSaleOrderEntry a
				inner join T_ATS_AssignSource b on b.FClassID_SRC=200000028 and b.FID_SRC=a.FID and b.FEntryID_SRC=a.FEntryID and b.FID<>0
				inner join t_ats_Assign c on c.FID=b.FID and c.FID<>0
				left join  t_ats_vehicle d on d.FID=c.FVehicleID  and d.FID<>0
				  where a.FID=@sourceInterId and a.FEntryID=@sourceEntryId;
				--���³���״̬Ϊ���䳵
				update a  
				 set a.FVehicleStatus=2, 
					a.FCustomerID=(select FCustomerID from T_ATS_VehicleSaleOrder where fid=@sourceInterId),  
					a.FCarOwner = (select FCarOwner from T_ATS_VehicleSaleOrder where fid=@sourceInterId),
					a.FOptional= @strOptional
				from t_ats_vehicle a  		
				where fid= @vehicleId;

				--���´�����񵥳���Ϣ
				
				select @rsCount = count(FID) from T_ATS_AgentServiceSource where FID_SRC=@sourceInterId and FEntryID_SRC= @sourceEntryId and FClassID_SRC=200000028;
				if (@rsCount > 1)
					raiserror('�������۶��������˶��ŵĴ�����񵥣��������䳵������ɾ�����������񵥻�ϲ�',16,1)

				update T_ATS_AgentService  
				set FVehicleID=@vehicleId 
				where FID=(select FID from T_ATS_AgentServiceSource 
						where FID_SRC=@sourceInterId and FEntryID_SRC= @sourceEntryId and FClassID_SRC=200000028)

				--���¾�Ʒ�������������Ϣ
				select @rsCount = count(FID) from T_ATS_DecorationOrderSource where FID_SRC=@sourceInterId and FEntryID_SRC=@sourceEntryId and FClassID_SRC=200000028
				if (@rsCount > 1)
					raiserror('�������۶��������˶��ŵľ�Ʒ����������������䳵������ɾ�����ྫƷ���������ϲ�',16,1)

				update T_ATS_DecorationOrder
				set FVehicleID = @vehicleId 
				where fid = (select fid from T_ATS_DecorationOrderSource 
					where FID_SRC=@sourceInterId and FEntryID_SRC=@sourceEntryId and FClassID_SRC=200000028)

		    end;
		    
		    if (@isUnAudit=1 and @sourceTranType=200000028) --����ˣ���ԴΪ���۶���
		    begin
				if exists (select 1 from T_ATS_VehicleSaleOrderEntry where FCheckStatus<>'1' and FID=@sourceInterId and FEntryID=@sourceEntryId)
				begin
					raiserror('�ѽ����飬���������䳵������ȡ��������',16,1)
				end

				if exists (select 1 from T_ATS_DecorationOrderSource a
							where a.FID_SRC=@sourceInterId and a.FEntryID_SRC=@sourceEntryId and a.FClassID_SRC=200000028
						and exists (select 1 from T_ATS_DecorateWOGift b where b.FClassID_SRC=200000054 and b.FID_SRC=a.FID))
				begin
					raiserror('���ξ�Ʒ���۶��������ɾ�Ʒ��װ���������������䳵',16,1)
				end

				if exists (select 1 from T_ATS_VehicleHangtag where FVehicleSEOrderClassID=200000028 and FVehicleSEOrderID=@sourceInterId and FVehicleSEOrderEntryID=@sourceEntryId)
				begin
					raiserror('���δ���������������ƵǼǣ������������䳵',16,1)
				end

				if exists (select 1 from T_ATS_VehicleInsurance where FVehicleSEOrderClassID=200000028 and FVehicleSEOrderID=@sourceInterId and FVehicleSEOrderEntryID=@sourceEntryId)
				begin
					raiserror('���δ�����������ɱ��յǼǵ��������������䳵',16,1)
				end
				if exists (select 1 from T_ATS_VehicleMortgage where FVehicleSEOrderClassID=200000028 and FVehicleSEOrderID=@sourceInterId and FVehicleSEOrderEntryID=@sourceEntryId)
				begin
					raiserror('���δ�����������ɰ��ҵǼǣ������������䳵',16,1)
				end


				-- ���³���״̬Ϊ������
				update t_ats_vehicle
				 set FVehicleStatus=1,
				 FCustomerId=0,
				 FCarOwner=''
				 where fid=@vehicleId;
				 
				 --������۶������䳵���
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

				--���������񵥳�����Ϣ
				select @rsCount = count(FID) from T_ATS_AgentServiceSource where FID_SRC=@sourceInterId and FEntryID_SRC= @sourceEntryId and FClassID_SRC=200000028;
				if (@rsCount > 1)
					raiserror('�������۶��������˶��ŵĴ�����񵥣��������䳵������ɾ�����������񵥻�ϲ�',16,1)

				 update T_ATS_AgentService  
				 set FVehicleID=0 
				 where FID=(select FID from T_ATS_AgentServiceSource 
						where FID_SRC=@sourceInterId and FEntryID_SRC= @sourceEntryId and FClassID_SRC=200000028)
				--�����Ʒ�������������Ϣ
				select @rsCount = count(FID) from T_ATS_DecorationOrderSource where FID_SRC=@sourceInterId and FEntryID_SRC=@sourceEntryId and FClassID_SRC=200000028
				if (@rsCount > 1)
					raiserror('�������۶��������˶��ŵľ�Ʒ����������������䳵������ɾ�����ྫƷ���������ϲ�',16,1)
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


