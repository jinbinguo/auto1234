if exists (select 1 from sysobjects where name = 'tri_VehicleHangtag_upd' and xtype='TR')
	drop trigger tri_VehicleHangtag_upd
go
create trigger tri_VehicleHangtag_upd
on t_ats_vehicleHangtag
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
	declare @plateNum varchar(20); --���ƺ�
	declare @plateColor varchar(2); --������ɫ
	declare @regionId int; --��ʻ֤���������
	declare @invalidDate datetime; --��ʻ֤��������
	declare @effectDate datetime; --��ʻ֤ע������
	declare @completeDate datetime; --�����������

	declare cur cursor local for select FID,FMultiCheckStatus,FVehicleId,FPlateNum,
			FPlateColor,FRegionID,FInvalidDate,FEffectDate,FCompleteDate from inserted;
	open cur;
	fetch cur into @interId,@newStatus,@vehicleId,@plateNum,@plateColor,@regionId,@invalidDate,@effectDate,@completeDate
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
		if (@isAudit = 1)--���
		begin	
			update t_ats_vehicle
			set FPlateNum=@plateNum,
				FPlateColor =@plateColor,
				FRegionID = @regionId,
				FInvalidDate = @invalidDate,
				FEffectDate = @effectDate,
				FCompleteDate = @completeDate
			where FID=@vehicleId
		end;
		if (@isUnAudit = 1) --�����
		begin
			if exists (select 1 from t_RP_ARPBillEntry where FClassID_SRC=200000046 and FID_SRC=@interId)
			begin
				raiserror('��������������Ӧ����,���ܲ������',16,1)
			end

			set @plateNum=''
			select top 1 @plateNum=FPlateNum,@plateColor=FPlateColor,@regionId=FRegionID,
			@invalidDate=FInvalidDate,@effectDate=FEffectDate,@completeDate=FCompleteDate
			 from T_ATS_VehicleHangtag where FVehicleID=@vehicleId and FMultiCheckStatus=16 order by FDate desc
			if @plateNum <> ''
			begin
				update t_ats_vehicle
				set FPlateNum=@plateNum,
					FPlateColor =@plateColor,
					FRegionID = @regionId,
					FInvalidDate = @invalidDate,
					FEffectDate = @effectDate,
					FCompleteDate = @completeDate
				where FID=@vehicleId
			end 



		end

		set @isAudit = 0;
		set @isUnAudit = 0;
		fetch next from cur into @interId,@newStatus,@vehicleId,@plateNum,@plateColor,@regionId,@invalidDate,@effectDate,@completeDate
	end;
	close cur;
	deallocate cur;

end


