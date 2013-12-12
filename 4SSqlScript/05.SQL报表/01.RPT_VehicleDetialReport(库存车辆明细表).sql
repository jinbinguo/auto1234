if exists (select 1 from sysobjects where name = 'RPT_VehicleDetialReport' and xtype='p')
	drop procedure RPT_VehicleDetialReport
go

create procedure RPT_VehicleDetialReport
AS
BEGIN
	/**整车库存明细表*/

	SET NOCOUNT ON;

	select d.FName FBrandName,c.FName FSeriesName, b.FName FModelName,a.FBillNo FNumber,a.FCfgDesc,
	a.FVIN,a.FEngineNum,a.FKeyNum,e.FName FDisplacementName,f.FName FGearboxName,g.FName FPowerFormName,
	h.FStereotype FStereotypeName,i.FName FDriverFormName,j.FInterior FInteriorName,k.FColor FColorName,
	a.FOptional,a.FProductDate,a.FPurDate,l.FName FStockName,a.FPurAmount 
	from T_ATS_Vehicle a
	left join T_ATS_Model b on b.FID=a.FModelID
	left join T_ATS_Series c on c.FID=b.FSeriesID
	left join T_ATS_Brand d on d.FID=c.FBrandID 
	left join T_ATS_Displacement e on e.FID=b.FDisplacementID 
	left join T_ATS_Gearbox f on f.FID=b.FGearboxID
	left join T_ATS_PowerForm g on g.FID=b.FPowerFormID 
	left join T_ATS_SeriesStereotype h on h.FEntryID=b.FStereotypeID
	left join T_ATS_DriverForm i on i.FID=b.FDriverFormID
	left join T_ATS_SeriesInterior j on j.FEntryID=a.FInteriorID
	left join T_ATS_SeriesColor k on  k.FEntryID =a.FColorID 
	left join t_Stock l on l.FItemID=a.FStockID and l.FItemID<>0
	where 
END
GO
