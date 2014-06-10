/**
	解决：安装后，BOS单据关联信息设置被还原为开发环境问题
*/

--备份单据关联信息设置主表icCLassUnionQuery
if exists (select 1  from sysobjects where name='icCLassUnionQuery_4SBAK' and xtype='U')
begin
	drop table icCLassUnionQuery_4SBAK;
end;
select * into icCLassUnionQuery_4SBAK from icCLassUnionQuery
--备份单据关联信息设置明细分录表ICBillNo
if exists (select 1  from sysobjects where name='icCLassUnionQueryEntry_4SBAK' and xtype='U')
begin
	drop table icCLassUnionQueryEntry_4SBAK;
end;
select * into icCLassUnionQueryEntry_4SBAK from icCLassUnionQueryEntry;


