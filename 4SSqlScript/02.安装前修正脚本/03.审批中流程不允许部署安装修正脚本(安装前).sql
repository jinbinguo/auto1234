declare @sql nvarchar(4000);
declare @mcStatusName varchar(50);
declare @icclassTypeId int;
declare @billName varchar(50);

if exists (select 1 from tempdb.dbo.sysobjects where id=object_id(N'tempdb..#tmpTable') and type='u')
		drop table #tmpTable;

create table #tmpTable(
	FMaxID int,
	FBillID int,
	FTemplateID int
);

declare cur cursor local for select name from  sysobjects where name like 'ICClassMCStatus%' and xtype='U' Order by name;
open cur;
fetch cur into @mcStatusName;
while (@@FETCH_STATUS=0)
begin
	set @icclassTypeId = cast(substring(@mcStatusName,16,len(@mcStatusName)-15) as int);
	select @billName=FName_CHS from ICClassType where FID=@icclassTypeId;
	truncate table #tmpTable;
	set @sql = 'insert into #tmpTable(FMaxID,FBillID,FTemplateID)
		select MAX(FID),FBillID,FTemplateID from ' + @mcStatusName + ' where FTemplateID<> 999999 group by FTemplateID,FBillID '
	execute sp_executesql @sql
	set @sql = 'insert into T_ATS_MCStatusTemp(FMCStatusName,FID,FBillID,FOldTemplateID,FNewTemplateID)
				select ''' + @mcStatusName + ''',a.FID,a.FBillID,a.FTemplateID,999999 from ' + @mcStatusName + ' a
					inner join #tmpTable b on a.FBillID=b.FBillID and a.FID=b.FMaxID and a.FTemplateID=b.FTemplateID
					where a.FNextLevelTagIndex<>1 ';
	execute sp_executesql @sql
	set @sql = 'update a
				set FTemplateID=999999
				from ' + @mcStatusName + ' a
				where exists (select 1 from  T_ATS_MCStatusTemp b where b.FMCStatusName=''' + @mcStatusName + '''
					and b.FID=a.FID and b.FBillID=a.FBillID and b.FOldTemplateId=a.FTemplateID)'
	execute sp_executesql @sql
	fetch next from cur into @mcStatusName;
end
close cur;
deallocate cur;