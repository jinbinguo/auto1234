VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "VehicleMortgage_BillEvent"
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
    Dim vehicleId As Integer
    vehicleId = Val(m_BillInterface.GetFieldValue("FBase1")) '车辆
    loadVehicleInfo vehicleId, -1
    loadVehicleSEOrderInfo lSelBillType
    setReturnAmount

End Sub




Private Sub loadVehicleSEOrderInfo(ByVal lSelBillType As Long)
    If lSelBillType <> 200000045 Then '代办服务单
        Exit Sub
    End If
    
    Dim sql As String
    Dim rs As ADODB.Recordset
    Dim sourceId As Integer
    sourceId = m_BillInterface.GetFieldValue("FID_SRC") '来源单ID
    sql = "select FID_SRC,FBillNo_SRC,FEntryID_SRC,FIndex_SRC from T_ATS_AgentServiceSource where FClassID_SRC = 200000028 AND FID=" & sourceId
    Set rs = m_BillInterface.K3Lib.GetData(sql)
    If Not rs.EOF Then
        m_BillInterface.SetFieldValue "FID_SRC1", rs!FID_SRC '销售订单内码
        m_BillInterface.SetFieldValue "FBillNo_Src1", rs!FBillNo_SRC '销售订单编号
        m_BillInterface.SetFieldValue "FEntryID_Src1", rs!FEntryID_SRC '销售订单分录内码
        m_BillInterface.SetFieldValue "FInteger", rs!FIndex_SRC '销售订单分录号
      '  m_BillInterface.SetFieldValue "FClassID_Src1", 200000028 '销售订单类型
        
    End If
    

End Sub



Private Sub loadVehicleInfo(vehicleId As Integer, lRow As Long)
    Dim rs As ADODB.Recordset
    Dim sql As String
    If (vehicleId > 0) Then
        sql = "select FBrandName,FModelName,FSeriesName,FCfgDesc from V_ATS_Vehicle where FID=" & CStr(vehicleId)
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

Private Sub m_BillInterface_Change(ByVal dct As KFO.IDictionary, ByVal dctFld As KFO.IDictionary, ByVal Col As Long, ByVal Row As Long, Cancel As Boolean)
    If (dct("FKey") = "FAmount") Then '按揭金额
        setReturnAmount
    End If
End Sub

Private Sub setReturnAmount()
    Dim rs As ADODB.Recordset
    Dim sql As String
    Dim mortgageCompanyId As Long
    Dim mortgageAmount As Double
    mortgageCompanyId = Val(m_BillInterface.GetFieldValue("FBase2")) '按揭公司
    mortgageAmount = m_BillInterface.GetFieldValue("FAmount") '按揭金额
    sql = "select FReturnRate from T_ATS_MortgageReturnRate where FMortCompanyID =" & mortgageCompanyId
    Set rs = m_BillInterface.K3Lib.GetData(sql)
    If Not rs.EOF Then
        m_BillInterface.SetFieldValue "FAmount1", mortgageAmount * rs!FReturnRate / 100#
    End If
    

End Sub
