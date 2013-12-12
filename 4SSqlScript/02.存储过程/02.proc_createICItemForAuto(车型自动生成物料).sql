if exists (select 1 from sysobjects where name='proc_createICItemForAuto' and xtype='P')
	drop procedure proc_createICItemForAuto
go
-- =============================================
-- Author:		jinbin_guo
-- Create date: 2013-7-27
-- Description:	车型自动生成物料
-- =============================================
create PROCEDURE proc_createICItemForAuto
	@modelId int,@userId int
AS
BEGIN
	SET NOCOUNT ON;
	
	declare @itemID int;
	exec GetICMaxNum 'T_Item',@itemId output; --物料内码
	declare @itemClassID int; --物料分类ID
	declare @name varchar(80); --车型名称
	declare @cfgDesc varchar(255); --车型配置说明
	declare @unitID int; --计量单位
	declare @unitGroupID int; --计量单位组
	declare @acctID int; --存货科目代码
	declare @saleAcctID int; --销售收入科目代码
	declare @costAcctID int; --销售成本科目代码
	declare @purPrice decimal(28,10); --采购单价
	declare @salePrice decimal(28,10); --销售单价
	declare @taxRate decimal(28,10); --税率
	declare @icitemClassFullName varchar(255); --物料分类全称
	declare @icitemClassLevel int; ----物料分类级别
	declare @fullname varchar(255); --物料全称
	declare @icitemNum varchar(50); --物料代码
	declare @unitNum varchar(50); --计量单位代码
	declare @oldItemId int;
	

	select @itemClassID = FICItemClassID,@name=FName,@purPrice=FPurTaxPrice,@oldItemId=FICItemID from t_ats_model where FID=@modelId;
	if @oldItemId > 0
	begin
		return;
	end
	declare @icitemShortNum varchar(80);
	exec proc_getModelICItemNum @itemClassId,@icitemNum output,@icitemShortNum output; --物料代码
	
	begin tran
	begin try	
	if not exists (select 1 from T_ATS_ModelICItemConfig)
	begin
		raiserror('未设置车型物料配置，请先设置',16,1)
	end
	
	
	select top 1 @unitID=a.FUnitID,@unitNum=b.FNumber,@unitGroupID=b.FParentID,@acctID=FAcctID,
		@saleAcctID=FSaleAcctID,@costAcctID=FCostAcctID,@taxRate=FTaxRate from T_ATS_ModelICItemConfig a
		left join v_ats_unittree b on a.FUnitID=b.fid;
	
	select @icitemClassFullName=FFullName,@icitemClassLevel=FLevel from t_Item where FItemID=@itemClassID;
	set @fullname = @icitemClassFullName + '_'  + @name;

	--select * from t_item where FItemId=2598 --
	--select * from t_ICItemCore where FItemID=2598  --物料核心资料
	--select * from t_ICItemBase where FItemID=2598  ---物料基本资料页签
	--select * from t_ICItemMaterial where FItemID=2598  --物料物流资料页签
	--select * from t_ICItemPlan where FItemID=2598  --物料计划资料页签
	--select * from t_ICItemDesign where FItemID=2598  --物料设计\服务资料页签
	--select * from t_ICItemStandard  where FItemID=2598  --物料标准资料页签
	--select * from t_ICItemQuality where FItemID=2598  --物料质量资料页签
	--select * from T_BASE_ICItemEntrance where FItemID=2598  --物料进出口资料页签
	--select * from t_ICItemCustom where FItemID=2598  --物料自定义资料页签
	insert into t_Item(FItemID,FItemClassID,FExternID,FNumber,
		FParentID,FLevel,FDetail,FName,FUnUsed,
		FBrNo,FFullNumber,FDiff,FDeleted,FShortNumber,
		FFullName,UUID,FGRCommonID,FSystemType,FUseSign,
		FChkUserID,FAccessory,FGrControl,FHavePicture)
	values(@itemID,4,-1,@icitemNum,
		@itemClassID,ISNULL(@icitemClassLevel,0)+1,1,@name,0,
		0,@icitemNum,0,0,@icitemShortNum,
		@fullname,NEWID(),-1,1,0,
		@userId,0,-1,0);

	--物料核心资料
	insert into t_ICItemCore(FItemID,FModel,FName,FHelpCode,FDeleted,
		FShortNumber,FNumber,FParentID,FBrNo,FTopID,
		FRP,FOmortize,FOmortizeScale,FForSale,FStaCost,
		FOrderPrice,FOrderMethod,FPriceFixingType,FSalePriceFixingType,FPerWastage,
		FARAcctID,FPlanPriceMethod,FPlanClass)
	values(@itemID,@cfgDesc,@name,null,0,
		@icitemShortNum,@icitemNum,@itemClassID,0,0,
		0,null,null,0,null,
		@purPrice ,null,null,null,0,
		null,null,null);
			
	--物料基本资料页签
	insert into t_ICItemBase(FItemID,FErpClsID,FUnitID,FUnitGroupID,FDefaultLoc,
		FSPID,FSource,FQtyDecimal,FLowLimit,FHighLimit,
		FSecInv,FUseState,FIsEquipment,FEquipmentNum,FIsSparePart,
		FFullName,FSecUnitID,FSecCoefficient,FSecUnitDecimal,FAlias,
		FOrderUnitID,FSaleUnitID,FStoreUnitID,FProductUnitID,FApproveNo,
		FAuxClassID,FTypeID,FPreDeadLine,FSerialClassID,FDefaultReadyLoc,FSPIDReady)
	values (@itemID,1,@unitID,@unitGroupID,0,
			0,0,0,0,1000,
			0,341,0,null,0,
			@name,0,0,0,null,
			@unitID,@unitID,@unitID,@unitID,null,
			0,0,null,0,0,0);
	
	--物料物流资料页签
	insert into t_ICItemMaterial(FItemID,FOrderRector,FPOHghPrcMnyType,FPOHighPrice,FWWHghPrc,
		FWWHghPrcMnyType,FSOLowPrc,FSOLowPrcMnyType,FIsSale,
		FProfitRate,FSalePrice,FBatchManager,FISKFPeriod,FKFPeriod,
		FTrack,FPlanPrice,FPriceDecimal,FAcctID,FSaleAcctID,
		FCostAcctID,FAPAcctID,FGoodSpec,FCostProject,FIsSnManage,
		FStockTime,FBookPlan,FBeforeExpire,FTaxRate,FAdminAcctID,
		FNote,FIsSpecialTax,FSOHighLimit,FSOLowLimit,FOIHighLimit,
		FOILowLimit,FDaysPer,FLastCheckDate,FCheckCycle,FCheckCycUnit,
		FStockPrice,FABCCls,FBatchQty,FClass,FCostDiffRate,
		FDepartment,FSaleTaxAcctID,FCBBmStandardID,FCBRestore,FPickHighLimit,FPickLowLimit)
	values (@itemID,0,1,0,0,
		1,0,1,0,
		0,@salePrice,0,0,0,
		76,0,2,@acctID,@saleAcctID,
		@costAcctID,0,0,0,0,
		0,0,0,@taxRate,0,
		null,0,0,0,0,
		0,null,null,null,0,
		0,null,null,0,null,
		0,null,0,1,0,0);
	
	--物料计划资料页签
	insert into t_ICItemPlan(FItemID,FPlanTrategy,FOrderTrategy,FLeadTime,FFixLeadTime,
		FTotalTQQ,FQtyMin,FQtyMax,FCUUnitID,FOrderInterVal,
		FBatchAppendQty,FOrderPoint,FBatFixEconomy,FBatChangeEconomy,
		FRequirePoint,FPlanPoint,FDefaultRoutingID,FDefaultWorkTypeID,FProductPrincipal,
		FDailyConsume,FMRPCon,FPlanner,FPutInteger,FInHighLimit,
		FInLowLimit,FLowestBomCode,FMRPOrder,FIsCharSourceItem,FCharSourceItemID,
		FPlanMode,FCtrlType,FCtrlStraregy,FContainerName,FKanBanCapability,
		FIsBackFlush,FBackFlushStockID,FBatchSplitDays,FBatchSplit,FIsFixedReOrder)
	values (@itemID,321,333,0,0,
			0,0,100000,0,0,
			0,0,1,1,
			1,1,0,0,0,
			0,1,0,0,0,
			0,null,0,0,null,
			14035,14039,0,null,1, --物料需求计划(MRP),MTO计划模式
			0,0,0,0,1);
	
	--物料设计\服务资料页签	
	insert into t_ICItemDesign(FItemID,FChartNumber,FIsKeyItem,FMaund,FGrossWeight,
		FNetWeight,FCubicMeasure,FLength,FWidth,FHeight,
		FSize,FVersion,FStartService,FMakeFile,FIsFix,
		FTtermOfService,FTtermOfUsefulTime)
	values (@itemID,null,0,0,0,
		0,0,0,0,0,
		0,null,0,0,0,
		0,0);
	
	--物料标准资料页签
	insert into t_ICItemStandard(FItemID,FStandardCost,FStandardManHour,FStdPayRate,
		FChgFeeRate,FStdFixFeeRate,FOutMachFee,FPieceRate,
		FStdBatchQty,FPOVAcctID,FPIVAcctID,FMCVAcctID,
		FPCVAcctID,FSLAcctID,FCAVAcctID,FCBAppendRate,FCBAppendProject,
		FCostBomID,FCBRouting,FOutMachFeeProject)
	values (@itemID,0,0,0,
		0,0,0,0,
		1,0,0,0,
		0,0,0,0,0,
		0,0,0);
	
	 --物料质量资料页签
	 insert into t_ICItemQuality(FItemID,FInspectionLevel,FInspectionProject,FIsListControl,FProChkMde,
		FWWChkMde,FSOChkMde,FWthDrwChkMde,FStkChkMde,FOtherChkMde,
		FStkChkPrd,FStkChkAlrm,FIdentifier,FSampStdCritical,FSampStdStrict,FSampStdSlight)
	values (@itemID,352,0,null,352,
	352,352,352,352,352,
	9999,0,0,0,0,0);
	
	--物料进出口资料页签
	insert into T_BASE_ICItemEntrance(FItemID,FNameEn,FModelEn,FHSNumber,FFirstUnit,
		FSecondUnit,FFirstUnitRate,FSecondUnitRate,FIsManage,FPackType,
		FLenDecimal,FCubageDecimal,FWeightDecimal,FImpostTaxRate,FConsumeTaxRate,
		FManageType,FExportRate)
	values (@itemID,null,null,0,null,
		null,0,0,0,null,
		2,4,2,0,0,
		0,0); 
	
	--物料自定义资料页签
	insert into t_ICItemCustom(FItemID)
	values( @itemId); 
	
	update t_ICItem
	set FItemID=FItemID
	where FItemID=@itemID;
	
	--更新车型
	update T_ATS_Model
	set FICItemID=@itemID,
		FUnitID = @unitID
	where FID=@modelId
	
	if @@error = 0
		commit;
	else rollback;
	end try
	begin catch
		declare @errorMsg varchar(4000);
		select @errorMsg=ERROR_MESSAGE();
		raiserror (@errorMsg,16,1)
		rollback;
	end catch
	
	select @icitemNum,@unitNum;
END
GO


