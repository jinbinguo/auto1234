/*
一、单据基础模板
01、ICTransactionType：该表反映了供需链所有单据的总体情况。
02、ICClassType：单据类别表
03、ICTemplate：该表反映了所有单据的表头的详细情况。
04、ICTemplateEntry：该表反映了所有单据的分录的详细情况。
二、单据选单模板
01、ICSelbills：记录选单关系的表。选单要取得哪些值，这些值是如何而来的，以及需回填到哪个对应的控件里。
02、ICTableRelation：选单中涉及的所有表之间的连接关系。
03、ICWriteBackTemplate：单据回填反写表
04、ICListTemplate：单据列表模板
05、ICClassLink：单据流程定义表
三、单据控制
01、ICBillNo 单据编号表
02、ICMaxNum 最大单据内码(FInterID)号表
四、单据套打
01、GLNoteType：单据套打表，记录单据与套打编号的关系。
02、GLNoteCitation：单据套打关系表，记录单据套打字段的属性。
五、单据序时簿表
01、ICChatBillTitle：单据序时簿表
 
一、工业单据相关表介绍
01. 单据事物类型表		IctransactionType
02. 单据模板表          ICtemplate
03. 单据模板分录表		ICtemplateentry
04. 序时簿模板          IClisttemplate
05. 序时簿的显示字段表  ICchatbilltitle
06. 序时簿的过滤条件    ICtableRelation
07. 选单模板表(作用选单时单据间携带数据的对应关系表) ICselbills
08. 表描述表            t_TableDescription
09. 字段描述表			t_FieldDescription
10.凭证金额来源			ICVoucherTField
11.核算项目附表信息描述 t_ItemPropDesc
12.出套打格式字段表     GLNoteCitation  
 */

--销售出库分录.车辆
update ICTableRelation 
set FFieldName='FVehicleID'
where FFieldName = 'FEntrySelfB0167'

update ICClassTableInfo
set ffieldname='FVehicleID'
where FFieldName='FEntrySelfB0167'

update ICTemplateEntry
set FFieldName='FVehicleID',
	FFilter= 'V_ATS_Vehicle.FICItemID=GetFldValue(FItemID,1)'
where FID=(select FTemplateID from ICTransactionType where FHeadTable='ICStockBill' and FName='销售出库')
 and FHeadCaption='车辆' and FFieldName = 'FEntrySelfB0167'
 
 update ICChatBillTitle
set FColName='FVehicleID'
where FColName='FEntrySelfB0167'

EXEC sp_rename 'ICStockBillEntry.FEntrySelfB0167', 'FVehicleID', 'COLUMN'
EXEC sp_rename 'ICStockBillEntry_1.FEntrySelfB0167', 'FVehicleID', 'COLUMN'
EXEC sp_rename 'ICStockBillEntry_10.FEntrySelfB0167', 'FVehicleID', 'COLUMN'
EXEC sp_rename 'ICStockBillEntry_2.FEntrySelfB0167', 'FVehicleID', 'COLUMN'
EXEC sp_rename 'ICStockBillEntry_21.FEntrySelfB0167', 'FVehicleID', 'COLUMN' 
EXEC sp_rename 'ICStockBillEntry_24.FEntrySelfB0167', 'FVehicleID', 'COLUMN' 
EXEC sp_rename 'ICStockBillEntry_28.FEntrySelfB0167', 'FVehicleID', 'COLUMN' 
EXEC sp_rename 'ICStockBillEntry_29.FEntrySelfB0167', 'FVehicleID', 'COLUMN' 
EXEC sp_rename 'ICStockBillEntry_41.FEntrySelfB0167', 'FVehicleID', 'COLUMN' 
EXEC sp_rename 'ICStockBillEntry_5.FEntrySelfB0167', 'FVehicleID', 'COLUMN'



--销售出库分录.车系

update ICTemplateEntry
set FFieldName='FSeriesName'
where FID=(select FTemplateID from ICTransactionType where FHeadTable='ICStockBill' and FName='销售出库')
 and FHeadCaption='车系' and FFieldName = 'FEntrySelfB0168'
 
update ICChatBillTitle
set FColName='FSeriesName'
where FColName='FEntrySelfB0168'


--销售出库分录.车型
update ICTemplateEntry
set FFieldName='FModelName'
where FID=(select FTemplateID from ICTransactionType where FHeadTable='ICStockBill' and FName='销售出库')
 and FHeadCaption='车型' and FFieldName = 'FEntrySelfB0169'
 
 update ICChatBillTitle
set FColName='FModelName'
where FColName='FEntrySelfB0169'


--销售出库分录.底盘号
update ICTemplateEntry
set FFieldName='FVin'
where FID=(select FTemplateID from ICTransactionType where FHeadTable='ICStockBill' and FName='销售出库')
 and FHeadCaption='底盘号' and FFieldName = 'FEntrySelfB0170'
 
 update ICChatBillTitle
set FColName='FVin'
where FColName='FEntrySelfB0170'

--销售出库分录.品牌
update ICTemplateEntry
set FFieldName='FBrandName'
where FID=(select FTemplateID from ICTransactionType where FHeadTable='ICStockBill' and FName='销售出库')
 and FHeadCaption='品牌' and FFieldName = 'FEntrySelfB0171'
 
 update ICChatBillTitle
set FColName='FBrandName'
where FColName='FEntrySelfB0171'

--销售出库分录.驱动形式
update ICTemplateEntry
set FFieldName='FDriverFormName'
where FID=(select FTemplateID from ICTransactionType where FHeadTable='ICStockBill' and FName='销售出库')
 and FHeadCaption='驱动形式' and FFieldName = 'FEntrySelfB0172'
 
 update ICChatBillTitle
