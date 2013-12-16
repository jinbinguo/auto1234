if exists (select 1 from sysobjects where name = 'RPT_VehicleStockAnalysisByModel' and xtype='P')
	drop procedure RPT_VehicleStockAnalysisByModel
go

create procedure RPT_VehicleStockAnalysisByModel
	@brandName varchar(100), --Ʒ������
	@seriesName varchar(100), --��ϵ����
	@modelName varchar(100)--��������
AS
BEGIN
	/**�������ͳ�Ʒ����������ͣ�*/

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
	create table #tmpTable(
		FBrandName varchar(100),
		FSeriesName varchar(100),
		FModelName varchar(100),
		FTotalCurrentQty decimal(10,0),
		FTotalCurrentAmount decimal(10,2),
		FTotalPreInQty decimal(10,0),
		FTotalPreInAmount decimal(10,2),
		FTotalPreOutQty decimal(10,0),
		FTotalPreOutAmount decimal(10,2)
	)
--���п��
	set @sql = 'insert into #tmpTable(FBrandName,FSeriesName,FModelName,FTotalCurrentQty,FTotalCurrentAmount)
		 select d.FName FBrandName,c.FName FSeriesName,b.FName FModelName,sum(1) FTotalQty,sum(a.FPurAmount) FTotalAmount
		from T_ATS_Vehicle a
		left join T_ATS_Model b on b.FID=a.FModelID
		left join T_ATS_Series c on c.FID=b.FSeriesID
		left join T_ATS_Brand d on d.FID=c.FBrandID 
	where (a.FVehicleStatus=1 or a.FVehicleStatus=2)'  + @filterSQL +
	' group by d.FName,b.FName,c.FName' +
	' Order by d.FName,b.FName,c.FName '

	execute sp_executesql @sql 
--Ԥ�����
	--����
	set @sql = 'update aaa
	set aaa.FTotalPreInQty=bbb.FTotalQty,
		aaa.FTotalPreInAmount=bbb.FTotalAmount
	from #tmpTable aaa 
	inner join (select d.FName FBrandName,c.FName FSeriesName,b.FName FModelName,sum(a.FQty) FTotalQty,sum(a.FTaxAmount) FTotalAmount
	from T_ATS_VehiclePurOrderEntry a
	left join T_ATS_VehiclePurOrder a1 on a1.FID=a.FID
	left join T_ATS_Model b on b.FID=a.FModelID
	left join T_ATS_Series c on c.FID=b.FSeriesID
	left join T_ATS_Brand d on d.FID=c.FBrandID 
where a1.FMultiCheckStatus=''16'' and a.FOnRoadStatus=''1''' + @filterSQL +
	' group by d.FName,c.FName,b.FName) bbb on aaa.FBrandName=bbb.FBrandName and aaa.FModelName=bbb.FModelName and aaa.FSeriesName=bbb.FSeriesName'
	execute sp_executesql @sql
	--����
	set @sql= 'insert into #tmpTable(FBrandName,FSeriesName,FModelName,FTotalPreInQty,FTotalPreInAmount)
	select aaa.FBrandName,aaa.FSeriesName,aaa.FModelName,aaa.FTotalQty,aaa.FTotalAmount from
	(select d.FName FBrandName,c.FName FSeriesName,b.FName FModelName,sum(a.FQty) FTotalQty,sum(a.FTaxAmount) FTotalAmount
	from T_ATS_VehiclePurOrderEntry a
	left join T_ATS_VehiclePurOrder a1 on a1.FID=a.FID
	left join T_ATS_Model b on b.FID=a.FModelID
	left join T_ATS_Series c on c.FID=b.FSeriesID
	left join T_ATS_Brand d on d.FID=c.FBrandID 
	where a1.FMultiCheckStatus=''16'' and a.FOnRoadStatus=''1''' + @filterSQL + 
	' group by d.FName,c.FName,b.FName) as aaa
	where not exists (select 1 from #tmpTable where FBrandName=aaa.FBrandName and FSeriesName=aaa.FSeriesName and FModelName=aaa.FModelName)'
	execute sp_executesql @sql

--Ԥ�Ƴ���
	--����
	set @sql = 'update aaa
	set aaa.FTotalPreOutQty=bbb.FTotalQty,
		aaa.FTotalPreOutAmount=bbb.FTotalAmount
	from #tmpTable aaa 
	inner join (select d.FName FBrandName,c.FName FSeriesName,b.FName FModelName,sum(a.FQty) FTotalQty,sum(a.FTaxAmount) FTotalAmount
	from T_ATS_VehicleSaleOrderEntry a
	left join T_ATS_VehicleSaleOrder a1 on a1.FID=a.FID
	left join T_ATS_Model b on b.FID=a.FModelID
	left join T_ATS_Series c on c.FID=b.FSeriesID
	left join T_ATS_Brand d on d.FID=c.FBrandID 
where a1.FMultiCheckStatus=''16'' and a.FIsIssue=0' + @filterSQL +
	' group by d.FName,c.FName,b.FName) bbb on aaa.FBrandName=bbb.FBrandName and aaa.FModelName=bbb.FModelName and aaa.FSeriesName=bbb.FSeriesName'
	execute sp_executesql @sql
	--����
	set @sql= 'insert into #tmpTable(FBrandName,FSeriesName,FModelName,FTotalPreOutQty,FTotalPreOutAmount)
	select aaa.FBrandName,aaa.FSeriesName,aaa.FModelName,aaa.FTotalQty,aaa.FTotalAmount from
	(select d.FName FBrandName,c.FName FSeriesName,b.FName FModelName,sum(a.FQty) FTotalQty,sum(a.FTaxAmount) FTotalAmount
	from T_ATS_VehicleSaleOrderEntry a
	left join T_ATS_VehicleSaleOrder a1 on a1.FID=a.FID
	left join T_ATS_Model b on b.FID=a.FModelID
	left join T_ATS_Series c on c.FID=b.FSeriesID
	left join T_ATS_Brand d on d.FID=c.FBrandID 
	where a1.FMultiCheckStatus=''16'' and a.FIsIssue=0' + @filterSQL + 
	' group by d.FName,c.FName,b.FName) as aaa
	where not exists (select 1 from #tmpTable where FBrandName=aaa.FBrandName and FSeriesName=aaa.FSeriesName and FModelName=aaa.FModelName)'
	execute sp_executesql @sql

	select FBrandName Ʒ��,FSeriesName ��ϵ,FModelName ����,FTotalCurrentQty '���п��+����',
		FTotalCurrentAmount '���п��+���',
		FTotalPreInQty 'Ԥ�����+����',
		FTotalPreInAmount 'Ԥ�����+���',
		FTotalPreOutQty 'Ԥ�Ƴ���+����',
		FTotalPreOutAmount 'Ԥ�Ƴ���+���'
	from #tmpTable
	union all
	select '','�ϼ�','',sum(FTotalCurrentQty),
		sum(FTotalCurrentAmount),
		sum(FTotalPreInQty),
		sum(FTotalPreInAmount),
		sum(FTotalPreOutQty),
		sum(FTotalPreOutAmount)
	from #tmpTable

END
GO
