if not exists (select 1  from sysobjects where name='T_ATS_RegInfo' and xtype='U')
begin
	CREATE TABLE T_ATS_RegInfo(
		FMachineCiphertext varchar(1000) NULL,
		FOrgNameCiphertext varchar(1000) NULL,
		FBeginDateCiphertext varchar(1000) NULL,
		FEndDateCiphertext varchar(1000) NULL
	) ON [PRIMARY]
end
go 