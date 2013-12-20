if exists (select 1 from sysobjects where name = 'tri_VehicleAlterCfg_upd' and xtype='TR')
	drop trigger tri_VehicleAlterCfg_upd
go
create trigger tri_VehicleAlterCfg_upd
on T_ATS_VehicleAlterCfg
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


	

	declare cur cursor local for select FID,FMultiCheckStatus,FVehicleId from inserted;
	open cur;
	fetch cur into @interId,@newStatus,@vehicleId
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
				if exists (select 1 from T_ATS_Vehicle where FID =@vehicleId and FVehicleStatus >='4')
				begin
					raiserror('�����ѽ�������������˳������ñ��',16,1)
				end

				--����������������ٴα��ʱ�����������
				if not exists (				
						select 1 from t_ats_vehicle a
						inner join inserted b on a.fid=b.FVehicleID 
										and b.FVehicleID<>0 
										and a.FModelID = b.FNewModelID
										and a.FColorID = b.FNewColorID
										and a.FInteriorID = b.FNewInteriorID
										and a.FOptional = b.FNewOptional
										and a.FCfgDesc = b.FNewCfgDesc
						where a.fid=@vehicleID )
				begin
					raiserror('���������ѱ������������˳������ñ��',16,1)
				end

				--��ԭ����
				update a
				set a.FModelID = b.FOldModelID,
					a.FColorID = b.FOldColorID,
					a.FInteriorID = b.FOldInteriorID,
					a.FOptional = b.FOldOptional,
					a.FCfgDesc = b.FOldCfgDesc
				from T_ATS_Vehicle a
				inner join inserted b on a.fid=b.FVehicleID and a.fid<>0
				where b.FID = @interId and a.fid=@vehicleID

			end

			if (@isAudit =1 )
			begin
				--����������������ٴα��ʱ�����������
				if not exists (				
						select 1 from t_ats_vehicle a
						inner join inserted b on a.fid=b.FVehicleID 
										and b.FVehicleID<>0 
										and a.FModelID = b.FOldModelID 
										and a.FColorID = b.FOldColorID
										and a.FInteriorID = b.FOldInteriorID
										and a.FOptional = b.FOldOptional 
										and a.FCfgDesc = b.FOldCfgDesc 
						where a.fid=@vehicleID )
				begin
					raiserror('���������ѱ������������˳������ñ��',16,1)
				end

				--��������
				update a
				set a.FModelID = b.FNewModelID,
					a.FColorID = b.FNewColorID,
					a.FInteriorID = b.FNewInteriorID,
					a.FOptional = b.FNewOptional,
					a.FCfgDesc = b.FNewCfgDesc
				from T_ATS_Vehicle a
				inner join inserted b on a.fid=b.FVehicleID and a.fid<>0
				where b.FID = @interId and a.fid=@vehicleID

				
			end 

			


		end;

		set @isAudit = 0;
		set @isUnAudit = 0;
		fetch next from cur into @interId,@newStatus,@vehicleId
	end
	close cur;
	deallocate cur;

end


