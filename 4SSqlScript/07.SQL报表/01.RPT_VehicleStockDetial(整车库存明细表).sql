if exists (select 1 from sysobjects where name = 'RPT_VehicleStockDetail' and xtype='P')
	drop procedure RPT_VehicleStockDetail
go

create procedure RPT_VehicleStockDetail
	@brandName varchar(100), --品牌名称
	@seriesName varchar(100), --车系名称
	@modelName varchar(100),--车型名称
	@stockName varchar(100) --仓库名称
AS
BEGIN
	/**整车库存明细表*/

	SET NOCOUNT ON;
	if exists (select 1 from tempdb.dbo.sysobjects where id=object_id(N'tempdb..#tmpTable') and type='u')
		drop table #tmpTable
	declare @sql nvarchar(4000);
	declare @filterSQL nvarchar(2000);
	set @filterSQL = ''
	if @brandName <> ''
		set @filterSQL = @filterSQL + ' and d.FName like ''%' + @brandName + '%'''
	if @seriesName <> ''
		set @filterSQL = @filterSQL + ' and c.FName like ''%' + @seriesName + '%'''
	if @modelName <> ''
		set @filterSQL = @filterSQL + ' and b.FName like ''%' + @modelName + '%'''
	if @stockName <> ''
		set @filterSQL = @filterSQL + ' and l.FName like ''%' + @stockName + '%'''

	create table #tmpTable(
		FBrandName varchar(100),
		FSeriesName varchar(100),
		FModelName varchar(100),
		FVehicleNo varchar(100),
		FCfgDesc varchar(100),
		FVIN varchar(100),
		FEngineNum varchar(100),
		FKeyNum varchar(100),
		FDisplacementName varchar(100),
		FGearboxName varchar(100),
		FPowerFormName varchar(100),
		FStereotypeName varchar(100),
		FDriverFormName varchar(100),
		FInteriorName varchar(100),
		FColorName varchar(100),
		FOptional varchar(100),
		FProductDate datetime,
		FPurDate datetime,
		FStockName varchar(100),
		FPurAmount decimal(10,2)
	);

	set @sql = 'insert into #tmpTable select d.FName FBrandName,c.FName FSeriesName, b.FName FModelName,a.FBillNo FVehicleNo,a.FCfgDesc,
		a.FVIN,a.FEngineNum,a.FKeyNum,e.FName FDisplacementName,f.FName FGearboxName,g.FName FPowerFormName,
		h.FStereotype FStereotypeName,i.FName FDriverFormName,j.FInterior FInteriorName,k.FColor FColorName,
		a.FOptional,a.FProductDate,a.FPurDate,l.FName FStockName,a.FPurAmount
		from T_ATS_Vehicle a
		left join T_ATS_Model b on b.FID=a.FModelID
		left join T_ATS_Series c on c.FID=b.FSeriesID
		left join T_ATS_Brand d on d.FID=c.FBrandID 
		left join T_ATS_Displacement e on e.FID=b.FDisplacementID 
		left join T_ATS_Gearbox f on f.FID=b.FGearboxID
		left join T_ATS_PowerForm g on g.FID=b.FPowerFormID 
		left join T_ATS_SeriesStereotype h on h.FEntryID=b.FStereotypeID
		left join T_ATS_DriverForm i on i.FID=b.FDriverFormID
		left join T_ATS_SeriesInterior j on j.FEntryID=a.FInteriorID
		left join T_ATS_SeriesColor k on  k.FEntryID =a.FColorID 
		left join t_Stock l on l.FItemID=a.FStockID and l.FItemID<>0
	where (a.FVehicleStatus=1 or a.FVehicleStatus=2) ' + @filterSQL +
	' Order by a.FBillNo '

	execute sp_executesql @sql 
	


	select FBrandName 品牌,FSeriesName 车系,FModelName 车型, FVehicleNo 车辆, FCfgDesc 车辆配置说明,
		FVIN 底盘号,FEngineNum 发动机号, FKeyNum 锁匙号,FDisplacementName 排量,FGearboxName 变速箱,
		FPowerFormName 动力形式,FStereotypeName 型版,FDriverFormName 驱动形式,FInteriorName 内饰, FColorName 颜色,
		FOptional 选装, FProductDate 生产日期, FPurDate 入库日期, FStockName 仓库, 1 数量,
		FPurAmount 金额
	from #tmpTable
	union all
	select '','合计','','','',
		'','','','','',
		'','','','','',
		'',null,null,'',isnull(sum(1),0),
		isnull(sum(FPurAmount),0)
	from #tmpTable

END
GO
