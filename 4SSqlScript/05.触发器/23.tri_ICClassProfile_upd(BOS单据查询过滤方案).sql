if exists (select 1 from sysobjects where name = 'tri_ICClassProfle_ins' and xtype='TR')
	drop trigger tri_ICClassProfle_ins
go
create trigger tri_ICClassProfle_ins
   ON  ICClassProfile
   after Insert
AS 
BEGIN
	--非administrator用户首次使用默认方案时，加载administrator用户配置的默认方案
	SET NOCOUNT ON;
	declare @schemeId int;
	declare @tranType int;
	declare cur cursor local for select FSchemeID,FTranType from inserted where FSchemeName='Default Scheme' and FUserID<>16394 and FSysName=''
	open cur;
	fetch cur into @schemeId,@tranType
	while (@@FETCH_STATUS = 0)
	begin
		if not exists (select 1 from ICClassProfileEntry where FSchemeID=@schemeId)
		begin
			insert into ICClassProfileEntry(FSchemeID,FKey,FType,FValue) select @schemeId,FKey,FType,FValue from ICClassProfileEntry 
						where FSchemeID = (select FSchemeID from ICClassProfile
									 where FSchemeName='Default Scheme' and FUserID=16394 
											and FSysName='' and FTranType=@tranType )
		end

		fetch next from cur into @schemeId,@tranType
	end
	close cur;
	deallocate cur;

END
GO