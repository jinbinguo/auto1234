if exists (select 1 from sysobjects where name = 'RPT_VehicleInOutGatherBySeries' and xtype='P')
	drop procedure RPT_VehicleInOutGatherBySeries
go

create procedure RPT_VehicleInOutGatherBySeries
	@beginDate date, --��ʼ����
	@endDate date, --��������
	@brandName varchar(100), --Ʒ������
	@seriesName varchar(100), --��ϵ����
	@stockName varchar(100) --�ֿ�����
AS
BEGIN
	/**�����շ�����ܱ������ͣ�*/

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
	if @stockName <> ''
		set @filterSQL = @filterSQL + ' and f.FName like ''%' + @stockName + '%'''

	set @filterInitDate = ' and a1.FDate<''' + convert(varchar(10),@beginDate,120) + ''''
	set @filterPeriodDate = 'and a1.FDate>='''+ convert(varchar(10),@beginDate,120) + ''' and a1.FDate<=''' + convert(varchar(10),@endDate,120) + ''''


	create table #tmpTable(
		FBrandName varchar(100),
		FSeriesName varchar(100),
		FModelName varchar(100),
		FStockName varchar(100),
		FInitPurInQty decimal(10,0) default 0,
		FInitPurInAmount decimal(10,2) default 0,
		FInitMoveInQty decimal(10,0) default 0,
		FInitMoveInAmount decimal(10,2) default 0,
		FInitMoveOutQty decimal(10,0) default 0,
		FInitMoveOutAmount decimal(10,2) default 0,
		FInitSaleOutQty decimal(10,0) default 0,
		FInitSaleOutAmount decimal(10,2) default 0,
		FPeriodPurInQty decimal(10,0) default 0,
		FPeriodPurInAmount decimal(10,2) default 0,
		FPeriodMoveInQty decimal(10,0) default 0,
		FPeriodMoveInAmount decimal(10,2) default 0,
		FPeriodMoveOutQty decimal(10,0) default 0,
		FPeriodMoveOutAmount decimal(10,2) default 0,
		FPeriodSaleOutQty decimal(10,0) default 0,
		FPeriodSaleOutAmount decimal(10,2) default 0
	);

	--�ڳ�
	--�ɹ����
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


	--������
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
	--������
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

	--���۳�
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


	--�ڼ�
	--�ɹ����
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


	--������
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

	--������
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

	--���۳�
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
	
	select FBrandName Ʒ��,FSeriesName ��ϵ,FStockName �ֿ�,
		sum(FInitPurInQty + FInitMoveInQty -FInitMoveOutQty -FInitSaleOutQty) '�ڳ����+����',
		sum(FInitPurInAmount + FInitMoveInAmount -FInitMoveOutAmount -FInitSaleOutAmount) '�ڳ����+����',
		sum(FPeriodPurInQty+FPeriodMoveInQty) '��������+����',
		sum(FPeriodPurInAmount+FPeriodMoveInAmount) '��������+���',
		sum(FPeriodMoveOutQty+FPeriodSaleOutQty) '���ڷ���+����',
		sum(FPeriodMoveOutAmount+FPeriodSaleOutAmount) '���ڷ���+���',
		sum(FInitPurInQty + FInitMoveInQty -FInitMoveOutQty -FInitSaleOutQty+FPeriodPurInQty+FPeriodMoveInQty-FPeriodMoveOutQty+FPeriodSaleOutQty) '��ĩ���+����',
		sum(FInitPurInAmount + FInitMoveInAmount -FInitMoveOutAmount -FInitSaleOutAmount+FPeriodPurInAmount+FPeriodMoveInAmount-FPeriodMoveOutAmount+FPeriodSaleOutAmount) '��ĩ���+���'
	from #tmpTable
	group by FBrandName,FSeriesName,FStockName

END
GO