if exists (select 1 from sysobjects where name = 'tri_RPContact_3_upd' and xtype='TR')
	drop trigger tri_RPContact_3_upd
go
create trigger tri_RPContact_3_upd
on t_rp_contact
for update
as
begin
/**
	原销售出库单转销售专用发票，此销售发票只能在销售模块中做业务处理，不能在财务模块中审核、反审核，
	所以这里做了数据修正，请配合28.tri_RPContact_3_ins\29.tri_ICSale_80_ins\30.tri_ICSaleEntry_21_Del触发器一起使用
逻辑:
	
*/
	set nocount on;
	declare @invoiceId int; --单据内码
	--FType 1-其它应收单 2-其它应付单 3-销售发票 4-采购发票 5-收款单 6-付款单 8-坏账生成对冲单据 9-转账生成的对冲单据 11-无号应收单 12-无号应付单 13-无号销售发票 14-无号采购发票 15-无号收款单 16-无号付款单
	
	update a
	set FK3Import=0
	from t_rp_contact a
	where exists (select 1 from inserted b where b.FK3Import=1 and b.FType=3 and b.FID=a.FID)
end