declare @maxInterId  int;
select @maxInterId=max(FInterId) from ICReportKeywords;

if not exists (select 1 from ICReportKeywords where FKeyword='*VehicleNo*' and FDataSource=200000030)
begin
set @maxInterId=@maxInterId+1
insert into ICReportKeywords(FInterID,FKeyword,FCaption,FCaption_CHT,FCaption_EN,
	FValueType,FDataSource,FBaseField,FSourceSql,FSourceField,
	FISAllowEnter,FISNeed,FLookUpType,FKeywordType)
values(@maxInterId,'*VehicleNo*','��ʼ��������','��ʼ��������','��ʼ��������',
	2,200000030,1,'','',
	1,0,0,0)
end

if not exists (select 1 from ICReportKeywords where FKeyword='#VehicleNo#' and FDataSource=200000030)
begin
set @maxInterId=@maxInterId+1
insert into ICReportKeywords(FInterID,FKeyword,FCaption,FCaption_CHT,FCaption_EN,
	FValueType,FDataSource,FBaseField,FSourceSql,FSourceField,
	FISAllowEnter,FISNeed,FLookUpType,FKeywordType)
values(@maxInterId,'#VehicleNo#','��ֹ��������','��ֹ��������','��ֹ��������',
	2,200000030,1,'','',
	1,0,0,0)
end

if not exists (select 1 from ICReportKeywords where FKeyword='@BrandName@' and FDataSource=200000011)
begin
set @maxInterId=@maxInterId+1
insert into ICReportKeywords(FInterID,FKeyword,FCaption,FCaption_CHT,FCaption_EN,
	FValueType,FDataSource,FBaseField,FSourceSql,FSourceField,
	FISAllowEnter,FISNeed,FLookUpType,FKeywordType)
values(@maxInterId,'@BrandName@','Ʒ������','Ʒ������','Ʒ������',
	2,200000011,2,'','',
	1,0,0,0)
end

if not exists (select 1 from ICReportKeywords where FKeyword='@ModelName@' and FDataSource=200000026)
begin
set @maxInterId=@maxInterId+1
insert into ICReportKeywords(FInterID,FKeyword,FCaption,FCaption_CHT,FCaption_EN,
	FValueType,FDataSource,FBaseField,FSourceSql,FSourceField,
	FISAllowEnter,FISNeed,FLookUpType,FKeywordType)
values(@maxInterId,'@ModelName@','��������','��������','��������',
	2,200000026,1,'','',
	1,0,0,0)
end

if not exists (select 1 from ICReportKeywords where FKeyword='@SeriesName@' and FDataSource=200000027)
begin
set @maxInterId=@maxInterId+1
insert into ICReportKeywords(FInterID,FKeyword,FCaption,FCaption_CHT,FCaption_EN,
	FValueType,FDataSource,FBaseField,FSourceSql,FSourceField,
	FISAllowEnter,FISNeed,FLookUpType,FKeywordType)
values(@maxInterId,'@SeriesName@','��ϵ����','��ϵ����','��ϵ����',
	2,200000027,1,'','',
	1,0,0,0)
end

if not exists (select 1 from ICReportKeywords where FKeyword='@VehicleNo@' and FDataSource=200000030)
begin
set @maxInterId=@maxInterId+1
insert into ICReportKeywords(FInterID,FKeyword,FCaption,FCaption_CHT,FCaption_EN,
	FValueType,FDataSource,FBaseField,FSourceSql,FSourceField,
	FISAllowEnter,FISNeed,FLookUpType,FKeywordType)
values(@maxInterId,'@VehicleNo@','��������','��������','��������',
	2,200000030,1,'','',
	1,0,0,0)
end