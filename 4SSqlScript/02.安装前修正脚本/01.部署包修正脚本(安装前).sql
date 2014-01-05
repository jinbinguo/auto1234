begin try
begin tran
--现金付款单
delete ICClassPackObject where FSrcClassTypeId=1006002
insert into ICClassPackObject(FPackID,FSrcClassTypeID,FGUID,FDstClassTypeID,FType) values (0,1006002,'8D7B903E-17DC-AE41-AE71-7125150C6573',0,4)

--现金收款单
delete ICClassPackObject where FSrcClassTypeId=1006004
insert into ICClassPackObject(FPackID,FSrcClassTypeID,FGUID,FDstClassTypeID,FType) values (0,1006004,'9E132323-C5B8-5044-8DF1-31ABFFF592E2',0,4)

--排量
delete ICClassPackObject where FSrcClassTypeId=200000009
insert into ICClassPackObject(FPackID,FSrcClassTypeID,FGUID,FDstClassTypeID,FType) values (0,200000009,'1A290465-7778-3942-8693-9BE219B329CF',0,1)

--品牌
delete ICClassPackObject where FSrcClassTypeId=200000011
insert into ICClassPackObject(FPackID,FSrcClassTypeID,FGUID,FDstClassTypeID,FType) values (0,200000011,'6FAC0267-DCC6-D845-9E8D-6E5B1E969947',0,1)

--变速箱
delete ICClassPackObject where FSrcClassTypeId=200000012
insert into ICClassPackObject(FPackID,FSrcClassTypeID,FGUID,FDstClassTypeID,FType) values (0,200000012,'172BBEA4-50AB-2E43-A1AB-40AA049FBE83',0,1)

--驱动形式
delete ICClassPackObject where FSrcClassTypeId=200000014
insert into ICClassPackObject(FPackID,FSrcClassTypeID,FGUID,FDstClassTypeID,FType) values (0,200000014,'A7D1077E-BBA8-5B4A-95A7-83F53D3B1FD2',0,1)

--动力形式
delete ICClassPackObject where FSrcClassTypeId=200000015
insert into ICClassPackObject(FPackID,FSrcClassTypeID,FGUID,FDstClassTypeID,FType) values (0,200000015,'1A432536-A841-7A4C-B537-748C9E5BCF10',0,1)

--车辆分类
delete ICClassPackObject where FSrcClassTypeId=200000016
insert into ICClassPackObject(FPackID,FSrcClassTypeID,FGUID,FDstClassTypeID,FType) values (0,200000016,'2F71F474-9D5E-784A-A364-CFF9DDA099BC',0,1)

--车系
delete ICClassPackObject where FSrcClassTypeId=200000019
insert into ICClassPackObject(FPackID,FSrcClassTypeID,FGUID,FDstClassTypeID,FType) values (0,200000019,'0C333A1C-C386-1949-B0CD-306E54A41086',0,4)

--车型来源
delete ICClassPackObject where FSrcClassTypeId=200000020
insert into ICClassPackObject(FPackID,FSrcClassTypeID,FGUID,FDstClassTypeID,FType) values (0,200000020,'8C02D20D-1C32-2841-9B55-9D487036B1ED',0,1)

--车型
delete ICClassPackObject where FSrcClassTypeId=200000021
insert into ICClassPackObject(FPackID,FSrcClassTypeID,FGUID,FDstClassTypeID,FType) values (0,200000021,'88F4C2AA-F4BF-934A-B29A-4854416D92A5',0,4)

--车辆档案
delete ICClassPackObject where FSrcClassTypeId=200000022
insert into ICClassPackObject(FPackID,FSrcClassTypeID,FGUID,FDstClassTypeID,FType) values (0,200000022,'0FFFD08E-0E45-3C44-B214-CC9FBCA8F2AA',0,4)

