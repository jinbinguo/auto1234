if exists (select 1 from sysobjects where name = 'RPT_VehicleSaleGatherBySeries' and xtype='P')
	drop procedure RPT_VehicleSaleGatherBySeries
go

create procedure RPT_VehicleSaleGatherBySeries
	@beginDate date, --开始日期
	@endDate date, --结束日期
	@brandName varchar(100), --品牌名称
	@seriesName varchar(100) --车系名称
AS
BEGIN
	/**整车销售汇总表（按车系）*/

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
	if @beginDate <> ''
		set @filterSQL = @filterSQL + ' and a1.FDate>='''+ convert(varchar(10),@beginDate,120) + ''''
	if @endDate <> ''
		set @filterSQL = @filterSQL + ' and a1.FDate<=''' + convert(varchar(10),@endDate,120) + ''''

	create table #tmpTable(
		FBrandName varchar(100),
		FSeriesName varchar(100),
		FQty decimal(10,0) default 0,
		FSaleAmt decimal(10,2) default 0,
		FPreferentialAmt decimal(10,2) default 0,
		FARAmount decimal(10,2) default 0,
		FOptionalAmt decimal(10,2) default 0,
		FSecondHandAmount decimal(10,2) default 0,
		FARRealAmount decimal(10,2) default 0,
		FReceiptBindingAmount decimal(10,2) default 0
	);

	set @sql = 'insert into #tmpTable(FBrandName,FSeriesName,
			FQty,FSaleAmt,FPreferentialAmt,
			FARAmount,FOptionalAmt,FSecondHandAmount,
			FARRealAmount,FReceiptBindingAmount)
		select e.FName FBrandName,d.FName FSeriesName,
		sum(a.FQty) FQty, sum(a.FVehicleSaleAmount) FSaleAmt, sum(a.FVehiclePreferentialAmt) FPreferentialAmt,
		sum(a.FARVehicleAmount) FARAmount,sum(a.FOptionalAmount) FOptionalAmt,sum(a.FSecondHandAmount) FSecondHandAmount,
		sum(a.FARRealVehicleAmount) FARRealAmount, sum(a.FReceiptBindingAmount) FReceiptBindingAmount
		  from T_ATS_VehicleSaleOrderEntry a
		left join T_ATS_VehicleSaleOrder a1 on a.FID=a1.FID
		left join t_ats_vehicle b on b.FID=a.FVehicleID
		left join T_ATS_Model c on c.FID=b.FModelID
		left join T_ATS_Series d on d.FID=c.FSeriesID
		left join T_ATS_Brand e on d.FID=d.FBrandID
		where a1.FMultiCheckStatus=''16''' + @filterSQL +
		'group by e.FName,d.FName,c.FName'
	execute sp_executesql @sql
	select FBrandName 品牌,FSeriesName 车系,
		FQty 数量, FSaleAmt 整车销售金额, FPreferentialAmt 整车优惠金额,
		FARAmount 整车应收金额,FOptionalAmt 选装金额,FSecondHandAmount 置换金额,
		FARRealAmount 实际应收金额, FReceiptBindingAmount 总已收金额
	from #tmpTable
	union all

	select '','合计',
		sum(FQty) 数量, sum(FSaleAmt) 整车销售金额, sum(FPreferentialAmt) 整车优惠金额,
		sum(FARAmount) 整车应收金额,sum(FOptionalAmt) 选装金额,sum(FSecondHandAmount) 置换金额,
		sum(FARRealAmount) 实际应收金额, sum(FReceiptBindingAmount) 总已收金额
	from #tmpTable


END
GO