set FColName='FDriverFormName'
where FColName='FEntrySelfB0172'

--销售出库分录.动力形式
update ICTemplateEntry
set FFieldName='FPowerFormName'
where FID=(select FTemplateID from ICTransactionType where FHeadTable='ICStockBill' and FName='销售出库')
 and FHeadCaption='动力形式' and FFieldName = 'FEntrySelfB0173'
 
 update ICChatBillTitle
set FColName='FPowerFormName'
where FColName='FEntrySelfB0173'

--销售出库分录.内饰
update ICTemplateEntry
set FFieldName='FInteriorName'
where FID=(select FTemplateID from ICTransactionType where FHeadTable='ICStockBill' and FName='销售出库')
 and FHeadCaption='内饰' and FFieldName = 'FEntrySelfB0174'
 
 update ICChatBillTitle
set FColName='FInteriorName'
where FColName='FEntrySelfB0174'
--销售出库分录.颜色
update ICTemplateEntry
set FFieldName='FColorName'
where FID=(select FTemplateID from ICTransactionType where FHeadTable='ICStockBill' and FName='销售出库')
 and FHeadCaption='颜色' and FFieldName = 'FEntrySelfB0175'
 
update ICChatBillTitle
set FColName='FColorName'
where FColName='FEntrySelfB0175'

--销售出库分录.选装
update ICTemplateEntry
set FFieldName='FOptional'
where FID=(select FTemplateID from ICTransactionType where FHeadTable='ICStockBill' and FName='销售出库')
 and FHeadCaption='选装' and FFieldName = 'FEntrySelfB0176'
 
 update ICChatBillTitle
set FColName='FOptional'
where FColName='FEntrySelfB0176'

--销售出库分录.排量

update ICTemplateEntry
set FFieldName='FDisplacementName'
where FID=(select FTemplateID from ICTransactionType where FHeadTable='ICStockBill' and FName='销售出库')
 and FHeadCaption='排量' and FFieldName = 'FEntrySelfB0177'
 
 update ICChatBillTitle
set FColName='FDisplacementName'
where FColName='FEntrySelfB0177'

--销售出库分录.型/版
update ICTemplateEntry
set FFieldName='FStereotypeName'
where FID=(select FTemplateID from ICTransactionType where FHeadTable='ICStockBill' and FName='销售出库')
 and FHeadCaption='型/版' and FFieldName = 'FEntrySelfB0178'
 
 update ICChatBillTitle
set FColName='FStereotypeName'
where FColName='FEntrySelfB0178'

--销售出库分录.配置说明
update ICTemplateEntry
set FFieldName='FCfgDesc'
where FID=(select FTemplateID from ICTransactionType where FHeadTable='ICStockBill' and FName='销售出库')
 and FHeadCaption='配置说明' and FFieldName = 'FEntrySelfB0179'
 
 update ICChatBillTitle
set FColName='FCfgDesc'
where FColName='FEntrySelfB0179'
--销售出库分录.发动机号
update ICTemplateEntry
set FFieldName='FEngineNum'
where FID=(select FTemplateID from ICTransactionType where FHeadTable='ICStockBill' and FName='销售出库')
 and FHeadCaption='发动机号' and FFieldName = 'FEntrySelfB0180'
 
 update ICChatBillTitle
set FColName='FEngineNum'
where FColName='FEntrySelfB0180'
--销售出库分录.变速箱
update ICTemplateEntry
set FFieldName='FGearboxName'
where FID=(select FTemplateID from ICTransactionType where FHeadTable='ICStockBill' and FName='销售出库')
 and FHeadCaption='变速箱' and FFieldName = 'FEntrySelfB0181'
 
 update ICChatBillTitle
set FColName='FGearboxName'
where FColName='FEntrySelfB0181'



--产品入库分录.车辆
update ICTableRelation 
set FFieldName='FVehicleID'
where FFieldName = 'FEntrySelfA0239'

update ICClassTableInfo
set ffieldname='FVehicleID'
where FFieldName='FEntrySelfA0239'

update ICTemplateEntry
set FFieldName='FVehicleID'
where FID=(select FTemplateID from ICTransactionType where FHeadTable='ICStockBill' and FName='产品入库')
 and FHeadCaption='车辆' and FFieldName = 'FEntrySelfA0239'
 
 update ICChatBillTitle
set FColName='FVehicleID'
where FColName='FEntrySelfA0239'

alter table ICStockBillEntry drop column FEntrySelfA0239;
alter table ICStockBillEntry_1 drop column FEntrySelfA0239;
alter table ICStockBillEntry_10 drop column FEntrySelfA0239;
alter table ICStockBillEntry_2 drop column FEntrySelfA0239;
alter table ICStockBillEntry_21 drop column FEntrySelfA0239;
alter table ICStockBillEntry_24 drop column FEntrySelfA0239;
alter table ICStockBillEntry_28 drop column FEntrySelfA0239;
alter table ICStockBillEntry_29 drop column FEntrySelfA0239;
alter table ICStockBillEntry_41 drop column FEntrySelfA0239;
alter table ICStockBillEntry_5 drop column FEntrySelfA0239;

--产品入库分录.车系

update ICTemplateEntry
set FFieldName='FSeriesName'
where FID=(select FTemplateID from ICTransactionType where FHeadTable='ICStockBill' and FName='产品入库')
 and FHeadCaption='车系' and FFieldName = 'FEntrySelfA0240'
 
