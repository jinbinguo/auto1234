if exists (select 1 from sysobjects where name = 'RPT_VehicleStockGatherByModel' and xtype='P')
	drop procedure RPT_VehicleStockGatherByModel
go

create procedure RPT_VehicleStockGatherByModel
	@brandName varchar(100), --品牌名称
	@seriesName varchar(100), --车系名称
	@modelName varchar(100),--车型名称
	@stockName varchar(100) --仓库名称
AS
BEGIN
	/**整车库存明细表-按车型*/

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
		FStockName varchar(100),
		FTotalQty decimal(10,0),
		FTotalAmount decimal(10,2)
	)

	set @sql = 'insert into #tmpTable select d.FName FBrandName,c.FName FSeriesName,b.FName FModelName,l.FName FStockName,sum(1) FTotalQty,sum(a.FPurAmount) FTotalAmount
		from T_ATS_Vehicle a
		left join T_ATS_Model b on b.FID=a.FModelID
		left join T_ATS_Series c on c.FID=b.FSeriesID
		left join T_ATS_Brand d on d.FID=c.FBrandID 
		left join t_Stock l on l.FItemID=a.FStockID and l.FItemID<>0
	where (a.FVehicleStatus=1 or a.FVehicleStatus=2)'  + @filterSQL +
	' group by d.FName,c.FName,l.FName,b.FName' +
	' Order by d.FName,b.FName,c.FName,l.FName '

	execute sp_executesql @sql 
	


	select FBrandName 品牌,FSeriesName 车系,FModelName 车型, FStockName 仓库, FTotalQty 数量,
		FTotalAmount 金额
	from #tmpTable
	union all
	select '','合计','','',isnull(sum(FTotalQty),0),
		isnull(sum(FTotalAmount),0)
	from #tmpTable

END
GO
