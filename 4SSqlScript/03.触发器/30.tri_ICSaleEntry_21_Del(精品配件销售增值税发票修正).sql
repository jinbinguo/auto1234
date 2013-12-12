if exists (select 1 from sysobjects where name = 'tri_ICSaleEntry_21_Del' and xtype='TR')
	drop trigger tri_ICSaleEntry_21_Del
go
create trigger tri_ICSaleEntry_21_Del
on ICSaleEntry
for delete
as
begin
/**
	原销售出库单转销售专用发票，此销售发票只能在销售模块中做业务处理，不能在财务模块中审核、反审核，
	所以这里做了数据修正，请配合tri_RPContact_3_ins触发器一起使用
逻辑:
	
*/
	set nocount on;
	update a
	set FQtyInvoice=0,
		FAuxQtyInvoice=0
	from ICStockBillEntry a
	where exists (select 1 from deleted b where b.FSourceTranType=21 and b.FSourceInterId=a.FInterID)
end

