
declare @importBillType varchar(50);
set @importBillType = 'VehiclePurForecast';

delete T_ATS_ImportEntryMapping where FImportBillType=@importBillType;

insert into T_ATS_ImportEntryMapping(FImportBillType,FExcelColName,FMustInput,FK3ColName,
	FK3ColKey,FK3ColType,FK3ColSrcTable,Fk3ColSrcFieldName,FK3ColSrcWhereEx,
	FSeq)
values (@importBillType,'�ᳵ�·�',1,'�ᳵ�·�',
	'FDate1','String','','','',
	1)

insert into T_ATS_ImportEntryMapping(FImportBillType,FExcelColName,FMustInput,FK3ColName,
	FK3ColKey,FK3ColType,FK3ColSrcTable,Fk3ColSrcFieldName,FK3ColSrcWhereEx,
	FSeq)
values (@importBillType,'��ϵ',1,'��ϵ',
	'FBase1','F7','V_ATS_Series','FName','',
	2)

insert into T_ATS_ImportEntryMapping(FImportBillType,FExcelColName,FMustInput,FK3ColName,
	FK3ColKey,FK3ColType,FK3ColSrcTable,Fk3ColSrcFieldName,FK3ColSrcWhereEx,
	FSeq)
values (@importBillType,'����|+|���ʹ���',1,'����',
	'FBase2','F7','V_ATS_Model','FName','',
	3)

insert into T_ATS_ImportEntryMapping(FImportBillType,FExcelColName,FMustInput,FK3ColName,
	FK3ColKey,FK3ColType,FK3ColSrcTable,Fk3ColSrcFieldName,FK3ColSrcWhereEx,
	FSeq)
values (@importBillType,'������ɫ',1,'��ɫ',
	'FBase6','F7','V_ATS_Color','FName','FSeriesID=(select FID from T_ATS_Series where FName={��ϵ})',
	4)

insert into T_ATS_ImportEntryMapping(FImportBillType,FExcelColName,FMustInput,FK3ColName,
	FK3ColKey,FK3ColType,FK3ColSrcTable,Fk3ColSrcFieldName,FK3ColSrcWhereEx,
	FSeq)
values (@importBillType,'����',1,'����',
	'FBase5','F7','V_ATS_Interior','FName','FSeriesID=(select FID from T_ATS_Series where FName={��ϵ})',
	5)

insert into T_ATS_ImportEntryMapping(FImportBillType,FExcelColName,FMustInput,FK3ColName,
	FK3ColKey,FK3ColType,FK3ColSrcTable,Fk3ColSrcFieldName,FK3ColSrcWhereEx,
	FSeq)
values (@importBillType,'��ѡװ��',0,'ѡװ',
	'FText','String','','','',
	6)

insert into T_ATS_ImportEntryMapping(FImportBillType,FExcelColName,FMustInput,FK3ColName,
	FK3ColKey,FK3ColType,FK3ColSrcTable,Fk3ColSrcFieldName,FK3ColSrcWhereEx,
	FSeq)
values (@importBillType,'����',1,'����',
	'FQty','Decimal','','','',
	7)