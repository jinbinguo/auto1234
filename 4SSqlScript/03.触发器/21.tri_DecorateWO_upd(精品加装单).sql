if exists (select 1 from sysobjects where name = 'tri_DecorateWO_upd' and xtype='TR')
	drop trigger tri_DecorateWO_upd
go
create trigger tri_DecorateWO_upd
on T_ATS_DecorateWO
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
				if exists (select 1 from T_ATS_VehicleAlterCfg where FClassID_SRC=200000058 and FID_SRC = @interId)
				begin
					raiserror('已生成下游车型变更单，不允许反审核精品加装',16,1)
				end

				if exists (select 1 from ICStockBillEntry where FSourceTranType=200000058 and FSourceInterId=@interId)
				begin
					raiserror('已生成下游出库单，不允许反审核精品加装',16,1)
				end

			end
			select @saleOrderId=FVehicleSEOrderID ,@saleOrderEntryId=FVehicleSEOrderEntryID from T_ATS_DecorateWO  where fid=@interId;
			if @saleOrderId > 0 
			begin
			--更新整车销售订单的精品就收金额，精品加装金额累计
				update b
				set FARGitwareAmount=(
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
					abc)
				from T_ATS_VehicleSaleOrderEntry b
				where b.fid=@saleOrderId and b.FEntryID=@saleOrderEntryId;
			end 
			 
			update a
			set FTotalARAmount = FARVehicleAmount + FARGitwareAmount + FARAgentAmount - FSecondHandAmount
			from T_ATS_VehicleSaleOrderEntry a
			where a.fid=@saleOrderId and a.FEntryID=@saleOrderEntryId;




		end;

		set @isAudit = 0;
		set @isUnAudit = 0;
		fetch next from cur into @interId,@newStatus,@vehicleId
	end
	close cur;
	deallocate cur;

end


