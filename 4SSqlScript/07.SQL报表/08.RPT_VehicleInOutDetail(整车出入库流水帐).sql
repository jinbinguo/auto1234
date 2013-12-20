if exists (select 1 from sysobjects where name = 'RPT_VehicleInOutDetail' and xtype='P')
	drop procedure RPT_VehicleInOutDetail
go

create procedure RPT_VehicleInOutDetail
	@beginDate date, --开始日期
	@endDate date, --结束日期
	@brandName varchar(100), --品牌名称
	@seriesName varchar(100), --车系名称
	@modelName varchar(100),--车型名称
	@stockName varchar(100) --仓库名称
AS
BEGIN
	/**整车出入库流水帐*/

	SET NOCOUNT ON;
	if exists (select 1 from tempdb.dbo.sysobjects where id=object_id(N'tempdb..#tmpTable') and type='u')
		drop table #tmpTable
	declare @sql nvarchar(4000);
	declare @filterSQL nvarchar(2000);
	declare @filterInitDate varchar(100);
	declare @filterPeriodDate varchar(100);
	set @filterSQL = ''
	if @brandName <> ''
		set @filterSQL = @filterSQL + ' and e.FName like ''%' + @brandName + '%'''
	if @seriesName <> ''
		set @filterSQL = @filterSQL + ' and d.FName like ''%' + @seriesName + '%'''
	if @modelName <> ''
		set @filterSQL = @filterSQL + ' and c.FName like ''%' + @modelName + '%'''
	if @stockName <> ''
		set @filterSQL = @filterSQL + ' and f.FName like ''%' + @stockName + '%'''

	set @filterInitDate = ' and a1.FDate<''' + convert(varchar(10),@beginDate,120) + ''''
	set @filterPeriodDate = 'and a1.FDate>='''+ convert(varchar(10),@beginDate,120) + ''' and a1.FDate<=''' + convert(varchar(10),@endDate,120) + ''''

	/*
	select b.FProductDate,a1.FDate,'整车入库单' FBillType,a.FIndex,e.FName FBrandName,
	d.FName FSeriesName,c.FName FModelName,b.FBillNo FVehileNo,b.FCfgDesc,b.FVIN,
	b.FEngineNum,b.FKeyNum,f.FName FDisplacementName,g.FName FGearboxName,h.FName FPowerForm,
	i.FStereotype FStereotypeName,j.FName FDriverFormName,k.FInterior FInteriorName,l.FColor FColorName, f.FName FStockName,
	a.FTaxPrice FPrice,a.FQty,a.FTaxAmount FAmount,null,null,
	null,null,null,null,a1.FNOTE,1 FSeq
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
where a1.FMultiCheckStatus='16'


union
select b.FProductDate,a1.FDate,'整车出库单' FBillType,a.FIndex,e.FName FBrandName,
	d.FName FSeriesName,c.FName FModelName,b.FBillNo FVehileNo,b.FCfgDesc,b.FVIN,
	b.FEngineNum,b.FKeyNum,f.FName FDisplacementName,g.FName FGearboxName,h.FName FPowerForm,
	i.FStereotype FStereotypeName,j.FName FDriverFormName,k.FInterior FInteriorName,l.FColor FColorName, f.FName FStockName,
	null,null,null,a.FVehicleARAmount FPrice,a.FQty,
	a.FVehicleARAmount FAmount,null,null,null,a1.FNOTE,
	
	2 FSeq
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
where a1.FMultiCheckStatus='16'

union

--调拨入
select b.FProductDate,a1.FDate,'整车调拨单' FBillType,a.FIndex,e.FName FBrandName,
	d.FName FSeriesName,c.FName FModelName,b.FBillNo FVehileNo,b.FCfgDesc,b.FVIN,
	b.FEngineNum,b.FKeyNum,f.FName FDisplacementName,g.FName FGearboxName,h.FName FPowerForm,
	i.FStereotype FStereotypeName,j.FName FDriverFormName,k.FInterior FInteriorName,l.FColor FColorName, f.FName FStockName,
	null,null,null,null,null,
	null,b.FPurAmount FPrice,1 FQty,b.FPurAmount FAmount,a1.FNOTE,3 FSeq
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
where a1.FMultiCheckStatus='16'

union
--调拨出
select b.FProductDate,a1.FDate,'整车调拨单' FBillType,a.FIndex,e.FName FBrandName,
	d.FName FSeriesName,c.FName FModelName,b.FBillNo FVehileNo,b.FCfgDesc,b.FVIN,
	b.FEngineNum,b.FKeyNum,f.FName FDisplacementName,g.FName FGearboxName,h.FName FPowerForm,
	i.FStereotype FStereotypeName,j.FName FDriverFormName,k.FInterior FInteriorName,l.FColor FColorName, f.FName FStockName,
	null,null,null,b.FPurAmount FPrice,1 FQty,
	b.FPurAmount FAmount,null,null,null,a1.FNOTE,4 FSeq
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
where a1.FMultiCheckStatus='16'
order by FDate,FSeq


*/
END
GO