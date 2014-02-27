if exists (select 1 from sysobjects where name = 'tri_VehicleIssueEntry_insDel' and xtype='TR')
	drop trigger tri_VehicleIssueEntry_insDel
go
create trigger tri_VehicleIssueEntry_insDel
on T_ATS_VehicleIssueEntry
for insert,delete
as
begin
/**
逻辑:

*/
	set nocount on;


	--是否生成整车出库单
	update a  
	set FIsCreateIssue = 1
	from T_ATS_VehicleSaleOrderEntry a
	inner join inserted b on b.FID_SRC=a.FID and b.FEntryID_SRC=a.FEntryID and  b.FID<>0
	where b.FClassID_SRC=200000028;


	update a  
	set FIsCreateIssue = 0
	from T_ATS_VehicleSaleOrderEntry a
	inner join deleted b on b.FID_SRC=a.FID and b.FEntryID_SRC=a.FEntryID and  b.FID<>0
	where b.FClassID_SRC=200000028
	
	
end


