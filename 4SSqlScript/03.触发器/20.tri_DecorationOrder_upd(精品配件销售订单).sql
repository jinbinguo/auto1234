if exists (select 1 from sysobjects where name = 'tri_DecorationOrder_upd' and xtype='TR')
	drop trigger tri_DecorationOrder_upd
go
create trigger tri_DecorationOrder_upd
on t_ats_DecorationOrder
for update
as
begin
/**
�߼�:

*/
	set nocount on;
	declare @isAudit bit = 0; --�Ƿ���˲���
	declare @isUnAudit bit = 0; --�Ƿ���˲���
	declare @oldStatus nvarchar(255); --�ɵ���״̬
	declare @newStatus nvarchar(255); --�µ���״̬
	declare @interId int; --��������
	declare @entryId int; --���ݷ�¼����
	declare @saleOrderId int; --Դ������
	declare @saleOrderEntryId int; --Դ����¼����
	declare @vehicleId int; --��������


	

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
		
		if (@isAudit = 1 or @isUnAudit = 1)--��˻����
		begin		
			if (@isUnAudit =1)
			begin
				if exists (select 1 from t_RP_NewReceiveBill where FClassID_Binding=200000054 and FID_Binding=@interId)
				begin
					raiserror('�ѹ����ֽ��տ���ֽ𸶿,���ܲ������',16,1)
				end

				if exists (select 1 from T_ATS_DecorateWOGift where FClassID_SRC=200000054 and FID_SRC = @interId)
				begin
					raiserror('���������ξ�Ʒ��װ����������������۶���',16,1)
				end
				if exists (select 1 from ICSaleEntry  where FClassID_SRC=200000054 and FSourceInterId = @interId)
				begin
					raiserror('��������������ֵ��Ʊ��������������۶���',16,1)
				end

			end
			select @saleOrderId=FID_SRC,@saleOrderEntryId=FEntryID_SRC from T_ATS_DecorationOrderSource where fid=@interId and FClassID_SRC=200000028
			if @saleOrderId > 0 
			begin
			--�����������۶����ľ�ƷӦ�ս���Ʒ��װ����ۼ�
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


