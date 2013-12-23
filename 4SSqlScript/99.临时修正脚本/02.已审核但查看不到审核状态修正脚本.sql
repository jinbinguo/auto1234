declare @sql nvarchar(4000);
declare @mcStatusName varchar(50);
declare @icclassTypeId int;
declare @templateId int;

declare cur cursor local for select name from  sysobjects where name like 'ICClassMCStatus%' and xtype='U' Order by name;
open cur;
fetch cur into @mcStatusName;
while (@@FETCH_STATUS=0)
begin
	set @icclassTypeId = cast(substring(@mcStatusName,16,len(@mcStatusName)-15) as int);
	select @templateId = FID from ICClassMCTemplate where FClassTypeID=@icclassTypeId;

	set @sql = 'update ' + @mcStatusName +
			  ' set FTemplateID=' + cast(@templateId as varchar) +
			  ' where FTemplateID<>' + cast(@templateId as varchar);
	execute sp_executesql @sql

	fetch next from cur into @mcStatusName;
end
close cur;
deallocate cur;