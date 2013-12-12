VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "DecorationOrder_BillEvent"
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



Private Sub m_BillInterface_AfterLoadBill()
    setDisByVehicleUI
End Sub

Private Sub m_BillInterface_AfterSelBill(ByVal lSelBillType As Long)
    Dim vehicleId As Integer
    vehicleId = Val(m_BillInterface.GetFieldValue("FBase2")) '车辆
    loadVehicleInfo vehicleId, -1
    setDisByVehicleUI
End Sub


Private Sub setDisByVehicleUI()

    Dim dctDisByVehicle As KFO.Dictionary
    Set dctDisByVehicle = m_BillInterface.GetFieldInfoByKey("FAmount10", "", -1)
    Dim sourceId As Long
    sourceId = Val(m_BillInterface.GetFieldValue("FID_Src"))
    If sourceId > 0 Then
        dctDisByVehicle("FLock") = 24
        m_BillInterface.LockCell dctDisByVehicle, -1, False
    Else
        m_BillInterface.LockCell dctDisByVehicle, -1, True
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
