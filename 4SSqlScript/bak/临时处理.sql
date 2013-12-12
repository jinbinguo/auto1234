---解决整车销售订单车型字段带辅助属性问题，在BOS下修改后，把关联弄坏

update icclasstableinfo set FDSPFieldName ='FSeriesName' where fcaption_chs='车系' and ftablename='T_ATS_VehicleSaleOrderEntry' and FSRCTableName = 'V_ATS_Model' and FFieldName='FModelId'



---解决配车单车辆字段带辅助属性问题，在BOS下修改后，把关联弄坏
update icclasstableinfo set FDSPFieldName='FVIN' where fcaption_chs='底盘号' and FTableName='T_ATS_Assign' and FSRCTableName='V_ATS_Vehicle' and FFieldName='FVehicleID'
update icclasstableinfo set FDSPFieldName='FEngineNum' where fcaption_chs='发动机号' and FTableName='T_ATS_Assign' and FSRCTableName='V_ATS_Vehicle' and FFieldName='FVehicleID'

---解决配车单车型字段带辅助属性问题，在BOS下修改后，把关联弄坏
update ICClassTableInfo set FDSPFieldName= 'FMakerModelNum' where FCaption_CHS='厂家车型编码' and  FTableName='t_ats_SettlementCheck' and FSRCTableName='V_ATS_Vehicle' and FFieldName='FVehicleID'
update ICClassTableInfo set FDSPFieldName= 'FSeriesName' where FCaption_CHS='车系' and  FTableName='t_ats_SettlementCheck' and FSRCTableName='V_ATS_Vehicle' and FFieldName='FVehicleID'


update icclasstableinfo set FDSPFieldName ='FBrandName' where fcaption_chs='品牌' and ftablename='T_ATS_Vehicle' and FSRCTableName = 'V_ATS_Model' and FFieldName='FModelId'
update icclasstableinfo set FDSPFieldName ='FDisplacementName' where fcaption_chs='排量' and ftablename='T_ATS_Vehicle' and FSRCTableName = 'V_ATS_Model' and FFieldName='FModelId'
update icclasstableinfo set FDSPFieldName ='FGearboxName' where fcaption_chs='变速箱' and ftablename='T_ATS_Vehicle' and FSRCTableName = 'V_ATS_Model' and FFieldName='FModelId'
update icclasstableinfo set FDSPFieldName ='FPowerFormName' where fcaption_chs='动力形式' and ftablename='T_ATS_Vehicle' and FSRCTableName = 'V_ATS_Model' and FFieldName='FModelId'
update icclasstableinfo set FDSPFieldName ='FStereotypeName' where fcaption_chs='型/版' and ftablename='T_ATS_Vehicle' and FSRCTableName = 'V_ATS_Model' and FFieldName='FModelId'
update icclasstableinfo set FDSPFieldName ='FDriverFormName' where fcaption_chs='驱动形式' and ftablename='T_ATS_Vehicle' and FSRCTableName = 'V_ATS_Model' and FFieldName='FModelId'



---解决结算检查车辆字段带辅助属性问题，在BOS下修改后，把关联弄坏

