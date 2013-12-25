if exists (select 1 from sysobjects where name = 'RPT_VehicleInOutDetail' and xtype='P')
	drop procedure RPT_VehicleInOutDetail
go

create procedure RPT_VehicleInOutDetail
	@beginDate date, --��ʼ����
	@endDate date, --��������
	@brandName varchar(100), --Ʒ������
	@seriesName varchar(100), --��ϵ����
	@modelName varchar(100),--��������
	@stockName varchar(100) --�ֿ�����
AS
BEGIN
	/**�����������ˮ��*/

	SET NOCOUNT ON;
	if exists (select 1 from tempdb.dbo.sysobjects where id=object_id(N'tempdb..#tmpTable') and type='u')
		drop table #tmpTable
	declare @sql nvarchar(4000);
	declare @filterSQL nvarchar(2000);
	set @filterSQL = ''
	if @brandName <> ''
		set @filterSQL = @filterSQL + ' and e.FName like ''%' + @brandName + '%'''
	if @seriesName <> ''
		set @filterSQL = @filterSQL + ' and d.FName like ''%' + @seriesName + '%'''
	if @modelName <> ''
		set @filterSQL = @filterSQL + ' and c.FName like ''%' + @modelName + '%'''
	if @stockName <> ''
		set @filterSQL = @filterSQL + ' and f.FName like ''%' + @stockName + '%'''
	if @beginDate <> ''
		set @filterSQL = @filterSQL +  'and a1.FDate>='''+ convert(varchar(10),@beginDate,120) + '''' 
	if @endDate <> ''
		set @filterSQL = @filterSQL +  ' and a1.FDate<=''' + convert(varchar(10),@endDate,120) + ''''

	create table #tmpTable(
		FProductDate datetime, --��������
		FBillDate datetime, --��������
		FBillType varchar(50), --��������
		FBillNo varchar(50), --���ݺ���
		FIndex int,--�����к�
		FBrandName varchar(50), --Ʒ��
		FSeriesName varchar(50),--��ϵ
		FModelName varchar(50), --����
		FVehicleNo varchar(50), --����
		FCfgDesc varchar(50),  --��������˵��
		FVin varchar(50), --���̺�
		FEngineNum varchar(50), --��������
		FKeyNum varchar(50), --���׺�
		FDisplacementName varchar(50), --����
		FGearboxName varchar(50), --������
		FPowerFormName varchar(50), --������ʽ
		FStereotypeName varchar(50), --�Ͱ�
		FDriverFormName varchar(50), --������ʽ
		FInteriorName varchar(50), --����
		FColorName varchar(50), --��ɫ
		FOptional varchar(50), --ѡװ
		FStockName varchar(50), --�ֿ�
		FInPrice decimal(10,2), --����.����
		FInQty decimal(10,0), --����.����
		FInAmount decimal(10,2), --����.���
		FOutPrice decimal(10,2), --����.����
		FOutQty decimal(10,0), --����.����
		FOutAmount decimal(10,2), --����.���
		FSaler varchar(50), --���۹���
		FCustomer varchar(50), --�ͻ�
		FAddr varchar(100), --��ַ
		FTel varchar(50), --�绰
		FNote varchar(255), --��ע
		FSeq int --���
	);
--������ⵥ
	set @sql = '
	insert into #tmpTable (FProductDate,FBillDate,FBillType,FBillNo,FIndex,
							FBrandName,FSeriesName,FModelName,FVehicleNo,FCfgDesc,
							FVin,FEngineNum,FKeyNum,FDisplacementName,FGearboxName,
							FPowerFormName,FStereotypeName,FDriverFormName,FInteriorName,FColorName,
							FOptional,FStockName,FInPrice,FInQty,FInAmount,
							FOutPrice,FOutQty,FOutAmount,FSaler,FCustomer,
							FAddr,FTel,FNote,FSeq)
		select b.FProductDate,a1.FDate,''������ⵥ'' FBillType,a1.FBillNo ,a.FIndex,
			e.FName FBrandName,d.FName FSeriesName,c.FName FModelName,b.FBillNo FVehileNo,b.FCfgDesc,
			b.FVIN,b.FEngineNum,b.FKeyNum,f.FName FDisplacementName,g.FName FGearboxName,
			h.FName FPowerForm,i.FStereotype FStereotypeName,j.FName FDriverFormName,k.FInterior FInteriorName,l.FColor FColorName,
			b.FOptional,f.FName FStockName,a.FTaxPrice FPrice,a.FQty,a.FTaxAmount FAmount,
			null,null,null,null,null,
			null,null,a1.FNOTE,1
		from T_ATS_VehicleInWarehsEntry a
		left join T_ATS_VehicleInWarehs a1 on a.FID=a1.FID
		left join t_ats_vehicle b on b.FID=a.FVehicleID
		left join T_ATS_Model c on c.FID=b.FModelID
		left join T_ATS_Series d on d.FID=c.FSeriesID
		left join T_ATS_Brand e on d.FID=d.FBrandID
		left join T_ATS_Displacement f on e.FID=c.FDisplacementID 
		left join T_ATS_Gearbox g on f.FID=c.FGearboxID
		left join T_ATS_PowerForm h on g.FID=c.FPowerFormID 
		left join T_ATS_SeriesStereotype i on h.FEntryID=c.FStereotypeID
		left join T_ATS_DriverForm j on i.FID=c.FDriverFormID
		left join T_ATS_SeriesInterior k on j.FEntryID=b.FInteriorID
		left join T_ATS_SeriesColor l on  k.FEntryID =b.FColorID 
		left join t_Stock m on m.FItemID=a.FStockID
		where a1.FMultiCheckStatus=''16''' + @filterSQL
	execute sp_executesql @sql

