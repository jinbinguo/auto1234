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

Dim optMortCheck As Boolean
Dim optMortSettle As Boolean

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

Private Sub m_BillInterface_AfterLoadBill()
    Dim isMortgageSettle As Boolean
    Dim isMortgageCheck As Boolean
    optMortCheck = False
    optMortSettle = False

    isMortgageSettle = m_BillInterface.GetFieldValue("FCheckBox") '按揭公司结算
    isMortgageCheck = m_BillInterface.GetFieldValue("FCheckBox1") '按揭公司核对

    If m_BillInterface.GetFieldValue("FMultiCheckStatus") = "16" Then
        m_BillInterface.MenuBar.BOSTools.Item("mnuMortgageCheck").Visible = True
        m_BillInterface.MenuBar.BOSTools.Item("mnuMortgageSettle").Visible = True
        If isMortgageCheck = True Then
            m_BillInterface.MenuBar.BOSTools.Item("mnuMortgageCheck").Caption = "取消按揭核对"
            m_BillInterface.MenuBar.BOSTools.Item("mnuMortgageCheck").Description = "取消按揭核对"
            m_BillInterface.MenuBar.BOSTools.Item("mnuMortgageCheck").ToolTipText = "取消按揭核对"
        Else
            m_BillInterface.MenuBar.BOSTools.Item("mnuMortgageCheck").Caption = "按揭核对"
            m_BillInterface.MenuBar.BOSTools.Item("mnuMortgageCheck").Description = "按揭核对"
            m_BillInterface.MenuBar.BOSTools.Item("mnuMortgageCheck").ToolTipText = "按揭核对"
        End If

        If isMortgageSettle = True Then
             m_BillInterface.MenuBar.BOSTools.Item("mnuMortgageSettle").Caption = "取消按揭结算"
             m_BillInterface.MenuBar.BOSTools.Item("mnuMortgageSettle").Description = "取消按揭结算"
             m_BillInterface.MenuBar.BOSTools.Item("mnuMortgageSettle").ToolTipText = "取消按揭结算"

        Else
            m_BillInterface.MenuBar.BOSTools.Item("mnuMortgageSettle").Caption = "按揭结算"
            m_BillInterface.MenuBar.BOSTools.Item("mnuMortgageSettle").Description = "按揭结算"
            m_BillInterface.MenuBar.BOSTools.Item("mnuMortgageSettle").ToolTipText = "按揭结算"

        End If
    Else
        m_BillInterface.MenuBar.BOSTools.Item("mnuMortgageCheck").Visible = False
        m_BillInterface.MenuBar.BOSTools.Item("mnuMortgageSettle").Visible = False
        
    End If
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
        m_BillInterface.SetFieldValue "FInteger1", rs!FIndex_SRC '销售订单分录号
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