update ICClassTableInfo set FDSPFieldName= 'FBrandName' where FCaption_CHS='品牌' and  FTableName='t_ats_SettlementCheck' and FSRCTableName='V_ATS_Vehicle' and FFieldName='FVehicleID'
update ICClassTableInfo set FDSPFieldName= 'FSeriesName' where FCaption_CHS='车系' and  FTableName='t_ats_SettlementCheck' and FSRCTableName='V_ATS_Vehicle' and FFieldName='FVehicleID'
update ICClassTableInfo set FDSPFieldName= 'FPowerFormName' where FCaption_CHS='动力形式' and  FTableName='t_ats_SettlementCheck' and FSRCTableName='V_ATS_Vehicle' and FFieldName='FVehicleID'
update ICClassTableInfo set FDSPFieldName= 'FDriverFormName' where FCaption_CHS='驱动形式' and  FTableName='t_ats_SettlementCheck' and FSRCTableName='V_ATS_Vehicle' and FFieldName='FVehicleID'
update ICClassTableInfo set FDSPFieldName= 'FInteriorName' where FCaption_CHS='内饰' and  FTableName='t_ats_SettlementCheck' and FSRCTableName='V_ATS_Vehicle' and FFieldName='FVehicleID'
update ICClassTableInfo set FDSPFieldName= 'FColorName' where FCaption_CHS='颜色' and  FTableName='t_ats_SettlementCheck' and FSRCTableName='V_ATS_Vehicle' and FFieldName='FVehicleID'
update ICClassTableInfo set FDSPFieldName= 'FOptional' where FCaption_CHS='选装' and  FTableName='t_ats_SettlementCheck' and FSRCTableName='V_ATS_Vehicle' and FFieldName='FVehicleID'
update ICClassTableInfo set FDSPFieldName= 'FModelName' where FCaption_CHS='车型' and  FTableName='t_ats_SettlementCheck' and FSRCTableName='V_ATS_Vehicle' and FFieldName='FVehicleID'
update ICClassTableInfo set FDSPFieldName= 'FVIN' where FCaption_CHS='底盘号' and  FTableName='t_ats_SettlementCheck' and FSRCTableName='V_ATS_Vehicle' and FFieldName='FVehicleID'
update ICClassTableInfo set FDSPFieldName= 'FEngineNum' where FCaption_CHS='发动机号' and  FTableName='t_ats_SettlementCheck' and FSRCTableName='V_ATS_Vehicle' and FFieldName='FVehicleID'
update ICClassTableInfo set FDSPFieldName= 'FMakerModelNum' where FCaption_CHS='厂家车型编码' and  FTableName='t_ats_SettlementCheck' and FSRCTableName='V_ATS_Vehicle' and FFieldName='FVehicleID'
update ICClassTableInfo set FDSPFieldName= 'FCfgDesc' where FCaption_CHS='配置说明' and  FTableName='t_ats_SettlementCheck' and FSRCTableName='V_ATS_Vehicle' and FFieldName='FVehicleID'
update ICClassTableInfo set FDSPFieldName= 'FDisplacementName' where FCaption_CHS='排量' and  FTableName='t_ats_SettlementCheck' and FSRCTableName='V_ATS_Vehicle' and FFieldName='FVehicleID'
update ICClassTableInfo set FDSPFieldName= 'FGearboxName' where FCaption_CHS='变速箱' and  FTableName='t_ats_SettlementCheck' and FSRCTableName='V_ATS_Vehicle' and FFieldName='FVehicleID'
update ICClassTableInfo set FDSPFieldName= 'FStereotypeName' where FCaption_CHS='型/版' and  FTableName='t_ats_SettlementCheck' and FSRCTableName='V_ATS_Vehicle' and FFieldName='FVehicleID'



---解决车辆资料中车型字段带辅助属性问题，在BOS下修改后，把关联弄坏

update icclasstableinfo set FDSPFieldName ='FBrandName' where fcaption_chs='品牌' and ftablename='T_ATS_Vehicle' and FSRCTableName = 'V_ATS_Model' and FFieldName='FModelId'
update icclasstableinfo set FDSPFieldName ='FDisplacementName' where fcaption_chs='排量' and ftablename='T_ATS_Vehicle' and FSRCTableName = 'V_ATS_Model' and FFieldName='FModelId'
update icclasstableinfo set FDSPFieldName ='FGearboxName' where fcaption_chs='变速箱' and ftablename='T_ATS_Vehicle' and FSRCTableName = 'V_ATS_Model' and FFieldName='FModelId'
update icclasstableinfo set FDSPFieldName ='FPowerFormName' where fcaption_chs='动力形式' and ftablename='T_ATS_Vehicle' and FSRCTableName = 'V_ATS_Model' and FFieldName='FModelId'
update icclasstableinfo set FDSPFieldName ='FStereotypeName' where fcaption_chs='型/版' and ftablename='T_ATS_Vehicle' and FSRCTableName = 'V_ATS_Model' and FFieldName='FModelId'
update icclasstableinfo set FDSPFieldName ='FDriverFormName' where fcaption_chs='驱动形式' and ftablename='T_ATS_Vehicle' and FSRCTableName = 'V_ATS_Model' and FFieldName='FModelId'


update t_DataFlowTimeStamp Set FName = FName