update ICChatBillTitle
set FColName='FSeriesName'
where FColName='FEntrySelfA0240'


--产品入库分录.车型
update ICTemplateEntry
set FFieldName='FModelName'
where FID=(select FTemplateID from ICTransactionType where FHeadTable='ICStockBill' and FName='产品入库')
 and FHeadCaption='车型' and FFieldName = 'FEntrySelfA0241'

 update ICChatBillTitle
set FColName='FModelName'
where FColName='FEntrySelfA0241'


--产品入库分录.底盘号
update ICTemplateEntry
set FFieldName='FVin'
where FID=(select FTemplateID from ICTransactionType where FHeadTable='ICStockBill' and FName='产品入库')
 and FHeadCaption='底盘号' and FFieldName = 'FEntrySelfA0242'

 update ICChatBillTitle
set FColName='FVin'
where FColName='FEntrySelfA0242'

--产品入库分录.品牌
update ICTemplateEntry
set FFieldName='FBrandName'
where FID=(select FTemplateID from ICTransactionType where FHeadTable='ICStockBill' and FName='产品入库')
 and FHeadCaption='品牌' and FFieldName = 'FEntrySelfA0243'

 update ICChatBillTitle
set FColName='FBrandName'
where FColName='FEntrySelfA0243'

--产品入库分录.驱动形式
update ICTemplateEntry
set FFieldName='FDriverFormName'
where FID=(select FTemplateID from ICTransactionType where FHeadTable='ICStockBill' and FName='产品入库')
 and FHeadCaption='驱动形式' and FFieldName = 'FEntrySelfA0244'

 update ICChatBillTitle
set FColName='FDriverFormName'
where FColName='FEntrySelfA0244'

--产品入库分录.动力形式
update ICTemplateEntry
set FFieldName='FPowerFormName'
where FID=(select FTemplateID from ICTransactionType where FHeadTable='ICStockBill' and FName='产品入库')
 and FHeadCaption='动力形式' and FFieldName = 'FEntrySelfA0245'

 update ICChatBillTitle
set FColName='FPowerFormName'
where FColName='FEntrySelfA0245'

--产品入库分录.内饰
update ICTemplateEntry
set FFieldName='FInteriorName'
where FID=(select FTemplateID from ICTransactionType where FHeadTable='ICStockBill' and FName='产品入库')
 and FHeadCaption='内饰' and FFieldName = 'FEntrySelfA0246'

 update ICChatBillTitle
set FColName='FInteriorName'
where FColName='FEntrySelfA0246'
--产品入库分录.颜色
update ICTemplateEntry
set FFieldName='FColorName'
where FID=(select FTemplateID from ICTransactionType where FHeadTable='ICStockBill' and FName='产品入库')
 and FHeadCaption='颜色' and FFieldName = 'FEntrySelfA0247'

update ICChatBillTitle
set FColName='FColorName'
where FColName='FEntrySelfA0247'

--产品入库分录.选装
update ICTemplateEntry
set FFieldName='FOptional'
where FID=(select FTemplateID from ICTransactionType where FHeadTable='ICStockBill' and FName='产品入库')
 and FHeadCaption='选装' and FFieldName = 'FEntrySelfA0248'

 update ICChatBillTitle
set FColName='FOptional'
where FColName='FEntrySelfA0248'

--产品入库分录.排量

update ICTemplateEntry
set FFieldName='FDisplacementName'
where FID=(select FTemplateID from ICTransactionType where FHeadTable='ICStockBill' and FName='产品入库')
 and FHeadCaption='排量' and FFieldName = 'FEntrySelfA0249'

 update ICChatBillTitle
set FColName='FDisplacementName'
where FColName='FEntrySelfA0249'

--产品入库分录.型/版
update ICTemplateEntry
set FFieldName='FStereotypeName'
where FID=(select FTemplateID from ICTransactionType where FHeadTable='ICStockBill' and FName='产品入库')
 and FHeadCaption='型/版' and FFieldName = 'FEntrySelfA0250'

 update ICChatBillTitle
set FColName='FStereotypeName'
where FColName='FEntrySelfA0250'

--产品入库分录.配置说明
update ICTemplateEntry
set FFieldName='FCfgDesc'
where FID=(select FTemplateID from ICTransactionType where FHeadTable='ICStockBill' and FName='产品入库')
 and FHeadCaption='配置说明' and FFieldName = 'FEntrySelfA0251'

 update ICChatBillTitle
set FColName='FCfgDesc'
where FColName='FEntrySelfA0251'

--产品入库分录.发动机号
update ICTemplateEntry
set FFieldName='FEngineNum'
where FID=(select FTemplateID from ICTransactionType where FHeadTable='ICStockBill' and FName='产品入库')
 and FHeadCaption='发动机号' and FFieldName = 'FEntrySelfA0252'
 
 update ICChatBillTitle
set FColName='FEngineNum'
where FColName='FEntrySelfA0252'
--产品入库分录.变速箱
update ICTemplateEntry
set FFieldName='FGearboxName'
where FID=(select FTemplateID from ICTransactionType where FHeadTable='ICStockBill' and FName='产品入库')
 and FHeadCaption='变速箱' and FFieldName = 'FEntrySelfA0253'
 
update ICChatBillTitle
set FColName='FGearboxName'
where FColName='FEntrySelfA0253'


--调拨单分录.车辆
update ICTableRelation 
set FFieldName='FVehicleID'
where FFieldName = 'FEntrySelfD0154'

update ICClassTableInfo
set ffieldname='FVehicleID'
where FFieldName='FEntrySelfD0154'

