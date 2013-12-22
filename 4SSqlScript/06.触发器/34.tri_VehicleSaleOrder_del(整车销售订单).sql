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
		--是否已生成精品配件销售订单，若已生成，不允许删除
		if exists (select 1 from T_ATS_DecorationOrderSource where FID_SRC=@interId and FClassID_SRC=200000028)
		begin
			raiserror('已生成代办服务单,不能删除整车销售订单',16,1)
		end;
		--是否已生成代办服务单，若已生成，不允许删除
		if exists (select 1 from T_ATS_AgentServiceSource where FID_SRC=@interId and FClassID_SRC=200000028)
		begin
			raiserror('已生成代办服务单,不能删除整车销售订单',16,1)
		end;
		fetch next from cur into @interId
	end
	close cur;
	deallocate cur;
end
go