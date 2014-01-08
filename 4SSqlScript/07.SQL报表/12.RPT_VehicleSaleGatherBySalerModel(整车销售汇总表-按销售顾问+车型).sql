if exists (select 1 from sysobjects where name = 'RPT_VehicleSaleGatherBySalerModel' and xtype='P')
	drop procedure RPT_VehicleSaleGatherBySalerModel
go

create procedure RPT_VehicleSaleGatherBySalerModel
	@beginDate date, --开始日期
	@endDate date, --结束日期
	@brandName varchar(100), --品牌名称
	@seriesName varchar(100), --车系名称
	@modelName varchar(100), --车型名称
	@empName varchar(100) --销售顾问
AS
BEGIN
	/**整车销售汇总表（按销售顾问+车型）*/

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
	if @empName <> ''
		set @filterSQL = @filterSQL + ' and f.FName like ''%' + @empName + '%'''

	if @beginDate <> ''
		set @filterSQL = @filterSQL + 'and a1.FDate>='''+ convert(varchar(10),@beginDate,120) + ''''
	if @endDate <> ''
		set @filterSQL = @filterSQL + 'and a1.FDate<=''' + convert(varchar(10),@endDate,120) + ''''

	create table #tmpTable(
		FSaler varchar(100),
		FBrandName varchar(100),
		FSeriesName varchar(100),
		FModelName varchar(100),
		FQty decimal(10,0) default 0,
		FSaleAmt decimal(10,2) default 0,
		FPreferentialAmt decimal(10,2) default 0,
		FARAmount decimal(10,2) default 0,
		FOptionalAmt decimal(10,2) default 0,
		FSecondHandAmount decimal(10,2) default 0,
		FARRealAmount decimal(10,2) default 0,
		FReceiptBindingAmount decimal(10,2) default 0
	);

	set @sql = 'insert into #tmpTable(FSaler,FBrandName,FSeriesName,FModelName,
			FQty,FSaleAmt,FPreferentialAmt,
			FARAmount,FOptionalAmt,FSecondHandAmount,
			FARRealAmount,FReceiptBindingAmount)
		select f.FName FSaler,e.FName FBrandName,d.FName FSeriesName,c.FName FModelName,
		sum(a.FQty) FQty, sum(a.FVehicleSaleAmount) FSaleAmt, sum(a.FVehiclePreferentialAmt) FPreferentialAmt,
		sum(a.FARVehicleAmount) FARAmount,sum(a.FOptionalAmount) FOptionalAmt,sum(a.FSecondHandAmount) FSecondHandAmount,
		sum(a.FARRealVehicleAmount) FARRealAmount, sum(a.FReceiptBindingAmount) FReceiptBindingAmount
		  from T_ATS_VehicleSaleOrderEntry a
		left join T_ATS_VehicleSaleOrder a1 on a.FID=a1.FID
		left join t_ats_vehicle b on b.FID=a.FVehicleID
		left join T_ATS_Model c on c.FID=b.FModelID
		left join T_ATS_Series d on d.FID=c.FSeriesID
		left join T_ATS_Brand e on d.FID=d.FBrandID
		left join t_Emp f on f.FItemID=a1.FPersonID
		where a1.FMultiCheckStatus=''16''' + @filterSQL +
		'group by f.FName,e.FName,d.FName,c.FName'
	execute sp_executesql @sql
	select FSaler 销售顾问,FBrandName 品牌,FSeriesName 车系,FModelName 车型, 
		FQty 数量, FSaleAmt 整车销售金额, FPreferentialAmt 整车优惠金额,
		FARAmount 整车应收金额,FOptionalAmt 选装金额,FSecondHandAmount 置换金额,
		FARRealAmount 实际应收金额, FReceiptBindingAmount 总已收金额
	from #tmpTable
	union all

	select '','合计','','',
		sum(FQty) 数量, sum(FSaleAmt) 整车销售金额, sum(FPreferentialAmt) 整车优惠金额,
		sum(FARAmount) 整车应收金额,sum(FOptionalAmt) 选装金额,sum(FSecondHandAmount) 置换金额,
		sum(FARRealAmount) 实际应收金额, sum(FReceiptBindingAmount) 总已收金额
	from #tmpTable


END
GO