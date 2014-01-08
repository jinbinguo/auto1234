VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "VehicleInsurance_BillEvent"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Attribute VB_Description = "This is BillEvent Interface Class, made by K3BOSPLUGINSWIZAED"
 
'定义 BillEvent 接口. 必须具有的声明, 以此来获得事件
Private WithEvents m_BillInterface  As BillEvent
Attribute m_BillInterface.VB_VarHelpID = -1
 
Dim optInusCheck As Boolean
Dim optInusSettle As Boolean
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
    Dim isInsuranceSettle As Boolean
    Dim isInsuranceCheck As Boolean
    optInusCheck = False
    optInusSettle = False

    isInsuranceSettle = m_BillInterface.GetFieldValue("FCheckBox") '保险公司结算
    isInsuranceCheck = m_BillInterface.GetFieldValue("FCheckBox1") '保险公司核对

    If m_BillInterface.GetFieldValue("FMultiCheckStatus") = "16" Then
        m_BillInterface.MenuBar.BOSTools.Item("mnuInsuranceCheck").Visible = True
        m_BillInterface.MenuBar.BOSTools.Item("mnuInsuranceSettle").Visible = True
        If isInsuranceCheck = True Then
            m_BillInterface.MenuBar.BOSTools.Item("mnuInsuranceCheck").Caption = "取消保险核对"
            m_BillInterface.MenuBar.BOSTools.Item("mnuInsuranceCheck").Description = "取消保险核对"
            m_BillInterface.MenuBar.BOSTools.Item("mnuInsuranceCheck").ToolTipText = "取消保险核对"
        Else
            m_BillInterface.MenuBar.BOSTools.Item("mnuInsuranceCheck").Caption = "保险核对"
            m_BillInterface.MenuBar.BOSTools.Item("mnuInsuranceCheck").Description = "保险核对"
            m_BillInterface.MenuBar.BOSTools.Item("mnuInsuranceCheck").ToolTipText = "保险核对"
        End If

        If isInsuranceSettle = True Then
             m_BillInterface.MenuBar.BOSTools.Item("mnuInsuranceSettle").Caption = "取消保险结算"
             m_BillInterface.MenuBar.BOSTools.Item("mnuInsuranceSettle").Description = "取消保险结算"
             m_BillInterface.MenuBar.BOSTools.Item("mnuInsuranceSettle").ToolTipText = "取消保险结算"

        Else
            m_BillInterface.MenuBar.BOSTools.Item("mnuInsuranceSettle").Caption = "保险结算"
            m_BillInterface.MenuBar.BOSTools.Item("mnuInsuranceSettle").Description = "保险结算"
            m_BillInterface.MenuBar.BOSTools.Item("mnuInsuranceSettle").ToolTipText = "保险结算"

        End If
    Else
        m_BillInterface.MenuBar.BOSTools.Item("mnuInsuranceCheck").Visible = False
        m_BillInterface.MenuBar.BOSTools.Item("mnuInsuranceSettle").Visible = False
        
    End If
End Sub