--整车采购订单
delete ICClassPackObject where FSrcClassTypeId=200000023
insert into ICClassPackObject(FPackID,FSrcClassTypeID,FGUID,FDstClassTypeID,FType) values (0,200000023,'1D8FAA71-B724-104D-AB40-E3BB604273E3',0,4)

--颜色.
delete ICClassPackObject where FSrcClassTypeId=200000024
insert into ICClassPackObject(FPackID,FSrcClassTypeID,FGUID,FDstClassTypeID,FType) values (0,200000024,'746BA6F4-B230-5643-A700-EAD97A8E1C90',0,1)

--内饰.
delete ICClassPackObject where FSrcClassTypeId=200000025
insert into ICClassPackObject(FPackID,FSrcClassTypeID,FGUID,FDstClassTypeID,FType) values (0,200000025,'7992AD5E-520B-8146-8E0C-78CC4870A31F',0,1)

--车型.
delete ICClassPackObject where FSrcClassTypeId=200000026
insert into ICClassPackObject(FPackID,FSrcClassTypeID,FGUID,FDstClassTypeID,FType) values (0,200000026,'0E6FD8AB-0051-044F-BB40-E819A63F911D',0,1)

--车系.
delete ICClassPackObject where FSrcClassTypeId=200000027
insert into ICClassPackObject(FPackID,FSrcClassTypeID,FGUID,FDstClassTypeID,FType) values (0,200000027,'F9C1D495-51F0-504E-929B-02A69A9BA05A',0,1)

--整车销售订单
delete ICClassPackObject where FSrcClassTypeId=200000028
insert into ICClassPackObject(FPackID,FSrcClassTypeID,FGUID,FDstClassTypeID,FType) values (0,200000028,'CA40939F-663E-9C45-9327-25C37FB3B068',0,4)

--交车单
delete ICClassPackObject where FSrcClassTypeId=200000029
insert into ICClassPackObject(FPackID,FSrcClassTypeID,FGUID,FDstClassTypeID,FType) values (0,200000029,'E2B4AEBA-031C-6546-898D-751BB51ABD4A',0,4)

--车辆.
delete ICClassPackObject where FSrcClassTypeId=200000030
insert into ICClassPackObject(FPackID,FSrcClassTypeID,FGUID,FDstClassTypeID,FType) values (0,200000030,'8E71701A-AB8A-6A47-9CF4-134C6087D2D8',0,1)

--型/版.
delete ICClassPackObject where FSrcClassTypeId=200000031
insert into ICClassPackObject(FPackID,FSrcClassTypeID,FGUID,FDstClassTypeID,FType) values (0,200000031,'708A9ECA-AAAD-1F4A-B21A-C26C12924EEF',0,1)

--物料分类.
delete ICClassPackObject where FSrcClassTypeId=200000032
insert into ICClassPackObject(FPackID,FSrcClassTypeID,FGUID,FDstClassTypeID,FType) values (0,200000032,'71CB68C9-85B3-E547-807B-9105049F4C51',0,1)

--车型物料配置
delete ICClassPackObject where FSrcClassTypeId=200000033
insert into ICClassPackObject(FPackID,FSrcClassTypeID,FGUID,FDstClassTypeID,FType) values (0,200000033,'AAB78B1E-B3C5-3944-AF67-CC2B5997DC65',0,1)

--计量单位.
delete ICClassPackObject where FSrcClassTypeId=200000034
insert into ICClassPackObject(FPackID,FSrcClassTypeID,FGUID,FDstClassTypeID,FType) values (0,200000034,'5372FFD5-FDC1-2B41-8FE4-4273A41B44F7',0,1)

--购车用途
delete ICClassPackObject where FSrcClassTypeId=200000035
insert into ICClassPackObject(FPackID,FSrcClassTypeID,FGUID,FDstClassTypeID,FType) values (0,200000035,'CD7B31D3-42AC-064F-9C98-FD46E4F8AF9B',0,1)

