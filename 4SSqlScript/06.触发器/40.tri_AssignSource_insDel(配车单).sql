if exists (select 1 from sysobjects where name = 'tri_AssignSource_insDel' and xtype='TR')
	drop trigger tri_AssignSource_insDel
go
create trigger tri_AssignSource_insDel
on T_ATS_AssignSource
for insert,delete
as
begin
/**
逻辑:

*/
	set nocount on;


	--是否生成配车单
	update a  
	set FIsCreateAssign = 1
	from T_ATS_VehicleSaleOrderEntry a
	inner join inserted b on b.FID_SRC=a.FID and b.FEntryID_SRC=a.FEntryID and  b.FID<>0
	where b.FClassID_SRC=200000028;


	update a  
	set FIsCreateAssign = 0
	from T_ATS_VehicleSaleOrderEntry a
	inner join deleted b on b.FID_SRC=a.FID and b.FEntryID_SRC=a.FEntryID and  b.FID<>0
	where b.FClassID_SRC=200000028
	
	
end


