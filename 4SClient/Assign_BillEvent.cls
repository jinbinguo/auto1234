VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "Assign_BillEvent"
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
    
'    Dim dct As Object
'
'    Set dct = m_BillInterface.GetDataFldbyKey("FBase2")
'
'    If (Not (dct Is Nothing) And m_BillInterface.BillStatus = Enu_BillStatusExt_New) Then '解决 车型自动带出其他属性值
'        m_BillInterface.SetFieldValue "FBase2", dct("FFND")
'    End If
    RegUtils.validateLicenseClient m_BillInterface
 
End Sub

Private Sub Class_Terminate()
 
    '释放接口对象
    '注意: 此方法必须存在, 请勿修改
    Set m_BillInterface = Nothing

End Sub

Private Sub m_BillInterface_AfterSelBill(ByVal lSelBillType As Long)
    Dim dctVehicle As Object
    Dim dctModel As Object
    Dim dctFldVehicle As KFO.Dictionary
    Dim dctFldModel As KFO.Dictionary
    
    Set dctVehicle = m_BillInterface.GetDataFldbyKey("FBase1")
    Set dctModel = m_BillInterface.GetDataFldbyKey("FBase2")
    Set dctFldVehicle = m_BillInterface.GetFieldInfoByKey("FBase1", "", -1)
    Set dctFldModel = m_BillInterface.GetFieldInfoByKey("FBase2", "", -1)
         
    If (Not dctVehicle Is Nothing And Val(dctVehicle("FFLD")) > 0) Then '解决 车辆自动带出其他属性值
        m_BillInterface_Change dctFldVehicle, dctVehicle, -1, -1, False
    ElseIf (Not dctModel Is Nothing And Val(dctModel("FFLD")) > 0) Then
        m_BillInterface_Change dctFldModel, dctModel, -1, -1, False
    End If
    
    If (lSelBillType = 200000028) Then '来源单为整车销售订单
        Dim entryId_src As Integer
        Dim id_src As Integer
        Dim rs As ADODB.Recordset
        entryId_src = Val(m_BillInterface.GetFieldValue("FEntryID_SRC"))
        id_src = Val(m_BillInterface.GetFieldValue("FID_SRC"))
        Set rs = m_BillInterface.K3Lib.GetData("select FIndex from T_ATS_VehicleSaleOrderEntry where fid=" & id_src & " and FEntryId=" & entryId_src)
        If Not rs.EOF Then
            m_BillInterface.SetFieldValue "FInteger", rs!FIndex
        End If
        
    End If
    
    
        
End Sub

Private Sub m_BillInterface_Change(ByVal dct As KFO.IDictionary, ByVal dctFld As KFO.IDictionary, ByVal Col As Long, ByVal row As Long, Cancel As Boolean)
    Dim rs As ADODB.Recordset
    If dct("FKey") = "FBase1" Then '车辆
        Dim vehicleId As Integer
        vehicleId = Val(dctFld("FFLD"))
        loadVehicleInfo vehicleId, row
    ElseIf dct("FKey") = "FBase2" Then '车型
        Dim modelId As Integer
        modelId = Val(dctFld("FFLD"))
        loadModelInfo modelId, row
    End If

End Sub



Private Sub loadVehicleInfo(vehicleId As Integer, lRow As Long)
    Dim rs As ADODB.Recordset
    Dim sql As String
    If (vehicleId > 0) Then
        sql = "select a.FVIN,a.FEngineNum,a.FOptional,b.FNumber stockNum, b.FName stockName,c.FInteriorNumber " & _
              "from V_ATS_Vehicle a " & _
              "left join t_Stock b on b.FItemID=a.FStockID and b.FItemID<>0 " & _
              "left join T_ATS_SeriesInterior c on c.FEntryID=a.FInteriorID and c.FID=a.FSeriesID " & _
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
        m_BillInterface.SetFieldValue "FBaseProperty11", rs!FVin, lRow '底盘号
        m_BillInterface.SetFieldValue "FBaseProperty12", rs!FEngineNum, lRow '发动机号
        m_BillInterface.SetFieldValue "FText", rs!FOptional, lRow '选装
        m_BillInterface.SetFieldValue "FBase5", rs!stockNum, lRow '所属仓库
        m_BillInterface.SetFieldValue "FBase4", rs!FInteriorNumber, lRow '内饰
    End If
End Sub

