/**
	解决：安装后，BOS单据编码规则被还原为开发环境问题
*/

delete t_BillCodeRule where exists (select 1 from t_BillCodeRule_4SBAK where FBillTypeID=t_BillCodeRule.FBillTypeID);
set IDENTITY_INSERT t_BillCodeRule on
insert into t_BillCodeRule(FID,FBillTypeID,FClassIndex,FProjectID,FProjectVal,FFormatIndex,FLength,FAddChar,FReChar,FBillType,FIsBy)
 select FID,FBillTypeID,FClassIndex,FProjectID,FProjectVal,FFormatIndex,FLength,FAddChar,FReChar,FBillType,FIsBy from t_BillCodeRule_4SBAK;
set IDENTITY_INSERT t_BillCodeRule off

delete ICBillNo where exists (select 1 from ICBillNo_4SBAK where FBillID=ICBillNo.FBillID)
insert into ICBillNo select * from ICBillNo_4SBAK;


