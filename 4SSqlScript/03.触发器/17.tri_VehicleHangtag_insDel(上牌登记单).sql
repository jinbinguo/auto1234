if exists (select 1 from sysobjects where name = 'tri_VehicleHangtag_insDel' and xtype='TR')
	drop trigger tri_VehicleHangtag_insDel
go
create trigger tri_VehicleHangtag_insDel
on t_ats_vehicleHangtag
for insert,delete
as
begin
/**
Âß¼­:

*/
	set nocount on;
	
	update a  
	set FIsHangTag = 1
	from T_ATS_AgentService a
	inner join inserted b on b.FID_SRC=a.FID and b.FID<>0
	where b.FClassID_SRC=200000045
	
	
	update a  
	set FIsHangTag = 0
	from T_ATS_AgentService a
	inner join deleted b on b.FID_SRC=a.FID and b.FID<>0
	where b.FClassID_SRC=200000045
	
	
end


