--------------单据导入分录映射表
if  exists (select 1  from sysobjects where name='T_ATS_ImportEntryMapping' and xtype='U')
begin
	drop table T_ATS_ImportEntryMapping
end
go
	CREATE TABLE T_ATS_ImportEntryMapping(
		FImportBillType varchar(50) NOT NULL, --导入单据类型
		FExcelColName varchar(50) NOT NULL, --Excel列名
		FMustInput bit NOT NULL, --是否必录
		FK3ColName varchar(50) NOT NULL, --K3列名
		FK3ColKey varchar(50) NOT NULL, --K3列Key
		FK3ColType varchar(50) NOT NULL, --K3列类型F7、String、Decimal、Int
		FK3ColSrcTable varchar(50) NULL, --当F7时，查询表名
		FK3ColSrcFieldName varchar(50) NULL, --当F7，值查询字段
		FK3ColSrcWhereEx varchar(1000) NULL, --扩展的where语句，主要用于再根据excel上的字段值增加查询字段
		FSeq int not null --导入顺序
	 CONSTRAINT PK_ImportMappingCfg PRIMARY KEY CLUSTERED  (
		FImportBillType ASC,
		FExcelColName ASC
	))

go

--------------单据更新导入分录映射表
if exists (select 1  from sysobjects where name='T_ATS_ImportUpdEntryMapping' and xtype='U')
begin
	drop table T_ATS_ImportUpdEntryMapping;
end
go
	CREATE TABLE T_ATS_ImportUpdEntryMapping(
		FImportBillType varchar(50) NOT NULL, --导入单据类型
		FExcelColName varchar(50) NOT NULL, --Excel列名
		FMustInput bit NOT NULL, --是否必录
		FIsUpdKey bit Not Null, --是否组合的更新Key
		FK3ColName varchar(50) NOT NULL, --K3列名
		FK3ColKey varchar(50) NOT NULL, --K3列Key
		FK3ColType varchar(50) NOT NULL, --K3列类型F7、String、Decimal、Int
		FK3ColSrcTable varchar(50) NULL, --当F7时，查询表名
		FK3ColSrcFieldName varchar(50) NULL, --当F7，值查询字段
		FK3ColSrcWhereEx varchar(1000) NULL, --扩展的where语句，主要用于再根据excel上的字段值增加查询字段
		FSeq int not null

	 CONSTRAINT PK_ImportUpdMappingCfg PRIMARY KEY CLUSTERED  (
		FImportBillType ASC,
		FExcelColName ASC
	))