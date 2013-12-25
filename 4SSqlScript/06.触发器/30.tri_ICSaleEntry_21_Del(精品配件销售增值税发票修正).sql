if exists (select 1 from sysobjects where name = 'tri_ICSaleEntry_21_Del' and xtype='TR')
	drop trigger tri_ICSaleEntry_21_Del
go
create trigger tri_ICSaleEntry_21_Del
on ICSaleEntry
for delete
as
begin
/**
	ԭ���۳��ⵥת����ר�÷�Ʊ�������۷�Ʊֻ��������ģ������ҵ���������ڲ���ģ������ˡ�����ˣ�
	���������������������������28.tri_RPContact_3_ins\29.tri_ICSale_80_ins\30.tri_ICSaleEntry_21_Del������һ��ʹ��
�߼�:
	
*/
	set nocount on;
	update a
	set FQtyInvoice=0,
		FAuxQtyInvoice=0
	from ICStockBillEntry a
	where exists (select 1 from deleted b where b.FSourceTranType=21 and b.FSourceInterId=a.FInterID)
end

