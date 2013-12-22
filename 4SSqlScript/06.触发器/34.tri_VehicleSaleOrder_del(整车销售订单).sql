if exists (select 1 from sysobjects where name = 'tri_VehicleSaleOrder_del' and xtype='TR')
	drop trigger tri_VehicleSaleOrder_del
go
create trigger tri_VehicleSaleOrder_del
on T_ATS_VehicleSaleOrder
for delete
as
begin
	set nocount on;
	declare @interId int;
	declare cur cursor local for select FID from deleted;
	open cur;
	fetch cur into @interId
	while(@@FETCH_STATUS=0)
	begin
		--�Ƿ������ɾ�Ʒ������۶������������ɣ�������ɾ��
		if exists (select 1 from T_ATS_DecorationOrderSource where FID_SRC=@interId and FClassID_SRC=200000028)
		begin
			raiserror('�����ɴ������,����ɾ���������۶���',16,1)
		end;
		--�Ƿ������ɴ�����񵥣��������ɣ�������ɾ��
		if exists (select 1 from T_ATS_AgentServiceSource where FID_SRC=@interId and FClassID_SRC=200000028)
		begin
			raiserror('�����ɴ������,����ɾ���������۶���',16,1)
		end;
		fetch next from cur into @interId
	end
	close cur;
	deallocate cur;
end
go