update ICTemplateEntry
set FFieldName='FVehicleID'
where FID=(select FTemplateID from ICTransactionType where FHeadTable='ICStockBill' and FName='调拨单')
 and FHeadCaption='车辆' and FFieldName = 'FEntrySelfD0154'
 
 update ICChatBillTitle
set FColName='FVehicleID'
where FColName='FEntrySelfD0154'

alter table ICStockBillEntry drop column FEntrySelfD0154;
alter table ICStockBillEntry_1 drop column FEntrySelfD0154;
alter table ICStockBillEntry_10 drop column FEntrySelfD0154;
alter table ICStockBillEntry_2 drop column FEntrySelfD0154;
alter table ICStockBillEntry_21 drop column FEntrySelfD0154;
alter table ICStockBillEntry_24 drop column FEntrySelfD0154;
alter table ICStockBillEntry_28 drop column FEntrySelfD0154;
alter table ICStockBillEntry_29 drop column FEntrySelfD0154;
alter table ICStockBillEntry_41 drop column FEntrySelfD0154;
alter table ICStockBillEntry_5 drop column FEntrySelfD0154;


--调拨单分录.车系

update ICTemplateEntry
set FFieldName='FSeriesName'
where FID=(select FTemplateID from ICTransactionType where FHeadTable='ICStockBill' and FName='调拨单')
 and FHeadCaption='车系' and FFieldName = 'FEntrySelfD0155'
 
update ICChatBillTitle
set FColName='FSeriesName'
where FColName='FEntrySelfD0155'


--调拨单分录.车型
update ICTemplateEntry
set FFieldName='FModelName'
where FID=(select FTemplateID from ICTransactionType where FHeadTable='ICStockBill' and FName='调拨单')
 and FHeadCaption='车型' and FFieldName = 'FEntrySelfD0156'

 update ICChatBillTitle
set FColName='FModelName'
where FColName='FEntrySelfD0156'


--调拨单分录.底盘号
update ICTemplateEntry
set FFieldName='FVin'
where FID=(select FTemplateID from ICTransactionType where FHeadTable='ICStockBill' and FName='调拨单')
 and FHeadCaption='底盘号' and FFieldName = 'FEntrySelfD0157'

 update ICChatBillTitle
set FColName='FVin'
where FColName='FEntrySelfD0157'

--调拨单分录.品牌
update ICTemplateEntry
set FFieldName='FBrandName'
where FID=(select FTemplateID from ICTransactionType where FHeadTable='ICStockBill' and FName='调拨单')
 and FHeadCaption='品牌' and FFieldName = 'FEntrySelfD0158'

 update ICChatBillTitle
set FColName='FBrandName'
where FColName='FEntrySelfD0158'

--调拨单分录.驱动形式
update ICTemplateEntry
set FFieldName='FDriverFormName'
where FID=(select FTemplateID from ICTransactionType where FHeadTable='ICStockBill' and FName='调拨单')
 and FHeadCaption='驱动形式' and FFieldName = 'FEntrySelfD0159'

 update ICChatBillTitle
set FColName='FDriverFormName'
where FColName='FEntrySelfD0159'

--调拨单分录.动力形式
update ICTemplateEntry
set FFieldName='FPowerFormName'
where FID=(select FTemplateID from ICTransactionType where FHeadTable='ICStockBill' and FName='调拨单')
 and FHeadCaption='动力形式' and FFieldName = 'FEntrySelfD0160'

 update ICChatBillTitle
set FColName='FPowerFormName'
where FColName='FEntrySelfD0160'

--调拨单分录.内饰
update ICTemplateEntry
set FFieldName='FInteriorName'
where FID=(select FTemplateID from ICTransactionType where FHeadTable='ICStockBill' and FName='调拨单')
 and FHeadCaption='内饰' and FFieldName = 'FEntrySelfD0161'

 update ICChatBillTitle
set FColName='FInteriorName'
where FColName='FEntrySelfD0161'
--调拨单分录.颜色
update ICTemplateEntry
set FFieldName='FColorName'
where FID=(select FTemplateID from ICTransactionType where FHeadTable='ICStockBill' and FName='调拨单')
 and FHeadCaption='颜色' and FFieldName = 'FEntrySelfD0162'

update ICChatBillTitle
set FColName='FColorName'
where FColName='FEntrySelfD0162'

--调拨单分录.选装
update ICTemplateEntry
set FFieldName='FOptional'
where FID=(select FTemplateID from ICTransactionType where FHeadTable='ICStockBill' and FName='调拨单')
 and FHeadCaption='选装' and FFieldName = 'FEntrySelfD0163'

 update ICChatBillTitle
set FColName='FOptional'
where FColName='FEntrySelfD0163'

--调拨单分录.排量

update ICTemplateEntry
set FFieldName='FDisplacementName'
where FID=(select FTemplateID from ICTransactionType where FHeadTable='ICStockBill' and FName='调拨单')
 and FHeadCaption='排量' and FFieldName = 'FEntrySelfD0164'

 update ICChatBillTitle
set FColName='FDisplacementName'
where FColName='FEntrySelfD0164'

--调拨单分录.型/版
update ICTemplateEntry
set FFieldName='FStereotypeName'
where FID=(select FTemplateID from ICTransactionType where FHeadTable='ICStockBill' and FName='调拨单')
 and FHeadCaption='型/版' and FFieldName = 'FEntrySelfD0165'

 update ICChatBillTitle
set FColName='FStereotypeName'
where FColName='FEntrySelfD0165'

