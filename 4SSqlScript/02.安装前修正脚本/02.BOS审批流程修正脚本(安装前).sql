/**
	�������װ����������ID��������µ��ݴ򿪣����������״̬
*/

--�����������̱�ICClassMCTemplate
if exists (select 1  from sysobjects where name='ICClassMCTemplate_4SBAK' and xtype='U')
begin
	drop table ICClassMCTemplate_4SBAK;
end;
select * into ICClassMCTemplate_4SBAK from ICClassMCTemplate;
--�����������̱�ICClassMCTableInfo
if exists (select 1  from sysobjects where name='ICClassMCTableInfo_4SBAK' and xtype='U')
begin
	drop table ICClassMCTableInfo_4SBAK;
end;
select * into ICClassMCTableInfo_4SBAK from ICClassMCTableInfo;


