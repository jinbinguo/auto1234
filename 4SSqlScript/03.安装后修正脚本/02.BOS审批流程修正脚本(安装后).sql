/**
	�������װ����������ID��������µ��ݴ򿪣����������״̬
*/

--��ʱ�м��
if exists (select 1 from tempdb.dbo.sysobjects where id=object_id(N'tempdb..#tmpTable') and type='u')
		drop table #tmpTable;
create table #tmpTable(
	FClassTypeID int,
	FNewID int,
	FOldID  int
);

--�ָ������������̱�ICClassMCTemplate
if exists (select 1  from sysobjects where name='ICClassMCTemplate_4SBAK' and xtype='U')
begin
	--���������ID
	insert into #tmpTable(FClassTypeID,FNewID,FOldID)
	select a.FClassTypeID,isnull(a.FID,0),isnull(b.FID,0) from ICClassMCTemplate a
		left join ICClassMCTemplate_4SBAK b on a.FClassTypeID=b.FClassTypeID
	where isnull(a.fid,0)<>isnull(b.FID,0) and isnull(a.fid,0)>0 and isnull(b.fid,0) > 0;

	--ɾ��������
	delete  aa
	from ICClassMCTemplate aa
	where exists (select 1 from #tmpTable bb where bb.FClassTypeID=aa.FClassTypeID and aa.FID=bb.FNewID);
	--��ԭ������
	insert into ICClassMCTemplate(FID,FClassTypeID,FTemplateID,FName_CHS,FName_CHT,
			FName_EN,FStatus,FIsRun,FFunctionControl,FPropertyStyle,
			FMCContent,FBusinessLevel,FCheckerKey,FCheckDateKey,FCreateDate)
	select FID,FClassTypeID,FTemplateID,FName_CHS,FName_CHT,
			FName_EN,FStatus,FIsRun,FFunctionControl,FPropertyStyle,
			FMCContent,FBusinessLevel,FCheckerKey,FCheckDateKey,FCreateDate
	from ICClassMCTemplate_4SBAK cc
	where exists (select 1 from #tmpTable dd where dd.FClassTypeID=cc.FClassTypeID and cc.FID=dd.FOldID);

end;


--�ָ������������̱�ICClassMCTableInfo
if exists (select 1  from sysobjects where name='ICClassMCTableInfo_4SBAK' and xtype='U')
begin
	--ɾ��������ģ��
	delete  aa
	from ICClassMCTableInfo aa
	where exists (select 1 from #tmpTable bb where aa.FTemplateID=bb.FNewID);
	--��ԭ������ģ��
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