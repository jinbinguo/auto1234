if exists (select 1 from sysobjects where name = 'tri_RPContact_3_upd' and xtype='TR')
	drop trigger tri_RPContact_3_upd
go
create trigger tri_RPContact_3_upd
on t_rp_contact
for update
as
begin
/**
	ԭ���۳��ⵥת����ר�÷�Ʊ�������۷�Ʊֻ��������ģ������ҵ���������ڲ���ģ������ˡ�����ˣ�
	���������������������������tri_ICSale_80_insDel������һ��ʹ��
�߼�:
	
*/
	set nocount on;
	declare @invoiceId int; --��������
	--FType 1-����Ӧ�յ� 2-����Ӧ���� 3-���۷�Ʊ 4-�ɹ���Ʊ 5-�տ 6-��� 8-�������ɶԳ嵥�� 9-ת�����ɵĶԳ嵥�� 11-�޺�Ӧ�յ� 12-�޺�Ӧ���� 13-�޺����۷�Ʊ 14-�޺Ųɹ���Ʊ 15-�޺��տ 16-�޺Ÿ��
	
	update a
	set FK3Import=0
	from t_rp_contact a
	where exists (select 1 from inserted b where b.FK3Import=1 and b.FType=3 and b.FID=a.FID)
end