--修正销售出库单安装后，宽度变小问题，安装包把宽度设成与高度一致了
update ICTransactionType
set FFormWidth=11310
where fname = '销售出库' and FHeadTable='ICStockBill' and FEntryTable='ICStockBillEntry'
