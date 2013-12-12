---修正采购订单表头字段[付款已关联金额]
if exists (select 1 from ICTemplate where FFieldName='FHeadSelfP0252' and FID='P02')
begin
	update ICTemplate
	set FFieldName = 'FPayBindingAmount'
	where FFieldName='FHeadSelfP0252' and FID='P02'
end
if exists (select 1 from ICClassTableInfo where FFieldName='FHeadSelfP0252' and FTableName='POOrder')
begin
	update ICClassTableInfo
	set FFieldName = 'FPayBindingAmount'
	where FFieldName='FHeadSelfP0252' and FTableName='POOrder'
end

if exists (select 1 from ICChatBillTitle where FColName='FHeadSelfP0252' and FTableName='POOrder')
begin
	update ICChatBillTitle
	set
		--FFormat = 'FAmountDecimal', 字段格式
		FColName = 'FPayBindingAmount'
	where FColName='FHeadSelfP0252' and FTableName='POOrder'
end

if exists (select 1 from GLNoteCitation where FCode='FHeadSelfP0252' and FTemplateID='P02')
begin
	update GLNoteCitation
	set FCode = 'FPayBindingAmount'
	where FCode='FHeadSelfP0252' and FTemplateID='P02'
end

if exists (select 1 from t_FieldDescription where FFieldName='FHeadSelfP0252' and FTableID=200004)
begin
	update t_FieldDescription
	set FFieldName = 'FPayBindingAmount'
	where FFieldName='FHeadSelfP0252' and FTableID=200004
end

if exists (select 1 from syscolumns where id=OBJECT_ID('POOrder') and name='FHeadSelfP0252')
begin
	EXEC sp_rename 'POOrder.FHeadSelfP0252', 'FPayBindingAmount', 'COLUMN'
end


---修正销售出库单表头字段[车辆]
if exists (select 1 from ICTableRelation where FFieldName='FHeadSelfB0153' and FTableName='ICStockBill')
begin
	update ICTableRelation
	set FFieldName = 'FVehicleID'
	where FFieldName='FHeadSelfB0153' and FTableName='ICStockBill'
end

if exists (select 1 from ICTemplate where FFieldName='FHeadSelfB0153' and FID='B01')
begin
	update ICTemplate
	set FFieldName = 'FVehicleID'
	where FFieldName='FHeadSelfB0153' and FID='B01'
end
if exists (select 1 from ICClassTableInfo where FFieldName='FHeadSelfB0153' and FTableName='ICStockBill')
begin
	update ICClassTableInfo
	set FFieldName = 'FVehicleID'
	where FFieldName='FHeadSelfB0153' and  FTableName='ICStockBill'
end

if exists (select 1 from ICChatBillTitle where FColName='FHeadSelfB0153' and FTableName='ICStockBill')
begin
	--更新前注意查看是否有垃圾数据
	update ICChatBillTitle
	set	FColName = 'FVehicleID'
	where FColName='FHeadSelfB0153'  and FTableName='ICStockBill'
end

if exists (select 1 from GLNoteCitation where FCode='FHeadSelfB0153' and FTemplateID='B01')
begin
	update GLNoteCitation
	set FCode = 'FVehicleID'
	where FCode='FHeadSelfB0153' and FTemplateID='B01'
end

if exists (select 1 from t_FieldDescription where FFieldName='FHeadSelfB0153' and FTableID=210008)
begin
	update t_FieldDescription
	set FFieldName = 'FVehicleID'
	where FFieldName='FHeadSelfB0153' and FTableID=210008
end

if exists (select 1 from syscolumns where id=OBJECT_ID('ICStockBill') and name='FHeadSelfB0153')
begin
	EXEC sp_rename 'ICStockBill.FHeadSelfB0153', 'FVehicleID', 'COLUMN'
end
if exists (select 1 from syscolumns where id=OBJECT_ID('ICStockBill_1') and name='FHeadSelfB0153')
begin
	EXEC sp_rename 'ICStockBill_1.FHeadSelfB0153', 'FVehicleID', 'COLUMN'
end
if exists (select 1 from syscolumns where id=OBJECT_ID('ICStockBill_10') and name='FHeadSelfB0153')
begin
	EXEC sp_rename 'ICStockBill_10.FHeadSelfB0153', 'FVehicleID', 'COLUMN'
end
if exists (select 1 from syscolumns where id=OBJECT_ID('ICStockBill_2') and name='FHeadSelfB0153')
begin
	EXEC sp_rename 'ICStockBill_2.FHeadSelfB0153', 'FVehicleID', 'COLUMN'
