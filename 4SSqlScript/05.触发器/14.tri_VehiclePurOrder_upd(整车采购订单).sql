if exists (select 1 from sysobjects where name = 'tri_VehiclePurOrder_upd' and xtype='TR')
	drop trigger tri_VehiclePurOrder_upd
go
create trigger tri_VehiclePurOrder_upd
on t_ats_VehiclePurOrder
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
			if (@isAudit =1)
			begin
				--���²ɹ��ƻ������¶�����
	     		update aa
				set aa.FTotalPurQty=aa.FTotalPurQty+bb.totalQty
				from T_ATS_VehiclePurPlanEntry aa
				inner join (
				select FID_SRC,FEntryID_SRC,sum(FQty) totalQty 
					from T_ATS_VehiclePurOrderEntry a 
				where a.FClassID_SRC=200000066 and a.FID=@interId 
				group by FID_SRC,FEntryID_SRC) bb on aa.FID=bb.FID_SRC and aa.FEntryID=bb.FEntryID_SRC
				where exists (select 1 from T_ATS_VehiclePurOrderEntry c where c.FID=@interId and c.FID_SRC=aa.FID)
			end

			if (@isUnAudit =1)
			begin
				if exists (select 1 from t_RP_NewReceiveBill where FClassID_Binding=200000023 and FID_Binding=@interId)
				begin
					raiserror('�ѹ����ֽ𸶿,���ܲ������',16,1)
				end

				if exists (select 1 from t_ats_vehiclePurCheckEntry where FClassID_SRC=200000023 and FID_SRC=@interId)
				begin
					raiserror('�����������������յ�,���������!',16,1);
				end
				--�Ƿ��������βɹ���ֵ��Ʊ
				if exists (select 1 from ICPurchaseEntry where FClassID_SRC=200000023 and FSourceInterId=@interId)
				begin
					raiserror('���������βɹ���ֵ��Ʊ��,���������!',16,1);
				end

				--���²ɹ��ƻ������¶�����
				update aa
				set aa.FTotalPurQty=aa.FTotalPurQty-bb.totalQty
				from T_ATS_VehiclePurPlanEntry aa
				inner join (
				select FID_SRC,FEntryID_SRC,sum(FQty) totalQty 
					from T_ATS_VehiclePurOrderEntry a 
				where a.FClassID_SRC=200000066 and a.FID=@interId 
				group by FID_SRC,FEntryID_SRC) bb on aa.FID=bb.FID_SRC and aa.FEntryID=bb.FEntryID_SRC
				where exists (select 1 from T_ATS_VehiclePurOrderEntry c where c.FID=@interId and c.FID_SRC=aa.FID)
			end

		end;

		set @isAudit = 0;
		set @isUnAudit = 0;
		fetch next from cur into @interId,@newStatus
	end;
	close cur;
	deallocate cur;

end


