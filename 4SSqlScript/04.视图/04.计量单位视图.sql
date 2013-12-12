--计量单位视图
if exists (select 1 from sysobjects where name = 'v_ats_unittree' and xtype='U')
	drop table v_ats_unittree
go
if exists (select 1 from sysobjects where name = 'v_ats_unittree' and xtype='V')
	drop view v_ats_unittree
go
create view v_ats_unittree as
select FItemID 'FID',FName,FNumber,FUnitGroupID 'FParentID',-1 'FLogic',1 'FDetail',0 'FDiscontinued',2 'FLevel',FNumber 'FFullNumber',200000034 'FClassTypeID'
from t_MeasureUnit  where FItemID>0
union
select FItemID 'FID',FName,FNumber,0 'FParentID',-1 'FLogic',0 'FDetail',0 'FDiscontinued',1 'FLevel',FFullNumber,200000034 'FClassTypeID'
from t_Item where FItemClassID=7 and FDetail=0 
 
go
if exists (select 1 from sysobjects where name = 'v_ats_unit' and xtype='U')
	drop table v_ats_unit
go
if exists (select 1 from sysobjects where name = 'v_ats_unit' and xtype='V')
	drop view v_ats_unit
go
create view v_ats_unit as 
select 0 'FEntryID',200000034 'FClassTypeID',FItemID 'FID',0 'FIndex',FNumber,FName
from t_Item where FItemClassID=7 and FDetail=0 
union
select 0 'FEntryID',200000034 'FClassTypeID',FItemID 'FID',0 'FIndex',FNumber,FName
from t_MeasureUnit where FItemID>0
go