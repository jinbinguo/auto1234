--车系_型/版视图
if exists (select 1 from sysobjects where name = 'V_ATS_Stereotype' and xtype='U')
	drop table V_ATS_Stereotype
go
if exists (select 1 from sysobjects where name = 'V_ATS_Stereotype' and xtype='V')
	drop view V_ATS_Stereotype
go
create view V_ATS_Stereotype as
select FEntryID,200000031 'FClassTypeID',FEntryID 'FID',FIndex,FStereotypeNumber 'FNumber',
FStereotype 'FName',0 'FParentID',-1 'FLogic',1 'FDetail',0 'FDiscontinued',1 'FLevels',
FStereotypeNumber 'FFullNumber',FID 'FSeriesID'
from T_ATS_SeriesStereotype
go