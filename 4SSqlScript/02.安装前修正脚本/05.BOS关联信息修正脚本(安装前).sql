/**
	�������װ��BOS���ݹ�����Ϣ���ñ���ԭΪ������������
*/

--���ݵ��ݹ�����Ϣ��������icCLassUnionQuery
if exists (select 1  from sysobjects where name='icCLassUnionQuery_4SBAK' and xtype='U')
begin
	drop table icCLassUnionQuery_4SBAK;
end;
select * into icCLassUnionQuery_4SBAK from icCLassUnionQuery
--���ݵ��ݹ�����Ϣ������ϸ��¼��ICBillNo
if exists (select 1  from sysobjects where name='icCLassUnionQueryEntry_4SBAK' and xtype='U')
begin
	drop table icCLassUnionQueryEntry_4SBAK;
end;
select * into icCLassUnionQueryEntry_4SBAK from icCLassUnionQueryEntry;


