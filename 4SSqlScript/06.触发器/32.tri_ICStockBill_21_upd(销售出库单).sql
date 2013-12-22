if exists (select 1 from sysobjects where name = 'tri_ICStockBill_21_upd' and xtype='TR')
	drop trigger tri_ICStockBill_21_upd
go
create trigger tri_ICStockBill_21_upd
   ON  ICStockBill
   for update
AS 
BEGIN
	SET NOCOUNT ON;
	declare @isAudit int;
	set @isAudit = 0;
	declare @isUnAudit int;
	set @isUnAudit = 0;
	declare @newCheckerID int;
	declare @oldCheckerID int;
	declare @interId int;
	declare cur cursor local for select isnull(FCheckerID,0),FInterID from inserted where FTranType=21;
	open cur;
	fetch cur into @newCheckerID,@interId
	while (@@FETCH_STATUS=0)
	begin
		select @oldCheckerID=isnull(FCheckerID,0) from deleted where FInterID=@interId and FTranType=21;
		if (@newCheckerID > 0 and @oldCheckerID <=0) 
		begin
			set @isAudit = 1;
		end
		if (@newCheckerID <= 0 and @oldCheckerID > 0) 
		begin
			set @isUnAudit = 1;
		end
		--精品销售流程:精品销售订单->精品加装单，精品销售订单—>销售出库出
		if (@isAudit = 1)
		begin
			
			--更新精品销售订单已出库数
			update a
			set FIssueQty=FIssueQty + (select isnull(b.FQty,0) from ICStockBillEntry b where b.FInterID=@interid
				and b.FSourceTranType=200000054 and b.FSourceInterId=a.FID and b.FSourceEntryID=a.FEntryID)
			from T_ATS_DecorationOrderEntry a
			where exists  (select 1 from ICStockBillEntry b where b.FInterID=@interid
				and b.FSourceTranType=200000054 and b.FSourceInterId=a.FID and b.FSourceEntryID=a.FEntryID);
			--更新精品销售订单未出库数
			update a
			set FUnIssueQty=FQty-FIssueQty
			from T_ATS_DecorationOrderEntry a
			where exists  (select 1 from ICStockBillEntry b where b.FInterID=@interid
				and b.FSourceTranType=200000054 and b.FSourceInterId=a.FID and b.FSourceEntryID=a.FEntryID);

			--更新精品加装单已出库数量
			update a
			set FIssueQty=FIssueQty + (select isnull(bb.FQty,0) from T_ATS_DecorationOrderEntry aa
				inner join ICStockBillEntry bb on bb.FSourceTranType=200000054 and bb.FSourceInterId=aa.FID and bb.FSourceEntryID=aa.FEntryID
				where a.FClassID_SRC=200000054 and a.FID_SRC=aa.FID and a.FEntryID_SRC=aa.FEntryID and bb.FInterID=@interId
				)
			from T_ATS_DecorateWOGift a
			where exists (select 1 from T_ATS_DecorationOrderEntry aa
				inner join ICStockBillEntry bb on bb.FSourceTranType=200000054 and bb.FSourceInterId=aa.FID and bb.FSourceEntryID=aa.FEntryID
				where a.FClassID_SRC=200000054 and a.FID_SRC=aa.FID and a.FEntryID_SRC=aa.FEntryID and bb.FInterID=@interId
				)
			
			--更新精品加装单未出库数量
			update a
			set FUnIssueQty=FQty - FIssueQty
			from T_ATS_DecorateWOGift a
			where exists (select 1 from T_ATS_DecorationOrderEntry aa
				inner join ICStockBillEntry bb on bb.FSourceTranType=200000054 and bb.FSourceInterId=aa.FID and bb.FSourceEntryID=aa.FEntryID
				where a.FClassID_SRC=200000054 and a.FID_SRC=aa.FID and a.FEntryID_SRC=aa.FEntryID and bb.FInterID=@interId
				)

