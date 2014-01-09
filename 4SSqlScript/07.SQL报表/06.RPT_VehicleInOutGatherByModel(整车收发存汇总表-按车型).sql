if exists (select 1 from sysobjects where name = 'RPT_VehicleInOutGatherByModel' and xtype='P')
	drop procedure RPT_VehicleInOutGatherByModel
go

create procedure RPT_VehicleInOutGatherByModel
	@beginDate date, --开始日期
	@endDate date, --结束日期
	@brandName varchar(100), --品牌名称
	@seriesName varchar(100), --车系名称
	@modelName varchar(100),--车型名称
	@stockName varchar(100) --仓库名称
AS
BEGIN
	/**整车收发存汇总表（按车型）*/

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
	set @filterPeriodDate = ' and a1.FDate>='''+ convert(varchar(10),@beginDate,120) + ''' and a1.FDate<=''' + convert(varchar(10),@endDate,120) + ''''


	create table #tmpTable(
		FBrandName varchar(100),
		FSeriesName varchar(100),
		FModelName varchar(100),
		FStockName varchar(100),
		FInitPurInQty decimal(10,0) default 0,
		FInitPurInAmount decimal(10,0) default 0,
		FInitMoveInQty decimal(10,0) default 0,
		FInitMoveInAmount decimal(10,0) default 0,
		FInitMoveOutQty decimal(10,0) default 0,
		FInitMoveOutAmount decimal(10,0) default 0,
		FInitSaleOutQty decimal(10,0) default 0,
		FInitSaleOutAmount decimal(10,0) default 0,
		FPeriodPurInQty decimal(10,0) default 0,
		FPeriodPurInAmount decimal(10,0) default 0,
		FPeriodMoveInQty decimal(10,0) default 0,
		FPeriodMoveInAmount decimal(10,0) default 0,
		FPeriodMoveOutQty decimal(10,0) default 0,
		FPeriodMoveOutAmount decimal(10,0) default 0,
		FPeriodSaleOutQty decimal(10,0) default 0,
		FPeriodSaleOutAmount decimal(10,0) default 0
	);

	--期初
	--采购入库
	set @sql = 'insert into #tmpTable(FBrandName,FSeriesName,FModelName,FStockName,FInitPurInQty,FInitPurInAmount)
		select e.FName FBrandName,d.FName FSeriesName,c.FName FModelName,f.FName FStockName,sum(a.FQty) FTotalQty,sum(a.FTaxAmount) FTotalAmount
		  from T_ATS_VehicleInWarehsEntry a
		left join T_ATS_VehicleInWarehs a1 on a.FID=a1.FID
		left join t_ats_vehicle b on b.FID=a.FVehicleID
		left join T_ATS_Model c on c.FID=b.FModelID
				left join T_ATS_Series d on d.FID=c.FSeriesID
				left join T_ATS_Brand e on d.FID=d.FBrandID
				left join t_Stock f on f.FItemID=a.FStockID
		where a1.FMultiCheckStatus=''16''' + @filterInitDate + @filterSQL +
		' group by e.FName,d.FName,c.FName,f.FName'
	execute sp_executesql @sql


	--调拨入
	set @sql = 'insert into #tmpTable(FBrandName,FSeriesName,FModelName,FStockName,FInitMoveInQty,FInitMoveInAmount)
		select e.FName FBrandName,d.FName FSeriesName,c.FName FModelName,f.FName FStockName, sum(1) FTotalQty,sum(b.FPurAmount) FTotalAmount
		  from T_ATS_VehicleTransferEntry a
		left join T_ATS_VehicleTransfer a1 on a.FID=a1.FID
		left join t_ats_vehicle b on b.FID=a.FVehicleID
		left join T_ATS_Model c on c.FID=b.FModelID
		left join T_ATS_Series d on d.FID=c.FSeriesID
		left join T_ATS_Brand e on d.FID=d.FBrandID 
		left join t_Stock f on f.FItemID=a1.FInWarehsStockID
		where a1.FMultiCheckStatus=''16''' + @filterInitDate + @filterSQL +
		' group by e.FName,d.FName,c.FName,f.FName'
	execute sp_executesql @sql
	--调拨出
	set @sql = 'insert into #tmpTable(FBrandName,FSeriesName,FModelName,FStockName,FInitMoveOutQty,FInitMoveOutAmount)
		select e.FName FBrandName,d.FName FSeriesName,c.FName FModelName,f.FName FStockName, sum(1) FTotalQty,sum(b.FPurAmount) FTotalAmount
		  from T_ATS_VehicleTransferEntry a
		left join T_ATS_VehicleTransfer a1 on a.FID=a1.FID
		left join t_ats_vehicle b on b.FID=a.FVehicleID
		left join T_ATS_Model c on c.FID=b.FModelID
				left join T_ATS_Series d on d.FID=c.FSeriesID
				left join T_ATS_Brand e on d.FID=d.FBrandID 
				left join t_Stock f on f.FItemID=a1.FIssueStockId
		where a1.FMultiCheckStatus=''16''' + @filterInitDate + @filterSQL +
		' group by e.FName,d.FName,c.FName,f.FName'
	execute sp_executesql @sql

	--销售出
	set @sql = 'insert into #tmpTable(FBrandName,FSeriesName,FModelName,FStockName,FInitSaleOutQty,FInitSaleOutAmount)
		select e.FName FBrandName,d.FName FSeriesName,c.FName FModelName,f.FName FStockName,sum(a.FQty) FTotalQty,sum(a.FTaxAmount) FTotalAmount
		  from T_ATS_VehicleIssueEntry a
		left join T_ATS_VehicleIssue a1 on a.FID=a1.FID
		left join t_ats_vehicle b on b.FID=a.FVehicleID
		left join T_ATS_Model c on c.FID=b.FModelID
				left join T_ATS_Series d on d.FID=c.FSeriesID
				left join T_ATS_Brand e on d.FID=d.FBrandID
				left join t_Stock f on f.FItemID=a.FStockID
		where a1.FMultiCheckStatus=''16''' + @filterInitDate + @filterSQL +
		' group by e.FName,d.FName,c.FName,f.FName'
	execute sp_executesql @sql


	--期间
	--采购入库
	set @sql = 'insert into #tmpTable(FBrandName,FSeriesName,FModelName,FStockName,FPeriodPurInQty,FPeriodPurInAmount)
		select e.FName FBrandName,d.FName FSeriesName,c.FName FModelName,f.FName FStockName,sum(a.FQty) FTotalQty,sum(a.FTaxAmount) FTotalAmount
		  from T_ATS_VehicleInWarehsEntry a
		left join T_ATS_VehicleInWarehs a1 on a.FID=a1.FID
		left join t_ats_vehicle b on b.FID=a.FVehicleID
		left join T_ATS_Model c on c.FID=b.FModelID
				left join T_ATS_Series d on d.FID=c.FSeriesID
				left join T_ATS_Brand e on d.FID=d.FBrandID
				left join t_Stock f on f.FItemID=a.FStockID
		where a1.FMultiCheckStatus=''16''' + @filterPeriodDate + @filterSQL +
		' group by e.FName,d.FName,c.FName,f.FName'
	execute sp_executesql @sql


	--调拨入
	set @sql = 'insert into #tmpTable(FBrandName,FSeriesName,FModelName,FStockName,FPeriodMoveInQty,FPeriodMoveInAmount)
		select e.FName FBrandName,d.FName FSeriesName,c.FName FModelName,f.FName FStockName, sum(1) FTotalQty,sum(b.FPurAmount) FTotalAmount
		  from T_ATS_VehicleTransferEntry a
		left join T_ATS_VehicleTransfer a1 on a.FID=a1.FID
		left join t_ats_vehicle b on b.FID=a.FVehicleID
		left join T_ATS_Model c on c.FID=b.FModelID
		left join T_ATS_Series d on d.FID=c.FSeriesID
		left join T_ATS_Brand e on d.FID=d.FBrandID 
		left join t_Stock f on f.FItemID=a1.FInWarehsStockID
		where a1.FMultiCheckStatus=''16''' + @filterPeriodDate + @filterSQL +
		' group by e.FName,d.FName,c.FName,f.FName'
	execute sp_executesql @sql

	--调拨出
	set @sql = 'insert into #tmpTable(FBrandName,FSeriesName,FModelName,FStockName,FPeriodMoveOutQty,FPeriodMoveOutAmount)
		select e.FName FBrandName,d.FName FSeriesName,c.FName FModelName,f.FName FStockName, sum(1) FTotalQty,sum(b.FPurAmount) FTotalAmount
		  from T_ATS_VehicleTransferEntry a
		left join T_ATS_VehicleTransfer a1 on a.FID=a1.FID
		left join t_ats_vehicle b on b.FID=a.FVehicleID
		left join T_ATS_Model c on c.FID=b.FModelID
				left join T_ATS_Series d on d.FID=c.FSeriesID
				left join T_ATS_Brand e on d.FID=d.FBrandID 
				left join t_Stock f on f.FItemID=a1.FIssueStockId
		where a1.FMultiCheckStatus=''16''' + @filterPeriodDate + @filterSQL +
		' group by e.FName,d.FName,c.FName,f.FName'
	execute sp_executesql @sql

	--销售出
	set @sql = 'insert into #tmpTable(FBrandName,FSeriesName,FModelName,FStockName,FPeriodSaleOutQty,FPeriodSaleOutAmount)
		select e.FName FBrandName,d.FName FSeriesName,c.FName FModelName,f.FName FStockName,sum(a.FQty) FTotalQty,sum(a.FTaxAmount) FTotalAmount
		  from T_ATS_VehicleIssueEntry a
		left join T_ATS_VehicleIssue a1 on a.FID=a1.FID
		left join t_ats_vehicle b on b.FID=a.FVehicleID
		left join T_ATS_Model c on c.FID=b.FModelID
				left join T_ATS_Series d on d.FID=c.FSeriesID
				left join T_ATS_Brand e on d.FID=d.FBrandID
				left join t_Stock f on f.FItemID=a.FStockID
		where a1.FMultiCheckStatus=''16''' + @filterPeriodDate + @filterSQL +
		' group by e.FName,d.FName,c.FName,f.FName'
	execute sp_executesql @sql
	
	select FBrandName 品牌,FSeriesName 车系,FModelName 车型,FStockName 仓库,
		sum(FInitPurInQty + FInitMoveInQty -FInitMoveOutQty -FInitSaleOutQty) '期初结存+数量',
		sum(FInitPurInAmount + FInitMoveInAmount -FInitMoveOutAmount -FInitSaleOutAmount) '期初结存+数量',
		sum(FPeriodPurInQty+FPeriodMoveInQty) '本期收入+数量',
		sum(FPeriodPurInAmount+FPeriodMoveInAmount) '本期收入+金额',
		sum(FPeriodMoveOutQty+FPeriodSaleOutQty) '本期发出+数量',
		sum(FPeriodMoveOutAmount+FPeriodSaleOutAmount) '本期发出+金额',
		sum(FInitPurInQty + FInitMoveInQty -FInitMoveOutQty -FInitSaleOutQty+FPeriodPurInQty+FPeriodMoveInQty-FPeriodMoveOutQty+FPeriodSaleOutQty) '期末结存+数量',
		sum(FInitPurInAmount + FInitMoveInAmount -FInitMoveOutAmount -FInitSaleOutAmount+FPeriodPurInAmount+FPeriodMoveInAmount-FPeriodMoveOutAmount+FPeriodSaleOutAmount) '期末结存+金额'
	from #tmpTable
	group by FBrandName,FSeriesName,FModelName,FStockName

END
GO