Private Sub loadModelInfo(modelId As Integer, lRow As Long)
    
    Dim rs As ADODB.Recordset
    Dim sql As String
    If (modelId > 0) Then
        sql = "select b.FName FSeriesName,b.FNumber FSeriesNum,a.FCfgDesc,c.FNumber FICItemNum," & _
             "d.FNumber FUnitNum,a.FMakerModelNum,a.FBrandName,a.FGearboxName,a.FPowerFormName," & _
             "a.FStereotypeName , a.FDriverFormName, a.FCarSourceName, a.FDisplacementName,a.FMakerGuidePrice,a.FCompGuidePrice " & _
             "from v_ats_model a " & _
             "left join T_ATS_Series b on b.FID<>0 and b.FID=a.FSeriesID " & _
             "left join t_ICItem c on c.FItemID<>0 and c.FItemID=a.FICItemID " & _
             "left join t_MeasureUnit d on d.FItemID<> 0 and d.FItemID=a.FUnitID" & _
             " where a.FID=" & CStr(modelId)
        Set rs = m_BillInterface.K3Lib.GetData(sql)
        setModelInfo rs, lRow
     End If
     
End Sub

Private Sub setModelInfo(rs As ADODB.Recordset, lRow As Long)
     If Not rs.EOF Then
        m_BillInterface.SetFieldValue "FBaseProperty", rs!FMakerModelNum, lRow '厂家车型代码
        m_BillInterface.SetFieldValue "FBaseProperty1", rs!FDisplacementName, lRow '排量
        m_BillInterface.SetFieldValue "FBaseProperty2", rs!FSeriesName, lRow '车系
        m_BillInterface.SetFieldValue "FBaseProperty3", rs!FGearboxName, lRow '变速箱
        m_BillInterface.SetFieldValue "FBaseProperty4", rs!FBrandName, lRow '品牌
        m_BillInterface.SetFieldValue "FBaseProperty5", rs!FPowerFormName, lRow '动力形式
        m_BillInterface.SetFieldValue "FBaseProperty6", rs!FStereotypeName, lRow '型/版
        m_BillInterface.SetFieldValue "FBaseProperty7", rs!FDriverFormName, lRow '驱动形式
        m_BillInterface.SetFieldValue "FBaseProperty8", rs!FCfgDesc, lRow '配置说明
        m_BillInterface.SetFieldValue "FBaseProperty9", rs!FMakerGuidePrice, lRow '厂家指导价
        m_BillInterface.SetFieldValue "FBaseProperty10", rs!FCompGuidePrice, lRow '公司指导价
        
    End If
End Sub


