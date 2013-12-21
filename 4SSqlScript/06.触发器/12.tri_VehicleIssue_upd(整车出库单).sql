if exists (select 1 from sysobjects where name = 'tri_VehicleIssue_upd' and xtype='TR')
	drop trigger tri_VehicleIssue_upd
go
create trigger tri_VehicleIssue_upd
on t_ats_vehicleIssue
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
	declare @sourceInterId int; --Դ������
	declare @sourceEntryId int; --Դ����¼����
	declare @vehicleId int; --��������
	declare @vehicleNo varchar(80); --��������
	declare @stockId int; --�ֿ�����
	declare @customerId int ; --�ͻ�

	declare cur cursor local for select FID,FMultiCheckStatus,FCustomerId from inserted;
	open cur;
	fetch cur into @interId,@newStatus,@customerId
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
		if (@isAudit = 1 or @isUnAudit = 1)--��˻����
		begin	
			declare cur1 cursor local for select FID_SRC,FEntryID_SRC,FVehicleID,FEntryID,FStockID from t_ats_vehicleIssueEntry where FID=@interId
			open cur1;
			fetch cur1 into @sourceInterId,@sourceEntryId,@vehicleId,@entryId,@stockId
			while (@@FETCH_STATUS = 0)
			begin
				if (@isAudit=1) --���
				begin
					--�����������۶���
					update a
					set a.FIsIssue=1
					from T_ATS_VehicleSaleOrderEntry a
					left join T_ATS_VehicleIssueEntry b on b.FID_SRC=a.FID and b.FEntryID_SRC=a.FEntryID 
						and b.FClassID_SRC=200000028 and b.FID<>0
					where a.FID=@sourceInterId AND a.FEntryId=@sourceEntryId
					
					--���³���
					update t_ats_vehicle
					set FVehicleStatus = '3',
						FStockID=0
					where fid=@vehicleID
					
				end
				if (@isUnAudit = 1) --�����
				begin
					if not exists (select 1 from t_ats_vehicle where FID=@vehicleId and FCustomerID=@customerId)
					begin
						raiserror('������ת�ۣ������������ⵥ',16,1)
					end
					
					if exists (select 1 from t_ats_vehicle where fid=@vehicleId and FVehicleStatus<>'3')
					begin
						raiserror('���ѳ���״̬�ĳ�����������˳��ⵥ',16,1);
					end
					
					--�Ƿ�����������ֵ��Ʊ���������ɣ����������
					if exists (select 1 from ICSaleEntry where FSourceInterId=@interId and FClassID_SRC=200000060)
					begin
						raiserror('������������ֵ��Ʊ��,���ܲ������',16,1)
					end;
					
					--�����������۶���
					update a
					set a.FIsIssue=0
					from T_ATS_VehicleSaleOrderEntry a
					left join T_ATS_VehicleIssueEntry b on b.FID_SRC=a.FID and b.FEntryID_SRC=a.FEntryID 
						and b.FClassID_SRC=200000028 and b.FID<>0
					where a.FID=@sourceInterId AND a.FEntryId=@sourceEntryId
					
					--���³���
					update t_ats_vehicle
					set FVehicleStatus = '2'
					where fid=@vehicleID
				end
				fetch next from cur1 into @sourceInterId,@sourceEntryId,@vehicleId,@entryId,@stockId
			end;
			close cur1;
			deallocate cur1;

		end;

		set @isAudit = 0;
		set @isUnAudit = 0;
		fetch next from cur into @interId,@newStatus,@customerId
	end;
	close cur;
	deallocate cur;

end


