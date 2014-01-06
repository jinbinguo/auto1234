declare @importBillType varchar(50);

set @importBillType = 'VehiclePurOrder';

delete T_ATS_ImportEntryMapping where FImportBillType=@importBillType;


insert into T_ATS_ImportEntryMapping(FImportBillType,FExcelColName,FMustInput,FK3ColName,
	FK3ColKey,FK3ColType,FK3ColSrcTable,Fk3ColSrcFieldName,FK3ColSrcWhereEx,FSeq)
values (@importBillType,'车系',1,'车系',
	'FBase8','F7','V_ATS_Series','FName','',1)

insert into T_ATS_ImportEntryMapping(FImportBillType,FExcelColName,FMustInput,FK3ColName,
	FK3ColKey,FK3ColType,FK3ColSrcTable,Fk3ColSrcFieldName,FK3ColSrcWhereEx,FSeq)
values (@importBillType,'车型|+|车型代码',1,'车型',
	'FBase9','F7','V_ATS_Model','FName','',2)

insert into T_ATS_ImportEntryMapping(FImportBillType,FExcelColName,FMustInput,FK3ColName,
	FK3ColKey,FK3ColType,FK3ColSrcTable,Fk3ColSrcFieldName,FK3ColSrcWhereEx,FSeq)
values (@importBillType,'车身颜色',1,'颜色',
	'FBase6','F7','V_ATS_Color','FName','FSeriesID=(select FID from T_ATS_Series where FName={车系})',3)

insert into T_ATS_ImportEntryMapping(FImportBillType,FExcelColName,FMustInput,FK3ColName,
	FK3ColKey,FK3ColType,FK3ColSrcTable,Fk3ColSrcFieldName,FK3ColSrcWhereEx,FSeq)
values (@importBillType,'内饰色',1,'内饰',
	'FBase5','F7','V_ATS_Interior','FName','FSeriesID=(select FID from T_ATS_Series where FName={车系})',4)

insert into T_ATS_ImportEntryMapping(FImportBillType,FExcelColName,FMustInput,FK3ColName,
	FK3ColKey,FK3ColType,FK3ColSrcTable,Fk3ColSrcFieldName,FK3ColSrcWhereEx,FSeq)
values (@importBillType,'采购单单号',1,'厂家订单号',
	'FText10','String','','','',5)

insert into T_ATS_ImportEntryMapping(FImportBillType,FExcelColName,FMustInput,FK3ColName,
	FK3ColKey,FK3ColType,FK3ColSrcTable,Fk3ColSrcFieldName,FK3ColSrcWhereEx,FSeq)
values (@importBillType,'资金类型',1,'资金方式',
	'FBase10','F7','T_ATS_FundingMode','FName','',6)


insert into T_ATS_ImportEntryMapping(FImportBillType,FExcelColName,FMustInput,FK3ColName,
	FK3ColKey,FK3ColType,FK3ColSrcTable,Fk3ColSrcFieldName,FK3ColSrcWhereEx,FSeq)
values (@importBillType,'合同价',1,'含税单价',
	'FPrice1','Decimal','','','',7)

insert into T_ATS_ImportEntryMapping(FImportBillType,FExcelColName,FMustInput,FK3ColName,
	FK3ColKey,FK3ColType,FK3ColSrcTable,Fk3ColSrcFieldName,FK3ColSrcWhereEx,FSeq)
values (@importBillType,'生产文本',0,'行备注',
	'FNote1','String','','','',8)

insert into T_ATS_ImportEntryMapping(FImportBillType,FExcelColName,FMustInput,FK3ColName,
	FK3ColKey,FK3ColType,FK3ColSrcTable,Fk3ColSrcFieldName,FK3ColSrcWhereEx,FSeq)
values (@importBillType,'下单数量',1,'数量',
	'FQty','int','','','',9)

insert into T_ATS_ImportEntryMapping(FImportBillType,FExcelColName,FMustInput,FK3ColName,
	FK3ColKey,FK3ColType,FK3ColSrcTable,Fk3ColSrcFieldName,FK3ColSrcWhereEx,FSeq)
values (@importBillType,'下单日期',0,'交货日期',
	'FDate1','String','','','',10)

insert into T_ATS_ImportEntryMapping(FImportBillType,FExcelColName,FMustInput,FK3ColName,
	FK3ColKey,FK3ColType,FK3ColSrcTable,Fk3ColSrcFieldName,FK3ColSrcWhereEx,FSeq)
values (@importBillType,'折扣价',0,'折扣价',
	'FAmount4','Decimal','','','',11)

insert into T_ATS_ImportEntryMapping(FImportBillType,FExcelColName,FMustInput,FK3ColName,
	FK3ColKey,FK3ColType,FK3ColSrcTable,Fk3ColSrcFieldName,FK3ColSrcWhereEx,FSeq)
values (@importBillType,'开票合计',0,'开票价',
	'FAmount5','Decimal','','','',12)



