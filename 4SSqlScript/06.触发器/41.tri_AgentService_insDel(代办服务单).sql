if exists (select 1 from sysobjects where name = 'tri_AgentServiceSource_insDel' and xtype='TR')
	drop trigger tri_AgentServiceSource_insDel
go
create trigger tri_AgentServiceSource_insDel
on T_ATS_AgentServiceSource
for insert,delete
as
begin
/**
�߼�:

*/
	set nocount on;

	--�Ƿ����ɴ������
	update a  
	set FIsCreateAgentService = 1
	from T_ATS_VehicleSaleOrderEntry a
	inner join inserted b on b.FID_SRC=a.FID and b.FEntryID_SRC=a.FEntryID and  b.FID<>0
	where b.FClassID_SRC=200000028;


	update a  
	set FIsCreateAgentService = 0
	from T_ATS_VehicleSaleOrderEntry a
	inner join deleted b on b.FID_SRC=a.FID and b.FEntryID_SRC=a.FEntryID and  b.FID<>0
	where b.FClassID_SRC=200000028
	
	
end


