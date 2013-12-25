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
        Err.Raise 1, "Auto4S_License", "�������Ʋ����ڣ�������֤��ҵ����4S��ȨLicense!"
    End If
    
    sql = "select FMachineCiphertext,FOrgNameCiphertext,FBeginDateCiphertext,FEndDateCiphertext  from T_ATS_RegInfo "
    Set rs = m_BillInterface.K3Lib.GetData(sql)
    If Not rs.EOF Then
     '�ͻ�����ȡ����������������
     '   If Not machineId = ENUtils.decode(orgName, rs!FMachineCiphertext) Then
     '       Err.Raise 2, "Auto4S_License", "��ҵ����4S��ȨLicense��֤��ͨ��!"
     '   End If
        If Not orgName = ENUtils.decode(orgName, rs!FOrgNameCiphertext) Then
            Err.Raise 2, "Auto4S_License", "��ҵ����4S��ȨLicense��֤��ͨ��!(�����쳣)"
        End If
        beginDate = ENUtils.decode(orgName, rs!FBeginDateCiphertext)
        endDate = ENUtils.decode(orgName, rs!FEndDateCiphertext)
    Else
        Err.Raise 2, "Auto4S_License", "��ҵ����4S��ȨLicense��֤��ͨ��!(ȱʧLicense)"
    End If
    
    sql = "select GETDATE() as currentDate"
    Set rs = m_BillInterface.K3Lib.GetData(sql)
    currentDate = rs!currentDate
    dBegin = CDate(beginDate)
    dEnd = CDate(endDate)
    dNow = CDate(currentDate)
    If (DateDiff("d", dBegin, currentDate) < 0) Or (DateDiff("d", currentDate, endDate) < 0) Then
         Err.Raise 3, "Auto4S_License", "��ҵ����4S��Ȩ�ѳ���ʱ�ޣ�����������!"
    End If
    
    Exit Sub
     
errLine:
    If Err.Number = 13 Then '��������ת������
        Err.Raise Err.Number, Auto4S_License, "��ҵ����4S��ȨLicense��֤��ͨ��!(����ת������)"

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
        Err.Raise 1, "Auto4S_License", "�������Ʋ����ڣ�������֤��ҵ����4S��Ȩ�������������µ���"
    End If
    
    sql = "select FMachineCiphertext,FOrgNameCiphertext,FBeginDateCiphertext,FEndDateCiphertext  from T_ATS_RegInfo "
    Set rs = m_cnn.Execute(sql)
    If Not rs.EOF Then
        If Not machineId = ENUtils.decode(orgName, rs!FMachineCiphertext) Then
            Err.Raise 2, "Auto4S_License", "��ҵ����4S��ȨLicense��֤��ͨ�����������浥��"
        End If
        If Not orgName = ENUtils.decode(orgName, rs!FOrgNameCiphertext) Then
            Err.Raise 2, "Auto4S_License", "��ҵ����4S��ȨLicense��֤��ͨ�����������浥��"
        End If
        beginDate = ENUtils.decode(orgName, rs!FBeginDateCiphertext)
        endDate = ENUtils.decode(orgName, rs!FEndDateCiphertext)
    Else
        Err.Raise 2, "Auto4S_License", "��ҵ����4S��ȨLicense��֤��ͨ�����������浥��"
    End If
    
    sql = "select GETDATE() as currentDate"
    Set rs = m_cnn.Execute(sql)
    currentDate = rs!currentDate
    dBegin = CDate(beginDate)
    dEnd = CDate(endDate)
    dNow = CDate(currentDate)
    If (DateDiff("d", dBegin, currentDate) < 0) Or (DateDiff("d", currentDate, endDate) < 0) Then
        Err.Raise 3, "Auto4S_License", "��ҵ����4S��Ȩ�ѳ���ʱ�ޣ����������룬�������浥��"
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
        
    If Err.Number = 13 Then '��������ת������
        Err.Raise Err.Number, Auto4S_License, "��ҵ����4S��ȨLicense��֤��ͨ��!"
    Else
        Err.Raise Err.Number, Err.Source, Err.Description
    End If

End Sub
