select * from sysobjects where name like 'icClassMCStatus%' and xtype='U'

SET NOCOUNT ON
IF OBJECT_ID('icClassMCStatus200000060') IS NOT NULL
BEGIN
select FID INTO #MyTable from (SELECT Max(FID) AS  FID FROM icClassMCStatus200000060 WHERE FTemplateID=138  GROUP BY FBillID) T
SELECT TOP 1 1 FROM icClassMCStatus200000060 T1
INNER JOIN #MyTable T2 ON T1.FID=T2.FID
Where T1.FNextLevelTagIndex <> 1
DROP TABLE #MyTable
End
SET NOCOUNT OFF

update ICClassMCTemplate
set FIsRun=0
 where FClassTypeID=200000060