--调拨单分录.配置说明
update ICTemplateEntry
set FFieldName='FCfgDesc'
where FID=(select FTemplateID from ICTransactionType where FHeadTable='ICStockBill' and FName='调拨单')
 and FHeadCaption='配置说明' and FFieldName = 'FEntrySelfD0166'

 update ICChatBillTitle
set FColName='FCfgDesc'
where FColName='FEntrySelfD0166'

--调拨单分录.发动机号
update ICTemplateEntry
set FFieldName='FEngineNum'
where FID=(select FTemplateID from ICTransactionType where FHeadTable='ICStockBill' and FName='调拨单')
 and FHeadCaption='发动机号' and FFieldName = 'FEntrySelfD0167'
 
 update ICChatBillTitle
set FColName='FEngineNum'
where FColName='FEntrySelfD0167'
--调拨单分录.变速箱
update ICTemplateEntry
set FFieldName='FGearboxName'
where FID=(select FTemplateID from ICTransactionType where FHeadTable='ICStockBill' and FName='调拨单')
 and FHeadCaption='变速箱' and FFieldName = 'FEntrySelfD0168'
 
 update ICChatBillTitle
set FColName='FGearboxName'
where FColName='FEntrySelfD0168'

--外购入库分录.车辆
update ICTableRelation 
set FFieldName='FVehicleID'
where FFieldName = 'FEntrySelfA0158'

update ICClassTableInfo
set ffieldname='FVehicleID'
where FFieldName='FEntrySelfA0158'

update ICTemplateEntry
set FFieldName='FVehicleID'
where FID=(select FTemplateID from ICTransactionType where FHeadTable='ICStockBill' and FName='外购入库')
 and FHeadCaption='车辆' and FFieldName = 'FEntrySelfA0158'
 
 update ICChatBillTitle
set FColName='FVehicleID'
where FColName='FEntrySelfA0158'

alter table ICStockBillEntry drop column FEntrySelfA0158;
alter table ICStockBillEntry_1 drop column FEntrySelfA0158;
alter table ICStockBillEntry_10 drop column FEntrySelfA0158;
alter table ICStockBillEntry_2 drop column FEntrySelfA0158;
alter table ICStockBillEntry_21 drop column FEntrySelfA0158;
alter table ICStockBillEntry_24 drop column FEntrySelfA0158;
alter table ICStockBillEntry_28 drop column FEntrySelfA0158;
alter table ICStockBillEntry_29 drop column FEntrySelfA0158;
alter table ICStockBillEntry_41 drop column FEntrySelfA0158;
alter table ICStockBillEntry_5 drop column FEntrySelfA0158;

--外购入库分录.车系

update ICTemplateEntry
set FFieldName='FSeriesName'
where FID=(select FTemplateID from ICTransactionType where FHeadTable='ICStockBill' and FName='外购入库')
 and FHeadCaption='车系' and FFieldName = 'FEntrySelfA0159'
 
update ICChatBillTitle
set FColName='FSeriesName'
where FColName='FEntrySelfA0159'


--外购入库分录.车型
update ICTemplateEntry
set FFieldName='FModelName'
where FID=(select FTemplateID from ICTransactionType where FHeadTable='ICStockBill' and FName='外购入库')
 and FHeadCaption='车型' and FFieldName = 'FEntrySelfA0160'

 update ICChatBillTitle
set FColName='FModelName'
where FColName='FEntrySelfA0160'


--外购入库分录.底盘号
update ICTemplateEntry
set FFieldName='FVin'
where FID=(select FTemplateID from ICTransactionType where FHeadTable='ICStockBill' and FName='外购入库')
 and FHeadCaption='底盘号' and FFieldName = 'FEntrySelfA0161'

 update ICChatBillTitle
set FColName='FVin'
where FColName='FEntrySelfA0161'

--外购入库分录.品牌
update ICTemplateEntry
set FFieldName='FBrandName'
where FID=(select FTemplateID from ICTransactionType where FHeadTable='ICStockBill' and FName='外购入库')
 and FHeadCaption='品牌' and FFieldName = 'FEntrySelfA0162'

 update ICChatBillTitle
set FColName='FBrandName'
where FColName='FEntrySelfA0162'

--外购入库分录.驱动形式
update ICTemplateEntry
set FFieldName='FDriverFormName'
where FID=(select FTemplateID from ICTransactionType where FHeadTable='ICStockBill' and FName='外购入库')
 and FHeadCaption='驱动形式' and FFieldName = 'FEntrySelfA0163'

 update ICChatBillTitle
set FColName='FDriverFormName'
where FColName='FEntrySelfA0163'

--外购入库分录.动力形式
update ICTemplateEntry
set FFieldName='FPowerFormName'
where FID=(select FTemplateID from ICTransactionType where FHeadTable='ICStockBill' and FName='外购入库')
 and FHeadCaption='动力形式' and FFieldName = 'FEntrySelfA0164'

 update ICChatBillTitle
set FColName='FPowerFormName'
where FColName='FEntrySelfA0164'

--外购入库分录.内饰
update ICTemplateEntry
set FFieldName='FInteriorName'
where FID=(select FTemplateID from ICTransactionType where FHeadTable='ICStockBill' and FName='外购入库')
 and FHeadCaption='内饰' and FFieldName = 'FEntrySelfA0165'

 update ICChatBillTitle
set FColName='FInteriorName'
where FColName='FEntrySelfA0165'
--外购入库分录.颜色
update ICTemplateEntry
set FFieldName='FColorName'
where FID=(select FTemplateID from ICTransactionType where FHeadTable='ICStockBill' and FName='外购入库')
 and FHeadCaption='颜色' and FFieldName = 'FEntrySelfA0166'