--配车单
delete ICClassPackObject where FSrcClassTypeId=200000036
insert into ICClassPackObject(FPackID,FSrcClassTypeID,FGUID,FDstClassTypeID,FType) values (0,200000036,'B7D959C0-6F85-124D-90AA-09E53DF3CDC0',0,4)

--结算检查
delete ICClassPackObject where FSrcClassTypeId=200000037
insert into ICClassPackObject(FPackID,FSrcClassTypeID,FGUID,FDstClassTypeID,FType) values (0,200000037,'865F2185-EAFB-F944-B0E4-87FBB7D6FECD',0,4)

--整车验收单
delete ICClassPackObject where FSrcClassTypeId=200000038
insert into ICClassPackObject(FPackID,FSrcClassTypeID,FGUID,FDstClassTypeID,FType) values (0,200000038,'7C52DAA5-7EC1-0F41-A72D-DAA7DD71D47C',0,4)

--代办项目类型
delete ICClassPackObject where FSrcClassTypeId=200000039
insert into ICClassPackObject(FPackID,FSrcClassTypeID,FGUID,FDstClassTypeID,FType) values (0,200000039,'9A474A5D-4C44-A247-A47E-08BAD44C7B70',0,1)

--代办项目
delete ICClassPackObject where FSrcClassTypeId=200000040
insert into ICClassPackObject(FPackID,FSrcClassTypeID,FGUID,FDstClassTypeID,FType) values (0,200000040,'B85558FB-9855-034A-BBD0-133E324357A2',0,1)

--险种
delete ICClassPackObject where FSrcClassTypeId=200000041
insert into ICClassPackObject(FPackID,FSrcClassTypeID,FGUID,FDstClassTypeID,FType) values (0,200000041,'6BE6C693-06C1-834F-AA0A-C5333F4141AC',0,1)

--保险返还率
delete ICClassPackObject where FSrcClassTypeId=200000042
insert into ICClassPackObject(FPackID,FSrcClassTypeID,FGUID,FDstClassTypeID,FType) values (0,200000042,'B2CA167C-C5D1-5440-AF5B-62DFBF11FD41',0,1)

--保险来源
delete ICClassPackObject where FSrcClassTypeId=200000043
insert into ICClassPackObject(FPackID,FSrcClassTypeID,FGUID,FDstClassTypeID,FType) values (0,200000043,'1B991D12-F24E-A845-BABC-25A5F989C9F0',0,1)

--按揭返还率
delete ICClassPackObject where FSrcClassTypeId=200000044
insert into ICClassPackObject(FPackID,FSrcClassTypeID,FGUID,FDstClassTypeID,FType) values (0,200000044,'49652A2A-E48F-3141-A4AD-0F13B3579F86',0,1)

--代办服务
delete ICClassPackObject where FSrcClassTypeId=200000045
insert into ICClassPackObject(FPackID,FSrcClassTypeID,FGUID,FDstClassTypeID,FType) values (0,200000045,'9D8E6A64-724A-5F4C-9ABD-866BDE7F1FC6',0,4)

--上牌登记
delete ICClassPackObject where FSrcClassTypeId=200000046
insert into ICClassPackObject(FPackID,FSrcClassTypeID,FGUID,FDstClassTypeID,FType) values (0,200000046,'28763415-3EB8-7C4B-9A00-3A87FFB3C354',0,4)

--保险登记单
delete ICClassPackObject where FSrcClassTypeId=200000047
insert into ICClassPackObject(FPackID,FSrcClassTypeID,FGUID,FDstClassTypeID,FType) values (0,200000047,'DB0B77C9-D900-664B-9E82-1C7783AB46AA',0,4)

--按揭登记
delete ICClassPackObject where FSrcClassTypeId=200000048
insert into ICClassPackObject(FPackID,FSrcClassTypeID,FGUID,FDstClassTypeID,FType) values (0,200000048,'CACC0867-A91C-F943-907F-875E92CFD9D3',0,4)

