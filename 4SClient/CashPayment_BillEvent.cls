VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "CashPayment_BillEvent"
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

Private Sub m_BillInterface_MenuBarClick(ByVal BOSTool As K3ClassEvents.BOSTool, Cancel As Boolean)
    Dim bindingBillTypeNum As String
    Dim sql As String
    Dim rs As ADODB.Recordset
    Dim bindingId As Long
    Dim bindingEntryId As Long
    Dim amountFor As Double
    amountFor = m_BillInterface.GetFieldValue("FAmountFor")
    bindingId = Val(m_BillInterface.GetFieldValue("FInteger1")) '关联单ID
    bindingEntryId = Val(m_BillInterface.GetFieldValue("FInteger2"))  '关联单分录ID
    bindingBillTypeNum = m_BillInterface.GetFieldValue("FComboBox") '关联单类型
    
    If BOSTool.ToolName = "mnuBinding" Then '关联
       If Val(m_BillInterface.GetFieldValue("FCheckerID_CN")) = 0 Then
            MsgBox "未审核,不允许关联", vbInformation, "金蝶提示"
            Exit Sub
       End If
       If Val(m_BillInterface.GetFieldValue("FInteger1")) > 0 Then '关联单内码
            MsgBox "已关联单据", vbInformation, "金蝶提示"
            Exit Sub
       End If
       
       frmCashPayBinding.ShowForm Me, m_BillInterface
    End If
    
    If BOSTool.ToolName = "mnuUnBinding" Then '取消关联
       If Val(m_BillInterface.GetFieldValue("FInteger1")) = 0 Then '关联单内码
            MsgBox "未关联单据,无需取消关联.", vbInformation, "金蝶提示"
            Exit Sub
       End If
        
       If MsgBox("是否取消关联？", vbQuestion + vbYesNo, "金蝶提示") = vbYes Then
            
            If bindingBillTypeNum = "200000028" Then '整车销售订单
                sql = "update T_ATS_VehicleSaleOrderEntry " & _
                    "set FPayBindingAmount=FPayBindingAmount-" & CStr(amountFor) & _
                    " where FID=" & CStr(bindingId) & " and FEntryID=" & CStr(bindingEntryId)
                m_BillInterface.K3Lib.UpdateData (sql)
            
            ElseIf bindingBillTypeNum = "200000054" Then '精品配件销售订单
                sql = "update T_ATS_DecorationOrder " & _
                    "set FPayBindingAmount=FPayBindingAmount-" & CStr(amountFor) & _
                    " where FID=" & CStr(bindingId)
                m_BillInterface.K3Lib.UpdateData (sql)
            
            ElseIf bindingBillTypeNum = "200000045" Then '代办服务单
                sql = "update T_ATS_AgentService " & _
                    "set FPayBindingAmount=FPayBindingAmount-" & CStr(amountFor) & _
                    " where FID=" & CStr(bindingId)
                m_BillInterface.K3Lib.UpdateData (sql)
            
            ElseIf bindingBillTypeNum = "200000023" Then '整车采购订单
                 sql = "update T_ATS_VehiclePurOrderEntry " & _
                    "set FPayBindingAmount=FPayBindingAmount-" & CStr(amountFor) & _
                    " where FID=" & CStr(bindingId) & " and FEntryID=" & CStr(bindingEntryId)
                m_BillInterface.K3Lib.UpdateData (sql)
            
            ElseIf bindingBillTypeNum = "P02" Then '精品配件采购订单
                sql = "update POOrder " & _
                    "set FPayBindingAmount=FPayBindingAmount-" & CStr(amountFor) & _
                    " where FInterID=" & CStr(bindingId)
                m_BillInterface.K3Lib.UpdateData (sql)
            Else
            
            End If
            
            
       

            m_BillInterface.SetFieldValue "FInteger1", 0 '关联单ID
            m_BillInterface.SetFieldValue "FText", "" '单号
            m_BillInterface.SetFieldValue "FInteger2", 0 '关联单分录ID
            m_BillInterface.SetFieldValue "FInteger", 0 '关联单分录行号
            m_BillInterface.SetFieldValue "FComboBox", 0 '关联单类型
            
            m_BillInterface.SaveBill
            MsgBox "取消关联完成", vbInformation, "金蝶提示"
            
       End If
        
    End If
End Sub
