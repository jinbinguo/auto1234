
declare @importBillType varchar(50);
set @importBillType = 'VehiclePurForecast';

delete T_ATS_ImportEntryMapping where FImportBillType=@importBillType;

insert into T_ATS_ImportEntryMapping(FImportBillType,FExcelColName,FMustInput,FK3ColName,
	FK3ColKey,FK3ColType,FK3ColSrcTable,Fk3ColSrcFieldName,FK3ColSrcWhereEx,
	FSeq)
values (@importBillType,'提车月份',1,'提车月份',
	'FDate1','String','','','',
	1)

insert into T_ATS_ImportEntryMapping(FImportBillType,FExcelColName,FMustInput,FK3ColName,
	FK3ColKey,FK3ColType,FK3ColSrcTable,Fk3ColSrcFieldName,FK3ColSrcWhereEx,
	FSeq)
values (@importBillType,'车系',1,'车系',
	'FBase1','F7','V_ATS_Series','FName','',
	2)

insert into T_ATS_ImportEntryMapping(FImportBillType,FExcelColName,FMustInput,FK3ColName,
	FK3ColKey,FK3ColType,FK3ColSrcTable,Fk3ColSrcFieldName,FK3ColSrcWhereEx,
	FSeq)
values (@importBillType,'车型|+|车型代号',1,'车型',
	'FBase2','F7','V_ATS_Model','FName','',
	3)

insert into T_ATS_ImportEntryMapping(FImportBillType,FExcelColName,FMustInput,FK3ColName,
	FK3ColKey,FK3ColType,FK3ColSrcTable,Fk3ColSrcFieldName,FK3ColSrcWhereEx,
	FSeq)
values (@importBillType,'车身颜色',1,'颜色',
	'FBase4','F7','V_ATS_Color','FName','FSeriesID=(select FID from T_ATS_Series where FName={车系})',
	4)

insert into T_ATS_ImportEntryMapping(FImportBillType,FExcelColName,FMustInput,FK3ColName,
	FK3ColKey,FK3ColType,FK3ColSrcTable,Fk3ColSrcFieldName,FK3ColSrcWhereEx,
	FSeq)
values (@importBillType,'内饰',1,'内饰',
	'FBase3','F7','V_ATS_Interior','FName','FSeriesID=(select FID from T_ATS_Series where FName={车系})',
	5)

insert into T_ATS_ImportEntryMapping(FImportBillType,FExcelColName,FMustInput,FK3ColName,
	FK3ColKey,FK3ColType,FK3ColSrcTable,Fk3ColSrcFieldName,FK3ColSrcWhereEx,
	FSeq)
values (@importBillType,'主选装件',0,'选装',
	'FText','String','','','',
	6)

insert into T_ATS_ImportEntryMapping(FImportBillType,FExcelColName,FMustInput,FK3ColName,
	FK3ColKey,FK3ColType,FK3ColSrcTable,Fk3ColSrcFieldName,FK3ColSrcWhereEx,
	FSeq)
values (@importBillType,'数量',1,'数量',
	'FQty','Decimal','','','',
	7)