update ICChatBillTitle
set FColName='FColorName'
where FColName='FEntrySelfA0166'

--外购入库分录.选装
update ICTemplateEntry
set FFieldName='FOptional'
where FID=(select FTemplateID from ICTransactionType where FHeadTable='ICStockBill' and FName='外购入库')
 and FHeadCaption='选装' and FFieldName = 'FEntrySelfA0167'

 update ICChatBillTitle
set FColName='FOptional'
where FColName='FEntrySelfA0167'

--外购入库分录.排量

update ICTemplateEntry
set FFieldName='FDisplacementName'
where FID=(select FTemplateID from ICTransactionType where FHeadTable='ICStockBill' and FName='外购入库')
 and FHeadCaption='排量' and FFieldName = 'FEntrySelfA0168'

 update ICChatBillTitle
set FColName='FDisplacementName'
where FColName='FEntrySelfA0168'

--外购入库分录.型/版
update ICTemplateEntry
set FFieldName='FStereotypeName'
where FID=(select FTemplateID from ICTransactionType where FHeadTable='ICStockBill' and FName='外购入库')
 and FHeadCaption='型/版' and FFieldName = 'FEntrySelfA0169'

 update ICChatBillTitle
set FColName='FStereotypeName'
where FColName='FEntrySelfA0169'

--外购入库分录.配置说明
update ICTemplateEntry
set FFieldName='FCfgDesc'
where FID=(select FTemplateID from ICTransactionType where FHeadTable='ICStockBill' and FName='外购入库')
 and FHeadCaption='配置说明' and FFieldName = 'FEntrySelfA0170'

 update ICChatBillTitle
set FColName='FCfgDesc'
where FColName='FEntrySelfA0170'

--外购入库分录.发动机号
update ICTemplateEntry
set FFieldName='FEngineNum'
where FID=(select FTemplateID from ICTransactionType where FHeadTable='ICStockBill' and FName='外购入库')
 and FHeadCaption='发动机号' and FFieldName = 'FEntrySelfA0171'
 
 update ICChatBillTitle
set FColName='FEngineNum'
where FColName='FEntrySelfA0171'
--外购入库分录.变速箱
update ICTemplateEntry
set FFieldName='FGearboxName'
where FID=(select FTemplateID from ICTransactionType where FHeadTable='ICStockBill' and FName='外购入库')
 and FHeadCaption='变速箱' and FFieldName = 'FEntrySelfA0172'
 
 update ICChatBillTitle
set FColName='FGearboxName'
where FColName='FEntrySelfA0172'

--其他入库分录.车辆
update ICTableRelation 
set FFieldName='FVehicleID'
where FFieldName = 'FEntrySelfA9744'

update ICClassTableInfo
set ffieldname='FVehicleID'
where FFieldName='FEntrySelfA9744'

update ICTemplateEntry
set FFieldName='FVehicleID'
where FID=(select FTemplateID from ICTransactionType where FHeadTable='ICStockBill' and FName='其他入库')
 and FHeadCaption='车辆' and FFieldName = 'FEntrySelfA9744'
 
 update ICChatBillTitle
set FColName='FVehicleID'
where FColName='FEntrySelfA9744'

alter table ICStockBillEntry drop column FEntrySelfA9744;
alter table ICStockBillEntry_1 drop column FEntrySelfA9744;
alter table ICStockBillEntry_10 drop column FEntrySelfA9744;
alter table ICStockBillEntry_2 drop column FEntrySelfA9744;
alter table ICStockBillEntry_21 drop column FEntrySelfA9744;
alter table ICStockBillEntry_24 drop column FEntrySelfA9744;
alter table ICStockBillEntry_28 drop column FEntrySelfA9744;
alter table ICStockBillEntry_29 drop column FEntrySelfA9744;
alter table ICStockBillEntry_41 drop column FEntrySelfA9744;
alter table ICStockBillEntry_5 drop column FEntrySelfA9744;


--其他入库分录.车系

update ICTemplateEntry
set FFieldName='FSeriesName'
where FID=(select FTemplateID from ICTransactionType where FHeadTable='ICStockBill' and FName='其他入库')
 and FHeadCaption='车系' and FFieldName = 'FEntrySelfA9745'
 
update ICChatBillTitle
set FColName='FSeriesName'
where FColName='FEntrySelfA9745'


--其他入库分录.车型
update ICTemplateEntry
set FFieldName='FModelName'
where FID=(select FTemplateID from ICTransactionType where FHeadTable='ICStockBill' and FName='其他入库')
 and FHeadCaption='车型' and FFieldName = 'FEntrySelfA9746'

 update ICChatBillTitle
set FColName='FModelName'
where FColName='FEntrySelfA9746'


--其他入库分录.底盘号
update ICTemplateEntry
set FFieldName='FVin'
where FID=(select FTemplateID from ICTransactionType where FHeadTable='ICStockBill' and FName='其他入库')
 and FHeadCaption='底盘号' and FFieldName = 'FEntrySelfA9747'

 update ICChatBillTitle
set FColName='FVin'
where FColName='FEntrySelfA9747'

--其他入库分录.品牌
update ICTemplateEntry
set FFieldName='FBrandName'
where FID=(select FTemplateID from ICTransactionType where FHeadTable='ICStockBill' and FName='其他入库')
 and FHeadCaption='品牌' and FFieldName = 'FEntrySelfA9748'

 update ICChatBillTitle
set FColName='FBrandName'
where FColName='FEntrySelfA9748'

