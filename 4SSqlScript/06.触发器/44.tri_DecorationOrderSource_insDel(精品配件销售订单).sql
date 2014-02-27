if exists (select 1 from sysobjects where name = 'tri_DecorationOrderSource_insDel' and xtype='TR')
	drop trigger tri_DecorationOrderSource_insDel
go
create trigger tri_DecorationOrderSource_insDel
on T_ATS_DecorationOrderSource
for insert,delete
as
begin
/**
�߼�:

*/
	set nocount on;


	--�Ƿ����ɾ�Ʒ�������
	update a  
	set FIsCreateDecorate = 1
	from T_ATS_VehicleSaleOrderEntry a
	inner join inserted b on b.FID_SRC=a.FID and b.FEntryID_SRC=a.FEntryID and  b.FID<>0
	where b.FClassID_SRC=200000028;


	update a  
	set FIsCreateDecorate = 0
	from T_ATS_VehicleSaleOrderEntry a
	inner join deleted b on b.FID_SRC=a.FID and b.FEntryID_SRC=a.FEntryID and  b.FID<>0
	where b.FClassID_SRC=200000028
	
	
end


