VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "DecorateWO_BillEvent"
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

Private Sub m_BillInterface_AfterFillRow(ByVal lRow As Long, ByVal dctPage As KFO.IDictionary, ByVal dctEntryData As KFO.IDictionary, ByVal dctLink As KFO.IDictionary)
    Dim sql As String
    Dim icitemId As Long
    Dim rs As ADODB.Recordset
    icitemId = Val(m_BillInterface.GetFieldValue("FBase5", lRow))
    If icitemId > 0 Then
        
        sql = "select FName,isNull(FModel,'') FModel from t_ICItem where FItemID = " & icitemId
        Set rs = m_BillInterface.K3Lib.GetData(sql)
        If Not rs.EOF Then
            m_BillInterface.SetFieldValue "FBaseProperty5", rs!FName, lRow
            m_BillInterface.SetFieldValue "FBaseProperty6", rs!FModel, lRow
        End If
    End If
    

End Sub

Private Sub m_BillInterface_AfterSelBill(ByVal lSelBillType As Long)
    Dim vehicleId As Integer
    Dim i As Integer
    vehicleId = Val(m_BillInterface.GetFieldValue("FBase2")) '����
    loadVehicleInfo vehicleId, -1
    Dim sql As String
    Dim rs As ADODB.Recordset
    
    Dim id_src As Long
    Dim dctIsPlan As KFO.Dictionary
    Set dctIsPlan = m_BillInterface.GetFieldInfoByKey("FComboBox", "", -1)
    If lSelBillType = 200000054 Then '��Ʒ���۶���
        id_src = m_BillInterface.GetFieldValue("FID_SRC", 1)
        sql = " select 1 from T_ATS_DecorationOrder  where FIsPlan=1 and FID = " & id_src
        Set rs = m_BillInterface.K3Lib.GetData(sql)
        If Not rs.EOF Then
            m_BillInterface.SetFieldValue "FComboBox", 2 '��װ����
            m_BillInterface.LockCell dctIsPlan, -1, True
        
        End If
        sql = "select FClassID_SRC,FID_SRC,FEntryID_SRC,FBillNo_SRC,FIndex_SRC  from T_ATS_DecorationOrderSource where fid=" & id_src
        Set rs = m_BillInterface.K3Lib.GetData(sql)
        If Not rs.EOF Then
            If rs!FClassID_SRC = 200000028 Then '�������۶���
                'm_BillInterface.SetFieldValue "FClassID_SRC1", rs!FClassID_SRC
                m_BillInterface.SetFieldValue "FID_SRC1", rs!FID_SRC
                m_BillInterface.SetFieldValue "FEntryID_SRC1", rs!FEntryID_SRC
                m_BillInterface.SetFieldValue "FBillNo_SRC1", rs!FBillNo_SRC
                m_BillInterface.SetFieldValue "FInteger", rs!FIndex_SRC
            End If
            
        End If
    End If
End Sub


Private Sub loadVehicleInfo(vehicleId As Integer, lRow As Long)
    Dim rs As ADODB.Recordset
    Dim sql As String
    If (vehicleId > 0) Then
        sql = "select FSeriesName,FModelName,FPlateNum,FCfgDesc from V_ATS_Vehicle " & _
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
        m_BillInterface.SetFieldValue "FBaseProperty1", rs!FSeriesName, lRow
        m_BillInterface.SetFieldValue "FBaseProperty2", rs!FModelName, lRow
        m_BillInterface.SetFieldValue "FBaseProperty3", rs!FPlateNum, lRow
        m_BillInterface.SetFieldValue "FBaseProperty4", rs!FCfgDesc, lRow
    End If
End Sub



Private Sub m_BillInterface_Change(ByVal dct As KFO.IDictionary, ByVal dctFld As KFO.IDictionary, ByVal Col As Long, ByVal Row As Long, Cancel As Boolean)
    Dim itemId As Long
    Dim rs As ADODB.Recordset
    Dim sql As String
    If (dct("FKey") = "FDecimal") Then '��ʱ��
        itemId = Val(m_BillInterface.GetFieldValue("FBase3", Row)) '�ӹ���Ŀ
        sql = "select FManHourFee/FManHour manHourFee from T_ATS_DecorationItem where fid=" & itemId
        Set rs = m_BillInterface.K3Lib.GetData(sql)
        If Not rs.EOF Then
            m_BillInterface.SetFieldValue "FDecimal1", rs!manHourFee * dctFld("FFLD")
            
        End If
        
        
        
    End If
End Sub