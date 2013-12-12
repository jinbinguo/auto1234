VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "AgentService_BillEvent"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Attribute VB_Description = "This is BillEvent Interface Class, made by K3BOSPLUGINSWIZAED"
 
'���� BillEvent �ӿ�. ������е�����, �Դ�������¼�
Private WithEvents m_BillInterface  As BillEvent
Attribute m_BillInterface.VB_VarHelpID = -1
 
Public Sub Show(ByVal oBillInterface As Object)
 
    'BillEvent �ӿ�ʵ��
    'ע��: �˷����������, �����޸�
    Set m_BillInterface = oBillInterface
    RegUtils.validateLicenseClient m_BillInterface
End Sub

Private Sub Class_Terminate()
    
 
    '�ͷŽӿڶ���
    'ע��: �˷����������, �����޸�
    Set m_BillInterface = Nothing

End Sub

Private Sub m_BillInterface_AfterSelBill(ByVal lSelBillType As Long)
    Dim dctVehicle As Object
    Dim dctModel As Object
    Dim dctFldVehicle As KFO.Dictionary
    Dim dctFldModel As KFO.Dictionary
    Dim dctDisByVehicle As KFO.Dictionary
    
    Set dctVehicle = m_BillInterface.GetDataFldbyKey("FBase1")
    Set dctFldVehicle = m_BillInterface.GetFieldInfoByKey("FBase1", "", -1)
    Set dctDisByVehicle = m_BillInterface.GetFieldInfoByKey("FAmount9", "", -1)

         
    If (Not dctVehicle Is Nothing And Val(dctVehicle("FFLD")) > 0) Then '��� �����Զ�������������ֵ
        m_BillInterface_Change dctFldVehicle, dctVehicle, -1, -1, False
    End If
    If (lSelBillType = 200000028) Then '��Դ��Ϊ�������۶���
        Dim entryId_src As Integer
        Dim id_src As Integer
        Dim rs As ADODB.Recordset
        entryId_src = Val(m_BillInterface.GetFieldValue("FEntryID_SRC"))
        id_src = Val(m_BillInterface.GetFieldValue("FID_SRC"))
        Set rs = m_BillInterface.K3Lib.GetData("select FIndex from T_ATS_VehicleSaleOrderEntry where fid=" & id_src & " and FEntryId=" & entryId_src)
        If Not rs.EOF Then
            m_BillInterface.SetFieldValue "FInteger1", rs!FIndex
        End If
    End If
    
    setDisByVehicleUI
End Sub

Private Sub m_BillInterface_AfterLoadBill()
    setDisByVehicleUI
End Sub

Private Sub setDisByVehicleUI()

    Dim dctDisByVehicle As KFO.Dictionary
    Set dctDisByVehicle = m_BillInterface.GetFieldInfoByKey("FAmount9", "", -1)
    Dim sourceId As Long
    sourceId = Val(m_BillInterface.GetFieldValue("FID_Src"))
    If sourceId > 0 Then
        dctDisByVehicle("FLock") = 24
        m_BillInterface.LockCell dctDisByVehicle, -1, False
    Else
        m_BillInterface.LockCell dctDisByVehicle, -1, True
    End If
End Sub



Private Sub m_BillInterface_Change(ByVal dct As KFO.IDictionary, ByVal dctFld As KFO.IDictionary, ByVal Col As Long, ByVal Row As Long, Cancel As Boolean)
    Dim rs As ADODB.Recordset
    Dim dctARAmount As KFO.Dictionary
    
    Set dctARAmount = m_BillInterface.GetFieldInfoByKey("FAmount8", "", -1)
    
    If dct("FKey") = "FBase1" Then '����
        Dim vehicleId As Integer
        vehicleId = Val(dctFld("FFLD"))
        loadVehicleInfo vehicleId, Row
    ElseIf dct("FKey") = "FBase2" Then '������Ŀ
        Set rs = m_BillInterface.K3Lib.GetData("select isnull(FStandardAmount,0) FStandardAmount from T_ATS_AgentItem where FId=" & Val(dctFld("FFLD")))
        If Not rs.EOF Then
            m_BillInterface.SetFieldValue "FAmount1", rs!FStandardAmount, Row '��˰�ϼ�

            m_BillInterface.SetFieldValue "FAmount3", rs!FStandardAmount, Row '��˰Ӧ�ս��

            m_BillInterface.SetFieldValue "FAmount4", rs!FStandardAmount / (1 + 17 / 100#), Row '����˰Ӧ�ս��
            m_BillInterface.SetFieldValue "FAmount5", rs!FStandardAmount - rs!FStandardAmount / (1 + 17 / 100#), Row '˰��
            m_BillInterface.SetFieldValue "FAmount9", 0, Row '�泵���ͽ��
            m_BillInterface.SetFieldValue "FAmount8", rs!FStandardAmount '��Ӧ�ս��
            
            m_BillInterface.SetFieldValue "FAmount", m_BillInterface.Sum(dctARAmount)
            
            ' �������������������ֶ�
        End If
    End If

End Sub



Private Sub loadVehicleInfo(vehicleId As Integer, lRow As Long)
    Dim rs As ADODB.Recordset
    Dim sql As String
    If (vehicleId > 0) Then
        sql = "select FBrandName,FModelName,FSeriesName,FCfgDesc from V_ATS_Vehicle " & _
            "where FID=" & CStr(vehicleId)
        Set rs = m_BillInterface.K3Lib.GetData(sql)
        setVehicleInfo rs, lRow
    End If
    
End Sub

Private Sub setVehicleInfo(rs As ADODB.Recordset, lRow As Long)
    If rs Is Nothing Then
        Exit Sub
    End If
    If (Not rs.EOF) Then
        m_BillInterface.SetFieldValue "FBaseProperty", rs!FBrandName, lRow
        m_BillInterface.SetFieldValue "FBaseProperty2", rs!FModelName, lRow
        m_BillInterface.SetFieldValue "FBaseProperty1", rs!FSeriesName, lRow
        m_BillInterface.SetFieldValue "FBaseProperty3", rs!FCfgDesc, lRow
    End If
End Sub
