--物料分类视图
if exists (select 1 from sysobjects where name = 'V_ATS_ICItemClassTree' and xtype='U')
	drop table V_ATS_ICItemClassTree
go
if exists (select 1 from sysobjects where name = 'V_ATS_ICItemClassTree' and xtype='V')
	drop view V_ATS_ICItemClassTree
go
create view V_ATS_ICItemClassTree as
select FItemID 'FID',FName,FNumber,FParentID,-1 'FLogic',FDetail,0 'FDiscontinued',FLevel,FFullNumber,200000032 'FClassTypeID'
from t_Item where FItemClassID=4 and FDetail=0 
go
if exists (select 1 from sysobjects where name = 'V_ATS_ICItemClass' and xtype='U')
	drop table V_ATS_ICItemClass
go
if exists (select 1 from sysobjects where name = 'V_ATS_ICItemClass' and xtype='V')
	drop view V_ATS_ICItemClass
go
create view V_ATS_ICItemClass as 
select 0 'FEntryID',200000032 'FClassTypeID',FItemID 'FID',0 'FIndex',FNumber,FName
from t_Item where FItemClassID=4 and FDetail=0 
go