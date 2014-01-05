VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "VehiclePurOrderImport"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Private m_BillInterface As BillEvent
Private m_UI As Object
Private dctMapping As KFO.Dictionary
Private dctMappingSeq As KFO.Dictionary
Private dctTitle As KFO.Dictionary
Private dctTitleInvert As KFO.Dictionary
Private dctContent As KFO.Dictionary
Private isCheckError As Boolean

Public Sub setBillInterface(ByVal billInterface As Object, ByVal ui As Object)
    Set m_BillInterface = billInterface
    Set m_UI = ui
    getMappingCfg '获取映射配置
End Sub


'取得映射配置信息
Private Sub getMappingCfg()
    Dim billType As String
    Dim sql As String
    Dim rs As ADODB.Recordset
    billType = "VehiclePurOrder"
    
  
    If dctMapping Is Nothing Then
        Set dctMapping = New KFO.Dictionary
    End If
    dctMapping.RemoveAll
    
    If dctMappingSeq Is Nothing Then
        Set dctMappingSeq = New KFO.Dictionary
    End If
    dctMappingSeq.RemoveAll
    
    sql = "select FExcelColName,FMustInput,FK3ColName,FK3ColKey,FK3ColType,FK3ColSrcTable,Fk3ColSrcFieldName,FK3ColSrcWhereEx from T_ATS_ImportEntryMapping " & _
        " where FImportBillType='" & billType & "' Order by FSeq"
    
    Dim seqIndex  As Long
    seqIndex = 1
    Set rs = m_BillInterface.K3Lib.GetData(sql)
    While Not rs.EOF
        Dim dctRow As KFO.Dictionary
        Set dctRow = New KFO.Dictionary
        dctRow("FExcelColName") = rs!FExcelColName
        dctRow("FMustInput") = rs!FMustInput

        dctRow("FK3ColName") = rs!FK3ColName
        dctRow("FK3ColKey") = rs!FK3ColKey
        dctRow("FK3ColType") = rs!FK3ColType
        dctRow("FK3ColSrcTable") = rs!FK3ColSrcTable
        dctRow("Fk3ColSrcFieldName") = rs!FK3ColSrcFieldName
        dctRow("FK3ColSrcWhereEx") = rs!FK3ColSrcWhereEx
        Set dctMapping(rs!FExcelColName) = dctRow
        dctMappingSeq(seqIndex) = rs!FK3ColKey
        rs.MoveNext
        seqIndex = seqIndex + 1
    Wend

End Sub


Public Sub runCheck()
   If checkExcel Then
        MsgBoxEx.showInfo "检查完成"
   Else
        MsgBoxEx.showInfo "检查完成，但导入数据存在错误，请查看。"
   End If
    
End Sub

Private Function checkExcel() As Boolean
     On Error GoTo errorLine
    Dim fileName As String
    Dim xlsBook As Excel.Workbook
    Dim xlSheet As Excel.Worksheet
    fileName = frmImportDlg.txtFileName.Text
    If existsFile(fileName) = False Then
     MsgBoxEx.showInfo "请先选导入文件..."
        Exit Function
    End If
    Dim titleRow As Long
    Dim dataBeginRow As Long
    
    isCheckError = False
    frmImportDlg.txtMsg.Text = ""
    titleRow = 2
    dataBeginRow = 3
    Set xlsBook = ExcelUtils.getWorkbook(fileName)
    Set xlsSheet = xlsBook.Sheets(1)
    parseTitle xlsSheet, titleRow
    parseContent xlsSheet, dataBeginRow

    ExcelUtils.closeExcel
    checkExcel = Not isCheckError
    Exit Function
errorLine:
    addMsg Err.Description
    MsgBox Err.Description
    Err.Clear
    ExcelUtils.closeExcel
    checkExcel = False

End Function

