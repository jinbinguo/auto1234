---����������۶��������ֶδ������������⣬��BOS���޸ĺ󣬰ѹ���Ū��

update icclasstableinfo set FDSPFieldName ='FSeriesName' where fcaption_chs='��ϵ' and ftablename='T_ATS_VehicleSaleOrderEntry' and FSRCTableName = 'V_ATS_Model' and FFieldName='FModelId'



---����䳵�������ֶδ������������⣬��BOS���޸ĺ󣬰ѹ���Ū��
update icclasstableinfo set FDSPFieldName='FVIN' where fcaption_chs='���̺�' and FTableName='T_ATS_Assign' and FSRCTableName='V_ATS_Vehicle' and FFieldName='FVehicleID'
update icclasstableinfo set FDSPFieldName='FEngineNum' where fcaption_chs='��������' and FTableName='T_ATS_Assign' and FSRCTableName='V_ATS_Vehicle' and FFieldName='FVehicleID'

---����䳵�������ֶδ������������⣬��BOS���޸ĺ󣬰ѹ���Ū��
update ICClassTableInfo set FDSPFieldName= 'FMakerModelNum' where FCaption_CHS='���ҳ��ͱ���' and  FTableName='t_ats_SettlementCheck' and FSRCTableName='V_ATS_Vehicle' and FFieldName='FVehicleID'
update ICClassTableInfo set FDSPFieldName= 'FSeriesName' where FCaption_CHS='��ϵ' and  FTableName='t_ats_SettlementCheck' and FSRCTableName='V_ATS_Vehicle' and FFieldName='FVehicleID'


update icclasstableinfo set FDSPFieldName ='FBrandName' where fcaption_chs='Ʒ��' and ftablename='T_ATS_Vehicle' and FSRCTableName = 'V_ATS_Model' and FFieldName='FModelId'
update icclasstableinfo set FDSPFieldName ='FDisplacementName' where fcaption_chs='����' and ftablename='T_ATS_Vehicle' and FSRCTableName = 'V_ATS_Model' and FFieldName='FModelId'
update icclasstableinfo set FDSPFieldName ='FGearboxName' where fcaption_chs='������' and ftablename='T_ATS_Vehicle' and FSRCTableName = 'V_ATS_Model' and FFieldName='FModelId'
update icclasstableinfo set FDSPFieldName ='FPowerFormName' where fcaption_chs='������ʽ' and ftablename='T_ATS_Vehicle' and FSRCTableName = 'V_ATS_Model' and FFieldName='FModelId'
update icclasstableinfo set FDSPFieldName ='FStereotypeName' where fcaption_chs='��/��' and ftablename='T_ATS_Vehicle' and FSRCTableName = 'V_ATS_Model' and FFieldName='FModelId'
update icclasstableinfo set FDSPFieldName ='FDriverFormName' where fcaption_chs='������ʽ' and ftablename='T_ATS_Vehicle' and FSRCTableName = 'V_ATS_Model' and FFieldName='FModelId'



---��������鳵���ֶδ������������⣬��BOS���޸ĺ󣬰ѹ���Ū��

