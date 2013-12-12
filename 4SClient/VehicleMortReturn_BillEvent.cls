VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "VehicleMortReturn_BillEvent"
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



Private Sub m_BillInterface_BeforeSave(bCancel As Boolean)
    Dim classId_src As Long
    Dim billNo_src As String
    Dim vehicleId As Long
    vehicleId = Val(m_BillInterface.GetFieldValue("FBase1"))
    If vehicleId = 0 Then
        MsgBox "车辆不能为空", vbInformation, "金蝶提示"
        bCancel = True
        Exit Sub
    End If
    classId_src = Val(m_BillInterface.GetFieldValue("FClassID_SRC"))
    billNo_src = m_BillInterface.GetFieldValue("FBillNo_SRC")
    If classId_src = 0 Or billNo_src = "" Then
        MsgBox "按揭登记必须关联代办服务单", vbInformation, "金蝶提示"
        bCancel = True
        Exit Sub
    End If

End Sub

Private Sub m_BillInterface_AfterSelBill(ByVal lSelBillType As Long)
    Dim vehicleId As Integer
    vehicleId = Val(m_BillInterface.GetFieldValue("FBase1")) '车辆
    loadVehicleInfo vehicleId, -1
    loadVehicleSEOrderInfo lSelBillType
    

End Sub

Private Sub loadVehicleSEOrderInfo(ByVal lSelBillType As Long)
    If lSelBillType <> 200000045 Then '代办服务单
        Exit Sub
    End If
    
    Dim sql As String
    Dim rs As ADODB.Recordset
    Dim sourceId As Integer
    sourceId = m_BillInterface.GetFieldValue("FID_SRC") '来源单ID
    sql = "select FID_SRC,FBillNo_SRC,FEntryID_SRC,FIndex_SRC from T_ATS_AgentServiceSource where FID=" & sourceId
    Set rs = m_BillInterface.K3Lib.GetData(sql)
    If Not rs.EOF Then
        m_BillInterface.SetFieldValue "FID_SRC1", rs!FID_SRC '销售订单内码
        m_BillInterface.SetFieldValue "FBillNo_Src1", rs!FBillNo_SRC '销售订单编号
        m_BillInterface.SetFieldValue "FEntryID_Src1", rs!FEntryID_SRC '销售订单分录内码
        m_BillInterface.SetFieldValue "FInteger1", rs!FIndex_SRC '销售订单分录号
        
        
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

