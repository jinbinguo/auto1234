if exists (select 1 from sysobjects where name = 'tri_ICStockBill_24_upd' and xtype='TR')
	drop trigger tri_ICStockBill_24_upd
go
create trigger tri_ICStockBill_24_upd
   ON  ICStockBill
   for update
AS 
BEGIN
	SET NOCOUNT ON;
	declare @isAudit bit;
	set @isAudit = 0;
	declare @isUnAudit bit;
	set @isUnAudit = 0;
	declare @newCheckerID int;
	declare @oldCheckerID int;
	declare @interId int;

	declare cur cursor local for select isnull(FCheckerID,0),FInterID from inserted where FTranType=24;
	open cur;
	fetch cur into @newCheckerID,@interId
	while (@@FETCH_STATUS=0)
	begin
		select @oldCheckerID=isnull(FCheckerID,0) from deleted where FInterID=@interId and FTranType=24;
		if (@newCheckerID > 0 and @oldCheckerID <=0) 
		begin
			set @isAudit = 1;
		end
		if (@newCheckerID <= 0 and @oldCheckerID > 0) 
		begin
			set @isUnAudit = 1;
		end
		if (@isAudit = 1)
		begin
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
		end

		if (@isUnAudit= 1) 
		begin
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



		end

		fetch next from cur into @newCheckerID,@interId
	end

	close cur;
	deallocate cur;
	


END
GO