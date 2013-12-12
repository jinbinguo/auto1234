--车系_内饰视图
if exists (select 1 from sysobjects where name = 'v_ats_interior' and xtype='U')
	drop table v_ats_interior
go
if exists (select 1 from sysobjects where name = 'v_ats_interior' and xtype='V')
	drop view v_ats_interior
go
create view v_ats_interior as
select FEntryID,200000025 'FClassTypeID',FEntryID 'FID',FIndex,FInteriorNumber 'FNumber',
FInterior 'FName',0 'FParentID',-1 'FLogic',1 'FDetail',0 'FDiscontinued',1 'FLevels',
FInteriorNumber 'FFullNumber',FID 'FSeriesID'
from T_ATS_SeriesInterior
go