--�������ⵥ
	set @sql = '
	insert into #tmpTable (FProductDate,FBillDate,FBillType,FBillNo,FIndex,
							FBrandName,FSeriesName,FModelName,FVehicleNo,FCfgDesc,
							FVin,FEngineNum,FKeyNum,FDisplacementName,FGearboxName,
							FPowerFormName,FStereotypeName,FDriverFormName,FInteriorName,FColorName,
							FOptional,FStockName,FInPrice,FInQty,FInAmount,
							FOutPrice,FOutQty,FOutAmount,FSaler,FCustomer,
							FAddr,FTel,FNote,FSeq)
	select b.FProductDate,a1.FDate,''�������ⵥ'' FBillType,a1.FBillNo,a.FIndex,
		e.FName FBrandName,d.FName FSeriesName,c.FName FModelName,b.FBillNo FVehileNo,b.FCfgDesc,
		b.FVIN,b.FEngineNum,b.FKeyNum,f.FName FDisplacementName,g.FName FGearboxName,
		h.FName FPowerForm,i.FStereotype FStereotypeName,j.FName FDriverFormName,k.FInterior FInteriorName,l.FColor FColorName,
		b.FOptional,f.FName FStockName,null,null,null,
		a.FVehicleARAmount FPrice,a.FQty,a.FVehicleARAmount FAmount,o.FName FSaler,n.FName FCusomterName,
		n.FAddress,n.FMobilePhone FTel,a1.FNOTE,3
	from T_ATS_VehicleIssueEntry a
		left join T_ATS_VehicleIssue a1 on a.FID=a1.FID
		left join t_ats_vehicle b on b.FID=a.FVehicleID
		left join T_ATS_Model c on c.FID=b.FModelID
		left join T_ATS_Series d on d.FID=c.FSeriesID
		left join T_ATS_Brand e on d.FID=d.FBrandID
		left join T_ATS_Displacement f on e.FID=c.FDisplacementID 
		left join T_ATS_Gearbox g on f.FID=c.FGearboxID
		left join T_ATS_PowerForm h on g.FID=c.FPowerFormID 
		left join T_ATS_SeriesStereotype i on h.FEntryID=c.FStereotypeID
		left join T_ATS_DriverForm j on i.FID=c.FDriverFormID
		left join T_ATS_SeriesInterior k on j.FEntryID=b.FInteriorID
		left join T_ATS_SeriesColor l on  k.FEntryID =b.FColorID 
		left join t_Stock m on m.FItemID=a.FStockID
		left join t_Organization n on n.FItemID=a1.FCustomerID and n.FItemID<>0
		left join t_Emp o on o.FItemID=a1.FPersonID and o.FItemID<>0
		where a1.FMultiCheckStatus=''16''' + @filterSQL
	execute sp_executesql @sql
--������
	set @sql = '
	insert into #tmpTable (FProductDate,FBillDate,FBillType,FBillNo,FIndex,
							FBrandName,FSeriesName,FModelName,FVehicleNo,FCfgDesc,
							FVin,FEngineNum,FKeyNum,FDisplacementName,FGearboxName,
							FPowerFormName,FStereotypeName,FDriverFormName,FInteriorName,FColorName,
							FOptional,FStockName,FInPrice,FInQty,FInAmount,
							FOutPrice,FOutQty,FOutAmount,FSaler,FCustomer,
							FAddr,FTel,FNote,FSeq)
		select b.FProductDate,a1.FDate,''����������'' FBillType,a1.FBillNo,a.FIndex,
			e.FName FBrandName,d.FName FSeriesName,c.FName FModelName,b.FBillNo FVehileNo,b.FCfgDesc,
			b.FVIN,b.FEngineNum,b.FKeyNum,f.FName FDisplacementName,g.FName FGearboxName,
			h.FName FPowerForm,i.FStereotype FStereotypeName,j.FName FDriverFormName,k.FInterior FInteriorName,l.FColor FColorName, 
			b.FOptional,f.FName FStockName,null,null,null,
			b.FPurAmount FPrice,1 FQty,b.FPurAmount FAmount,null,null,
			null,null,a1.FNOTE,2
			from T_ATS_VehicleTransferEntry a
		left join T_ATS_VehicleTransfer a1 on a.FID=a1.FID
		left join t_ats_vehicle b on b.FID=a.FVehicleID
		left join T_ATS_Model c on c.FID=b.FModelID
		left join T_ATS_Series d on d.FID=c.FSeriesID
		left join T_ATS_Brand e on d.FID=d.FBrandID
		left join T_ATS_Displacement f on e.FID=c.FDisplacementID 
		left join T_ATS_Gearbox g on f.FID=c.FGearboxID
		left join T_ATS_PowerForm h on g.FID=c.FPowerFormID 
		left join T_ATS_SeriesStereotype i on h.FEntryID=c.FStereotypeID
		left join T_ATS_DriverForm j on i.FID=c.FDriverFormID
		left join T_ATS_SeriesInterior k on j.FEntryID=b.FInteriorID
		left join T_ATS_SeriesColor l on  k.FEntryID =b.FColorID 
		left join t_Stock m on m.FItemID=a1.FInWarehsStockID
		where a1.FMultiCheckStatus=''16''' + @filterSQL
	execute sp_executesql @sql

