if exists (select 1 from sysobjects where name = 'tri_VehiclePurPlan_upd' and xtype='TR')
	drop trigger tri_VehiclePurPlan_upd
go
create trigger tri_VehiclePurPlan_upd
on t_ats_VehiclePurPlan
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
		
		if (@isAudit = 1 or @isUnAudit = 1)--��˻����
		begin
			if (@isUnAudit =1)
			begin
				if exists (select 1 from T_ATS_VehiclePurOrderEntry where FClassID_SRC=200000066 and FID_SRC=@interId)
				begin
					raiserror('���������������ɹ�����,���ܲ������',16,1)
				end
			end

		end;

		set @isAudit = 0;
		set @isUnAudit = 0;
		fetch next from cur into @interId,@newStatus
	end;
	close cur;
	deallocate cur;

end


