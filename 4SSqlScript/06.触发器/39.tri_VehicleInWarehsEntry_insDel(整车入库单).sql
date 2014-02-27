if exists (select 1 from sysobjects where name = 'tri_VehicleInWarehsEntry_insDel' and xtype='TR')
	drop trigger tri_VehicleInWarehsEntry_insDel
go
create trigger tri_VehicleInWarehsEntry_insDel
on T_ATS_VehicleInWarehsEntry
for insert,delete
as
begin
/**
逻辑:

*/
	set nocount on;


	--是否生成入库单
	update a  
	set FIsCreateInWaresh = 1
	from T_ATS_VehiclePurOrderEntry a
	inner join inserted b on b.FID_SRC=a.FID and b.FEntryID_SRC=a.FEntryID and  b.FID<>0
	where b.FClassID_SRC=200000023;


	update a  
	set FIsCreateInWaresh = 0
	from T_ATS_VehiclePurOrderEntry a
	inner join deleted b on b.FID_SRC=a.FID and b.FEntryID_SRC=a.FEntryID and  b.FID<>0
	where b.FClassID_SRC=200000023
	
	
end


