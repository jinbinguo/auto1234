if exists (select 1 from sysobjects where name = 'tri_ModelICItemConfig_ins' and xtype='TR')
	drop trigger tri_ModelICItemConfig_ins
go
create trigger tri_ModelICItemConfig_ins
on T_ATS_ModelICItemConfig
after insert
as
begin
	set nocount on;
	declare @rowCount int;
	select @rowCount=COUNT(1) from T_ATS_ModelICItemConfig;
	if @rowCount >1
		raiserror('������������ֻ����1����¼',16,1);
		
	/*���´����ֶ�ֵ����������롢�������غ�û��¼�������*/
	update a
	set a.FNumber=b.FID
	from T_ATS_ModelICItemConfig a
	inner join inserted b on b.FID=a.FID;
	update a
	set a.FNumber=b.FID
	from T_ATS_ModelICItemConfigTree a
	inner join inserted b on b.FID=a.FID;
	
	
end