Private Sub parseContent(ByVal sheet As Excel.Worksheet, ByVal dataBeginRow As Long)
    If dctContent Is Nothing Then
        Set dctContent = New KFO.Dictionary
    End If
    dctContent.RemoveAll
    Dim rowCount As Long
    Dim cellValue As String
    Dim cellValue1 As String
    Dim cellValue2 As String
    
    For rowCount = dataBeginRow To sheet.Rows.Count
        cellValue = sheet.Cells(rowCount, 1)
        If cellValue = "" Then
            Exit For
        End If
    Next rowCount
    Dim colMappingCount As Long
    colMappingCount = dctMapping.Count '映射表头列
    Dim colIndex1 As Long
    Dim colIndex2 As Long
    Dim mappingIndex As Long
    Dim rowIndex As Long
    Dim rs As ADODB.Recordset
    Dim sql As String
    addMsg "正在解析内容..."
    resetProgress colMappingCount * (rowCount - dataBeginRow)
    For mappingIndex = 1 To colMappingCount '按映射表头遍历
        Dim mapping As KFO.Dictionary
        Set mapping = dctMapping.value(dctMapping.Name(mappingIndex))
        Dim excelColName As String
        Dim mustInput As Boolean
        Dim k3ColName As String
        Dim k3ColSrcKey As String
        Dim k3ColType As String
        Dim k3ColSrcTable As String
        Dim k3ColSrcFieldName As String
        Dim k3ColSrcWhereEx As String

        excelColName = mapping("FExcelColName")
        mustInput = mapping("FMustInput")
        k3ColName = mapping("FK3ColName")
        k3ColSrcKey = mapping("FK3ColKey")
        k3ColType = mapping("FK3ColType")
        k3ColSrcTable = mapping("FK3ColSrcTable")
        k3ColSrcFieldName = mapping("Fk3ColSrcFieldName")
        k3ColSrcWhereEx = mapping("FK3ColSrcWhereEx")
        colIndex1 = -1
        colIndex2 = -1
        
        Dim isCombination As Long
        isCombination = InStr(excelColName, "|+|")
        If isCombination > 0 Then
            colIndex1 = getTitleIndex(Left(excelColName, isCombination - 1))
            colIndex2 = getTitleIndex(Right(excelColName, Len(excelColName) - isCombination - 2))
            
            
        Else
            colIndex1 = getTitleIndex(excelColName)
            
        End If
        
      '  colIndex = dctTitle(excelColName)

        For rowIndex = dataBeginRow To rowCount - 1
