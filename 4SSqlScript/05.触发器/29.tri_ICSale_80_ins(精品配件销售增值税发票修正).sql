if exists (select 1 from sysobjects where name = 'tri_ICSale_80_upd' and xtype='TR')
	drop trigger tri_ICSale_80_upd
go
create trigger tri_ICSale_80_upd
on ICSale
for update
as
begin
/**
	ԭ���۳��ⵥת����ר�÷�Ʊ�������۷�Ʊֻ��������ģ������ҵ���������ڲ���ģ������ˡ�����ˣ�
	���������������������������tri_RPContact_3_ins������һ��ʹ��
�߼�:
	
*/
	set nocount on;
	declare @isAudit bit;
	set @isAudit = 0;
	declare @isUnAudit bit;
	set @isUnAudit = 0;
	declare @newCheckerID int;
	declare @oldCheckerID int;
	declare @billId int;
	
	declare cur cursor local for select isnull(FCheckerID,0),FInterID from inserted where FTranType=80;
	open cur;
	fetch cur into @newCheckerID,@billId;
	while (@@FETCH_STATUS=0)
	begin
		select @oldCheckerID=isnull(FCheckerID,0) from deleted where FInterID=@billId;
		if (@newCheckerID > 0 and @oldCheckerID <=0) 
		begin
			set @isAudit = 1;
		end
		if (@newCheckerID <= 0 and @oldCheckerID > 0) 
		begin
			set @isUnAudit = 1;
		end	
		if (@isAudit=1) --���
		begin
			update ICSale
			set FArApStatus=1
			where FInterID=@billId;

			update t_rp_contact
			set FStatus=1
			where FInvoiceID=@billId;
		end 

		if (@isUnAudit=1) --�����
		begin
			update ICSale
			set FArApStatus=0,
				FStatus=0
			where FInterID=@billId;

			update t_rp_contact
			set FStatus=0
			where FInvoiceID=@billId and FStatus=1;
		end

		fetch next from cur into @newCheckerID,@billId;
	end 
	close cur;
	deallocate cur;


	update a
	set FSubSystemID=1
	from ICSale a
	where exists (select 1 from inserted b where b.FSubSystemID=0 and b.FTranType=80 and b.FInterID=a.FInterID)
end