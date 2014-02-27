if exists (select 1 from sysobjects where name = 'tri_vehiclePurCheckEntry_insDel' and xtype='TR')
	drop trigger tri_vehiclePurCheckEntry_insDel
go
create trigger tri_vehiclePurCheckEntry_insDel
on t_ats_vehiclePurCheckEntry
for insert,delete
as
begin
/**
Âß¼­:

*/
	set nocount on;


	update a  
	set FIsCreateCheck = 1
	from T_ATS_VehiclePurOrderEntry a
	inner join inserted b on b.FID_SRC=a.FID and b.FEntryID_SRC=a.FEntryID and  b.FID<>0
	where b.FClassID_SRC=200000023
	
	
	update a  
	set FIsCreateCheck = 0
	from T_ATS_VehiclePurOrderEntry a
	inner join inserted b on b.FID_SRC=a.FID and b.FEntryID_SRC=a.FEntryID and  b.FID<>0
	where b.FClassID_SRC=200000023
	
	
end


