if exists (select 1 from sysobjects where name = 'tri_NewReceiveBill_1006002_upd' and xtype='TR')
	drop trigger tri_NewReceiveBill_1006002_upd
go
create trigger tri_NewReceiveBill_1006002_upd
   ON  T_RP_NewReceiveBill
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
	declare @billId int;
	declare @id_Binding int;

	declare cur cursor local for select FCheckerID_CN,FBillID,FID_Binding  from inserted where FClassTypeID_cn=1006002;
	open cur;
	fetch cur into @newCheckerID,@billId,@id_Binding
	while (@@FETCH_STATUS=0)
	begin
		select @oldCheckerID=FCheckerID_CN from deleted where FBillID=@billId and FClassTypeID_cn=1006002;
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
				if (@id_Binding > 0)
				begin
					raiserror('已关联单据，不允许驳回审核',16,1)
				end
			end

		end
		
		fetch next from cur into @newCheckerID,@billId,@id_Binding
	end

	close cur;
	deallocate cur;
	


END
GO