Private Sub m_BillInterface_MenuBarClick(ByVal BOSTool As K3ClassEvents.BOSTool, Cancel As Boolean)
    Dim isMortgageSettle As Boolean
    Dim isMortgageCheck As Boolean
    isMortgageSettle = m_BillInterface.GetFieldValue("FCheckBox") '按揭公司结算
    isMortgageCheck = m_BillInterface.GetFieldValue("FCheckBox1")  '按揭公司核对
    Dim dctCheckDate As KFO.Dictionary '核对日期
    Dim dctSettleDate As KFO.Dictionary '结算日期
    Dim dctReturnAmount As KFO.Dictionary '返利金额
    Dim dctMortgageBillNum As KFO.Dictionary '返利结算号码
    Dim dctMortgageInvoiceNum As KFO.Dictionary '按揭返利号码
    Dim multiCheckStatus As String
    multiCheckStatus = m_BillInterface.GetFieldValue("FMultiCheckStatus")
    
    Set dctSettleDate = m_BillInterface.GetFieldInfoByKey("FDate2", "", -1)
    Set dctCheckDate = m_BillInterface.GetFieldInfoByKey("FDate3", "", -1)
    Set dctReturnAmount = m_BillInterface.GetFieldInfoByKey("FAmount1", "", -1)
    Set dctMortgageBillNum = m_BillInterface.GetFieldInfoByKey("FText2", "", -1)
    Set dctMortgageInvoiceNum = m_BillInterface.GetFieldInfoByKey("FText1", "", -1)
    
    
    
    If BOSTool.ToolName = "mnuMortgageCheck" Then '核对
        If multiCheckStatus <> "16" Then
            MsgBox "未审核状态不允许按揭核对", vbInformation, "金蝶提示"
            Cancel = True
            Exit Sub
        End If
        If isMortgageCheck = True Then
            
            If MsgBox("是否取消按揭核对", vbQuestion + vbYesNo, "金蝶提示") <> vbYes Then
                Cancel = True
                Exit Sub
            End If
            
            m_BillInterface.SetFieldValue "FDate3", "" '核对日期
            m_BillInterface.SetFieldValue "FCheckBox1", 0 '按揭公司核对
            m_BillInterface.SaveBill
        
        Else
            If isMortgageSettle = False Then
                MsgBox "未按揭结算，不允许按揭核对", vbInformation, "金蝶提示"
                Cancel = True
                Exit Sub
            End If
            
            optMortCheck = True
            m_BillInterface.BillCtl.BillStatus = Enu_BillStatusExt_New
            m_BillInterface.MenuBar.BOSTools.Item("mnuFileSave").Enabled = True
            m_BillInterface.MenuBar.BOSTools.Item("mnuFileSave").Visible = True
            dctCheckDate("FLock") = 24
            m_BillInterface.LockCell dctCheckDate, 1, False
            m_BillInterface.LockBillEntry 1
        End If
    End If
    
    If BOSTool.ToolName = "mnuMortgageSettle" Then '结算
        If multiCheckStatus <> "16" Then
            MsgBox "未审核状态不允许按揭结算", vbInformation, "金蝶提示"
            Cancel = True
            Exit Sub
        End If
        
        If isMortgageSettle = True Then
            If isMortgageCheck = True Then
                MsgBox "已按揭核对，不允许取消按揭结算", vbInformation, "金蝶提示"
                Cancel = True
                Exit Sub
            End If
            
            If MsgBox("是否取消按揭结算", vbQuestion + vbYesNo, "金蝶提示") <> vbYes Then
                Cancel = True
                Exit Sub
            End If
            
            m_BillInterface.SetFieldValue "FDate2", "" '结算日期
            m_BillInterface.SetFieldValue "FCheckBox", 0 '按揭公司结算
            
            m_BillInterface.SaveBill
        
        Else
            optMortSettle = True
            m_BillInterface.BillCtl.BillStatus = Enu_BillStatusExt_New
            m_BillInterface.MenuBar.BOSTools.Item("mnuFileSave").Enabled = True
            m_BillInterface.MenuBar.BOSTools.Item("mnuFileSave").Visible = True
            dctSettleDate("FLock") = 24
            m_BillInterface.LockCell dctSettleDate, -1, False
            m_BillInterface.LockCell dctReturnAmount, -1, False
            m_BillInterface.LockCell dctMortgageBillNum, -1, False
            m_BillInterface.LockCell dctMortgageInvoiceNum, -1, False
            m_BillInterface.LockBillEntry 1
        
        End If
    End If
    
End Sub


Private Sub m_BillInterface_BeforeSave(bCancel As Boolean)
    Dim classId_src As Long
    Dim billNo_src As String

    classId_src = Val(m_BillInterface.GetFieldValue("FClassID_SRC"))
    billNo_src = m_BillInterface.GetFieldValue("FBillNo_SRC")
    If classId_src = 0 Or billNo_src = "" Then
        MsgBox "按揭登记必须关联代办服务单", vbInformation, "金蝶提示"
        bCancel = True
        Exit Sub
    End If
    
    If optMortCheck = True Then
        If m_BillInterface.GetFieldValue("FDate3") = "" Then
            MsgBox "按揭公司核对日期不能为空", vbInformation, "金蝶提示"
            bCancel = True
            Exit Sub
        End If
        
        m_BillInterface.SetFieldValue "FCheckBox1", 1
        optInusCheck = False
    End If
    
    If optMortSettle = True Then
        If m_BillInterface.GetFieldValue("FDate2") = "" Then
            MsgBox "按揭公司结算日期不能为空", vbInformation, "金蝶提示"
            bCancel = True
            Exit Sub
        End If
        m_BillInterface.SetFieldValue "FCheckBox", 1
        optInusSettle = False
    End If
    
    


End Sub