--维修类型
delete ICClassPackObject where FSrcClassTypeId=200000049
insert into ICClassPackObject(FPackID,FSrcClassTypeID,FGUID,FDstClassTypeID,FType) values (0,200000049,'915BDE3D-AC27-6E4D-B56E-B582DD57D5D0',0,1)

--维修种类
delete ICClassPackObject where FSrcClassTypeId=200000050
insert into ICClassPackObject(FPackID,FSrcClassTypeID,FGUID,FDstClassTypeID,FType) values (0,200000050,'5B8B3D80-924F-704E-8B77-5D8C70345AB9',0,1)

--保修类型
delete ICClassPackObject where FSrcClassTypeId=200000051
insert into ICClassPackObject(FPackID,FSrcClassTypeID,FGUID,FDstClassTypeID,FType) values (0,200000051,'E67FE737-6442-3948-AD11-EA962C31D514',0,1)

--维修项目
delete ICClassPackObject where FSrcClassTypeId=200000052
insert into ICClassPackObject(FPackID,FSrcClassTypeID,FGUID,FDstClassTypeID,FType) values (0,200000052,'3C5AF434-BA7D-6D47-87C8-4C4E895A42B1',0,4)

--工时标准单价
delete ICClassPackObject where FSrcClassTypeId=200000053
insert into ICClassPackObject(FPackID,FSrcClassTypeID,FGUID,FDstClassTypeID,FType) values (0,200000053,'F95F7113-40E8-E645-9527-7B94FD56A488',0,1)

--精品配件销售订单
delete ICClassPackObject where FSrcClassTypeId=200000054
insert into ICClassPackObject(FPackID,FSrcClassTypeID,FGUID,FDstClassTypeID,FType) values (0,200000054,'5A3B8B5B-E1F0-BC40-AF8C-6CCFCBFC4A7B',0,4)

--加装项目
delete ICClassPackObject where FSrcClassTypeId=200000057
insert into ICClassPackObject(FPackID,FSrcClassTypeID,FGUID,FDstClassTypeID,FType) values (0,200000057,'67DB57F6-C5D8-1348-9C70-1050696C05C5',0,1)

--精品加装单
delete ICClassPackObject where FSrcClassTypeId=200000058
insert into ICClassPackObject(FPackID,FSrcClassTypeID,FGUID,FDstClassTypeID,FType) values (0,200000058,'CF0AF2F1-1F51-884C-A59D-9C152AC93551',0,4)

--整车入库单
delete ICClassPackObject where FSrcClassTypeId=200000059
insert into ICClassPackObject(FPackID,FSrcClassTypeID,FGUID,FDstClassTypeID,FType) values (0,200000059,'D14EE1CA-6802-7645-9CCD-217AA8939349',0,4)

--整车出库单
delete ICClassPackObject where FSrcClassTypeId=200000060
insert into ICClassPackObject(FPackID,FSrcClassTypeID,FGUID,FDstClassTypeID,FType) values (0,200000060,'E53E887F-E00F-4F43-BD8B-E762B9CC6B60',0,4)

--整车调拨单
delete ICClassPackObject where FSrcClassTypeId=200000061
insert into ICClassPackObject(FPackID,FSrcClassTypeID,FGUID,FDstClassTypeID,FType) values (0,200000061,'FE4CBC7A-5E66-6245-8A91-28598EFEB6FD',0,4)

--车辆配置变更
delete ICClassPackObject where FSrcClassTypeId=200000062
insert into ICClassPackObject(FPackID,FSrcClassTypeID,FGUID,FDstClassTypeID,FType) values (0,200000062,'C7DC616E-EF4A-2B42-AC70-18C2D7EEA628',0,4)

--其他应收单
delete ICClassPackObject where FSrcClassTypeId=1000021
insert into ICClassPackObject(FPackID,FSrcClassTypeID,FGUID,FDstClassTypeID,FType) values (0,1000021,'DA549F34-532E-504D-955F-ED646E905E1B',0,4)