--其他入库分录.驱动形式
update ICTemplateEntry
set FFieldName='FDriverFormName'
where FID=(select FTemplateID from ICTransactionType where FHeadTable='ICStockBill' and FName='其他入库')
 and FHeadCaption='驱动形式' and FFieldName = 'FEntrySelfA9749'

 update ICChatBillTitle
set FColName='FDriverFormName'
where FColName='FEntrySelfA9749'

--其他入库分录.动力形式
update ICTemplateEntry
set FFieldName='FPowerFormName'
where FID=(select FTemplateID from ICTransactionType where FHeadTable='ICStockBill' and FName='其他入库')
 and FHeadCaption='动力形式' and FFieldName = 'FEntrySelfA9750'

 update ICChatBillTitle
set FColName='FPowerFormName'
where FColName='FEntrySelfA9750'

--其他入库分录.内饰
update ICTemplateEntry
set FFieldName='FInteriorName'
where FID=(select FTemplateID from ICTransactionType where FHeadTable='ICStockBill' and FName='其他入库')
 and FHeadCaption='内饰' and FFieldName = 'FEntrySelfA9751'

 update ICChatBillTitle
set FColName='FInteriorName'
where FColName='FEntrySelfA9751'
--其他入库分录.颜色
update ICTemplateEntry
set FFieldName='FColorName'
where FID=(select FTemplateID from ICTransactionType where FHeadTable='ICStockBill' and FName='其他入库')
 and FHeadCaption='颜色' and FFieldName = 'FEntrySelfA9752'

update ICChatBillTitle
set FColName='FColorName'
where FColName='FEntrySelfA9752'

--其他入库分录.选装
update ICTemplateEntry
set FFieldName='FOptional'
where FID=(select FTemplateID from ICTransactionType where FHeadTable='ICStockBill' and FName='其他入库')
 and FHeadCaption='选装' and FFieldName = 'FEntrySelfA9753'

 update ICChatBillTitle
set FColName='FOptional'
where FColName='FEntrySelfA9753'

--其他入库分录.排量

update ICTemplateEntry
set FFieldName='FDisplacementName'
where FID=(select FTemplateID from ICTransactionType where FHeadTable='ICStockBill' and FName='其他入库')
 and FHeadCaption='排量' and FFieldName = 'FEntrySelfA9754'

 update ICChatBillTitle
set FColName='FDisplacementName'
where FColName='FEntrySelfA9754'

--其他入库分录.型/版
update ICTemplateEntry
set FFieldName='FStereotypeName'
where FID=(select FTemplateID from ICTransactionType where FHeadTable='ICStockBill' and FName='其他入库')
 and FHeadCaption='型/版' and FFieldName = 'FEntrySelfA9755'

 update ICChatBillTitle
set FColName='FStereotypeName'
where FColName='FEntrySelfA9755'

--其他入库分录.配置说明
update ICTemplateEntry
set FFieldName='FCfgDesc'
where FID=(select FTemplateID from ICTransactionType where FHeadTable='ICStockBill' and FName='其他入库')
 and FHeadCaption='配置说明' and FFieldName = 'FEntrySelfA9756'

 update ICChatBillTitle
set FColName='FCfgDesc'
where FColName='FEntrySelfA9756'

--其他入库分录.发动机号
update ICTemplateEntry
set FFieldName='FEngineNum'
where FID=(select FTemplateID from ICTransactionType where FHeadTable='ICStockBill' and FName='其他入库')
 and FHeadCaption='发动机号' and FFieldName = 'FEntrySelfA9757'
 
 update ICChatBillTitle
set FColName='FEngineNum'
where FColName='FEntrySelfA9757'
--其他入库分录.变速箱
update ICTemplateEntry
set FFieldName='FGearboxName'
where FID=(select FTemplateID from ICTransactionType where FHeadTable='ICStockBill' and FName='其他入库')
 and FHeadCaption='变速箱' and FFieldName = 'FEntrySelfA9758'
 
 update ICChatBillTitle
set FColName='FGearboxName'
where FColName='FEntrySelfA9758'


--其他出库单分录.车辆
update ICTableRelation 
set FFieldName='FVehicleID'
where FFieldName = 'FEntrySelfB0944'

update ICClassTableInfo
set ffieldname='FVehicleID'
where FFieldName='FEntrySelfB0944'

update ICTemplateEntry
set FFieldName='FVehicleID'
where FID=(select FTemplateID from ICTransactionType where FHeadTable='ICStockBill' and FName='其他出库单')
 and FHeadCaption='车辆' and FFieldName = 'FEntrySelfB0944'
 
 update ICChatBillTitle
set FColName='FVehicleID'
where FColName='FEntrySelfB0944'

alter table ICStockBillEntry drop column FEntrySelfB0944;
alter table ICStockBillEntry_1 drop column FEntrySelfB0944;
alter table ICStockBillEntry_10 drop column FEntrySelfB0944;
alter table ICStockBillEntry_2 drop column FEntrySelfB0944;
alter table ICStockBillEntry_21 drop column FEntrySelfB0944;
alter table ICStockBillEntry_24 drop column FEntrySelfB0944;
alter table ICStockBillEntry_28 drop column FEntrySelfB0944;
alter table ICStockBillEntry_29 drop column FEntrySelfB0944;
alter table ICStockBillEntry_41 drop column FEntrySelfB0944;
alter table ICStockBillEntry_5 drop column FEntrySelfB0944;


--其他出库单分录.车系

update ICTemplateEntry
set FFieldName='FSeriesName'
where FID=(select FTemplateID from ICTransactionType where FHeadTable='ICStockBill' and FName='其他出库单')
 and FHeadCaption='车系' and FFieldName = 'FEntrySelfB0945'
 
