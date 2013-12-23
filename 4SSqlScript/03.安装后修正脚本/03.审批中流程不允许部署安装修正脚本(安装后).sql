declare @sql nvarchar(4000);
declare @mcStatusName varchar(50);
declare @id int;
declare @billId int;
declare @oldTemplateId int;
declare @newTemplateId int;


declare cur cursor local for select distinct FMCStatusName from T_ATS_MCStatusTemp;
open cur;
fetch cur into @mcStatusName
while (@@FETCH_STATUS=0) 
begin
	set @sql = 'update a
				set a.FTemplateID=(select FOldTemplateId from T_ATS_MCStatusTemp b where b.FMCStatusName=''' + @mcStatusName +'''
						and b.FID=a.FID and b.FBillID=a.FBillID and b.FNewTemplateId=a.FTemplateID)
				from ' + @mcStatusName + ' a
				where exists (select 1 from T_ATS_MCStatusTemp b where b.FMCStatusName=''' + @mcStatusName + '''
						and b.FID=a.FID and b.FBillID=a.FBillID and b.FNewTemplateId=a.FTemplateID)'
	execute sp_executesql @sql
	fetch next from cur into @mcStatusName
end
close cur;
deallocate cur;
truncate table T_ATS_MCStatusTemp;