VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "VehicleHangtag_BillEvent"
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

Private Sub m_BillInterface_BeforeSave(bCancel As Boolean)
    Dim classId_src As Long
    Dim billNo_src As String
    Dim vehicleId As Long
    vehicleId = Val(m_BillInterface.GetFieldValue("FBase1"))
    If vehicleId = 0 Then
        MsgBox "��������Ϊ��", vbInformation, "�����ʾ"
        bCancel = True
        Exit Sub
    End If
    classId_src = Val(m_BillInterface.GetFieldValue("FClassID_SRC"))
    billNo_src = m_BillInterface.GetFieldValue("FBillNo_SRC")
    If classId_src = 0 Or billNo_src = "" Then
        MsgBox "���ƵǼǱ�������������", vbInformation, "�����ʾ"
        bCancel = True
        Exit Sub
    End If

End Sub

Private Sub m_BillInterface_AfterSelBill(ByVal lSelBillType As Long)
    Dim vehicleId As Integer
    vehicleId = Val(m_BillInterface.GetFieldValue("FBase1")) '����
    loadVehicleInfo vehicleId, -1
    loadVehicleSEOrderInfo lSelBillType
    

End Sub

Private Sub loadVehicleSEOrderInfo(ByVal lSelBillType As Long)
    If lSelBillType <> 200000045 Then '�������
        Exit Sub
    End If
    
    Dim sql As String
    Dim rs As ADODB.Recordset
    Dim sourceId As Integer
    sourceId = m_BillInterface.GetFieldValue("FID_SRC") '��Դ��ID
    sql = "select FID_SRC,FBillNo_SRC,FEntryID_SRC,FIndex_SRC from T_ATS_AgentServiceSource where FClassID_SRC = 200000028 AND FID=" & sourceId
    Set rs = m_BillInterface.K3Lib.GetData(sql)
    If Not rs.EOF Then
        m_BillInterface.SetFieldValue "FID_SRC1", rs!FID_SRC '���۶�������
        m_BillInterface.SetFieldValue "FBillNo_Src1", rs!FBillNo_SRC '���۶������
        m_BillInterface.SetFieldValue "FEntryID_Src1", rs!FEntryID_SRC '���۶�����¼����
        m_BillInterface.SetFieldValue "FInteger", rs!FIndex_SRC '���۶�����¼��
      '  m_BillInterface.SetFieldValue "FClassID_Src1", 200000028 '���۶�������
        
        
    End If
    

End Sub



Private Sub loadVehicleInfo(vehicleId As Integer, lRow As Long)
    Dim rs As ADODB.Recordset
    Dim sql As String
    If (vehicleId > 0) Then
        sql = "select isnull(a.FSeriesName,'') FSeriesName,isnull(a.FModelName,'') FModelName,isnull(a.FVin,'') FVin," & _
            "isnull(a.FBrandName,'') FBrandName,isnull(a.FDriverFormName,'') FDriverFormName,isnull(a.FPowerFormName,'') FPowerFormName," & _
            "isnull(a.FInteriorName,'') FInteriorName,isnull(a.FColorName,'') FColorName,isnull(a.FOptional,'') FOptional," & _
            "isnull(a.FDisplacementName,'') FDisplacementName,isnull(a.FStereotypeName,'') FStereotypeName," & _
            "isnull(a.FCfgDesc,'') FCfgDesc,isnull(a.FEngineNum,'') FEngineNum,isnull(a.FGearboxName,'') FGearboxName," & _
            "c.FNumber FModelNum,d.FNumber FInteriorNum,e.FNumber FColorNum,f.FNumber FICItemNum,g.FNumber FUnitNum," & _
            "isnull(a.FMakerModelNum,'') FMakerModelNum,a.FCarSourceName " & _
            "from V_ATS_Vehicle a " & _
            "left join T_ATS_Model c on c.FID<>0 and c.FID=a.FModelID " & _
            "left join v_ats_interior d on d.FID<>0 and d.FID=a.FInteriorID " & _
            "left join v_ats_color e on e.FID<>0 and e.FID=a.FColorID " & _
            "left join t_ICItem f on f.FItemID<> 0 and f.FItemID=a.FICItemID " & _
            "left join t_MeasureUnit g on g.FItemID<>0 and g.FItemID=a.FUnitID " & _
            "where a.FID=" & CStr(vehicleId)
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
        m_BillInterface.SetFieldValue "FBaseProperty1", rs!FSeriesName, lRow
        m_BillInterface.SetFieldValue "FBaseProperty2", rs!FModelName, lRow
        m_BillInterface.SetFieldValue "FBaseProperty3", rs!FCfgDesc, lRow
    End If
End Sub
