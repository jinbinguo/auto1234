if exists (select 1 from sysobjects where name = 'RPT_VehiclePurGatherByModel' and xtype='P')
	drop procedure RPT_VehiclePurGatherByModel
go

create procedure RPT_VehiclePurGatherByModel
	@brandName varchar(100), --品牌名称
	@seriesName varchar(100), --车系名称
	@modelName varchar(100)--车型名称
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
		set @filterSQL = @filterSQL + ' and e.FName like ''%' + @brandName + '%'''
	if @seriesName <> ''
		set @filterSQL = @filterSQL + ' and d.FName like ''%' + @seriesName + '%'''
	if @modelName <> ''
		set @filterSQL = @filterSQL + ' and c.FName like ''%' + @modelName + '%'''

	create table #tmpTable(
		FBrandName varchar(100),
		FSeriesName varchar(100),
		FModelName varchar(100),
		FCfgDesc varchar(100),
		FDisplacementName varchar(100),
		FGearboxName varchar(100),
		FPowerFormName varchar(100),
		FStereotypeName varchar(100),
		FDriverFormName varchar(100),
		FInteriorName varchar(100),
		FColorName varchar(100),
		FOptional varchar(100),
		FTotalQty decimal(10,0),
		FTotalAmount decimal(10,2)
	);

	set @sql = 'insert into #tmpTable(FBrandName,FSeriesName,FModelName,FCfgDesc,FDisplacementName,
					FGearboxName,FPowerFormName,FStereotypeName,FDriverFormName,FInteriorName,
					FColorName,FOptional,FTotalQty,FTotalAmount)
				select 	e.FName FBrandName,d.FName FSeriesName,c.FName FModelName,b.FCfgDesc,
						f.FName FDisplacementName,g.FName FGearboxName,
						h.FName FPowerForm,i.FStereotype FStereotypeName,j.FName FDriverFormName,k.FInterior FInteriorName,
						l.FColor FColorName,b.FOptional,sum(a.FQty) FTotalQty,sum(a.FTaxAmount) FTaxAmount
					from T_ATS_VehicleInWarehsEntry a
					left join T_ATS_VehicleInWarehs a1 on a.FID=a1.FID
					left join t_ats_Vehicle b on b.FID=a.FVehicleID
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
				where a1.FMultiCheckStatus=''16''' + @filterSQL + 
				'group by e.FName,d.FName,c.FName,b.FCfgDesc,f.FName,g.FName,h.FName,
					i.FStereotype,j.FName,k.FInterior,l.FColor,b.FOptional 
				order by d.FName,c.FName'
	execute sp_executesql @sql 

	select FBrandName 品牌,FSeriesName 车系,FModelName 车型, FCfgDesc 车辆配置说明,FDisplacementName 排量,
		FGearboxName 变速箱,FPowerFormName 动力形式,FStereotypeName 型版,FDriverFormName 驱动形式,FInteriorName 内饰,
		FColorName 颜色,FOptional 选装, FTotalQty 数量,	FTotalAmount 金额
	from #tmpTable
	
	union all
	select '','合计','','','',
		'','','','','',
		'','',isnull(sum(FTotalQty),0),isnull(sum(FTotalAmount),0)
	from #tmpTable

	
END
GO
