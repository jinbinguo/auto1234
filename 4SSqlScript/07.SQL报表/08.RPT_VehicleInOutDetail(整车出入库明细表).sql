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
		FProductDate datetime, --生产日期
		FBillDate datetime, --单据日期
		FBillType varchar(50), --单据类型
		FBillNo varchar(50), --单据号码
		FIndex int,--单据行号
		FBrandName varchar(50), --品牌
		FSeriesName varchar(50),--车系
		FModelName varchar(50), --车型
		FVehicleNo varchar(50), --车辆
		FCfgDesc varchar(50),  --车辆配置说明
		FVin varchar(50), --底盘号
		FEngineNum varchar(50), --发动机号
		FKeyNum varchar(50), --锁匙号
		FDisplacementName varchar(50), --排量
		FGearboxName varchar(50), --变速箱
		FPowerFormName varchar(50), --动力形式
		FStereotypeName varchar(50), --型版
		FDriverFormName varchar(50), --驱动形式
		FInteriorName varchar(50), --内饰
		FColorName varchar(50), --颜色
		FOptional varchar(50), --选装
		FStockName varchar(50), --仓库
		FInPrice decimal(10,2), --收入.单价
		FInQty decimal(10,0), --收入.数量
		FInAmount decimal(10,2), --收入.金额
		FOutPrice decimal(10,2), --发出.单价
		FOutQty decimal(10,0), --发出.数量
		FOutAmount decimal(10,2), --发出.金额
		FSaler varchar(50), --销售顾问
		FCustomer varchar(50), --客户
		FAddr varchar(100), --地址
		FTel varchar(50), --电话
		FNote varchar(255), --备注
		FSeq int --序号
	);
--整车入库单
	set @sql = '
	insert into #tmpTable (FProductDate,FBillDate,FBillType,FBillNo,FIndex,
							FBrandName,FSeriesName,FModelName,FVehicleNo,FCfgDesc,
							FVin,FEngineNum,FKeyNum,FDisplacementName,FGearboxName,
							FPowerFormName,FStereotypeName,FDriverFormName,FInteriorName,FColorName,
							FOptional,FStockName,FInPrice,FInQty,FInAmount,
							FOutPrice,FOutQty,FOutAmount,FSaler,FCustomer,
							FAddr,FTel,FNote,FSeq)
		select b.FProductDate,a1.FDate,''整车入库单'' FBillType,a1.FBillNo ,a.FIndex,
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

--整车出库单
	set @sql = '
	insert into #tmpTable (FProductDate,FBillDate,FBillType,FBillNo,FIndex,
							FBrandName,FSeriesName,FModelName,FVehicleNo,FCfgDesc,
							FVin,FEngineNum,FKeyNum,FDisplacementName,FGearboxName,
							FPowerFormName,FStereotypeName,FDriverFormName,FInteriorName,FColorName,
							FOptional,FStockName,FInPrice,FInQty,FInAmount,
							FOutPrice,FOutQty,FOutAmount,FSaler,FCustomer,
							FAddr,FTel,FNote,FSeq)
	select b.FProductDate,a1.FDate,''整车出库单'' FBillType,a1.FBillNo,a.FIndex,
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
--调拨入
	set @sql = '
	insert into #tmpTable (FProductDate,FBillDate,FBillType,FBillNo,FIndex,
							FBrandName,FSeriesName,FModelName,FVehicleNo,FCfgDesc,
							FVin,FEngineNum,FKeyNum,FDisplacementName,FGearboxName,
							FPowerFormName,FStereotypeName,FDriverFormName,FInteriorName,FColorName,
							FOptional,FStockName,FInPrice,FInQty,FInAmount,
							FOutPrice,FOutQty,FOutAmount,FSaler,FCustomer,
							FAddr,FTel,FNote,FSeq)
		select b.FProductDate,a1.FDate,''整车调拨单'' FBillType,a1.FBillNo,a.FIndex,
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

--调拨出
	set @sql = '
	insert into #tmpTable (FProductDate,FBillDate,FBillType,FBillNo,FIndex,
							FBrandName,FSeriesName,FModelName,FVehicleNo,FCfgDesc,
							FVin,FEngineNum,FKeyNum,FDisplacementName,FGearboxName,
							FPowerFormName,FStereotypeName,FDriverFormName,FInteriorName,FColorName,
							FOptional,FStockName,FInPrice,FInQty,FInAmount,
							FOutPrice,FOutQty,FOutAmount,FSaler,FCustomer,
							FAddr,FTel,FNote,FSeq)
		select b.FProductDate,a1.FDate,''整车调拨单'' FBillType,a1.FBillNo,a.FIndex,
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

	select FProductDate 生产日期,FBillDate 单据日期,FBillType 单据类型,FBillNo 单据号码,FIndex 单据行号,
	FBrandName 品牌,FSeriesName 车系,FModelName 车型,FVehicleNo 车辆,FCfgDesc 车辆配置说明,
	FVin 底盘号,FEngineNum 发动机号,FKeyNum 锁匙号,FDisplacementName 排量,FGearboxName 变速箱,
	FPowerFormName 动力形式,FStereotypeName 型版,FDriverFormName 驱动形式,FInteriorName 内饰,FColorName 颜色,
	FOptional 选装,FStockName 仓库,FInPrice '收入+单价',FInQty '收入+数量',FInAmount '收入+金额',
	FOutPrice '发出+单价',FOutQty '发出+数量',FOutAmount '发出+金额',FSaler 销售顾问,FCustomer 客户,
	FAddr 地址,FTel 电话,FNote 备注 from #tmpTable order by FBillDate,FSeq
END
GO