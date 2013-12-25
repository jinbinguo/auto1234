if exists (select 1 from sysobjects where name = 'RPT_VehiclePurGatherBySeries' and xtype='P')
	drop procedure RPT_VehiclePurGatherBySeries
go

create procedure RPT_VehiclePurGatherBySeries
	@brandName varchar(100), --品牌名称
	@seriesName varchar(100) --车系名称
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

	create table #tmpTable(
		FBrandName varchar(100),
		FSeriesName varchar(100),
		FTotalQty decimal(10,0),
		FTotalAmount decimal(10,2)
	);

	set @sql = 'insert into #tmpTable(FBrandName,FSeriesName,FTotalQty,FTotalAmount)
				select 	e.FName FBrandName,d.FName FSeriesName,sum(a.FQty) FTotalQty,sum(a.FTaxAmount) FTaxAmount
					from T_ATS_VehicleInWarehsEntry a
					left join T_ATS_VehicleInWarehs a1 on a.FID=a1.FID
					left join t_ats_Vehicle b on b.FID=a.FVehicleID
					left join T_ATS_Model c on c.FID=b.FModelID
					left join T_ATS_Series d on d.FID=c.FSeriesID
					left join T_ATS_Brand e on d.FID=d.FBrandID
				where a1.FMultiCheckStatus=''16''' + @filterSQL + 
				'group by e.FName,d.FName
				order by d.FName'
	execute sp_executesql @sql 

	select FBrandName 品牌,FSeriesName 车系,FTotalQty 数量,	FTotalAmount 金额
	from #tmpTable
	
	union all
	select '','合计',isnull(sum(FTotalQty),0),isnull(sum(FTotalAmount),0)
	from #tmpTable

	
END
GO
