/**
	�������װ��BOS���ݱ�����򱻻�ԭΪ������������
*/

--���ݱ���������ñ�t_BillCodeRule
if exists (select 1  from sysobjects where name='t_BillCodeRule_4SBAK' and xtype='U')
begin
	drop table t_BillCodeRule_4SBAK;
end;
select * into t_BillCodeRule_4SBAK from t_BillCodeRule;
--���ݱ�����ʱ��ICBillNo
if exists (select 1  from sysobjects where name='ICBillNo_4SBAK' and xtype='U')
begin
	drop table ICBillNo_4SBAK;
end;
select * into ICBillNo_4SBAK from ICBillNo;


