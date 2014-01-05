declare @importBillType varchar(50);
set @importBillType = 'VehiclePurCheckUpd';

delete T_ATS_ImportUpdEntryMapping where FImportBillType=@importBillType;


insert into T_ATS_ImportUpdEntryMapping(FImportBillType,FExcelColName,FMustInput,FK3ColName,
	FK3ColKey,FK3ColType,FK3ColSrcTable,Fk3ColSrcFieldName,FIsUpdKey,
	FK3ColSrcWhereEx,FSeq)
values (@importBillType,'车型|+|车型代号',1,'车型',
	'FBase3','F7','V_ATS_Model','FName',1,
	'',1)

insert into T_ATS_ImportUpdEntryMapping(FImportBillType,FExcelColName,FMustInput,FK3ColName,
	FK3ColKey,FK3ColType,FK3ColSrcTable,Fk3ColSrcFieldName,FIsUpdKey,
	FK3ColSrcWhereEx,FSeq)
values (@importBillType,'车身颜色',1,'颜色',
	'FBase5','F7','V_ATS_Color','FName',1,
	'FSeriesID=(select FID from T_ATS_Series where FName={车系})',2)

insert into T_ATS_ImportUpdEntryMapping(FImportBillType,FExcelColName,FMustInput,FK3ColName,
	FK3ColKey,FK3ColType,FK3ColSrcTable,Fk3ColSrcFieldName,FIsUpdKey,
	FK3ColSrcWhereEx,FSeq)
values (@importBillType,'内饰',0,'内饰',
	'FBase4','F7','V_ATS_Interior','FName',1,
	'FSeriesID=(select FID from T_ATS_Series where FName={车系})',3)

insert into T_ATS_ImportUpdEntryMapping(FImportBillType,FExcelColName,FMustInput,FK3ColName,
	FK3ColKey,FK3ColType,FK3ColSrcTable,Fk3ColSrcFieldName,FIsUpdKey,
	FK3ColSrcWhereEx,FSeq)
values (@importBillType,'主选装件',0,'选装',
	'FText4','String','','',1,
	'',4)

insert into T_ATS_ImportUpdEntryMapping(FImportBillType,FExcelColName,FMustInput,FK3ColName,
	FK3ColKey,FK3ColType,FK3ColSrcTable,Fk3ColSrcFieldName,FIsUpdKey,
	FK3ColSrcWhereEx,FSeq)
values (@importBillType,'资金方式',1,'资金方式',
	'FBase10','F7','T_ATS_FundingMode','FName',0,
	'',5)

insert into T_ATS_ImportUpdEntryMapping(FImportBillType,FExcelColName,FMustInput,FK3ColName,
	FK3ColKey,FK3ColType,FK3ColSrcTable,Fk3ColSrcFieldName,FIsUpdKey,
	FK3ColSrcWhereEx,FSeq)
values (@importBillType,'VIN码',0,'底盘号',
	'FText5','String','','',0,
	'',6)

insert into T_ATS_ImportUpdEntryMapping(FImportBillType,FExcelColName,FMustInput,FK3ColName,
	FK3ColKey,FK3ColType,FK3ColSrcTable,Fk3ColSrcFieldName,FIsUpdKey,
	FK3ColSrcWhereEx,FSeq)
values (@importBillType,'发动机号',1,'发动机号',
	'FText6','String','','',0,
	'',7)

insert into T_ATS_ImportUpdEntryMapping(FImportBillType,FExcelColName,FMustInput,FK3ColName,
	FK3ColKey,FK3ColType,FK3ColSrcTable,Fk3ColSrcFieldName,FIsUpdKey,
	FK3ColSrcWhereEx,FSeq)
values (@importBillType,'合格证编号',1,'合格证编号',
	'FText8','String','','',0,
	'',8)