Private Sub m_BillInterface_BeforeSave(bCancel As Boolean)
    Dim classId_src As Long
    Dim billNo_src As String
    Dim vehicleId As Long
    Dim row As Long
    Dim insuCompanyId As Long
    Dim insuType As String '办理类型
    Dim insuProductType As String '险种类别
    Dim vehVesTaxAmount As Double '车船税
    Dim forcedAmount As Double '交强险保单金额
    Dim forcedSaleAmount As Double '交强险销售金额

    Dim businessAmount As Double '商业险保单金额
    Dim businessSaleAmount As Double '商业险销售金额

    
    
    vehicleId = Val(m_BillInterface.GetFieldValue("FBase1")) '车辆
    insuType = m_BillInterface.GetFieldValue("FCombobox1") '办理类型 1->代办;2->自办
    If vehicleId = 0 Then
        MsgBox "车辆不能为空", vbInformation, "金蝶提示"
        bCancel = True
        Exit Sub
    End If
    classId_src = Val(m_BillInterface.GetFieldValue("FClassID_SRC"))
    billNo_src = m_BillInterface.GetFieldValue("FBillNo_SRC")
    If classId_src = 0 Or billNo_src = "" Then
        MsgBox "保险登记必须关联代办服务单", vbInformation, "金蝶提示"
        bCancel = True
        Exit Sub
    End If
    If insuType = "1" Then '代办
        
        insuCompanyId = Val(m_BillInterface.GetFieldValue("FBase2")) '保险公司
        If insuCompanyId = 0 Then
            MsgBox "保险公司不能为空", vbInformation, "金蝶提示"
        bCancel = True
        Exit Sub
        End If
    End If
    
    If optInusCheck = True Then
        If m_BillInterface.GetFieldValue("FDate4") = "" Then
            MsgBox "保险公司核对日期不能为空", vbInformation, "金蝶提示"
            bCancel = True
            Exit Sub
        End If
        
        m_BillInterface.SetFieldValue "FCheckBox1", 1
        optInusCheck = False
    End If
    
    If optInusSettle = True Then
        If m_BillInterface.GetFieldValue("FDate3") = "" Then
            MsgBox "保险公司结算日期不能为空", vbInformation, "金蝶提示"
            bCancel = True
            Exit Sub
        End If
        m_BillInterface.SetFieldValue "FCheckBox", 1
        optInusSettle = False
    End If
    
    
    For row = 1 To m_BillInterface.BillEntrys(1).GridMaxDataRowNum
        insuProductType = m_BillInterface.GetFieldValue("FBaseProperty4", row) '险种类别
        If insuProductType = "1" Then '1=交强险
            forcedAmount = forcedAmount + m_BillInterface.GetFieldValue("FAmount7", row) '保额
            forcedSaleAmount = forcedSaleAmount + m_BillInterface.GetFieldValue("FAmount8", row) '保费
            
        ElseIf insuProductType = "2" Then '2=商业险
            businessAmount = businessAmount + m_BillInterface.GetFieldValue("FAmount7", row) '保额
            businessSaleAmount = businessSaleAmount + m_BillInterface.GetFieldValue("FAmount8", row) '保费
        ElseIf insuProductType = "3" Then '3=车船税
            vehVesTaxAmount = vehVesTaxAmount + m_BillInterface.GetFieldValue("FAmount8", row)
        End If
    
    Next row
    
    m_BillInterface.SetFieldValue "FAmount", vehVesTaxAmount '车船税
    m_BillInterface.SetFieldValue "FAmount1", forcedAmount '交强险保单金额
    m_BillInterface.SetFieldValue "FAmount2", forcedSaleAmount '交强险销售金额
    m_BillInterface.SetFieldValue "FAmount3", businessAmount '商业险保单金额
    m_BillInterface.SetFieldValue "FAmount4", businessSaleAmount '商业险销售金额
    m_BillInterface.SetFieldValue "FAmount5", forcedSaleAmount + businessSaleAmount '保险总额
    setReturnAmount

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
        sql = "select a.FBrandName,a.FModelName,a.FSeriesName,a.FCfgDesc,isnull(h.FNumber,'') FInsuCompanyNum  " & _
            "from V_ATS_Vehicle a " & _
            "left join t_Item h on h.FItemId=a.FInsuCompanyID and h.FItemClassID=1 and h.FItemId<>0 " & _
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
        m_BillInterface.SetFieldValue "FBase3", FInsuCompanyNum, lRow '上一年保险公司
    End If
End Sub


Private Sub m_BillInterface_Change(ByVal dct As KFO.IDictionary, ByVal dctFld As KFO.IDictionary, ByVal Col As Long, ByVal row As Long, Cancel As Boolean)
    If dct("FKey") = "FAmount1" Or dct("FKey") = "FAmount3" Or dct("FKey") = "FBase2" Or dct("FKey") = "FComboBox" Then '交强险保单金额\商业险保单金额\保险公司\保险类型
        setReturnAmount
    ElseIf dct("FKey") = "FDate1" Then '起保日期
       Dim effectDate As Date
       Dim strEffectDate As String
       strEffectDate = dctFld("FFLD")
       If strEffectDate <> "" Then
            m_BillInterface.SetFieldValue "FDate2", DateAdd("yyyy", 1, Format(strEffectDate, "yyyy-mm-dd")) '终保日期
       End If
       
    End If
    
End Sub

Private Sub setReturnAmount()
    Dim forcedAmount As Double
    Dim businessAmount As Double
    Dim insuCompanyId As Integer
    Dim sql As String
    Dim rs As ADODB.Recordset
    Dim insuType As String '投保类型1->首保; 2->继保
    
    forcedAmount = Val(m_BillInterface.GetFieldValue("FAmount2")) '交强险
    businessAmount = Val(m_BillInterface.GetFieldValue("FAmount4")) '商业险
    insuCompanyId = Val(m_BillInterface.GetFieldValue("FBase2")) '保险公司
    insuType = m_BillInterface.GetFieldValue("FCombobox") '投保类型
    If insuCompanyId = 0 Then
        MsgBox "保险公司不能为空", vbInformation, "金蝶提示"
        Exit Sub
    End If
    If insuType = "1" Then '首保
        sql = "select FNewFInsuRtnRate FRate,FNewBInsuRtnRate BRate from T_ATS_InsuranceReturn where FInsuCompanyID =" & insuCompanyId
    ElseIf insuType = "2" Then '继保
        sql = "select FOldFInsuRtnRate FRate,FOldBInsuRtnRate BRate from T_ATS_InsuranceReturn where FInsuCompanyID =" & insuCompanyId
    Else
       MsgBox "保险类型不能为空", vbInformation, "金蝶提示"
        Exit Sub
    End If
    Set rs = m_BillInterface.K3Lib.GetData(sql)
    If Not rs.EOF Then
       m_BillInterface.SetFieldValue "FAmount6", forcedAmount * rs!FRate / 100# + businessAmount * rs!BRate / 100#   '返利金额
    Else
        MsgBox "对应保险公司未设置返点率", vbInformation, "金蝶提示"
        Exit Sub
    End If
