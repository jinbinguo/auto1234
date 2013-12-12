--车系_颜色视图
if exists (select 1 from sysobjects where name = 'v_ats_color' and xtype='U')
	drop table v_ats_color
go
if exists (select 1 from sysobjects where name = 'v_ats_color' and xtype='V')
	drop view v_ats_color
go
create view v_ats_color as
select FEntryID,200000024 'FClassTypeID',FEntryID 'FID',FIndex,FColorNumber 'FNumber',
FColor 'FName',0 'FParentID',-1 'FLogic',1 'FDetail',0 'FDiscontinued',1 'FLevels',
FColorNumber 'FFullNumber',FID 'FSeriesID'
from T_ATS_SeriesColor
go