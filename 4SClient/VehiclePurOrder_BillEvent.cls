VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "VehiclePurOrder_BillEvent"
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
    resetBOTPUI
    RegUtils.validateLicenseClient m_BillInterface
End Sub

Private Sub Class_Terminate()
 
    '释放接口对象
    '注意: 此方法必须存在, 请勿修改
    Set m_BillInterface = Nothing

End Sub


Private Sub m_BillInterface_AfterLoadBill()
        resetBOTPUI
End Sub

Private Sub resetBOTPUI()

    Dim dctSeries As KFO.Dictionary
    Dim dctModel As KFO.Dictionary
    Dim dctSupplier As KFO.Dictionary
    
    On Error GoTo errorLine
    Set dctSeries = m_BillInterface.GetFieldInfoByKey("FBase8", "", -1) '车系
    Set dctModel = m_BillInterface.GetFieldInfoByKey("FBase9", "", -1) '车型
    Set dctSupplier = m_BillInterface.GetFieldInfoByKey("FBase2", "", -1) '供应商

    If m_BillInterface.BillStatus = Enu_BillStatusExt_Modify Or m_BillInterface.BillStatus = Enu_BillStatusExt_New Then
        If Val(m_BillInterface.GetFieldValue("FClassID_SRC", 1)) = 200000066 Then
            dctSeries("FLock") = -1
            m_BillInterface.LockCell dctSeries, -1, True
            dctModel("FLock") = -1
            m_BillInterface.LockCell dctModel, -1, True
            dctSupplier("FLock") = -1
            m_BillInterface.LockCell dctSupplier, -1, True
        End If

    End If
    
errorLine:
    Exit Sub

End Sub

Public Sub Change(ByVal dct As KFO.IDictionary, ByVal dctFld As KFO.IDictionary, ByVal Col As Long, ByVal row As Long)
    m_BillInterface_Change dct, dctFld, Col, row, False
End Sub

Private Sub m_BillInterface_Change(ByVal dct As KFO.IDictionary, ByVal dctFld As KFO.IDictionary, ByVal Col As Long, ByVal row As Long, Cancel As Boolean)
    
    If (dct("FKey") = "FBase7") Then '车辆
        Dim vehicleId As Integer
        vehicleId = Val(dctFld("FFLD"))
    
        loadVehicleInfo vehicleId, row
    
    ElseIf (dct("FKey") = "FBase8") Then '车系
        Dim seriesId As Integer
        seriesId = Val(dctFld("FFLD"))
        '车型过滤
        If seriesId > 0 Then
            m_BillInterface.DataSrv.TableInfo(m_BillInterface.TableInfo("Map")("FBase9"))("FFilter") = "v_ats_model.FSeriesID=" & seriesId
        Else
            m_BillInterface.DataSrv.TableInfo(m_BillInterface.TableInfo("Map")("FBase9"))("FFilter") = ""
        End If
    
    ElseIf (dct("FKey") = "FBase9") Then '车型
        Dim modelId As Integer
        modelId = Val(dctFld("FFLD"))
        loadModelInfo modelId, row
    
    ElseIf (dct("FKey") = "FPrice1") Then '含税单价
        With m_BillInterface
            .SetFieldValue "FPrice", .GetFieldValue("FPrice1", row) / (1 + .GetFieldValue("FDecimal", row) / 100), row
            .SetFieldValue "FAmount", (.GetFieldValue("FPrice1", row) / (1 + .GetFieldValue("FDecimal", row) / 100)) * .GetFieldValue("FQty", row), row
            .SetFieldValue "FAmount1", .GetFieldValue("FPrice1", row) * .GetFieldValue("FQty", row), row
            .SetFieldValue "FAmount2", .GetFieldValue("FPrice", row) * .GetFieldValue("FDecimal", row) / 100 * .GetFieldValue("FQty", row), row
        
        End With
        '[采购信息.FPrice - 单价]=[采购信息.FPrice1 - 含税单价]/(1+[采购信息.FDecimal - 税率]/100)
        '[采购信息.FAmount - 金额] = ([采购信息.FPrice1 - 含税单价] / (1 + [采购信息.FDecimal - 税率] / 100)) * [采购信息.FQty - 数量]
        '[采购信息.FAmount1 - 价税合计] = [采购信息.FPrice1 - 含税单价] * [采购信息.FQty - 数量]
        '[采购信息.FAmount2 - 税额] = [采购信息.FPrice - 单价] * [采购信息.FDecimal - 税率] / 100 * [采购信息.FQty - 数量]
    End If
    
    
End Sub