End Sub


Private Sub m_BillInterface_MenuBarClick(ByVal BOSTool As K3ClassEvents.BOSTool, Cancel As Boolean)
    Dim isInsuranceSettle As Boolean
    Dim isInsuranceCheck As Boolean
    isInsuranceSettle = m_BillInterface.GetFieldValue("FCheckBox") '保险公司结算
    isInsuranceCheck = m_BillInterface.GetFieldValue("FCheckBox1")  '保险公司核对
    Dim dctCheckDate As KFO.Dictionary '核对日期
    Dim dctSettleDate As KFO.Dictionary '结算日期
    Dim dctReturnAmount As KFO.Dictionary '返利金额
    Dim dctInsuranceBillNum As KFO.Dictionary '保险公司收据号
    Dim dctInsuranceInvoiceNum As KFO.Dictionary '保险公司发票号
    Dim multiCheckStatus As String
    multiCheckStatus = m_BillInterface.GetFieldValue("FMultiCheckStatus")
    
    Set dctSettleDate = m_BillInterface.GetFieldInfoByKey("FDate3", "", -1)
    Set dctCheckDate = m_BillInterface.GetFieldInfoByKey("FDate4", "", -1)
    Set dctReturnAmount = m_BillInterface.GetFieldInfoByKey("FAmount6", "", -1)
    Set dctInsuranceBillNum = m_BillInterface.GetFieldInfoByKey("FText2", "", -1)
    Set dctInsuranceInvoiceNum = m_BillInterface.GetFieldInfoByKey("FText3", "", -1)
    
    
    
    If BOSTool.ToolName = "mnuInsuranceCheck" Then '核对
        If multiCheckStatus <> "16" Then
            MsgBox "未审核状态不允许保险核对", vbInformation, "金蝶提示"
            Cancel = True
            Exit Sub
        End If
        If isInsuranceCheck = True Then
            
            If MsgBox("是否取消保险核对", vbQuestion + vbYesNo, "金蝶提示") <> vbYes Then
                Cancel = True
                Exit Sub
            End If
            
            m_BillInterface.SetFieldValue "FDate4", "" '核对日期
            m_BillInterface.SetFieldValue "FCheckBox1", 0 '保险公司核对
            m_BillInterface.SaveBill
        
        Else
            If isInsuranceSettle = False Then
                MsgBox "未保险结算，不允许保险核对", vbInformation, "金蝶提示"
                Cancel = True
                Exit Sub
            End If
            
            optInusCheck = True
            m_BillInterface.BillCtl.BillStatus = Enu_BillStatusExt_New
            m_BillInterface.MenuBar.BOSTools.Item("mnuFileSave").Enabled = True
            m_BillInterface.MenuBar.BOSTools.Item("mnuFileSave").Visible = True
            dctCheckDate("FLock") = 24
            m_BillInterface.LockCell dctCheckDate, 1, False
            m_BillInterface.LockBillEntry 1
        End If
    End If
    
    If BOSTool.ToolName = "mnuInsuranceSettle" Then '结算
        If multiCheckStatus <> "16" Then
            MsgBox "未审核状态不允许保险结算", vbInformation, "金蝶提示"
            Cancel = True
            Exit Sub
        End If
        
        If isInsuranceSettle = True Then
            If isInsuranceCheck = True Then
                MsgBox "已保险核对，不允许取消保险结算", vbInformation, "金蝶提示"
                Cancel = True
                Exit Sub
            End If
            
            If MsgBox("是否取消保险结算", vbQuestion + vbYesNo, "金蝶提示") <> vbYes Then
                Cancel = True
                Exit Sub
            End If
            
            m_BillInterface.SetFieldValue "FDate3", "" '结算日期
            m_BillInterface.SetFieldValue "FCheckBox", 0 '保险公司结算
            
            m_BillInterface.SaveBill
        
        Else
            optInusSettle = True
            m_BillInterface.BillCtl.BillStatus = Enu_BillStatusExt_New
            m_BillInterface.MenuBar.BOSTools.Item("mnuFileSave").Enabled = True
            m_BillInterface.MenuBar.BOSTools.Item("mnuFileSave").Visible = True
            dctSettleDate("FLock") = 24
            m_BillInterface.LockCell dctSettleDate, -1, False
            m_BillInterface.LockCell dctReturnAmount, -1, False
            m_BillInterface.LockCell dctInsuranceBillNum, -1, False
            m_BillInterface.LockCell dctInsuranceInvoiceNum, -1, False
            m_BillInterface.LockBillEntry 1
        
        End If
    End If
    
End Sub


