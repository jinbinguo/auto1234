Attribute VB_Name = "ExcelUtils"
Private xlsApp As Excel.Application


Public Function openFile(importCls As Object) As String
   frmImportDlg.setImportCls importCls
   frmImportDlg.showForm False, "*.xls;*.xlsx"
End Function


Public Function getWorkbook(ByVal fileName As String) As Excel.Workbook
    If xlsApp Is Nothing Then
        Set xlsApp = New Excel.Application
    End If
    Dim xlsWorkBook As Excel.Workbook
   ' Set xlsWorkBook = New Excel.Workbook
    Set xlsWorkBook = xlsApp.Workbooks.Open(fileName)
    Set getWorkbook = xlsWorkBook
End Function

Public Sub closeExcel()
    If Not (xlsApp Is Nothing) Then
        xlsApp.Quit
        Set xlsApp = Nothing
    End If
End Sub


