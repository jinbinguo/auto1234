VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "VehicleInWarehs_BillEvent"
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



Private Sub resetVehicleInfo(ByVal rs As ADODB.Recordset, ByVal lRow As Long)
    If rs.EOF Then
        Exit Sub
    End If
    m_BillInterface.SetFieldValue "FBaseProperty", rs!FSeriesName, lRow
    m_BillInterface.SetFieldValue "FBaseProperty1", rs!FModelName, lRow
    m_BillInterface.SetFieldValue "FBaseProperty2", rs!FCfgDesc, lRow
    m_BillInterface.SetFieldValue "FBaseProperty3", rs!FInteriorName, lRow
    m_BillInterface.SetFieldValue "FBaseProperty4", rs!FColorName, lRow
    m_BillInterface.SetFieldValue "FBaseProperty5", rs!FOptional, lRow

End Sub



Private Sub m_BillInterface_AfterFillRow(ByVal lRow As Long, ByVal dctPage As KFO.IDictionary, ByVal dctEntryData As KFO.IDictionary, ByVal dctLink As KFO.IDictionary)
     Dim vehicleId As Double
     Dim rs As ADODB.Recordset
     Dim sql As String
     vehicleId = Val(dctEntryData(m_BillInterface.DataSrv.TableInfo("map")("FBase1"))("FFLD"))
     If (vehicleId > 0) Then
       sql = "select isnull(FSeriesName,'') FSeriesName,isnull(FModelName,'') FModelName,isnull(FVin,'') FVin,isnull(FBrandName,'') FBrandName,isnull(FDriverFormName,'') FDriverFormName,isnull(FPowerFormName,'') FPowerFormName," & _
                 "isnull(FInteriorName,'') FInteriorName,isnull(FColorName,'') FColorName,isnull(FOptional,'') FOptional,isnull(FDisplacementName,'') FDisplacementName,isnull(FStereotypeName,'') FStereotypeName," & _
                 "isnull(FCfgDesc,'') FCfgDesc,isnull(FEngineNum,'') FEngineNum,isnull(FGearboxName,'') FGearboxName from V_ATS_Vehicle where FID=" & CStr(vehicleId)
       Set rs = m_BillInterface.K3Lib.GetData(sql)
       resetVehicleInfo rs, lRow
        
     End If
     
End Sub
