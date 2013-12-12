VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "VehicleAlterCfg_BillEvent"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Attribute VB_Description = "This is BillEvent Interface Class, made by K3BOSPLUGINSWIZAED"
 
'定义 BillEvent 接口. 必须具有的声明, 以此来获得事件
Private WithEvents m_BillInterface  As BillEvent
Attribute m_BillInterface.VB_VarHelpID = -1
 
Public Sub Show(ByVal oBillInterface As Object)
 
    'BillEvent 接口实现
    '注意: 此方法必须存在, 请勿修改
    Set m_BillInterface = oBillInterface
    RegUtils.validateLicenseClient m_BillInterface
End Sub

Private Sub Class_Terminate()
 
    '释放接口对象
    '注意: 此方法必须存在, 请勿修改
    Set m_BillInterface = Nothing

End Sub


Private Sub m_BillInterface_AfterSelBill(ByVal lSelBillType As Long)
    Dim vehicleId As Long
    vehicleId = Val(m_BillInterface.GetFieldValue("FBase"))
    If vehicleId > 0 Then
        loadVehicleInfo vehicleId, -1
    End If

End Sub


Private Sub m_BillInterface_Change(ByVal dct As KFO.IDictionary, ByVal dctFld As KFO.IDictionary, ByVal Col As Long, ByVal Row As Long, Cancel As Boolean)
    Dim vehicleId As Long
    If dct("FKey") = "FBase" Then '车辆
        vehicleId = Val(m_BillInterface.GetFieldValue("FBase"))
        If vehicleId > 0 Then
            loadVehicleInfo vehicleId, Row
        End If
    End If
End Sub


Private Sub loadVehicleInfo(vehicleId As Long, lRow As Long)
    Dim rs As ADODB.Recordset
    Dim sql As String
    If (vehicleId > 0) Then
        sql = "select b.FName FModelName,c.FName FColorName,d.FName FInteriorName,a.FOptional,a.FCfgDesc," & _
            "b.FNumber FModelNum,c.FNumber FColorNum,d.FNumber FInteriorNum,b.FID FModelID,c.FID FColorID,d.FID FInteriorID from t_ATS_Vehicle a " & _
            "left join T_ATS_Model  b on b.FID=a.FModelID and b.FID <> 0 " & _
            "left join v_ats_color c on c.FID = a.FColorID and c.fid <> 0 " & _
            "left join v_ats_interior d on d.FID = a.FInteriorID and d.FID <> 0 " & _
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
        m_BillInterface.SetFieldValue "FText", rs!FModelName, lRow
        m_BillInterface.SetFieldValue "FText1", rs!FColorName, lRow
        m_BillInterface.SetFieldValue "FText2", rs!FOptional, lRow
        m_BillInterface.SetFieldValue "FText3", rs!FInteriorName, lRow
        m_BillInterface.SetFieldValue "FText4", rs!FCfgDesc, lRow
        
        m_BillInterface.SetFieldValue "FBase1", rs!FModelNum, lRow
        m_BillInterface.SetFieldValue "FBase2", rs!FColorNum, lRow
        m_BillInterface.SetFieldValue "FBase3", rs!FInteriorNum, lRow
        m_BillInterface.SetFieldValue "FText5", rs!FOptional, lRow
        m_BillInterface.SetFieldValue "FText6", rs!FCfgDesc, lRow
        
        m_BillInterface.SetFieldValue "FInteger", rs!FModelID, lRow
        m_BillInterface.SetFieldValue "FInteger1", rs!FColorID, lRow
        m_BillInterface.SetFieldValue "FInteger2", rs!FInteriorID, lRow
        
    End If
End Sub