/*		
			--更新精品加装单已出库数量
			update a
			set FIssueQty=FIssueQty + (select isnull(b.FQty,0) from ICStockBillEntry b where b.FInterID=@interId 
					and b.FSourceTranType=200000058 and b.FSourceInterId=a.FID and b.FSourceEntryID=a.FEntryID)
			from T_ATS_DecorateWOGift a
			where exists (select 1 from ICStockBillEntry b where b.FInterID=@interId 
					and b.FSourceTranType=200000058 and b.FSourceInterId=a.FID and b.FSourceEntryID=a.FEntryID)

			--更新精品加装单未出库数量
			update a
			set FUnIssueQty=FQty - FIssueQty
			from T_ATS_DecorateWOGift a
			where exists (select 1 from ICStockBillEntry b where b.FInterID=@interId 
					and b.FSourceTranType=200000058 and b.FSourceInterId=a.FID and b.FSourceEntryID=a.FEntryID)

			--更新精品销售订单已出库数量
			update aa
			set FIssueQty=FIssueQty + (select isnull(ac.fqty,0) from T_ATS_DecorateWOGift ab
						inner join ICStockBillEntry ac on ac.FSourceTranType=200000058 and ac.FSourceInterId=ab.FID and ac.FSourceEntryID=ab.FEntryID
			 where ac.FInterID=@interId and ab.FID_SRC=aa.FID and ab.FEntryID_SRC=aa.FEntryID and ab.FClassID_SRC=200000054 )
			from T_ATS_DecorationOrderEntry aa
			where exists (select 1 from T_ATS_DecorateWOGift ab
						inner join ICStockBillEntry ac on ac.FSourceTranType=200000058 and ac.FSourceInterId=ab.FID and ac.FSourceEntryID=ab.FEntryID
			 where ac.FInterID=@interId and ab.FID_SRC=aa.FID and ab.FEntryID_SRC=aa.FEntryID and ab.FClassID_SRC=200000054)
			
			--更新精品销售订单未出库数量

			update aa
			set FUnIssueQty=FQty-FIssueQty
			from T_ATS_DecorationOrderEntry aa
			where exists (select 1 from T_ATS_DecorateWOGift ab
						inner join ICStockBillEntry ac on ac.FSourceTranType=200000058 and ac.FSourceInterId=ab.FID and ac.FSourceEntryID=ab.FEntryID
			 where ac.FInterID=@interId and ab.FID_SRC=aa.FID and ab.FEntryID_SRC=aa.FEntryID and ab.FClassID_SRC=200000054)
*/
		end

		if (@isUnAudit= 1) 
		begin
					--更新精品销售订单已出库数
			update a
			set FIssueQty=FIssueQty - (select isnull(b.FQty,0) from ICStockBillEntry b where b.FInterID=@interid
				and b.FSourceTranType=200000054 and b.FSourceInterId=a.FID and b.FSourceEntryID=a.FEntryID)
			from T_ATS_DecorationOrderEntry a
			where exists  (select 1 from ICStockBillEntry b where b.FInterID=@interid
				and b.FSourceTranType=200000054 and b.FSourceInterId=a.FID and b.FSourceEntryID=a.FEntryID);
			--更新精品销售订单未出库数
			update a
			set FUnIssueQty=FQty-FIssueQty
			from T_ATS_DecorationOrderEntry a
			where exists  (select 1 from ICStockBillEntry b where b.FInterID=@interid
				and b.FSourceTranType=200000054 and b.FSourceInterId=a.FID and b.FSourceEntryID=a.FEntryID);

			--更新精品加装单已出库数量
			update a
			set FIssueQty=FIssueQty - (select isnull(bb.FQty,0) from T_ATS_DecorationOrderEntry aa
				inner join ICStockBillEntry bb on bb.FSourceTranType=200000054 and bb.FSourceInterId=aa.FID and bb.FSourceEntryID=aa.FEntryID
				where a.FClassID_SRC=200000054 and a.FID_SRC=aa.FID and a.FEntryID_SRC=aa.FEntryID and bb.FInterID=@interId
				)
			from T_ATS_DecorateWOGift a
			where exists (select 1 from T_ATS_DecorationOrderEntry aa
				inner join ICStockBillEntry bb on bb.FSourceTranType=200000054 and bb.FSourceInterId=aa.FID and bb.FSourceEntryID=aa.FEntryID
				where a.FClassID_SRC=200000054 and a.FID_SRC=aa.FID and a.FEntryID_SRC=aa.FEntryID and bb.FInterID=@interId
				)
			
			--更新精品加装单未出库数量
			update a
			set FUnIssueQty=FQty - FIssueQty
			from T_ATS_DecorateWOGift a
			where exists (select 1 from T_ATS_DecorationOrderEntry aa
				inner join ICStockBillEntry bb on bb.FSourceTranType=200000054 and bb.FSourceInterId=aa.FID and bb.FSourceEntryID=aa.FEntryID
				where a.FClassID_SRC=200000054 and a.FID_SRC=aa.FID and a.FEntryID_SRC=aa.FEntryID and bb.FInterID=@interId
				)
