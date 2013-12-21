if exists (select 1 from sysobjects where name = 'tri_model_del' and xtype='TR')
	drop trigger tri_model_del
go
create trigger tri_model_del
on T_ATS_Model
for delete
as
begin
	set nocount on;
	declare @number varchar(50);
	declare @status int;
	declare cur cursor local for select FNumber,FStatus from deleted;
	open cur;
	fetch cur into @number,@status
	while(@@FETCH_STATUS=0)
	begin
		if (@status >= 2) 
		begin
			raiserror('已启用或已禁用不允许删除',16,1)
		end
		fetch next from cur into @number,@status
	end
	close cur;
	deallocate cur;
end