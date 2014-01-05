--------------���ݵ����¼ӳ���
if  exists (select 1  from sysobjects where name='T_ATS_ImportEntryMapping' and xtype='U')
begin
	drop table T_ATS_ImportEntryMapping
end
go
	CREATE TABLE T_ATS_ImportEntryMapping(
		FImportBillType varchar(50) NOT NULL, --���뵥������
		FExcelColName varchar(50) NOT NULL, --Excel����
		FMustInput bit NOT NULL, --�Ƿ��¼
		FK3ColName varchar(50) NOT NULL, --K3����
		FK3ColKey varchar(50) NOT NULL, --K3��Key
		FK3ColType varchar(50) NOT NULL, --K3������F7��String��Decimal��Int
		FK3ColSrcTable varchar(50) NULL, --��F7ʱ����ѯ����
		FK3ColSrcFieldName varchar(50) NULL, --��F7��ֵ��ѯ�ֶ�
		FK3ColSrcWhereEx varchar(1000) NULL, --��չ��where��䣬��Ҫ�����ٸ���excel�ϵ��ֶ�ֵ���Ӳ�ѯ�ֶ�
		FSeq int not null --����˳��
	 CONSTRAINT PK_ImportMappingCfg PRIMARY KEY CLUSTERED  (
		FImportBillType ASC,
		FExcelColName ASC
	))

go

--------------���ݸ��µ����¼ӳ���
if exists (select 1  from sysobjects where name='T_ATS_ImportUpdEntryMapping' and xtype='U')
begin
	drop table T_ATS_ImportUpdEntryMapping;
end
go
	CREATE TABLE T_ATS_ImportUpdEntryMapping(
		FImportBillType varchar(50) NOT NULL, --���뵥������
		FExcelColName varchar(50) NOT NULL, --Excel����
		FMustInput bit NOT NULL, --�Ƿ��¼
		FIsUpdKey bit Not Null, --�Ƿ���ϵĸ���Key
		FK3ColName varchar(50) NOT NULL, --K3����
		FK3ColKey varchar(50) NOT NULL, --K3��Key
		FK3ColType varchar(50) NOT NULL, --K3������F7��String��Decimal��Int
		FK3ColSrcTable varchar(50) NULL, --��F7ʱ����ѯ����
		FK3ColSrcFieldName varchar(50) NULL, --��F7��ֵ��ѯ�ֶ�
		FK3ColSrcWhereEx varchar(1000) NULL, --��չ��where��䣬��Ҫ�����ٸ���excel�ϵ��ֶ�ֵ���Ӳ�ѯ�ֶ�
		FSeq int not null

	 CONSTRAINT PK_ImportUpdMappingCfg PRIMARY KEY CLUSTERED  (
		FImportBillType ASC,
		FExcelColName ASC
	))