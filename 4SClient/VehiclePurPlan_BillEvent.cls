VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "VehiclePurPlan_BillEvent"
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


Private Sub initData()
    Dim strYear As String
    Dim strMonth As String
    strYear = Format(Date, "yyyy")
    strMonth = Format(Date, "mm")
    m_BillInterface.SetFieldValue "FComboBox1", strYear
    m_BillInterface.SetFieldValue "FComboBox2", strMonth
    

End Sub


Private Sub m_BillInterface_AfterLoadBill()
    If m_BillInterface.BillStatus = Enu_BillStatusExt_View Then
        m_BillInterface.MenuBar.BOSTools("mnuCreatePurOrder").Enabled = False
        m_BillInterface.MenuBar.BOSTools("mnuGenPurOrder").Enabled = True
    End If


End Sub

Private Sub m_BillInterface_AfterNewBill()
    initData
End Sub

Private Sub showPurOrder()
    Dim oDataSrv As Object
    Dim oBill As Object
    Dim dctRow As KFO.Dictionary
    
    Dim i As Integer
    m_BillInterface.SetActiveCell "FBase2", -1
    
    Dim totalCurrentPurQty As Double '本次采购数量累计
    Dim purQty As Double '行计划采购数
    Dim totalPurQty As Double '行累计已下订单数
    Dim currentPurQty As Double '行本次采购数量
    Dim isOver As Boolean
    isOver = False
    For i = 1 To m_BillInterface.BillEntrys(1).GridMaxDataRowNum
        purQty = Val(m_BillInterface.GetFieldValue("FQty", i)) '行计划采购数
        totalPurQty = Val(m_BillInterface.GetFieldValue("FQty4", i)) '行累计已下订单数
        currentPurQty = Val(m_BillInterface.GetFieldValue("FQty1", i)) '行本次采购数量
        If purQty < totalPurQty + currentPurQty Then '本次采购数据+已下订单数>计划采购数
            isOver = True
        End If
        totalCurrentPurQty = totalCurrentPurQty + currentPurQty
    Next i
    If totalCurrentPurQty <= 0 Then
        MsgBox "本次采购数必须大于0", vbInformation, "金蝶提示"
        Exit Sub
    End If
    If isOver = True Then
        If MsgBox("累计采购下单数超过计划采购数，是否继续", vbExclamation + vbYesNo, "金蝶提示") = vbNo Then
            Exit Sub
        End If
    End If
    
     
    On Error GoTo err_ctr
    Set oDataSrv = m_BillInterface.K3Lib.CreateK3Object("K3ClassTpl.DataSrv")
     
    oDataSrv.ClassTypeID = 200000023 '采购订单
    Dim oTableInfo As Object
    Set oTableInfo = oDataSrv.TableInfo
    Dim oData As Object
    Set oData = oDataSrv.GetEmptyBill
   
    
    oData("Page1")(oTableInfo("map")("FBase"))("FFND") = m_BillInterface.BillHeads(1).BOSFields("FBase1").Number  '采购方式编码
    oData("Page1")(oTableInfo("map")("FBase"))("FFLD") = m_BillInterface.BillHeads(1).BOSFields("FBase1").Value  '采购方式内码
    oData("Page1")(oTableInfo("map")("FBase"))("FDSP") = m_BillInterface.BillHeads(1).BOSFields("FBase1").Text  '采购方式名称
    
    oData("Page1")(oTableInfo("map")("FBase1"))("FFND") = m_BillInterface.BillHeads(1).BOSFields("FBase2").Number  '采购员编码
    oData("Page1")(oTableInfo("map")("FBase1"))("FFLD") = m_BillInterface.BillHeads(1).BOSFields("FBase2").Value  '采购员内码
    oData("Page1")(oTableInfo("map")("FBase1"))("FDSP") = m_BillInterface.BillHeads(1).BOSFields("FBase2").Text  '采购员名称
    
    oData("Page1")(oTableInfo("map")("FBase2"))("FFND") = m_BillInterface.BillHeads(1).BOSFields("FBase").Number  '供应商编码
    oData("Page1")(oTableInfo("map")("FBase2"))("FFLD") = m_BillInterface.BillHeads(1).BOSFields("FBase").Value  '供应商内码
    oData("Page1")(oTableInfo("map")("FBase2"))("FDSP") = m_BillInterface.BillHeads(1).BOSFields("FBase").Text  '供应商名称
    
    oData("Page1")(oTableInfo("map")("FNote"))("FFLD") = m_BillInterface.GetFieldValue("FNote") '备注
    Set dctRow = oData("Page2")(1).CloneAll()
    Dim rowPurOrder As Integer
    Dim rowPurPlan As Integer
    Dim Row As Integer
    For rowPurPlan = 1 To m_BillInterface.BillEntrys(1).GridMaxDataRowNum
        For rowPurOrder = 1 To Val(m_BillInterface.GetFieldValue("FQty1", rowPurPlan)) '本次采购数量
            Row = Row + 1
            If Row > 1 Then
                oData("Page2").Add dctRow.CloneAll()
            End If
            oData("Page2")(Row)(oTableInfo("map")("FBase8"))("FFND") = m_BillInterface.GetFieldValue("FBase3", rowPurPlan, Enu_ValueType_FFND) '车系编码
            oData("Page2")(Row)(oTableInfo("map")("FBase8"))("FFLD") = m_BillInterface.GetFieldValue("FBase3", rowPurPlan, Enu_ValueType_FFLD) '车系内码
            oData("Page2")(Row)(oTableInfo("map")("FBase8"))("FDSP") = m_BillInterface.GetFieldValue("FBase3", rowPurPlan, Enu_ValueType_FDSP) '车系名称
            
            oData("Page2")(Row)(oTableInfo("map")("FBase9"))("FFND") = m_BillInterface.GetFieldValue("FBase4", rowPurPlan, Enu_ValueType_FFND) '车型编码
            oData("Page2")(Row)(oTableInfo("map")("FBase9"))("FFLD") = m_BillInterface.GetFieldValue("FBase4", rowPurPlan, Enu_ValueType_FFLD) '车型内码
            oData("Page2")(Row)(oTableInfo("map")("FBase9"))("FDSP") = m_BillInterface.GetFieldValue("FBase4", rowPurPlan, Enu_ValueType_FDSP) '车型名称
            
            oData("Page2")(Row)(oTableInfo("map")("FBaseProperty6"))("FDSP") = m_BillInterface.GetFieldValue("FBaseProperty", rowPurPlan) '配置说明
            
            oData("Page2")(Row)(oTableInfo("map")("FBase5"))("FFND") = m_BillInterface.GetFieldValue("FBase5", rowPurPlan, Enu_ValueType_FFND) '内饰编码
            oData("Page2")(Row)(oTableInfo("map")("FBase5"))("FFLD") = m_BillInterface.GetFieldValue("FBase5", rowPurPlan, Enu_ValueType_FFLD) '内饰内码
            oData("Page2")(Row)(oTableInfo("map")("FBase5"))("FDSP") = m_BillInterface.GetFieldValue("FBase5", rowPurPlan, Enu_ValueType_FDSP) '内饰名称
            
            oData("Page2")(Row)(oTableInfo("map")("FBase6"))("FFND") = m_BillInterface.GetFieldValue("FBase6", rowPurPlan, Enu_ValueType_FFND) '颜色编码
            oData("Page2")(Row)(oTableInfo("map")("FBase6"))("FFLD") = m_BillInterface.GetFieldValue("FBase6", rowPurPlan, Enu_ValueType_FFLD) '颜色内码
            oData("Page2")(Row)(oTableInfo("map")("FBase6"))("FDSP") = m_BillInterface.GetFieldValue("FBase6", rowPurPlan, Enu_ValueType_FDSP) '颜色名称
            
            oData("Page2")(Row)(oTableInfo("map")("FText5"))("FFLD") = m_BillInterface.GetFieldValue("FText", rowPurPlan)   '选装
            oData("Page2")(Row)(oTableInfo("map")("FNOTE1"))("FFLD") = m_BillInterface.GetFieldValue("FNOTE", rowPurPlan)   '行备注
            
            oData("Page2")(Row)(oTableInfo("map")("FBase4"))("FFND") = m_BillInterface.GetFieldValue("FBase8", rowPurPlan, Enu_ValueType_FFND) '计量单位编码
            oData("Page2")(Row)(oTableInfo("map")("FBase4"))("FFLD") = m_BillInterface.GetFieldValue("FBase8", rowPurPlan, Enu_ValueType_FFLD) '计量单位内码
            oData("Page2")(Row)(oTableInfo("map")("FBase4"))("FDSP") = m_BillInterface.GetFieldValue("FBase8", rowPurPlan, Enu_ValueType_FDSP) '计量单位名称
            
            oData("Page2")(Row)(oTableInfo("map")("FQty"))("FFLD") = 1 '数量
            
            '--价格处理 计算出单价，其他金额字段自动反算，但用含税单价却不反算
            oData("Page2")(Row)(oTableInfo("map")("FPrice"))("FFLD") = m_BillInterface.GetFieldValue("FPrice", rowPurPlan) / (1 + 17 / 100#) '单价
            
            oData("Page2")(Row)(oTableInfo("map")("FBase3"))("FFND") = m_BillInterface.GetFieldValue("FBase7", rowPurPlan, Enu_ValueType_FFND) '物料编码
            oData("Page2")(Row)(oTableInfo("map")("FBase3"))("FFLD") = m_BillInterface.GetFieldValue("FBase7", rowPurPlan, Enu_ValueType_FFLD) '物料内码
            oData("Page2")(Row)(oTableInfo("map")("FBase3"))("FDSP") = m_BillInterface.GetFieldValue("FBase7", rowPurPlan, Enu_ValueType_FDSP) '物料名称
            
            oData("Page2")(Row)(oTableInfo("map")("FBillNo_SRC"))("FFLD") = m_BillInterface.GetFieldValue("FBillNo") '源单据编号
            oData("Page2")(Row)(oTableInfo("map")("FID_SRC"))("FFLD") = m_BillInterface.GetFieldValue("FID2", rowPurPlan) '源单据ID
            oData("Page2")(Row)(oTableInfo("map")("FEntryID_SRC"))("FFLD") = m_BillInterface.GetFieldValue("FEntryID2", rowPurPlan) '源单据分录ID
            oData("Page2")(Row)(oTableInfo("map")("FClassID_SRC"))("FFLD") = 200000066 '源单据类型
            
        Next rowPurOrder
        
    Next rowPurPlan
    
     Set oBill = m_BillInterface.K3Lib.CreateK3Object("K3SingleClassBill.ClassInfoManager")
     With oBill
       .DataSrv = oDataSrv
       .ISNetControl = True
       .ISCheckRight = True
       .Show 0, False, 1, oData
    
       '**********************
       'Show 参数类型
       '第一个参数 Optional ByVal lID As Long = 0 ；描述修改或查看的单据ID
       '第二个参数 Optional ByVal bShowGroup As Boolean = False ；如是基础资料时，是否显示分组
       '第三个参数 Optional ByVal BillStatus As Long = Enu_BillStatus_New ；显示方式 0—查看；1—新增；2—修改
       '第四个参数 Optional ByVal dctData As KFO.Dictionary '单据初始值
       '**********************
     End With
    
     Set oDataSrv = Nothing
     Set oBill = Nothing
     m_BillInterface.BillCtl.BillStatus = Enu_BillStatusExt_View
     m_BillInterface.RefreshBill
     m_BillInterface.MenuBar.BOSTools("mnuGenPurOrder").Enabled = True
     m_BillInterface.LockBillEntry 2
    Exit Sub
err_ctr:
    Set oDataSrv = Nothing
    Set oBill = Nothing


End Sub

Private Sub m_BillInterface_MenuBarClick(ByVal BOSTool As K3ClassEvents.BOSTool, Cancel As Boolean)
    Dim dctCurrentPurQty As KFO.Dictionary
    Set dctCurrentPurQty = m_BillInterface.GetFieldInfoByKey("FQty1", "", -1)
    If BOSTool.ToolName = "mnuGenPurOrder" Then '执行采购下单
        If Not m_BillInterface.GetFieldValue("FMultiCheckStatus") = "16" Then
            MsgBox "非审核状态，不能执行采购下单", vbInformation, "金蝶提示"
            Cancle = True
            Exit Sub
        End If
     
        m_BillInterface.MenuBar.BOSTools("mnuCreatePurOrder").Enabled = True
        'm_BillInterface.MenuBar.BOSBands("BandToolBar").BOSTools.Item("mnuCreatePurOrder").Enabled = True
        dctCurrentPurQty("FLock") = 0
        m_BillInterface.LockCell dctCurrentPurQty, -1, False
    End If
    
    If BOSTool.ToolName = "mnuCreatePurOrder" Then '生成采购订单
        showPurOrder
    End If
End Sub

Private Sub m_BillInterface_Change(ByVal dct As KFO.IDictionary, ByVal dctFld As KFO.IDictionary, ByVal Col As Long, ByVal Row As Long, Cancel As Boolean)
    
    If (dct("FKey") = "FBase3") Then '车系
        Dim seriesId As Integer
        seriesId = Val(dctFld("FFLD"))
        '车型过滤
        If seriesId > 0 Then
            m_BillInterface.DataSrv.TableInfo(m_BillInterface.TableInfo("Map")("FBase4"))("FFilter") = "v_ats_model.FSeriesID=" & seriesId
        Else
            m_BillInterface.DataSrv.TableInfo(m_BillInterface.TableInfo("Map")("FBase4"))("FFilter") = ""
        End If
    
    ElseIf (dct("FKey") = "FBase4") Then '车型
        Dim modelId As Integer
        modelId = Val(dctFld("FFLD"))
        loadModelInfo modelId, Row
    End If
    
    
End Sub

Private Sub setModelInfo(rs As ADODB.Recordset, lRow As Long)
    Dim isLock As Boolean
    If rs Is Nothing Then
        m_BillInterface.SetFieldValue "FBaseProperty", "", lRow
        m_BillInterface.SetFieldValue "FBase3", "", lRow
        m_BillInterface.SetFieldValue "FBase4", "", lRow

        isLock = False
    Else
        m_BillInterface.SetFieldValue "FBase3", rs!FSeriesNum, lRow
        m_BillInterface.SetFieldValue "FBaseProperty", rs!FCfgDesc, lRow
        m_BillInterface.SetFieldValue "FBase7", rs!FICItemNum, lRow
        m_BillInterface.SetFieldValue "FBase8", rs!FUnitNum, lRow
        m_BillInterface.SetFieldValue "FPrice", rs!FPurTaxPrice, lRow
        
        isLock = True
    End If
    m_BillInterface.LockCell m_BillInterface.GetFieldInfoByKey("FBase3", "", -1), lRow, isLock



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
    Dim seriesId As Integer
    Dim modelId As Integer

    seriesId = Val(m_BillInterface.GetFieldValue("FBase3", lRow))
    modelId = Val(m_BillInterface.GetFieldValue("FBase4", lRow))
    
    If (dct("FKey") = "FBase4") Then  '车型
        If seriesId > 0 Then
         strFilter = "v_ats_model.FSeriesID=" & seriesId
        End If
    ElseIf (dct("FKey") = "FBase3") Then '车系
        
    End If
End Sub

