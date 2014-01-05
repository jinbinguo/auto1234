--≥µ–Õ ”Õº
if exists (select 1 from sysobjects where name = 'v_ats_model' and xtype='U')
	drop table v_ats_model
go
if exists (select 1 from sysobjects where name = 'v_ats_model' and xtype='V')
	drop view v_ats_model
go
create view v_ats_model as
select a.FID,a.FName,a.FNumber,0 'FParentID',-1 'FLogic',1 'FDetail',0 'FDiscontinued',1 'FLevels',
a.FNumber 'FFullNumber',1 'FEntryID', 0 'FIndex',200000026 'FClassTypeID',
a.FSeriesID,isnull(a.FMakerModelNum,'') FMakerModelNum,b.FBrandID,a.FDisplacementID,a.FGearboxID,a.FStereotypeID,a.FPowerFormID,
a.FDriverFormID,isnull(a.FCfgDesc,'') FCfgDesc,a.FICItemID,a.FUnitID,a.FMakerGuidePrice,a.FCompGuidePrice,a.FPurTaxPrice,a.fstatus,a.FCarSourceID,
ISNULL(b.FName,'') FSeriesName,ISNULL(c.FName,'') FBrandName,ISNULL(d.FName,'') FDisplacementName,
ISNULL(e.FName,'') FGearboxName,ISNULL(f.FName,'') FStereotypeName,ISNULL(g.FName,'') FPowerFormName,
ISNULL(h.FName,'') FDriverFormName,ISNULL(i.FName,'') FCarSourceName,ISNULL(j.FName,'') FICItemName,
ISNULL(k.FName,'') FUnitName,FMakerModel
from T_ATS_Model a
left join T_ATS_Series b on b.FID=a.FSeriesID
left join T_ATS_Brand c on c.FID=b.FBrandID
left join T_ATS_Displacement d on d.FID=a.FDisplacementID
left join T_ATS_Gearbox e on e.FID=a.FGearboxID
left join V_ATS_Stereotype f on f.FID=a.FStereotypeID 
left join T_ATS_PowerForm g on g.FID=a.FPowerFormID 
left join T_ATS_DriverForm h on h.FID=a.FDriverFormID
left join T_ATS_CarSource i on i.FID=a.FCarSourceID 
left join t_ICItem j on j.FItemID=a.FICItemID
left join t_MeasureUnit k on k.FItemID=a.FUnitID
where a.FStatus=2
go
