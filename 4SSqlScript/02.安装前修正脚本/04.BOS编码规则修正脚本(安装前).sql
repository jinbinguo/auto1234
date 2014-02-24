/**
	解决：安装后，BOS单据编码规则被还原为开发环境问题
*/

--备份编码规则设置表t_BillCodeRule
if exists (select 1  from sysobjects where name='t_BillCodeRule_4SBAK' and xtype='U')
begin
	drop table t_BillCodeRule_4SBAK;
end;
select * into t_BillCodeRule_4SBAK from t_BillCodeRule Where FBillTypeID >= 200000000;
--备份编码序时表ICBillNo
if exists (select 1  from sysobjects where name='ICBillNo_4SBAK' and xtype='U')
begin
	drop table ICBillNo_4SBAK;
end;
select * into ICBillNo_4SBAK from ICBillNo where FBillID>=200000000;


