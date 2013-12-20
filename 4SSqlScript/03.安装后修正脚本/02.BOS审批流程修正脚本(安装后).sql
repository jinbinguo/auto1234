/**
	解决：安装后，审批流程ID变更，导致单据打开，看不到审核状态
*/

--临时中间表
if exists (select 1 from tempdb.dbo.sysobjects where id=object_id(N'tempdb..#tmpTable') and type='u')
		drop table #tmpTable;
create table #tmpTable(
	FClassTypeID int,
	FNewID int,
	FOldID  int
);

--恢复修正审批流程表ICClassMCTemplate
if exists (select 1  from sysobjects where name='ICClassMCTemplate_4SBAK' and xtype='U')
begin
	--检查变更流程ID
	insert into #tmpTable(FClassTypeID,FNewID,FOldID)
	select a.FClassTypeID,isnull(a.FID,0),isnull(b.FID,0) from ICClassMCTemplate a
		left join ICClassMCTemplate_4SBAK b on a.FClassTypeID=b.FClassTypeID
	where isnull(a.fid,0)<>isnull(b.FID,0) and isnull(a.fid,0)>0 and isnull(b.fid,0) > 0;

	--删除新流程
	delete  aa
	from ICClassMCTemplate aa
	where exists (select 1 from #tmpTable bb where bb.FClassTypeID=aa.FClassTypeID and aa.FID=bb.FNewID);
	--还原旧流程
	insert into ICClassMCTemplate(FID,FClassTypeID,FTemplateID,FName_CHS,FName_CHT,
			FName_EN,FStatus,FIsRun,FFunctionControl,FPropertyStyle,
			FMCContent,FBusinessLevel,FCheckerKey,FCheckDateKey,FCreateDate)
	select FID,FClassTypeID,FTemplateID,FName_CHS,FName_CHT,
			FName_EN,FStatus,FIsRun,FFunctionControl,FPropertyStyle,
			FMCContent,FBusinessLevel,FCheckerKey,FCheckDateKey,FCreateDate
	from ICClassMCTemplate_4SBAK cc
	where exists (select 1 from #tmpTable dd where dd.FClassTypeID=cc.FClassTypeID and cc.FID=dd.FOldID);

end;


--恢复修正审批流程表ICClassMCTableInfo
if exists (select 1  from sysobjects where name='ICClassMCTableInfo_4SBAK' and xtype='U')
begin
	--删除新流程模块
	delete  aa
	from ICClassMCTableInfo aa
	where exists (select 1 from #tmpTable bb where aa.FTemplateID=bb.FNewID);
	--还原旧流程模块
	insert into ICClassMCTableInfo(FTemplateID,FObjectType,FName_CHS,FName_CHT,FName_EN,
		FCheckRight,FUnCheckRight,FPropertyStyle,FDefaultComment,FFunctionControl,
		FMessageID,FUnCheckMessageID,FTagIndex,FOriginBox,FDestinationBox,
		FCirculateCondition,FPriorityControl,FInfoControl,FCirculateConditionExt)
	select FTemplateID,FObjectType,FName_CHS,FName_CHT,FName_EN,
		FCheckRight,FUnCheckRight,FPropertyStyle,FDefaultComment,FFunctionControl,
		FMessageID,FUnCheckMessageID,FTagIndex,FOriginBox,FDestinationBox,
		FCirculateCondition,FPriorityControl,FInfoControl,FCirculateConditionExt
	from ICClassMCTableInfo_4SBAK cc
	where exists (select 1 from #tmpTable dd where cc.FTemplateID=dd.FOldID);

end;