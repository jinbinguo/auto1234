begin try
begin tran
--按揭登记转其他应付单
update ICClassLink set FIsUsed=2 where FSourClassTypeID =200000048 and FDestClassTypeID=1000022;

--保险登记单转其他应付单
update ICClassLink set FIsUsed=2 where FSourClassTypeID =200000047 and FDestClassTypeID=1000022;

--代办服务转按揭登记
update ICClassLink set FIsUsed=2 where FSourClassTypeID =200000045 and FDestClassTypeID=200000048;

--代办服务转保险登记单
update ICClassLink set FIsUsed=2 where FSourClassTypeID =200000045 and FDestClassTypeID=200000047;

--代办服务转其他应收单
update ICClassLink set FIsUsed=2 where FSourClassTypeID =200000045 and FDestClassTypeID=1000021;

--代办服务转上牌登记
update ICClassLink set FIsUsed=2 where FSourClassTypeID =200000045 and FDestClassTypeID=200000046;

--精品加装单转车辆配置变更
update ICClassLink set FIsUsed=2 where FSourClassTypeID =200000058 and FDestClassTypeID=200000062;

--精品配件销售订单转精品加装单
update ICClassLink set FIsUsed=2 where FSourClassTypeID =200000054 and FDestClassTypeID=200000058;

--精品配件销售订单转销售出库
update ICClassLink set FIsUsed=2 where FSourClassTypeID =200000054 and FDestClassTypeID=-21;

--精品配件销售订单转销售增值税发票
update ICClassLink set FIsUsed=2 where FSourClassTypeID =200000054 and FDestClassTypeID=1000002;

--上牌登记转其他应付单
update ICClassLink set FIsUsed=2 where FSourClassTypeID =200000046 and FDestClassTypeID=1000022;

--整车采购订单转采购增值税发票
update ICClassLink set FIsUsed=2 where FSourClassTypeID =200000023 and FDestClassTypeID=1000004;

--整车采购订单转整车入库单
update ICClassLink set FIsUsed=2 where FSourClassTypeID =200000023 and FDestClassTypeID=200000059;

--整车采购订单转整车验收单
update ICClassLink set FIsUsed=2 where FSourClassTypeID =200000023 and FDestClassTypeID=200000038;

--整车采购计划单转整车采购订单
update ICClassLink set FIsUsed=2 where FSourClassTypeID =200000066 and FDestClassTypeID=200000023;

--整车出库单转销售增值税发票
update ICClassLink set FIsUsed=2 where FSourClassTypeID =200000060 and FDestClassTypeID=1000002;

--整车入库单转采购增值税发票
update ICClassLink set FIsUsed=2 where FSourClassTypeID =200000059 and FDestClassTypeID=1000004;

--整车销售订单转代办服务
update ICClassLink set FIsUsed=2 where FSourClassTypeID =200000028 and FDestClassTypeID=200000045;

--整车销售订单转交车单
update ICClassLink set FIsUsed=2 where FSourClassTypeID =200000028 and FDestClassTypeID=200000029;

--整车销售订单转精品配件销售订单
update ICClassLink set FIsUsed=2 where FSourClassTypeID =200000028 and FDestClassTypeID=200000054;

--整车销售订单转配车单
update ICClassLink set FIsUsed=2 where FSourClassTypeID =200000028 and FDestClassTypeID=200000036;

--整车销售订单转销售增值税发票
update ICClassLink set FIsUsed=2 where FSourClassTypeID =200000028 and FDestClassTypeID=1000002;

--整车销售订单转整车出库单
update ICClassLink set FIsUsed=2 where FSourClassTypeID =200000028 and FDestClassTypeID=200000060;



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