'Private Sub m_BillInterface_AfterSave(bCancel As Boolean)
'
'    'TODO: 请在此处添加代码响应事件
'    Dim sourceId As Long
'    Dim sourceEntryID As Long
'    Dim assignDate As Date
'    Dim personID As Long
'    Dim vehicleId As Long
'    Dim assignNum As String
'    Dim sql As String
'    Dim assignID As Long
'    Dim rs As ADODB.Recordset
'    Dim vin As String
'    Dim strOptional As String
'    Dim stockId As Long
'    sourceId = m_BillInterface.GetFieldValue("FID_SRC")
'
'    assignID = m_BillInterface.GetFieldValue("FID")
'    sourceEntryID = m_BillInterface.GetFieldValue("FEntryID_SRC")
'    assignDate = m_BillInterface.GetFieldValue("FDate")
'    personID = m_BillInterface.GetFieldValue("FBase")
'    vehicleId = m_BillInterface.GetFieldValue("FBase1")
'    assignNum = m_BillInterface.GetFieldValue("FBillNO")
'    vin = m_BillInterface.GetFieldValue("FBaseProperty11")
'    strOptional = m_BillInterface.GetFieldValue("FText")
'    stockId = m_BillInterface.GetFieldValue("FBase5") '仓库
'
'    '更新销售订单配车信息
'    sql = "update T_ATS_VehicleSaleOrderEntry " & _
'          "set FIsAssign = 1," & _
'          "FAssignDate = '" & FormatDateTime(assignDate) & "'," & _
'          "FVehicleID = " & vehicleId & ", " & _
'          "FAssignBillID=" & assignID & "," & _
'          "FAssignBillNo='" & assignNum & "'," & _
'          "FVin='" & vin & "'," & _
'          "FStockId=" & stockId & "," & _
'          "FOptional = '" & strOptional & "' " & _
'          "where FID=" & sourceId & " and FEntryID=" & sourceEntryID
'   m_BillInterface.K3Lib.UpdateData (sql)
'   '更新车辆状态为"已配车"
'   sql = "update t_ats_vehicle " & _
'         "set FVehicleStatus='2'," & _
'            "FCustomerID=(select FCustomerID from T_ATS_VehicleSaleOrder where fid=" & sourceId & "), " & _
'            "FOptional='" & strOptional & " '" & _
'         "where fid=" & vehicleId
'
'   m_BillInterface.K3Lib.UpdateData (sql)
'   '更新代办服务单车信息
'   sql = "update T_ATS_AgentService " & _
'        "set FVehicleID=" & vehicleId & _
'        "where FID=(select FID from T_ATS_AgentServiceSource where FID_SRC=" & sourceId & " and FEntryID_SRC=" & sourceEntryID & ")"
'   m_BillInterface.K3Lib.UpdateData (sql)
'
'   MsgBox "配车成功", vbInformation, "金蝶提示"
'   m_BillInterface.BillCtl.BillStatus = Enu_BillStatusExt_View
'   m_BillInterface.RefreshBill
'
'
'
'
'End Sub
'
'
'
'
'Private Sub m_BillInterface_MenuBarClick(ByVal BOSTool As K3ClassEvents.BOSTool, Cancel As Boolean)
'    Dim sql As String
'    Dim sourceId As Long
'    Dim sourceEntryID As Long
'    Dim rs As ADODB.Recordset
'
'    sourceId = Val(m_BillInterface.GetFieldValue("FID_SRC"))
'    sourceEntryID = Val(m_BillInterface.GetFieldValue("FEntryID_SRC"))
'
'    If BOSTool.ToolName = "mnuFileSave" Then '配车
'        sql = "select 1 from T_ATS_VehicleSaleOrderEntry where fisassign=1 and FID=" & sourceId & " and FEntryID=" & sourceEntryID
'        Set rs = m_BillInterface.K3Lib.GetData(sql)
'        If (Not rs.EOF) Then
'            MsgBox "已配车，若需重新配车，请先取消配车", vbInformation, "金蝶提示"
'            Cancel = True
'            Exit Sub
'        End If
'        If MsgBox("是否进行配车？", vbQuestion + vbYesNo, "金蝶提示") = vbNo Then
'                Cancel = True
'                Exit Sub
'            End If
'    End If
'
'    If BOSTool.ToolName = "unAssign" Then '取消配车
'        Dim vehicle As KFO.Dictionary
'        Set vehicle = m_BillInterface.GetDataFldbyKey("FBase1") '车辆
'
'        '是否已结算检查
'        sql = "select 1 from T_ATS_VehicleSaleOrderEntry where FCheckStatus<>'1' and FID=" & sourceId & " and FEntryID=" & sourceEntryID
'        Set rs = m_BillInterface.K3Lib.GetData(sql)
'        If (Not rs.EOF) Then
'             MsgBox "已结算检查，若需重新配车，请先取消结算检查", vbInformation, "金蝶提示"
'            Cancle = True
'            Exit Sub
'        End If
'
'
'        If vehicle("FFLD") <> "" Then
'            If MsgBox("是否取消配车？", vbQuestion + vbYesNo, "金蝶提示") = vbNo Then
'                Cancel = True
'                Exit Sub
'            End If
'
'            '更新车辆状态为"在售中"
'            sql = "update t_ats_vehicle set FVehicleStatus=1,FCustomerId=0 where fid=" & vehicle("FFLD")
'            m_BillInterface.K3Lib.UpdateData (sql)
'
'            '清除销售订单的配车标记
'            sql = "update T_ATS_VehicleSaleOrderEntry " & _
'                  "set FIsAssign = 0," & _
'                  "FAssignDate = null," & _
'                  "FVehicleID = 0, " & _
'                  "FVIN='', " & _
'                  "FStockId=0 " & _
'                  "where FID=" & sourceId & " and FEntryID=" & sourceEntryID
'            m_BillInterface.K3Lib.UpdateData (sql)
'
'            '清除配车单的配车信息
'            sql = "update T_ATS_Assign " & _
'                  "set FVehicleID=0,FDate=null,FPersonID = 0,FStockId=0 " & _
'                  "where FID= " & Val(m_BillInterface.Data("FID"))
'            m_BillInterface.K3Lib.UpdateData (sql)
'            MsgBox "取消配车成功", vbInformation, "金蝶提示"
'            m_BillInterface.BillCtl.BillStatus = Enu_BillStatusExt_Modify
'            m_BillInterface.RefreshBill
'
'        Else
'            MsgBox "未配车,不能取消配车", vbInformation, "金蝶提示"
'        End If
'
'    End If
'
'
'End Sub
'
'Private Sub m_BillInterface_MenuBarInitialize(ByVal oMenuBar As K3ClassEvents.MenuBar)
'    oMenuBar.BOSTools.Item("mnuFileSave").Caption = "配车"
'    oMenuBar.BOSTools.Item("mnuFileSave").Description = "配车"
'    oMenuBar.BOSTools.Item("mnuFileSave").ToolTipText = "配车"
'    oMenuBar.BOSBands("BandToolBar").BOSTools.Item("mnuFileSave").Caption = "配车"
'    oMenuBar.BOSBands("BandToolBar").BOSTools.Item("mnuFileSave").Description = "配车"
'    oMenuBar.BOSBands("BandToolBar").BOSTools.Item("mnuFileSave").ToolTipText = "配车"
'End Sub
