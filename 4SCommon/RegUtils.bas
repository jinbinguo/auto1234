Attribute VB_Name = "RegUtils"
Public Sub validateLicenseClient(ByVal m_BillInterface As BillEvent)
    Dim sql As String
    Dim rs As ADODB.Recordset
    Dim machineId As String
    Dim orgName As String
    Dim beginDate As String
    Dim endDate As String
    Dim currentDate As String
    Dim dBegin As Date
    Dim dEnd As Date
    Dim dNow As Date
    On Error GoTo errLine
    machineId = ENUtils.getDiskKey
    sql = "select FValue from t_SystemProfile where FKey = 'CompanyName' and FCategory='General'"
    Set rs = m_BillInterface.K3Lib.GetData(sql)
    If Not rs.EOF Then
        orgName = rs!FValue
    Else
        Err.Raise 1, "Auto4S_License", "机构名称不存在，不能验证行业汽车4S授权License!"
    End If
    
    sql = "select FMachineCiphertext,FOrgNameCiphertext,FBeginDateCiphertext,FEndDateCiphertext  from T_ATS_RegInfo "
    Set rs = m_BillInterface.K3Lib.GetData(sql)
    If Not rs.EOF Then
     '客户机获取不到服务器机器码
     '   If Not machineId = ENUtils.decode(orgName, rs!FMachineCiphertext) Then
     '       Err.Raise 2, "Auto4S_License", "行业汽车4S授权License验证不通过!"
     '   End If
        If Not orgName = ENUtils.decode(orgName, rs!FOrgNameCiphertext) Then
            Err.Raise 2, "Auto4S_License", "行业汽车4S授权License验证不通过!(机构异常)"
        End If
        beginDate = ENUtils.decode(orgName, rs!FBeginDateCiphertext)
        endDate = ENUtils.decode(orgName, rs!FEndDateCiphertext)
    Else
        Err.Raise 2, "Auto4S_License", "行业汽车4S授权License验证不通过!(缺失License)"
    End If
    
    sql = "select GETDATE() as currentDate"
    Set rs = m_BillInterface.K3Lib.GetData(sql)
    currentDate = rs!currentDate
    dBegin = CDate(beginDate)
    dEnd = CDate(endDate)
    dNow = CDate(currentDate)
    If (DateDiff("d", dBegin, currentDate) < 0) Or (DateDiff("d", currentDate, endDate) < 0) Then
         Err.Raise 3, "Auto4S_License", "行业汽车4S授权已超过时限，请重新申请!"
    End If
    
    Exit Sub
     
errLine:
    If Err.Number = 13 Then '可能日期转换错误
        Err.Raise Err.Number, Auto4S_License, "行业汽车4S授权License验证不通过!(日期转换错误)"

    Else
        Err.Raise Err.Number, Err.Source, Err.Description
    End If
End Sub


Public Sub validateLicenseServer(ByVal sDsn As String)
    Dim m_cnn As ADODB.Connection
    Set m_cnn = New ADODB.Connection
    On Error GoTo errLine
    
    m_cnn.Open GetConnectiongString(sDsn)
    Dim sql As String
    Dim rs As ADODB.Recordset
    Dim machineId As String
    Dim orgName As String
    Dim beginDate As String
    Dim endDate As String
    Dim currentDate As String
    Dim dBegin As Date
    Dim dEnd As Date
    Dim dNow As Date
    machineId = ENUtils.getDiskKey
    sql = "select FValue from t_SystemProfile where FKey = 'CompanyName' and FCategory='General'"
    Set rs = m_cnn.Execute(sql)
    If Not rs.EOF Then
        orgName = rs!FValue
    Else
        Err.Raise 1, "Auto4S_License", "机构名称不存在，不能验证行业汽车4S授权，将不允许保存新单据"
    End If
    
    sql = "select FMachineCiphertext,FOrgNameCiphertext,FBeginDateCiphertext,FEndDateCiphertext  from T_ATS_RegInfo "
    Set rs = m_cnn.Execute(sql)
    If Not rs.EOF Then
        If Not machineId = ENUtils.decode(orgName, rs!FMachineCiphertext) Then
            Err.Raise 2, "Auto4S_License", "行业汽车4S授权License验证不通过，不允许保存单据"
        End If
        If Not orgName = ENUtils.decode(orgName, rs!FOrgNameCiphertext) Then
            Err.Raise 2, "Auto4S_License", "行业汽车4S授权License验证不通过，不允许保存单据"
        End If
        beginDate = ENUtils.decode(orgName, rs!FBeginDateCiphertext)
        endDate = ENUtils.decode(orgName, rs!FEndDateCiphertext)
    Else
        Err.Raise 2, "Auto4S_License", "行业汽车4S授权License验证不通过，不允许保存单据"
    End If
    
    sql = "select GETDATE() as currentDate"
    Set rs = m_cnn.Execute(sql)
    currentDate = rs!currentDate
    dBegin = CDate(beginDate)
    dEnd = CDate(endDate)
    dNow = CDate(currentDate)
    If (DateDiff("d", dBegin, currentDate) < 0) Or (DateDiff("d", currentDate, endDate) < 0) Then
        Err.Raise 3, "Auto4S_License", "行业汽车4S授权已超过时限，请重新申请，不允许保存单据"
    End If
    

    If Not m_cnn Is Nothing Then
        m_cnn.Close
    End If
    Set m_cnn = Nothing
    Exit Sub
     
errLine:
    If Not m_cnn Is Nothing Then
        m_cnn.Close
    End If
    Set m_cnn = Nothing
        
    If Err.Number = 13 Then '可能日期转换错误
        Err.Raise Err.Number, Auto4S_License, "行业汽车4S授权License验证不通过!"
    Else
        Err.Raise Err.Number, Err.Source, Err.Description
    End If

End Sub