--其他应付单
delete ICClassPackObject where FSrcClassTypeId=1000022
insert into ICClassPackObject(FPackID,FSrcClassTypeID,FGUID,FDstClassTypeID,FType) values (0,1000022,'CF15C424-0FC7-9C48-85E0-9F0799B9B929',0,4)

--付费类别
delete ICClassPackObject where FSrcClassTypeId=200000063
insert into ICClassPackObject(FPackID,FSrcClassTypeID,FGUID,FDstClassTypeID,FType) values (0,200000063,'E2FD12BC-B875-C248-B489-FF598F96ADAA',0,1)

--维修预约单
delete ICClassPackObject where FSrcClassTypeId=200000064
insert into ICClassPackObject(FPackID,FSrcClassTypeID,FGUID,FDstClassTypeID,FType) values (0,200000064,'C15951B0-54AA-9249-9C01-EBF624515943',0,4)

--维修项目.
delete ICClassPackObject where FSrcClassTypeId=200000065
insert into ICClassPackObject(FPackID,FSrcClassTypeID,FGUID,FDstClassTypeID,FType) values (0,200000065,'5330FC45-943F-B04F-BCBF-F0EDFD4A0C04',0,1)

--整车采购计划单
delete ICClassPackObject where FSrcClassTypeId=200000066
insert into ICClassPackObject(FPackID,FSrcClassTypeID,FGUID,FDstClassTypeID,FType) values (0,200000066,'63EBC14E-774F-154A-BCB7-440E48EE6B5B',0,4)

--采购增值税发票
delete ICClassPackObject where FSrcClassTypeId=1000004
insert into ICClassPackObject(FPackID,FSrcClassTypeID,FGUID,FDstClassTypeID,FType) values (0,1000004,'93E246B8-57D4-5249-8262-D834F1990286',0,4)

--销售增值税发票
delete ICClassPackObject where FSrcClassTypeId=1000002
insert into ICClassPackObject(FPackID,FSrcClassTypeID,FGUID,FDstClassTypeID,FType) values (0,1000002,'935A877D-D51A-404A-A66F-82F202969C72',0,4)

--汽车4S注册信息
delete ICClassPackObject where FSrcClassTypeId=200000067
insert into ICClassPackObject(FPackID,FSrcClassTypeID,FGUID,FDstClassTypeID,FType) values (0,200000067,'3851155A-0051-B540-8D20-BECBA7D108D0',0,4)

--维修工单
delete ICClassPackObject where FSrcClassTypeId=200000068
insert into ICClassPackObject(FPackID,FSrcClassTypeID,FGUID,FDstClassTypeID,FType) values (0,200000068,'7C559D2C-486D-5E42-B5C5-C4560B5F9F7F',0,4)

--车间管理
delete ICClassPackObject where FSrcClassTypeId=200000069
insert into ICClassPackObject(FPackID,FSrcClassTypeID,FGUID,FDstClassTypeID,FType) values (0,200000069,'34D37232-9510-DA44-905E-E48E9E254362',0,4)

--附加项目
delete ICClassPackObject where FSrcClassTypeId=200000070
insert into ICClassPackObject(FPackID,FSrcClassTypeID,FGUID,FDstClassTypeID,FType) values (0,200000070,'6E5A98D7-FEA6-8C49-A1F1-99B8CED179A6',0,1)

--维修派工单
delete ICClassPackObject where FSrcClassTypeId=200000071
insert into ICClassPackObject(FPackID,FSrcClassTypeID,FGUID,FDstClassTypeID,FType) values (0,200000071,'6B735AD6-D9C5-E949-A817-A9A703261782',0,4)

--工位
delete ICClassPackObject where FSrcClassTypeId=200000072
insert into ICClassPackObject(FPackID,FSrcClassTypeID,FGUID,FDstClassTypeID,FType) values (0,200000072,'1AEEF70B-C2FD-3D4E-89DA-78003B161E14',0,1)

