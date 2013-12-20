/**
	解决：安装后，审批流程ID变更，导致单据打开，看不到审核状态
*/

--备份审批流程表ICClassMCTemplate
if exists (select 1  from sysobjects where name='ICClassMCTemplate_4SBAK' and xtype='U')
begin
	drop table ICClassMCTemplate_4SBAK;
end;
select * into ICClassMCTemplate_4SBAK from ICClassMCTemplate;
--备份审批流程表ICClassMCTableInfo
if exists (select 1  from sysobjects where name='ICClassMCTableInfo_4SBAK' and xtype='U')
begin
	drop table ICClassMCTableInfo_4SBAK;
end;
select * into ICClassMCTableInfo_4SBAK from ICClassMCTableInfo;


