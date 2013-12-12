--≥µœµ ”Õº
if exists (select 1 from sysobjects where name = 'V_ATS_RepairItem' and xtype='U')
	drop table V_ATS_RepairItem
go
if exists (select 1 from sysobjects where name = 'V_ATS_RepairItem' and xtype='V')
	drop view V_ATS_RepairItem
go
create view V_ATS_RepairItem as
select FID,FName,FNumber,0 'FParentID',-1 'FLogic',1 'FDetail',0 'FDiscontinued',1 'FLevels',
FNumber 'FFullNumber',1 'FEntryID', 0 'FIndex',200000027 'FClassTypeID',FRepairClassifyID,FNOTE
from T_ATS_RepairItem
go