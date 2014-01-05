if exists (select 1 from sysobjects where name = 'tri_ICSale_upd' and xtype='TR')
	drop trigger tri_ICSale_upd
go
create trigger tri_ICSale_upd
   ON  ICSale
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
	declare cur cursor local for select isnull(FCheckerID,0),FInterID from inserted;
	open cur;
	fetch cur into @newCheckerID,@interId
	while (@@FETCH_STATUS=0)
	begin
		select @oldCheckerID=isnull(FCheckerID,0) from deleted where FInterID=@interId;
		if (@newCheckerID > 0 and @oldCheckerID <=0) 
		begin
			set @isAudit = 1;
		end
		if (@newCheckerID <= 0 and @oldCheckerID > 0) 
		begin
			set @isUnAudit = 1;
		end

		--整车出库单
		update a
		set a.FIsCreateInvoice=isnull ((select top 1 FID from ICSaleEntry b 
						inner join ICSale bb on bb.FInterID=b.FInterID 
					where bb.FCheckerID>0 and b.FClassID_SRC=200000060 and b.FSourceInterId=a.FID and b.FSourceEntryID=a.FEntryID),0)
		from T_ATS_VehicleIssueEntry a
		where exists (select 1 from ICSaleEntry aa where aa.FInterID=@interId and
					aa.FClassID_SRC=200000060 and aa.FSourceInterId=a.FID and aa.FSourceEntryID=a.FEntryID);

		--精品配件销售订单

		update a
		set a.FIsCreateInvoice=isnull ((select top 1 FID from ICSaleEntry b 
						inner join ICSale bb on bb.FInterID=b.FInterID 
					where bb.FCheckerID>0 and b.FClassID_SRC=200000054 and b.FSourceInterId=a.FID and b.FSourceEntryID=a.FEntryID),0)
		from T_ATS_DecorationOrderEntry a
		where exists (select 1 from ICSaleEntry aa where aa.FInterID=@interId and
					aa.FClassID_SRC=200000054 and aa.FSourceInterId=a.FID and aa.FSourceEntryID=a.FEntryID);


		--整车销售订单

		update a
		set a.FIsCreateInvoice=isnull ((select top 1 FID from ICSaleEntry b 
						inner join ICSale bb on bb.FInterID=b.FInterID 
					where bb.FCheckerID>0 and b.FClassID_SRC=200000028 and b.FSourceInterId=a.FID and b.FSourceEntryID=a.FEntryID),0)
		from T_ATS_VehicleSaleOrderEntry a
		where exists (select 1 from ICSaleEntry aa where aa.FInterID=@interId and
					aa.FClassID_SRC=200000028 and aa.FSourceInterId=a.FID and aa.FSourceEntryID=a.FEntryID);



		fetch next from cur into @newCheckerID,@interId
	end

	close cur;
	deallocate cur;
	


END
GO