Private Sub setVehicleInfo(ByVal rs As ADODB.Recordset, lRow As Long)
    Dim isLock As Boolean
    If (rs Is Nothing) Then

        m_BillInterface.SetFieldValue "FBase5", "", lRow
        m_BillInterface.SetFieldValue "FBase6", "", lRow
        m_BillInterface.SetFieldValue "FText5", "", lRow
        m_BillInterface.SetFieldValue "FText8", "", lRow
        m_BillInterface.SetFieldValue "FText9", "", lRow

        
        isLock = False
    Else
        m_BillInterface.SetFieldValue "FBase8", rs!FSeriesNum, lRow
        m_BillInterface.SetFieldValue "FBase9", rs!FModelNum, lRow
        m_BillInterface.SetFieldValue "FBaseProperty6", rs!FCfgDesc, lRow
        m_BillInterface.SetFieldValue "FBase5", rs!FInteriorNum, lRow
        m_BillInterface.SetFieldValue "FBase6", rs!FColorNum, lRow
        m_BillInterface.SetFieldValue "FText5", rs!FOptional, lRow
        m_BillInterface.SetFieldValue "FText8", rs!FVin, lRow
        m_BillInterface.SetFieldValue "FText9", rs!FEngineNum, lRow
        m_BillInterface.SetFieldValue "FBase3", rs!FICItemNum, lRow
        m_BillInterface.SetFieldValue "FBase4", rs!FUnitNum, lRow
        m_BillInterface.SetFieldValue "FBaseProperty", rs!FMakerModelNum, lRow
        m_BillInterface.SetFieldValue "FBaseProperty1", rs!FBrandName, lRow
        m_BillInterface.SetFieldValue "FBaseProperty2", rs!FGearboxName, lRow
        m_BillInterface.SetFieldValue "FBaseProperty3", rs!FPowerFormName, lRow
        m_BillInterface.SetFieldValue "FBaseProperty4", rs!FStereotypeName, lRow
        m_BillInterface.SetFieldValue "FBaseProperty5", rs!FDriverFormName, lRow
        m_BillInterface.SetFieldValue "FBaseProperty7", rs!FCarSourceName, lRow
        m_BillInterface.SetFieldValue "FBaseProperty8", rs!FDisplacementName, lRow
        
        isLock = True
    End If
    m_BillInterface.LockCell m_BillInterface.GetFieldInfoByKey("FBase8", "", -1), lRow, isLock
    m_BillInterface.LockCell m_BillInterface.GetFieldInfoByKey("FBase8", "", -1), lRow, isLock
    m_BillInterface.LockCell m_BillInterface.GetFieldInfoByKey("FBase9", "", -1), lRow, isLock
    m_BillInterface.LockCell m_BillInterface.GetFieldInfoByKey("FBase5", "", -1), lRow, isLock
    m_BillInterface.LockCell m_BillInterface.GetFieldInfoByKey("FBase6", "", -1), lRow, isLock
    m_BillInterface.LockCell m_BillInterface.GetFieldInfoByKey("FText5", "", -1), lRow, isLock
    m_BillInterface.LockCell m_BillInterface.GetFieldInfoByKey("FText8", "", -1), lRow, isLock
    m_BillInterface.LockCell m_BillInterface.GetFieldInfoByKey("FText9", "", -1), lRow, isLock
    m_BillInterface.LockCell m_BillInterface.GetFieldInfoByKey("FBase3", "", -1), lRow, isLock
    m_BillInterface.LockCell m_BillInterface.GetFieldInfoByKey("FBase4", "", -1), lRow, isLock

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
    End If
    setVehicleInfo rs, lRow
End Sub

Private Sub setModelInfo(rs As ADODB.Recordset, lRow As Long)
    Dim isLock As Boolean
    If rs Is Nothing Then
        'm_BillInterface.SetFieldValue "FBase8", "", lRow
        m_BillInterface.SetFieldValue "FBaseProperty6", "", lRow
        m_BillInterface.SetFieldValue "FBase3", "", lRow
        m_BillInterface.SetFieldValue "FBase4", "", lRow
        isLock = False
    Else
        m_BillInterface.SetFieldValue "FBase8", rs!FSeriesNum, lRow
        m_BillInterface.SetFieldValue "FBaseProperty6", rs!FCfgDesc, lRow
        m_BillInterface.SetFieldValue "FBase3", rs!FICItemNum, lRow
        m_BillInterface.SetFieldValue "FBase4", rs!FUnitNum, lRow

        m_BillInterface.SetFieldValue "FPrice1", rs!FPurTaxPrice, lRow
        isLock = True
    End If
    m_BillInterface.LockCell m_BillInterface.GetFieldInfoByKey("FBase8", "", -1), lRow, isLock
    m_BillInterface.LockCell m_BillInterface.GetFieldInfoByKey("FBase3", "", -1), lRow, isLock
    m_BillInterface.LockCell m_BillInterface.GetFieldInfoByKey("FBase4", "", -1), lRow, isLock


End Sub

