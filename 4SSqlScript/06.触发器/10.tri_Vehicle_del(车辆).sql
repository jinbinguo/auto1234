if exists (select 1 from sysobjects where name = 'tri_vehicle_del' and xtype='TR')
	drop trigger tri_vehicle_del
go
create trigger tri_vehicle_del
on T_ATS_Vehicle
for delete
as
begin
	set nocount on;
	declare @number varchar(50);
	declare @status int;
	
	if exists (select top 1 fid from T_ATS_VehiclePurOrderEntry where FVehicleID in (select FID from deleted))
		raiserror('车辆已被整车采购订单引用,不允许删除',16,1)
		
	if exists (select top 1 fid from t_ats_vehiclePurCheckEntry where FVehicleID in (select FID from deleted))
		raiserror('车辆已被整车验收单引用,不允许删除',16,1)
end