Continue:
            addProgress
            
            Dim dctRow As KFO.Dictionary
            Set dctRow = IIf(IsEmpty(dctContent.GetValue(rowIndex - dataBeginRow + 1)), Nothing, dctContent.GetValue(rowIndex - dataBeginRow + 1))
            If dctRow Is Nothing Then
                Set dctRow = New KFO.Dictionary
            End If
        
            Dim dctCol As KFO.Dictionary
            Set dctCol = IIf(IsEmpty(dctRow.GetValue(k3ColSrcKey)), Nothing, dctRow.GetValue(k3ColSrcKey))
            If dctCol Is Nothing Then
                Set dctCol = New KFO.Dictionary
            End If
            dctCol("FKey") = k3ColSrcKey
            cellValue1 = sheet.Cells(rowIndex, colIndex1)
            If colIndex2 > 0 Then
                cellValue2 = sheet.Cells(rowIndex, colIndex2)
                cellValue = cellValue1 & "-" & cellValue2
            Else
                cellValue = cellValue1
            End If
            
            If mustInput = True And cellValue = "" Then
                addError rowIndex, colIndex1, colIndex2, cellValue, "不能为空"
                rowIndex = rowIndex + 1
                If rowIndex > (rowCount - 1) Then
                    Exit For
                Else
                    GoTo Continue
                End If
            End If
            
            If k3ColType = "F7" Then
                Dim whereExSQL As String
                whereExSQL = ""
                
                If k3ColSrcWhereEx <> "" Then '解析扩展的过滤查询条件
                    Dim whereExExcelColName As String
                    whereExExcelColName = Right(k3ColSrcWhereEx, (Len(k3ColSrcWhereEx) - InStr(k3ColSrcWhereEx, "{")))
                    whereExExcelColName = Left(whereExExcelColName, InStr(whereExExcelColName, "}") - 1)
                    Dim whereExExcelColIndex As Long
                    whereExExcelColIndex = getTitleIndex(whereExExcelColName)
                    Dim whereExCellValue As String
                    whereExCellValue = sheet.Cells(rowIndex, whereExExcelColIndex)
                    whereExSQL = Replace(k3ColSrcWhereEx, "{" & whereExExcelColName & "}", "'" & whereExCellValue & "'")
                                
                End If
            
            
                sql = "select FNumber from " & k3ColSrcTable & " where " & k3ColSrcFieldName & "='" & cellValue & "'"
                If whereExSQL <> "" Then
                    sql = sql & " and " & whereExSQL
                End If
                Set rs = m_BillInterface.K3Lib.GetData(sql)
                If rs.EOF Then
                    addError rowIndex, colIndex1, colIndex2, cellValue, "不在于基础资料"
                    
                    rowIndex = rowIndex + 1
                    If rowIndex > (rowCount - 1) Then
                        Exit For
                    Else
                        GoTo Continue
                    End If
                Else
                    dctCol("FValue") = rs!FNumber
                End If
                
            Else
                dctCol("FValue") = cellValue
            
            End If
            

            Set dctRow(k3ColSrcKey) = dctCol
            Set dctContent(rowIndex - dataBeginRow + 1) = dctRow
        Next rowIndex
    
    Next mappingIndex
    
    If isCheckError Then
        addMsg "解析内容存在错误，请查看明细..."
        Exit Sub
    End If
    addMsg "解析内容完成..."
End Sub

Private Sub addError(ByVal rowIndex As Long, ByVal colIndex1 As Long, ByVal colIndex2 As Long, ByVal value As String, ByVal errMsg As String)
    Dim msg As String
    If colIndex2 > 0 Then
         msg = "第" & CStr(rowIndex) & "行,组合[" & dctTitleInvert(colIndex1) & ";" & dctTitleInvert(colIndex2) & "]列：" & value & errMsg
    Else
        msg = "第" & CStr(rowIndex) & "行,[" & dctTitleInvert(colIndex1) & "]列：" & value & errMsg
    End If
    isCheckError = True
    addMsg msg
End Sub

Private Function getTitleIndex(ByVal titleName As String) As Long
    Dim titleIndex As Long
    titleIndex = Val(dctTitle(titleName))
    If titleIndex = 0 Then
        addMsg titleName & "]不存在"
        isCheckError = True
        Err.Raise 1000, "getTitleIndex", "列[" & titleName & "]不存在"
    End If
    getTitleIndex = titleIndex
    

End Function


Private Sub parseTitle(ByVal sheet As Excel.Worksheet, ByVal titleRow As Long)
    If dctTitle Is Nothing Then
        Set dctTitle = New KFO.Dictionary
    End If
    dctTitle.RemoveAll
    If dctTitleInvert Is Nothing Then
        Set dctTitleInvert = New KFO.Dictionary
    End If
    dctTitleInvert.RemoveAll
    
    Dim cellValue As String
    Dim colIndex As Long
    addMsg "正在解析标题...."
    resetProgress 50
    For colIndex = 1 To 10000
        cellValue = sheet.Cells(titleRow, colIndex)
        addProgress
        If cellValue = "" Then
            addMsg "解析标题完成...."
            Exit Sub
        End If
        dctTitle(cellValue) = colIndex
        dctTitleInvert(colIndex) = cellValue
    Next colIndex
End Sub


