--³µÁ¾µµ°¸
if exists (select 1 from sysobjects where name = 'V_ATS_Vehicle' and xtype='U')
	drop table V_ATS_Vehicle
go
if exists (select 1 from sysobjects where name = 'V_ATS_Vehicle' and xtype='V')
	drop view V_ATS_Vehicle
go
create view V_ATS_Vehicle as
select a.FID,a.FCfgDesc 'FName',a.FBillNo 'FNumber',0 'FParentID',-1 'FLogic',1 'FDetail',0 'FDiscontinued',1 'FLevels',
a.FBillNo 'FFullNumber',1 'FEntryID', 0 'FIndex',200000030 'FClassTypeID',c.FBrandID,b.FCarSourceID,
isnull(a.FCfgDesc,'') FCfgDesc,isnull(a.FVIN,'') FVIN,
isnull(a.FEngineNum,'') FEngineNum,FVehicleSource,
isnull(a.FOptional,'') FOptional,b.FICItemID,b.FUnitID,isnull(b.FMakerModelNum,'') FMakerModelNum,
a.FStatus,a.FVehicleStatus,isnull(c.FName,'') FSeriesName,isnull(d.FName,'') FBrandName,isnull(e.FName,'') FDisplacementName,
isnull(f.FName,'') FGearboxName,isnull(g.FName,'') FStereotypeName,isnull(b.FName,'') FModelName, isnull(h.FName,'') FPowerFormName,
isnull(i.FName,'') FDriverFormName,isnull(j.FName,'') FCarSourceName, isnull(k.FInterior,'') FInteriorName,isnull(l.FColor,'') FColorName,
isnull(m.FName,'') FICItemName,isnull(n.FName,'') FUnitName,ISNULL(o.FName,'') FInsuCompanyName,a.FPlateNum,a.FStockID,
FModelID,FColorID,FInteriorID,FInsuCompanyID,c.FID FSeriesID,a.FCarOwner,FCertificateNo,FFundingModeID
from T_ATS_Vehicle a
left join T_ATS_Model b on b.FID=a.FModelID
left join T_ATS_Series c on c.FID=b.FSeriesID 
left join T_ATS_Brand d on d.FID=c.FBrandID 
left join T_ATS_Displacement e on e.FID=b.FDisplacementID
left join T_ATS_Gearbox f on f.FID=b.FGearboxID
left join v_ATS_Stereotype g on g.FID=b.FStereotypeID
left join T_ATS_PowerForm h on h.FID=b.FPowerFormID 
left join T_ATS_DriverForm i on i.FID=b.FDriverFormID
left join T_ATS_CarSource j on j.FID=b.FCarSourceID 
left join T_ATS_SeriesInterior k on k.FEntryID =a.FInteriorID 
left join T_ATS_SeriesColor l on l.FEntryID=a.FColorID 
left join t_ICItem m on m.FItemID = b.FICItemID 
left join t_MeasureUnit n on n.FItemID = b.FUnitID 
left join t_Item o on o.FItemClassID=1 and o.FItemID=a.FInsuCompanyID and o.FItemID<>0
where a.FStatus=2