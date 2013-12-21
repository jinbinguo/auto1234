if exists (select 1 from sysobjects where name = 'tri_VehicleMortgage_upd' and xtype='TR')
	drop trigger tri_VehicleMortgage_upd
go
create trigger tri_VehicleMortgage_upd
on t_ats_VehicleMortgage
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

		if (@isAudit = 1)--���
		begin	
			select 1
		end;
		if (@isUnAudit = 1) --�����
		begin
			if exists (select 1 from t_RP_ARPBillEntry where FClassID_SRC=200000048 and FID_SRC=@interId)
			begin
				raiserror('��������������Ӧ����,���ܲ������',16,1)
			end
		end

		set @isAudit = 0;
		set @isUnAudit = 0;
		fetch next from cur into @interId,@newStatus
	end;
	close cur;
	deallocate cur;

end