Public Sub runImport()
    If Not checkExcel Then
        MsgBoxEx.showInfo "检查失败,存在不符合数据，请查看。"
        Exit Sub
    End If
    addMsg "正在导入数据....."
    Dim rowIndex As Long
    Dim rowCount As Long
    Dim colIndex As Long
    rowCount = dctContent.Count
        
    Dim progressMax As Long
    progressMax = rowCount
    
    For rowIndex = 1 To rowCount
        Dim dctTmpRow As KFO.Dictionary
        Set dctTmpRow = dctContent(rowIndex)
        Dim dctTmpQtyCol As KFO.Dictionary
        Dim qtyTmp As Long
        qtyTmp = 1
        Set dctTmpQtyCol = dctTmpRow("FQty")
        If Not dctTmpQtyCol Is Nothing Then
            qtyTmp = Val(dctTmpQtyCol("FValue"))
            If qtyTmp = 0 Then
                qtyTmp = 1
            End If
        End If
        progressMax = progressMax + (qtyTmp - 1)
        
    Next rowIndex
    
    resetProgress progressMax
    Dim rowRealIndex As Long
    rowRealIndex = 1
    For rowIndex = 1 To rowCount
        Dim dctRow As KFO.Dictionary
        Set dctRow = dctContent(rowIndex)
        
        
        Dim qty As Long
        Dim qtyIndex As Long
        qty = 1
        Dim dctQtyCol As KFO.Dictionary
        Set dctQtyCol = dctRow("FQty")
        If Not dctQtyCol Is Nothing Then
            qty = Val(dctQtyCol("FValue"))
            If qty = 0 Then
                qty = 1
            End If
        End If
        
        For qtyIndex = 1 To qty
            m_BillInterface.InsertNewRowAndFill 2, m_BillInterface.BillEntrys(1).GridMaxDataRowNum + 1, nil
            For colIndex = 1 To dctMappingSeq.Count
                 Dim dctCol As KFO.Dictionary
                 
                 Set dctCol = dctRow.value(dctMappingSeq(colIndex))
                 If dctCol("FKey") = "FQty" Then
                    m_BillInterface.SetFieldValue dctCol("FKey"), 1, rowRealIndex
                 Else
                    m_BillInterface.SetFieldValue dctCol("FKey"), dctCol("FValue"), rowRealIndex
                 End If
                 Dim dct As KFO.Dictionary
                 Dim dctFld As KFO.Dictionary
                
                 Set dct = m_BillInterface.GetFieldInfoByKey(dctCol("FKey"), "", -1)
                 Set dctFld = m_BillInterface.GetDataFldbyKey(dctCol("FKey"), rowRealIndex)
                 
                ' m_BillInterface.FireEntryFieldChanged dct, dctFld, dctCol("FValue"), colIndex, rowRealIndex
                 m_UI.Change dct, dctFld, colIndex, rowRealIndex
             
            Next colIndex
        
        
            rowRealIndex = rowRealIndex + 1
        
            addProgress
        Next qtyIndex
        
        
    Next rowIndex
    addMsg "导入数据完成....."
    MsgBoxEx.showInfo "导入数据成功"
End Sub


Private Function existsFile(ByVal fileName As String) As Boolean
    If Dir(fileName) <> "" Then
        existsFile = True
    Else
        existsFile = False
    End If
End Function

Private Sub resetProgress(ByVal max As Long)
    frmImportDlg.ProgressBar1.Min = 0
    frmImportDlg.ProgressBar1.max = max
    frmImportDlg.ProgressBar1.value = 0
End Sub

Private Sub addProgress()
    If frmImportDlg.ProgressBar1.value = frmImportDlg.ProgressBar1.max Then
        Exit Sub
    End If
    frmImportDlg.ProgressBar1.value = frmImportDlg.ProgressBar1.value + 1
End Sub

Private Sub addMsg(msg As String)
    frmImportDlg.txtMsg.Text = frmImportDlg.txtMsg.Text & msg & vbCrLf
    
End Sub
