--≥µœµ ”Õº
if exists (select 1 from sysobjects where name = 'V_ATS_Series' and xtype='U')
	drop table V_ATS_Series
go
if exists (select 1 from sysobjects where name = 'V_ATS_Series' and xtype='V')
	drop view V_ATS_Series
go
create view V_ATS_Series as
select FID,FName,FNumber,0 'FParentID',-1 'FLogic',1 'FDetail',0 'FDiscontinued',1 'FLevels',
FNumber 'FFullNumber',1 'FEntryID', 0 'FIndex',200000027 'FClassTypeID',FBrandID,FCarTypeID,FStatus
from T_ATS_Series where FStatus=2
go