--中断类型
delete ICClassPackObject where FSrcClassTypeId=200000073
insert into ICClassPackObject(FPackID,FSrcClassTypeID,FGUID,FDstClassTypeID,FType) values (0,200000073,'8095AECC-3566-2D49-B4C5-8A70917BF085',0,1)

--维修中断
delete ICClassPackObject where FSrcClassTypeId=200000074
insert into ICClassPackObject(FPackID,FSrcClassTypeID,FGUID,FDstClassTypeID,FType) values (0,200000074,'85F76981-CF7E-874B-86DC-5C42FDD3222D',0,4)

--维修质检
delete ICClassPackObject where FSrcClassTypeId=200000075
insert into ICClassPackObject(FPackID,FSrcClassTypeID,FGUID,FDstClassTypeID,FType) values (0,200000075,'AA258FAD-9488-A845-BDD0-A7B650E7EDF6',0,4)

--洗车单
delete ICClassPackObject where FSrcClassTypeId=200000076
insert into ICClassPackObject(FPackID,FSrcClassTypeID,FGUID,FDstClassTypeID,FType) values (0,200000076,'D3BB3B05-EBDA-DD4B-BE64-A2154142741C',0,4)

--新车销售回访
delete ICClassPackObject where FSrcClassTypeId=200000077
insert into ICClassPackObject(FPackID,FSrcClassTypeID,FGUID,FDstClassTypeID,FType) values (0,200000077,'7659F9F5-5092-E443-984E-3932BEA30642',0,4)

--回访不成功原因
delete ICClassPackObject where FSrcClassTypeId=200000078
insert into ICClassPackObject(FPackID,FSrcClassTypeID,FGUID,FDstClassTypeID,FType) values (0,200000078,'0934C8BF-AE1C-F049-A0F1-B7975EBF39AD',0,1)

--客户满意度
delete ICClassPackObject where FSrcClassTypeId=200000079
insert into ICClassPackObject(FPackID,FSrcClassTypeID,FGUID,FDstClassTypeID,FType) values (0,200000079,'A9B66EB5-EF99-6445-AA95-0D074637473E',0,1)

--售后维修回访
delete ICClassPackObject where FSrcClassTypeId=200000080
insert into ICClassPackObject(FPackID,FSrcClassTypeID,FGUID,FDstClassTypeID,FType) values (0,200000080,'E8135E31-8F83-A24E-BD0F-CF1A04B88E41',0,4)

--潜在客户回访
delete ICClassPackObject where FSrcClassTypeId=200000081
insert into ICClassPackObject(FPackID,FSrcClassTypeID,FGUID,FDstClassTypeID,FType) values (0,200000081,'4FAEE2BB-F9DB-F948-B099-D99244C698F1',0,4)

--定期保养提醒
delete ICClassPackObject where FSrcClassTypeId=200000082
insert into ICClassPackObject(FPackID,FSrcClassTypeID,FGUID,FDstClassTypeID,FType) values (0,200000082,'9EFDE396-88C9-6D41-9602-CC84F4C4406A',0,4)

--保险到期提醒
delete ICClassPackObject where FSrcClassTypeId=200000083
insert into ICClassPackObject(FPackID,FSrcClassTypeID,FGUID,FDstClassTypeID,FType) values (0,200000083,'67599906-614B-B448-BAFF-02A1C68245A3',0,4)

--保修到期提醒
delete ICClassPackObject where FSrcClassTypeId=200000084
insert into ICClassPackObject(FPackID,FSrcClassTypeID,FGUID,FDstClassTypeID,FType) values (0,200000084,'98E7CB9B-7754-5B49-9A58-A7351840E3D5',0,4)

--生日祝福
delete ICClassPackObject where FSrcClassTypeId=200000085
insert into ICClassPackObject(FPackID,FSrcClassTypeID,FGUID,FDstClassTypeID,FType) values (0,200000085,'F48DC5B6-0BC1-1C46-8301-175345DC2107',0,4)

