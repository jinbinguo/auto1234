if exists (select 1 from sysobjects where name = 'tri_DecorationOrder_upd' and xtype='TR')
	drop trigger tri_DecorationOrder_upd
go
create trigger tri_DecorationOrder_upd
on t_ats_DecorationOrder
for update
as
begin
/**
逻辑:

*/
	set nocount on;
	declare @isAudit bit = 0; --是否审核操作
	declare @isUnAudit bit = 0; --是否反审核操作
	declare @oldStatus nvarchar(255); --旧单据状态
	declare @newStatus nvarchar(255); --新单据状态
	declare @interId int; --单据内码
	declare @entryId int; --单据分录内码
	declare @saleOrderId int; --源单内码
	declare @saleOrderEntryId int; --源单分录内码
	declare @vehicleId int; --车辆内码


	

	declare cur cursor local for select FID,FMultiCheckStatus,FVehicleId from inserted;
	open cur;
	fetch cur into @interId,@newStatus,@vehicleId
	while (@@FETCH_STATUS=0)
	begin
		select @oldStatus = isnull(FMultiCheckStatus,'') from deleted where FID = @interId;
		if (@newStatus = '16' and @oldStatus <> '16') 
		begin 
			set @isAudit = 1; 
		end;
		if (@newStatus <> '16' and @oldStatus = '16')
		begin
			set @isUnAudit = 1;
		end;
		
		if (@isAudit = 1 or @isUnAudit = 1)--审核或反审核
		begin		
			if (@isUnAudit =1)
			begin
				if exists (select 1 from t_RP_NewReceiveBill where FClassID_Binding=200000054 and FID_Binding=@interId)
				begin
					raiserror('已关联现金收款单或现金付款单,不能驳回审核',16,1)
				end

				if exists (select 1 from T_ATS_DecorateWOGift where FClassID_SRC=200000054 and FID_SRC = @interId)
				begin
					raiserror('已生成下游精品加装单，不允许反审核销售订单',16,1)
				end
				if exists (select 1 from ICSaleEntry  where FClassID_SRC=200000054 and FSourceInterId = @interId)
				begin
					raiserror('已生成下销售增值发票，不允许反审核销售订单',16,1)
				end

			end
			select @saleOrderId=FID_SRC,@saleOrderEntryId=FEntryID_SRC from T_ATS_DecorationOrderSource where fid=@interId and FClassID_SRC=200000028
			if @saleOrderId > 0 
			begin
			--更新整车销售订单的精品应收金额，精品加装金额累计
				update b
				set FARGitwareAmount=(  --精品应收金额
					select isnull(sum(amount),0) from (
					select sum(b.FARAmount) amount from T_ATS_DecorationOrderSource a 
					inner join T_ATS_DecorationOrderEntry b on b.fid=a.fid
					inner join T_ATS_DecorationOrder c on c.fid=a.fid
					where a.FClassID_SRC=200000028 and a.FID_SRC=@saleOrderId and a.FEntryID_SRC=@saleOrderEntryId 
					and c.FMultiCheckStatus = '16'
					union
					select sum(FManHourFee) amount from T_ATS_DecorateWOItem aa
					inner join T_ATS_DecorateWO bb on aa.FID=bb.FID
					where bb.FVehicleSEOrderID=@saleOrderId and bb.FVehicleSEOrderEntryID = @saleOrderEntryId and bb.FMultiCheckStatus='16')
					abc),
					FGiftwareDiscount=isnull((select sum(FDisByVehicleAmount) from T_ATS_DecorationOrderEntry where FID=@interId),0) --实际随车赠送精品金额
				from T_ATS_VehicleSaleOrderEntry b
				where b.fid=@saleOrderId and b.FEntryID=@saleOrderEntryId;

				update a
				set FTotalARAmount = FARVehicleAmount + FARGitwareAmount + FARAgentAmount - FSecondHandAmount
				from T_ATS_VehicleSaleOrderEntry a
				where a.fid=@saleOrderId and a.FEntryID=@saleOrderEntryId;

			end 
		end;

		set @isAudit = 0;
		set @isUnAudit = 0;
		fetch next from cur into @interId,@newStatus,@vehicleId
	end
	close cur;
	deallocate cur;

end