/*
			--更新精品加装单已出库数量
			update a
			set FIssueQty=FIssueQty - (select isnull(b.FQty,0) from ICStockBillEntry b where b.FInterID=@interId 
					and b.FSourceTranType=200000058 and b.FSourceInterId=a.FID and b.FSourceEntryID=a.FEntryID)
			from T_ATS_DecorateWOGift a
			where exists (select 1 from ICStockBillEntry b where b.FInterID=@interId 
					and b.FSourceTranType=200000058 and b.FSourceInterId=a.FID and b.FSourceEntryID=a.FEntryID)

			--更新精品加装单未出库数量
			update a
			set FUnIssueQty=FQty - FIssueQty
			from T_ATS_DecorateWOGift a
			where exists (select 1 from ICStockBillEntry b where b.FInterID=@interId 
					and b.FSourceTranType=200000058 and b.FSourceInterId=a.FID and b.FSourceEntryID=a.FEntryID)

			--更新精品销售订单已出库数量
			update aa
			set FIssueQty=FIssueQty - (select isnull(ac.fqty,0) from T_ATS_DecorateWOGift ab
						inner join ICStockBillEntry ac on ac.FSourceTranType=200000058 and ac.FSourceInterId=ab.FID and ac.FSourceEntryID=ab.FEntryID
			 where ac.FInterID=@interId and ab.FID_SRC=aa.FID and ab.FEntryID_SRC=aa.FEntryID and ab.FClassID_SRC=200000054 )
			from T_ATS_DecorationOrderEntry aa
			where exists (select 1 from T_ATS_DecorateWOGift ab
						inner join ICStockBillEntry ac on ac.FSourceTranType=200000058 and ac.FSourceInterId=ab.FID and ac.FSourceEntryID=ab.FEntryID
			 where ac.FInterID=@interId and ab.FID_SRC=aa.FID and ab.FEntryID_SRC=aa.FEntryID and ab.FClassID_SRC=200000054)
			
			--更新精品销售订单未出库数量

			update aa
			set FUnIssueQty=FQty-FIssueQty
			from T_ATS_DecorationOrderEntry aa
			where exists (select 1 from T_ATS_DecorateWOGift ab
						inner join ICStockBillEntry ac on ac.FSourceTranType=200000058 and ac.FSourceInterId=ab.FID and ac.FSourceEntryID=ab.FEntryID
			 where ac.FInterID=@interId and ab.FID_SRC=aa.FID and ab.FEntryID_SRC=aa.FEntryID and ab.FClassID_SRC=200000054)


*/
		end

		fetch next from cur into @newCheckerID,@interId
	end

	close cur;
	deallocate cur;
	


END
GO