end

if exists (select 1 from syscolumns where id=OBJECT_ID('ICStockBill_21') and name='FHeadSelfB0153')
begin
	EXEC sp_rename 'ICStockBill_21.FHeadSelfB0153', 'FVehicleID', 'COLUMN'
end
if exists (select 1 from syscolumns where id=OBJECT_ID('ICStockBill_24') and name='FHeadSelfB0153')
begin
	EXEC sp_rename 'ICStockBill_24.FHeadSelfB0153', 'FVehicleID', 'COLUMN'
end
if exists (select 1 from syscolumns where id=OBJECT_ID('ICStockBill_28') and name='FHeadSelfB0153')
begin
	EXEC sp_rename 'ICStockBill_28.FHeadSelfB0153', 'FVehicleID', 'COLUMN'
end
if exists (select 1 from syscolumns where id=OBJECT_ID('ICStockBill_29') and name='FHeadSelfB0153')
begin
	EXEC sp_rename 'ICStockBill_29.FHeadSelfB0153', 'FVehicleID', 'COLUMN'
end
if exists (select 1 from syscolumns where id=OBJECT_ID('ICStockBill_41') and name='FHeadSelfB0153')
begin
	EXEC sp_rename 'ICStockBill_41.FHeadSelfB0153', 'FVehicleID', 'COLUMN'
end
if exists (select 1 from syscolumns where id=OBJECT_ID('ICStockBill_5') and name='FHeadSelfB0153')
begin
	EXEC sp_rename 'ICStockBill_5.FHeadSelfB0153', 'FVehicleID', 'COLUMN'
end

---修正销售出库单表头字段[车辆].[车牌号]
if exists (select 1 from ICTemplate where FFieldName='FHeadSelfB0154' and FID='B01')
begin
	update ICTemplate
	set FFieldName = 'FPlateNum'
	where FFieldName='FHeadSelfB0154' and FID='B01'
end

if exists (select 1 from GLNoteCitation where FCode='FHeadSelfB0154' and FTemplateID='B01')
begin
	update GLNoteCitation
	set FCode = 'FPlateNum'
	where FCode='FHeadSelfB0154' and FTemplateID='B01'
end

if exists (select 1 from ICChatBillTitle where FColName='FHeadSelfB0154' and FTableName='V_ATS_VEHICLE')
begin
	--更新前注意查看是否有垃圾数据
	update ICChatBillTitle
	set	FColName = 'FPlateNum'
	where FColName='FHeadSelfB0154'  and FTableName='V_ATS_VEHICLE'
end


---修正销售出库单表头字段[车辆].[底盘号]
if exists (select 1 from ICTemplate where FFieldName='FHeadSelfB0155' and FID='B01')
begin
	update ICTemplate
	set FFieldName = 'FVin'
	where FFieldName='FHeadSelfB0155' and FID='B01'
end

if exists (select 1 from GLNoteCitation where FCode='FHeadSelfB0155' and FTemplateID='B01')
begin
	update GLNoteCitation
	set FCode = 'FVin'
	where FCode='FHeadSelfB0155' and FTemplateID='B01'
end

if exists (select 1 from ICChatBillTitle where FColName='FHeadSelfB0155' and FTableName='V_ATS_VEHICLE')
begin
	--更新前注意查看是否有垃圾数据
	update ICChatBillTitle
	set	FColName = 'FVin'
	where FColName='FHeadSelfB0155'  and FTableName='V_ATS_VEHICLE'
end


---修正销售出库单表头字段[车辆].[车型]
if exists (select 1 from ICTemplate where FFieldName='FHeadSelfB0156' and FID='B01')
begin
	update ICTemplate
	set FFieldName = 'FModelName'
	where FFieldName='FHeadSelfB0156' and FID='B01'
end

if exists (select 1 from GLNoteCitation where FCode='FHeadSelfB0156' and FTemplateID='B01')
begin
	update GLNoteCitation
	set FCode = 'FModelName'
	where FCode='FHeadSelfB0156' and FTemplateID='B01'
end

if exists (select 1 from ICChatBillTitle where FColName='FHeadSelfB0156' and FTableName='V_ATS_VEHICLE')
begin
	--更新前注意查看是否有垃圾数据
	update ICChatBillTitle
	set	FColName = 'FModelName'
	where FColName='FHeadSelfB0156'  and FTableName='V_ATS_VEHICLE'
end