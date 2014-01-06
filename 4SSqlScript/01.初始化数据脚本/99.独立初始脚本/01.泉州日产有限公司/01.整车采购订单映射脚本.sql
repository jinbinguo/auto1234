declare @importBillType varchar(50);

set @importBillType = 'VehiclePurOrder';

delete T_ATS_ImportEntryMapping where FImportBillType=@importBillType;


insert into T_ATS_ImportEntryMapping(FImportBillType,FExcelColName,FMustInput,FK3ColName,
	FK3ColKey,FK3ColType,FK3ColSrcTable,Fk3ColSrcFieldName,FK3ColSrcWhereEx,FSeq)
values (@importBillType,'��ϵ',1,'��ϵ',
	'FBase8','F7','V_ATS_Series','FName','',1)

insert into T_ATS_ImportEntryMapping(FImportBillType,FExcelColName,FMustInput,FK3ColName,
	FK3ColKey,FK3ColType,FK3ColSrcTable,Fk3ColSrcFieldName,FK3ColSrcWhereEx,FSeq)
values (@importBillType,'����|+|���ʹ���',1,'����',
	'FBase9','F7','V_ATS_Model','FName','',2)

insert into T_ATS_ImportEntryMapping(FImportBillType,FExcelColName,FMustInput,FK3ColName,
	FK3ColKey,FK3ColType,FK3ColSrcTable,Fk3ColSrcFieldName,FK3ColSrcWhereEx,FSeq)
values (@importBillType,'������ɫ',1,'��ɫ',
	'FBase6','F7','V_ATS_Color','FName','FSeriesID=(select FID from T_ATS_Series where FName={��ϵ})',3)

insert into T_ATS_ImportEntryMapping(FImportBillType,FExcelColName,FMustInput,FK3ColName,
	FK3ColKey,FK3ColType,FK3ColSrcTable,Fk3ColSrcFieldName,FK3ColSrcWhereEx,FSeq)
values (@importBillType,'����ɫ',1,'����',
	'FBase5','F7','V_ATS_Interior','FName','FSeriesID=(select FID from T_ATS_Series where FName={��ϵ})',4)

insert into T_ATS_ImportEntryMapping(FImportBillType,FExcelColName,FMustInput,FK3ColName,
	FK3ColKey,FK3ColType,FK3ColSrcTable,Fk3ColSrcFieldName,FK3ColSrcWhereEx,FSeq)
values (@importBillType,'�ɹ�������',1,'���Ҷ�����',
	'FText10','String','','','',5)

insert into T_ATS_ImportEntryMapping(FImportBillType,FExcelColName,FMustInput,FK3ColName,
	FK3ColKey,FK3ColType,FK3ColSrcTable,Fk3ColSrcFieldName,FK3ColSrcWhereEx,FSeq)
values (@importBillType,'�ʽ�����',1,'�ʽ�ʽ',
	'FBase10','F7','T_ATS_FundingMode','FName','',6)


insert into T_ATS_ImportEntryMapping(FImportBillType,FExcelColName,FMustInput,FK3ColName,
	FK3ColKey,FK3ColType,FK3ColSrcTable,Fk3ColSrcFieldName,FK3ColSrcWhereEx,FSeq)
values (@importBillType,'��ͬ��',1,'��˰����',
	'FPrice1','Decimal','','','',7)

insert into T_ATS_ImportEntryMapping(FImportBillType,FExcelColName,FMustInput,FK3ColName,
	FK3ColKey,FK3ColType,FK3ColSrcTable,Fk3ColSrcFieldName,FK3ColSrcWhereEx,FSeq)
values (@importBillType,'�����ı�',0,'�б�ע',
	'FNote1','String','','','',8)

insert into T_ATS_ImportEntryMapping(FImportBillType,FExcelColName,FMustInput,FK3ColName,
	FK3ColKey,FK3ColType,FK3ColSrcTable,Fk3ColSrcFieldName,FK3ColSrcWhereEx,FSeq)
values (@importBillType,'�µ�����',1,'����',
	'FQty','int','','','',9)

insert into T_ATS_ImportEntryMapping(FImportBillType,FExcelColName,FMustInput,FK3ColName,
	FK3ColKey,FK3ColType,FK3ColSrcTable,Fk3ColSrcFieldName,FK3ColSrcWhereEx,FSeq)
values (@importBillType,'�µ�����',0,'��������',
	'FDate1','String','','','',10)

insert into T_ATS_ImportEntryMapping(FImportBillType,FExcelColName,FMustInput,FK3ColName,
	FK3ColKey,FK3ColType,FK3ColSrcTable,Fk3ColSrcFieldName,FK3ColSrcWhereEx,FSeq)
values (@importBillType,'�ۿۼ�',0,'�ۿۼ�',
	'FAmount4','Decimal','','','',11)

insert into T_ATS_ImportEntryMapping(FImportBillType,FExcelColName,FMustInput,FK3ColName,
	FK3ColKey,FK3ColType,FK3ColSrcTable,Fk3ColSrcFieldName,FK3ColSrcWhereEx,FSeq)
values (@importBillType,'��Ʊ�ϼ�',0,'��Ʊ��',
	'FAmount5','Decimal','','','',12)