Private Sub loadModelInfo(modelId As Integer, lRow As Long)
    
    Dim rs As ADODB.Recordset
    Dim sql As String
    If (modelId > 0) Then
        sql = "select b.FNumber FSeriesNum,a.FCfgDesc,c.FNumber FICItemNum," & _
             "d.FNumber FUnitNum,a.FMakerModelNum,a.FBrandName,a.FGearboxName,a.FPowerFormName," & _
             "a.FStereotypeName , a.FDriverFormName, a.FCarSourceName, a.FDisplacementName,a.FPurTaxPrice " & _
             "from v_ats_model a " & _
             "left join T_ATS_Series b on b.FID<>0 and b.FID=a.FSeriesID " & _
             "left join t_ICItem c on c.FItemID<>0 and c.FItemID=a.FICItemID " & _
             "left join t_MeasureUnit d on d.FItemID<> 0 and d.FItemID=a.FUnitID" & _
             " where a.FID=" & CStr(modelId)
        Set rs = m_BillInterface.K3Lib.GetData(sql)
     End If
     setModelInfo rs, lRow
End Sub


Private Sub m_BillInterface_F7LookUp(ByVal dct As KFO.IDictionary, ByVal vCurValue As Variant, ByVal lRow As Long, strFilter As String, sRetMsg As String, bCancel As Boolean)
    Dim vehicleId As Integer
    Dim seriesId As Integer
    Dim modelId As Integer
    vehicleId = Val(m_BillInterface.GetFieldValue("FBase7", lRow))
    seriesId = Val(m_BillInterface.GetFieldValue("FBase8", lRow))
    modelId = Val(m_BillInterface.GetFieldValue("FBase9", lRow))
    
    If (dct("FKey") = "FBase7") Then '车辆
        
    ElseIf (dct("FKey") = "FBase9") Then  '车型
        If seriesId > 0 Then
         strFilter = "v_ats_model.FSeriesID=" & seriesId
        End If
    ElseIf (dct("FKey") = "FBase8") Then '车系
        
    End If
End Sub




Private Sub m_BillInterface_MenuBarClick(ByVal BOSTool As K3ClassEvents.BOSTool, Cancel As Boolean)
    If BOSTool.ToolName = "mnuFileImportBill" Then
        Dim importCls As Object
        Set importCls = New VehiclePurOrderImport
        importCls.setBillInterface m_BillInterface, Me
        ExcelUtils.openFile importCls
        
    ElseIf BOSTool.ToolName = "mnuCancelOrderEntry" Then '取消订单
        If (m_BillInterface.GetFieldValue("FMultiCheckStatus") <> "16") Then
            MsgBoxEx.showInfo "未审核单据，不允许取消订单"
            Cancel = True
            Exit Sub
        End If
        If m_BillInterface.GetFieldValue("FComboBox2") = "1" Then
            MsgBoxEx.showInfo "已是取消订单，不允许重复取消订单"
            Cancel = True
            Exit Sub
        End If
        If Val(m_BillInterface.GetFieldValue("FAmount3")) > 0 Then
            MsgBoxEx.showInfo "已关联付款，不允许取消订单"
            Cancel = True
            Exit Sub
        End If
        
        If m_BillInterface.GetFieldValue("FCheckBox") = 1 Then
            MsgBoxEx.showInfo "已验收，不允许取消订单"
            Cancel = True
            Exit Sub
        End If
        
        If m_BillInterface.GetFieldValue("FCheckBox1") = 1 Then
            MsgBoxEx.showInfo "已生成发票，不允许取消订单"
            Cancel = True
            Exit Sub
        End If
        
        If vbYes = MsgBoxEx.confirm("是否取消订单?") Then
            m_BillInterface.SetFieldValue "FComboBox2", 1
            m_BillInterface.SaveBill
            MsgBoxEx.showInfo "取消订单成功"
        End If
        
        
        '1.审核
        '2.未取消、恢复订单
        '3.未关联付款
        '4.未转整车验收单
        '5.采购增值发票单
        
        
        
        
    ElseIf BOSTool.ToolName = "mnuCancelCancelOrderEntry" Then '恢复订单
         If (m_BillInterface.GetFieldValue("FMultiCheckStatus") <> "16") Then
            MsgBoxEx.showInfo "未审核单据，不允许取消订单"
            Cancel = True
            Exit Sub
        End If
        If m_BillInterface.GetFieldValue("FComboBox2") <> "1" Then
            MsgBoxEx.showInfo "非取消订单状态，不允许愎取消订单"
            Cancel = True
            Exit Sub
        End If
        
        If vbYes = MsgBoxEx.confirm("是否恢复订单?") Then
            m_BillInterface.SetFieldValue "FComboBox2", 2
            m_BillInterface.SaveBill
            MsgBoxEx.showInfo "恢复订单成功"
            
        End If
        '审核
        '非取消状态
        '
        '
        '
    
    End If
    
    
    
End Sub
