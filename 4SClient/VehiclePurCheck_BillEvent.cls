VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "VehiclePurCheck_BillEvent"
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

' 在BOTP转单下，车辆关联数据重取
Private Sub loadVehicleForBotpNew(ByVal vehicleId As Integer, ByVal Row As Long)
    Dim rs As ADODB.Recordset
    Dim sql As String
    If (vehicleId > 0) Then
        sql = "select isnull(a.FSeriesName,'') FSeriesName,isnull(a.FModelName,'') FModelName,isnull(a.FVin,'') FVin," & _
            "isnull(a.FBrandName,'') FBrandName,isnull(a.FDriverFormName,'') FDriverFormName,isnull(a.FPowerFormName,'') FPowerFormName," & _
            "isnull(a.FInteriorName,'') FInteriorName,isnull(a.FColorName,'') FColorName,isnull(a.FOptional,'') FOptional," & _
            "isnull(a.FDisplacementName,'') FDisplacementName,isnull(a.FStereotypeName,'') FStereotypeName," & _
            "isnull(a.FCfgDesc,'') FCfgDesc,isnull(a.FEngineNum,'') FEngineNum,isnull(a.FGearboxName,'') FGearboxName," & _
            "b.FNumber FSeriesNum,c.FNumber FModelNum,d.FNumber FInteriorNum,e.FNumber FColorNum,f.FNumber FICItemNum,g.FNumber FUnitNum," & _
            "isnull(a.FMakerModelNum,'') FMakerModelNum,a.FCarSourceName " & _
            "from V_ATS_Vehicle a " & _
            "left join T_ATS_Series b on b.FID<>0 and b.FID=a.FSeriesID " & _
            "left join T_ATS_Model c on c.FID<>0 and c.FID=a.FModelID " & _
            "left join v_ats_interior d on d.FID<>0 and d.FID=a.FInteriorID " & _
            "left join v_ats_color e on e.FID<>0 and e.FID=a.FColorID " & _
            "left join t_ICItem f on f.FItemID<> 0 and f.FItemID=a.FICItemID " & _
            "left join t_MeasureUnit g on g.FItemID<>0 and g.FItemID=a.FUnitID " & _
            "where a.FID=" & CStr(vehicleId)
        Set rs = m_BillInterface.K3Lib.GetData(sql)
    End If
    If rs.EOF Then
        Exit Sub
    End If
    'm_BillInterface.SetFieldValue "FBase3", rs!FModelNum, row
    m_BillInterface.SetFieldValue "FBaseProperty", rs!FSeriesName, Row
    m_BillInterface.SetFieldValue "FBaseProperty1", rs!FCfgDesc, Row
    m_BillInterface.SetFieldValue "FBaseProperty2", rs!FMakerModelNum, Row
   ' m_BillInterface.SetFieldValue "FBaseProperty3", rs!FBrandName, Row
   ' m_BillInterface.SetFieldValue "FBaseProperty4", rs!FDisplacementName, Row
   ' m_BillInterface.SetFieldValue "FBaseProperty5", rs!FGearboxName, Row
   ' m_BillInterface.SetFieldValue "FBaseProperty6", rs!FPowerFormName, Row
   ' m_BillInterface.SetFieldValue "FBaseProperty7", rs!FDriverFormName, Row
   ' m_BillInterface.SetFieldValue "FBaseProperty8", rs!FStereotypeName, Row
   ' m_BillInterface.SetFieldValue "FBaseProperty9", rs!FCarSourceName, Row
End Sub

' 在BOTP转单下，车型关联数据重取
Private Sub loadModelForBotpNew(ByVal modelId As Integer, ByVal Row As Long)
    Dim rs As ADODB.Recordset
    Dim sql As String
    If (modelId > 0) Then
        sql = "select b.FNumber FSeriesNum,a.FCfgDesc,c.FNumber FICItemNum," & _
             "d.FNumber FUnitNum,a.FMakerModelNum,a.FBrandName,a.FGearboxName,a.FPowerFormName," & _
             "a.FStereotypeName , a.FDriverFormName, a.FCarSourceName, a.FDisplacementName,a.FSeriesName " & _
             "from v_ats_model a " & _
             "left join T_ATS_Series b on b.FID<>0 and b.FID=a.FSeriesID " & _
             "left join t_ICItem c on c.FItemID<>0 and c.FItemID=a.FICItemID " & _
             "left join t_MeasureUnit d on d.FItemID<> 0 and d.FItemID=a.FUnitID" & _
             " where a.FID=" & CStr(modelId)
        Set rs = m_BillInterface.K3Lib.GetData(sql)
    End If
    If rs.EOF Then
        Exit Sub
   End If
    
    'm_BillInterface.SetFieldValue "FBase3", rs!FModelNum, row
    m_BillInterface.SetFieldValue "FBaseProperty", rs!FSeriesName, Row
    m_BillInterface.SetFieldValue "FBaseProperty1", rs!FCfgDesc, Row
    m_BillInterface.SetFieldValue "FBaseProperty2", rs!FMakerModelNum, Row
 '   m_BillInterface.SetFieldValue "FBaseProperty3", rs!FBrandName, Row
 '   m_BillInterface.SetFieldValue "FBaseProperty4", rs!FDisplacementName, Row
 '   m_BillInterface.SetFieldValue "FBaseProperty5", rs!FGearboxName, Row
 '   m_BillInterface.SetFieldValue "FBaseProperty6", rs!FPowerFormName, Row
 '   m_BillInterface.SetFieldValue "FBaseProperty7", rs!FDriverFormName, Row
 '   m_BillInterface.SetFieldValue "FBaseProperty8", rs!FStereotypeName, Row
 '   m_BillInterface.SetFieldValue "FBaseProperty9", rs!FCarSourceName, Row
End Sub



Private Sub m_BillInterface_AfterFillRow(ByVal lRow As Long, ByVal dctPage As KFO.IDictionary, ByVal dctEntryData As KFO.IDictionary, ByVal dctLink As KFO.IDictionary)
    Dim dctModel As KFO.Dictionary
    Dim dctVehicle As KFO.Dictionary
    Dim i As Integer
    
    '解决BOTP关联字段无法带出
    If m_BillInterface.BillStatus = Enu_BillStatusExt_New Then
            i = lRow
         Set dctVehicle = m_BillInterface.GetDataFldbyKey("FBase2", i) '车辆
         Set dctModel = m_BillInterface.GetDataFldbyKey("FBase3", i) '车型
         If Val(dctVehicle("FFLD")) > 0 Then
            loadVehicleForBotpNew dctVehicle("FFLD"), i
         ElseIf Val(dctModel("FFLD")) > 0 Then
            loadModelForBotpNew dctModel("FFLD"), i
         End If
    
    End If
    
End Sub