--������
	set @sql = '
	insert into #tmpTable (FProductDate,FBillDate,FBillType,FBillNo,FIndex,
							FBrandName,FSeriesName,FModelName,FVehicleNo,FCfgDesc,
							FVin,FEngineNum,FKeyNum,FDisplacementName,FGearboxName,
							FPowerFormName,FStereotypeName,FDriverFormName,FInteriorName,FColorName,
							FOptional,FStockName,FInPrice,FInQty,FInAmount,
							FOutPrice,FOutQty,FOutAmount,FSaler,FCustomer,
							FAddr,FTel,FNote,FSeq)
		select b.FProductDate,a1.FDate,''����������'' FBillType,a1.FBillNo,a.FIndex,
			e.FName FBrandName,d.FName FSeriesName,c.FName FModelName,b.FBillNo FVehileNo,b.FCfgDesc,
			b.FVIN,b.FEngineNum,b.FKeyNum,f.FName FDisplacementName,g.FName FGearboxName,
			h.FName FPowerForm,i.FStereotype FStereotypeName,j.FName FDriverFormName,k.FInterior FInteriorName,l.FColor FColorName, 
			b.FOptional,f.FName FStockName,b.FPurAmount FPrice,1 FQty,
			null,null,null,b.FPurAmount FAmount,null,null,
			null,null,a1.FNOTE,4
		from T_ATS_VehicleTransferEntry a
	left join T_ATS_VehicleTransfer a1 on a.FID=a1.FID
	left join t_ats_vehicle b on b.FID=a.FVehicleID
	left join T_ATS_Model c on c.FID=b.FModelID
	left join T_ATS_Series d on d.FID=c.FSeriesID
	left join T_ATS_Brand e on d.FID=d.FBrandID
	left join T_ATS_Displacement f on e.FID=c.FDisplacementID 
	left join T_ATS_Gearbox g on f.FID=c.FGearboxID
	left join T_ATS_PowerForm h on g.FID=c.FPowerFormID 
	left join T_ATS_SeriesStereotype i on h.FEntryID=c.FStereotypeID
	left join T_ATS_DriverForm j on i.FID=c.FDriverFormID
	left join T_ATS_SeriesInterior k on j.FEntryID=b.FInteriorID
	left join T_ATS_SeriesColor l on  k.FEntryID =b.FColorID 
	left join t_Stock m on m.FItemID=a1.FIssueStockId
	where a1.FMultiCheckStatus=''16''' + @filterSQL
	execute sp_executesql @sql

	select FProductDate ��������,FBillDate ��������,FBillType ��������,FBillNo ���ݺ���,FIndex �����к�,
	FBrandName Ʒ��,FSeriesName ��ϵ,FModelName ����,FVehicleNo ����,FCfgDesc ��������˵��,
	FVin ���̺�,FEngineNum ��������,FKeyNum ���׺�,FDisplacementName ����,FGearboxName ������,
	FPowerFormName ������ʽ,FStereotypeName �Ͱ�,FDriverFormName ������ʽ,FInteriorName ����,FColorName ��ɫ,
	FOptional ѡװ,FStockName �ֿ�,FInPrice '����+����',FInQty '����+����',FInAmount '����+���',
	FOutPrice '����+����',FOutQty '����+����',FOutAmount '����+���',FSaler ���۹���,FCustomer �ͻ�,
	FAddr ��ַ,FTel �绰,FNote ��ע from #tmpTable order by FBillDate,FSeq
END
GO