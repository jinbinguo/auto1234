--------------注册信息
if not exists (select 1  from sysobjects where name='T_ATS_RegInfo' and xtype='U')
begin
	CREATE TABLE T_ATS_RegInfo(
		FMachineCiphertext varchar(1000) NULL, --机器码密文
		FOrgNameCiphertext varchar(1000) NULL, --机构名称密文
		FBeginDateCiphertext varchar(1000) NULL, --开始日期密文
		FEndDateCiphertext varchar(1000) NULL --结束日期密文
	) ON [PRIMARY]
end
go 

-------------审核中流程数据中间表
if not exists (select 1  from sysobjects where name='T_ATS_MCStatusTemp' and xtype='U')
begin
	CREATE TABLE T_ATS_MCStatusTemp(
		FMCStatusName varchar(50),  --流程ICClassMCStatusXXXXX表名
		FID int, --ICClassMCStatusXXX.FID  流程状态表ID
		FBillID int, --ICClassMCStatusXXX.FBillID 流程状态表单据ID
		FOldTemplateID int, --ICClassMCStatusXXX.FTemplateID 流程模版ID
		FNewTemplateID int --重新定义流程模版ID 一般设999999
	) ON [PRIMARY]
end
go 

--------------单据导入分录映射表
if not exists (select 1  from sysobjects where name='T_ATS_ImportEntryMapping' and xtype='U')
begin
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
end


--------------单据更新导入分录映射表
if not exists (select 1  from sysobjects where name='T_ATS_ImportUpdEntryMapping' and xtype='U')
begin
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
end

go
go