update ICChatBillTitle
set FColName='FSeriesName'
where FColName='FEntrySelfB0945'


--其他出库单分录.车型
update ICTemplateEntry
set FFieldName='FModelName'
where FID=(select FTemplateID from ICTransactionType where FHeadTable='ICStockBill' and FName='其他出库单')
 and FHeadCaption='车型' and FFieldName = 'FEntrySelfB0946'

 update ICChatBillTitle
set FColName='FModelName'
where FColName='FEntrySelfB0946'


--其他出库单分录.底盘号
update ICTemplateEntry
set FFieldName='FVin'
where FID=(select FTemplateID from ICTransactionType where FHeadTable='ICStockBill' and FName='其他出库单')
 and FHeadCaption='底盘号' and FFieldName = 'FEntrySelfB0947'

 update ICChatBillTitle
set FColName='FVin'
where FColName='FEntrySelfB0947'

--其他出库单分录.品牌
update ICTemplateEntry
set FFieldName='FBrandName'
where FID=(select FTemplateID from ICTransactionType where FHeadTable='ICStockBill' and FName='其他出库单')
 and FHeadCaption='品牌' and FFieldName = 'FEntrySelfB0948'

 update ICChatBillTitle
set FColName='FBrandName'
where FColName='FEntrySelfB0948'

--其他出库单分录.驱动形式
update ICTemplateEntry
set FFieldName='FDriverFormName'
where FID=(select FTemplateID from ICTransactionType where FHeadTable='ICStockBill' and FName='其他出库单')
 and FHeadCaption='驱动形式' and FFieldName = 'FEntrySelfB0949'

 update ICChatBillTitle
set FColName='FDriverFormName'
where FColName='FEntrySelfB0949'

--其他出库单分录.动力形式
update ICTemplateEntry
set FFieldName='FPowerFormName'
where FID=(select FTemplateID from ICTransactionType where FHeadTable='ICStockBill' and FName='其他出库单')
 and FHeadCaption='动力形式' and FFieldName = 'FEntrySelfB0950'

 update ICChatBillTitle
set FColName='FPowerFormName'
where FColName='FEntrySelfB0950'

--其他出库单分录.内饰
update ICTemplateEntry
set FFieldName='FInteriorName'
where FID=(select FTemplateID from ICTransactionType where FHeadTable='ICStockBill' and FName='其他出库单')
 and FHeadCaption='内饰' and FFieldName = 'FEntrySelfB0951'

 update ICChatBillTitle
set FColName='FInteriorName'
where FColName='FEntrySelfB0951'
--其他出库单分录.颜色
update ICTemplateEntry
set FFieldName='FColorName'
where FID=(select FTemplateID from ICTransactionType where FHeadTable='ICStockBill' and FName='其他出库单')
 and FHeadCaption='颜色' and FFieldName = 'FEntrySelfB0952'

update ICChatBillTitle
set FColName='FColorName'
where FColName='FEntrySelfB0952'

--其他出库单分录.选装
update ICTemplateEntry
set FFieldName='FOptional'
where FID=(select FTemplateID from ICTransactionType where FHeadTable='ICStockBill' and FName='其他出库单')
 and FHeadCaption='选装' and FFieldName = 'FEntrySelfB0953'

 update ICChatBillTitle
set FColName='FOptional'
where FColName='FEntrySelfB0953'

--其他出库单分录.排量

update ICTemplateEntry
set FFieldName='FDisplacementName'
where FID=(select FTemplateID from ICTransactionType where FHeadTable='ICStockBill' and FName='其他出库单')
 and FHeadCaption='排量' and FFieldName = 'FEntrySelfB0954'

 update ICChatBillTitle
set FColName='FDisplacementName'
where FColName='FEntrySelfB0954'

--其他出库单分录.型/版
update ICTemplateEntry
set FFieldName='FStereotypeName'
where FID=(select FTemplateID from ICTransactionType where FHeadTable='ICStockBill' and FName='其他出库单')
 and FHeadCaption='型/版' and FFieldName = 'FEntrySelfB0955'

 update ICChatBillTitle
set FColName='FStereotypeName'
where FColName='FEntrySelfB0955'

--其他出库单分录.配置说明
update ICTemplateEntry
set FFieldName='FCfgDesc'
where FID=(select FTemplateID from ICTransactionType where FHeadTable='ICStockBill' and FName='其他出库单')
 and FHeadCaption='配置说明' and FFieldName = 'FEntrySelfB0956'

 update ICChatBillTitle
set FColName='FCfgDesc'
where FColName='FEntrySelfB0956'

--其他出库单分录.发动机号
update ICTemplateEntry
set FFieldName='FEngineNum'
where FID=(select FTemplateID from ICTransactionType where FHeadTable='ICStockBill' and FName='其他出库单')
 and FHeadCaption='发动机号' and FFieldName = 'FEntrySelfB0957'
 
 update ICChatBillTitle
set FColName='FEngineNum'
where FColName='FEntrySelfB0957'
--其他出库单分录.变速箱
update ICTemplateEntry
set FFieldName='FGearboxName'
where FID=(select FTemplateID from ICTransactionType where FHeadTable='ICStockBill' and FName='其他出库单')
 and FHeadCaption='变速箱' and FFieldName = 'FEntrySelfB0958'
 
 update ICChatBillTitle
set FColName='FGearboxName'
where FColName='FEntrySelfB0958'
update t_DataFlowTimeStamp 
set FName=FName