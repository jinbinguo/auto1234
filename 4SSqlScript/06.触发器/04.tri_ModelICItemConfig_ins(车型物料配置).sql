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
		raiserror('车型物料配置只允许1条记录',16,1);
		
	/*更新代码字段值，解决将代码、名称隐藏后没有录入的问题*/
	update a
	set a.FNumber=b.FID
	from T_ATS_ModelICItemConfig a
	inner join inserted b on b.FID=a.FID;
	update a
	set a.FNumber=b.FID
	from T_ATS_ModelICItemConfigTree a
	inner join inserted b on b.FID=a.FID;
	
	
end
