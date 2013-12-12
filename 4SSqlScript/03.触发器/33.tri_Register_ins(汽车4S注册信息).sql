if exists (select 1 from sysobjects where name = 'tri_Register_ins' and xtype='TR')
	drop trigger tri_Register_ins
go
create trigger tri_Register_ins
on t_ats_Register
for insert
as
begin
/**
Âß¼­:

*/
	set nocount on;
	
	delete t_ats_Register where fid not in (select fid from inserted)
	
end


