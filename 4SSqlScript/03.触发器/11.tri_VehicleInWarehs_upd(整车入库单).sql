if exists (select 1 from sysobjects where name = 'tri_VehicleInWarehs_upd' and xtype='TR')
	drop trigger tri_VehicleInWarehs_upd
go
create trigger tri_VehicleInWarehs_upd
on t_ats_vehicleInWarehs
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
	--declare @vehicleNo varchar(80); --��������
	declare @stockId int; --�ֿ�����
	declare @taxAmount float; --��˰�ϼ�
	declare @date datetime;--�ɹ�����

	declare cur cursor local for select FID,FMultiCheckStatus,FDate from inserted;
	open cur;
	fetch cur into @interId,@newStatus,@date
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
			declare cur1 cursor local for select FID_SRC,FEntryID_SRC,FVehicleID,FEntryID,FStockID,FTaxAmount from t_ats_vehicleInWarehsEntry where FID=@interId
			open cur1;
			fetch cur1 into @sourceInterId,@sourceEntryId,@vehicleId,@entryId,@stockId,@taxAmount
			while (@@FETCH_STATUS = 0)
			begin
				if (@isAudit=1) --���
				begin
					--���������ɹ�����
					update a
					set a.FOnRoadStatus='2'
					from T_ATS_VehiclePurOrderEntry a
					left join t_ats_vehicleInWarehsEntry b on b.FID_SRC=a.FID and b.FEntryID_SRC=a.FEntryID 
						and b.FClassID_SRC=200000023 and b.FID<>0
					where a.FID=@sourceInterId AND a.FEntryId=@sourceEntryId
					
					--���³���
					update t_ats_vehicle
					set FStockID = @stockId,
						FVehicleStatus = '1',
						FPurDate = @date,
						FPurAmount = @taxAmount
					where fid=@vehicleID
					
				end
				if (@isUnAudit = 1) --�����
				begin
					if not exists (select 1 from t_ats_vehicle where FID=@vehicleId and FStockID=@stockId)
					begin
						raiserror('������ת�Ʋֿ⣬�����������ⵥ',16,1)
					end
					
					
					if exists (select 1 from t_ats_vehicle where fid=@vehicleId and FVehicleStatus<>'1')
					begin
						raiserror('������״̬�ĳ���,�����������ⵥ',16,1);
					end
					
					--�Ƿ��������βɹ���ֵ��Ʊ
					if exists (select 1 from ICPurchaseEntry where FClassID_SRC=200000059 and FSourceInterId=@interId)
					begin
						raiserror('���������βɹ���ֵ��Ʊ��,���������!',16,1);
					end
				
					--���������ɹ�����
					update a
					set a.FOnRoadStatus='1'
					from T_ATS_VehiclePurOrderEntry a
					left join t_ats_vehicleInWarehsEntry b on b.FID_SRC=a.FID and b.FEntryID_SRC=a.FEntryID 
						and b.FClassID_SRC=200000023 and b.FID<>0
					where a.FID=@sourceInterId AND a.FEntryId=@sourceEntryId
					
					--���³���
					update t_ats_vehicle
					set FStockID = 0,
						FVehicleStatus = '0',
						FPurAmount = 0,
						FPurDate = null
					where fid=@vehicleID
				end
				fetch next from cur1 into @sourceInterId,@sourceEntryId,@vehicleId,@entryId,@stockId,@taxAmount
			end;
			close cur1;
			deallocate cur1;

		end;

		set @isAudit = 0;
		set @isUnAudit = 0;
		fetch next from cur into @interId,@newStatus,@date
	end;
	close cur;
	deallocate cur;

end


