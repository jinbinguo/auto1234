if exists (select 1 from sysobjects where name = 'tri_POOrder_upd' and xtype='TR')
	drop trigger tri_POOrder_upd
go
create trigger tri_POOrder_upd
   ON  POOrder
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
	declare @id_Binding int;

	declare cur cursor local for select FCheckerID,FInterID  from inserted;
	open cur;
	fetch cur into @newCheckerID,@interId
	while (@@FETCH_STATUS=0)
	begin
		select @oldCheckerID=FCheckerID from deleted where FInterID=@interId;
		if (@newCheckerID > 0 and @oldCheckerID <=0) 
		begin
			set @isAudit = 1;
		end
		if (@newCheckerID <= 0 and @oldCheckerID > 0) 
		begin
			set @isUnAudit = 1;
		end
		if (@isAudit = 1 or @isUnAudit = 1)
		begin
			if (@isUnAudit= 1) 
			begin
				if exists (select 1 from t_RP_NewReceiveBill where FClassID_Binding='P02' and FID_Binding=@interId)
				begin
					raiserror('已关联现金付款单,不能驳回审核',16,1)
				end
			end

		end
		
		fetch next from cur into @newCheckerID,@interId
	end

	close cur;
	deallocate cur;
	


END
GO