--节日定义
delete ICClassPackObject where FSrcClassTypeId=200000086
insert into ICClassPackObject(FPackID,FSrcClassTypeID,FGUID,FDstClassTypeID,FType) values (0,200000086,'810761DF-2FFF-5249-9189-027255426EDF',0,1)

--节日问候
delete ICClassPackObject where FSrcClassTypeId=200000087
insert into ICClassPackObject(FPackID,FSrcClassTypeID,FGUID,FDstClassTypeID,FType) values (0,200000087,'1A4E71E9-95D1-3C4E-B52D-0322FF622544',0,4)

--客户投诉单
delete ICClassPackObject where FSrcClassTypeId=200000088
insert into ICClassPackObject(FPackID,FSrcClassTypeID,FGUID,FDstClassTypeID,FType) values (0,200000088,'66BE67FA-7300-4E47-A6B5-4E5C5667FA59',0,4)

--投诉类型4S
delete ICClassPackObject where FSrcClassTypeId=200000089
insert into ICClassPackObject(FPackID,FSrcClassTypeID,FGUID,FDstClassTypeID,FType) values (0,200000089,'6FA9910A-ED8F-CC40-B846-D5D3B22DF4AC',0,1)

--投诉性质
delete ICClassPackObject where FSrcClassTypeId=200000090
insert into ICClassPackObject(FPackID,FSrcClassTypeID,FGUID,FDstClassTypeID,FType) values (0,200000090,'56F80AD1-6A3A-4440-9E2B-7218336A9A60',0,1)

--满意度调查方案
delete ICClassPackObject where FSrcClassTypeId=200000091
insert into ICClassPackObject(FPackID,FSrcClassTypeID,FGUID,FDstClassTypeID,FType) values (0,200000091,'E913FCBA-E767-8640-ADB2-80547DCB425A',0,4)

--调查方案类型
delete ICClassPackObject where FSrcClassTypeId=200000092
insert into ICClassPackObject(FPackID,FSrcClassTypeID,FGUID,FDstClassTypeID,FType) values (0,200000092,'8EFBC3B4-2025-8841-A95D-F0819C26F10F',0,1)

--满意度问题分类
delete ICClassPackObject where FSrcClassTypeId=200000093
insert into ICClassPackObject(FPackID,FSrcClassTypeID,FGUID,FDstClassTypeID,FType) values (0,200000093,'6887AD4F-6327-7D47-8B9B-4C7CA11828F0',0,1)

--满意度调查计划
delete ICClassPackObject where FSrcClassTypeId=200000094
insert into ICClassPackObject(FPackID,FSrcClassTypeID,FGUID,FDstClassTypeID,FType) values (0,200000094,'64DF2744-209A-2742-B5E8-9EFF081596F8',0,4)

--满意度调查登记
delete ICClassPackObject where FSrcClassTypeId=200000095
insert into ICClassPackObject(FPackID,FSrcClassTypeID,FGUID,FDstClassTypeID,FType) values (0,200000095,'272AD03A-6B34-6643-B86E-4B8E82248B85',0,4)

--整车采购月预测单
delete ICClassPackObject where FSrcClassTypeId=200000096
insert into ICClassPackObject(FPackID,FSrcClassTypeID,FGUID,FDstClassTypeID,FType) values (0,200000096,'7DB6C6D4-7DBD-2B43-A4C7-0919702864F5',0,4)

--资金方式
delete ICClassPackObject where FSrcClassTypeId=200000097
insert into ICClassPackObject(FPackID,FSrcClassTypeID,FGUID,FDstClassTypeID,FType) values (0,200000097,'1863DDD5-B677-B64F-B750-CC0DC640EAAE',0,1)



if @@ERROR = 0 
begin
  commit;
end else
begin
  rollback;
end
end try
begin catch
  declare @errorMsg varchar(4000)
  select @errorMsg=ERROR_MESSAGE();
  raiserror (@errorMsg,16,1)
  rollback;
end catch
