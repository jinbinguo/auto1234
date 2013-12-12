if exists (select 1 from sysobjects where name = 'tri_series_del' and xtype='TR')
	drop trigger tri_series_del
go
create trigger tri_series_del
on T_ATS_series
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
go