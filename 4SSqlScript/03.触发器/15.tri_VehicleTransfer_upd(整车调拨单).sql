if exists (select 1 from sysobjects where name = 'tri_VehicleTransfer_upd' and xtype='TR')
	drop trigger tri_VehicleTransfer_upd
go
create trigger tri_VehicleTransfer_upd
on t_ats_VehicleTransfer
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


	declare @issueStockId int; --����ֿ�����
	declare @inWarehsStockId int; --���ֿ�����

	declare cur cursor local for select FID,FMultiCheckStatus,FIssueStockId,FInWarehsStockId from inserted;
	open cur;
	fetch cur into @interId,@newStatus,@issueStockId,@inWarehsStockId
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
			if (@isAudit = 1) 
			begin
				if exists (select 1 from t_ats_vehicleTransferEntry a 
								inner join t_ats_vehicle b on a.FVehicleID=b.FID and b.FID<>0
							where b.FVehicleStatus <> '1' and b.FStatus='2' and a.FID=@interId)
				begin
					raiserror('���ڷ����۵ĳ���������������',16,1)
				end
				--���²ֿ�
				update a
				set FStockID=@inWarehsStockId
				from t_ats_vehicle a
				inner join t_ats_vehicleTransferEntry b on a.FID=b.FVehicleID and b.FVehicleID<>0
				where b.FID=@interId
				
				
				
			end
			
			if (@isUnAudit =1)
			begin
				if exists (select 1 from T_ATS_VehicleTransferEntry a
					inner join T_ATS_VehicleTransfer b on a.FID=b.FID and b.FID<>0
					left join t_ats_vehicle c on c.FID=a.FVehicleID and c.FID<>0
				where b.FInWarehsStockID <> c.FStockID and a.FID=@interId)
				begin
					raiserror('������ת�Ʋ�������������',16,1)
				end
			
				if exists (select 1 from t_ats_vehicleTransferEntry a 
								inner join t_ats_vehicle b on a.FVehicleID=b.FID and b.FID<>0
							where b.FVehicleStatus <> '1' and b.FStatus='2' and a.FID=@interId)
				begin
					raiserror('���ڷ����۵ĳ�����������������',16,1)
				end
				
				--���²ֿ�
				update a
				set FStockID=@issueStockId
				from t_ats_vehicle a
				inner join t_ats_vehicleTransferEntry b on a.FID=b.FVehicleID and b.FVehicleID<>0
				where b.FID=@interId
				
			end

		end;

		set @isAudit = 0;
		set @isUnAudit = 0;
		fetch next from cur into @interId,@newStatus,@issueStockId,@inWarehsStockId
	end;
	close cur;
	deallocate cur;

end