update ICClassTableInfo set FDSPFieldName= 'FBrandName' where FCaption_CHS='Ʒ��' and  FTableName='t_ats_SettlementCheck' and FSRCTableName='V_ATS_Vehicle' and FFieldName='FVehicleID'
update ICClassTableInfo set FDSPFieldName= 'FSeriesName' where FCaption_CHS='��ϵ' and  FTableName='t_ats_SettlementCheck' and FSRCTableName='V_ATS_Vehicle' and FFieldName='FVehicleID'
update ICClassTableInfo set FDSPFieldName= 'FPowerFormName' where FCaption_CHS='������ʽ' and  FTableName='t_ats_SettlementCheck' and FSRCTableName='V_ATS_Vehicle' and FFieldName='FVehicleID'
update ICClassTableInfo set FDSPFieldName= 'FDriverFormName' where FCaption_CHS='������ʽ' and  FTableName='t_ats_SettlementCheck' and FSRCTableName='V_ATS_Vehicle' and FFieldName='FVehicleID'
update ICClassTableInfo set FDSPFieldName= 'FInteriorName' where FCaption_CHS='����' and  FTableName='t_ats_SettlementCheck' and FSRCTableName='V_ATS_Vehicle' and FFieldName='FVehicleID'
update ICClassTableInfo set FDSPFieldName= 'FColorName' where FCaption_CHS='��ɫ' and  FTableName='t_ats_SettlementCheck' and FSRCTableName='V_ATS_Vehicle' and FFieldName='FVehicleID'
update ICClassTableInfo set FDSPFieldName= 'FOptional' where FCaption_CHS='ѡװ' and  FTableName='t_ats_SettlementCheck' and FSRCTableName='V_ATS_Vehicle' and FFieldName='FVehicleID'
update ICClassTableInfo set FDSPFieldName= 'FModelName' where FCaption_CHS='����' and  FTableName='t_ats_SettlementCheck' and FSRCTableName='V_ATS_Vehicle' and FFieldName='FVehicleID'
update ICClassTableInfo set FDSPFieldName= 'FVIN' where FCaption_CHS='���̺�' and  FTableName='t_ats_SettlementCheck' and FSRCTableName='V_ATS_Vehicle' and FFieldName='FVehicleID'
update ICClassTableInfo set FDSPFieldName= 'FEngineNum' where FCaption_CHS='��������' and  FTableName='t_ats_SettlementCheck' and FSRCTableName='V_ATS_Vehicle' and FFieldName='FVehicleID'
update ICClassTableInfo set FDSPFieldName= 'FMakerModelNum' where FCaption_CHS='���ҳ��ͱ���' and  FTableName='t_ats_SettlementCheck' and FSRCTableName='V_ATS_Vehicle' and FFieldName='FVehicleID'
update ICClassTableInfo set FDSPFieldName= 'FCfgDesc' where FCaption_CHS='����˵��' and  FTableName='t_ats_SettlementCheck' and FSRCTableName='V_ATS_Vehicle' and FFieldName='FVehicleID'
update ICClassTableInfo set FDSPFieldName= 'FDisplacementName' where FCaption_CHS='����' and  FTableName='t_ats_SettlementCheck' and FSRCTableName='V_ATS_Vehicle' and FFieldName='FVehicleID'
update ICClassTableInfo set FDSPFieldName= 'FGearboxName' where FCaption_CHS='������' and  FTableName='t_ats_SettlementCheck' and FSRCTableName='V_ATS_Vehicle' and FFieldName='FVehicleID'
update ICClassTableInfo set FDSPFieldName= 'FStereotypeName' where FCaption_CHS='��/��' and  FTableName='t_ats_SettlementCheck' and FSRCTableName='V_ATS_Vehicle' and FFieldName='FVehicleID'



---������������г����ֶδ������������⣬��BOS���޸ĺ󣬰ѹ���Ū��

update icclasstableinfo set FDSPFieldName ='FBrandName' where fcaption_chs='Ʒ��' and ftablename='T_ATS_Vehicle' and FSRCTableName = 'V_ATS_Model' and FFieldName='FModelId'
update icclasstableinfo set FDSPFieldName ='FDisplacementName' where fcaption_chs='����' and ftablename='T_ATS_Vehicle' and FSRCTableName = 'V_ATS_Model' and FFieldName='FModelId'
update icclasstableinfo set FDSPFieldName ='FGearboxName' where fcaption_chs='������' and ftablename='T_ATS_Vehicle' and FSRCTableName = 'V_ATS_Model' and FFieldName='FModelId'
update icclasstableinfo set FDSPFieldName ='FPowerFormName' where fcaption_chs='������ʽ' and ftablename='T_ATS_Vehicle' and FSRCTableName = 'V_ATS_Model' and FFieldName='FModelId'
update icclasstableinfo set FDSPFieldName ='FStereotypeName' where fcaption_chs='��/��' and ftablename='T_ATS_Vehicle' and FSRCTableName = 'V_ATS_Model' and FFieldName='FModelId'
update icclasstableinfo set FDSPFieldName ='FDriverFormName' where fcaption_chs='������ʽ' and ftablename='T_ATS_Vehicle' and FSRCTableName = 'V_ATS_Model' and FFieldName='FModelId'


update t_DataFlowTimeStamp Set FName = FName