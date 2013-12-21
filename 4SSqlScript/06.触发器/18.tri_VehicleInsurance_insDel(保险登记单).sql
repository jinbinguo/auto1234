if exists (select 1 from sysobjects where name = 'tri_VehicleInsurance_insDel' and xtype='TR')
	drop trigger tri_VehicleInsurance_insDel
go
create trigger tri_VehicleInsurance_insDel
on t_ats_VehicleInsurance
for insert,delete
as
begin
/**
�߼�:

*/
	set nocount on;
	
	update a  
	set FIsInsurance = 1
	from T_ATS_AgentService a
	inner join inserted b on b.FID_SRC=a.FID and b.FID<>0
	where b.FClassID_SRC=200000045
	
	
	update a  
	set FIsInsurance = 0
	from T_ATS_AgentService a
	inner join deleted b on b.FID_SRC=a.FID and b.FID<>0
	where b.FClassID_SRC=200000045
	
	
end


