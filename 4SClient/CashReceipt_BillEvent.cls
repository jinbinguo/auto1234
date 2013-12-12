VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "CashReceipt_BillEvent"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Attribute VB_Description = "This is BillEvent Interface Class, made by K3BOSPLUGINSWIZAED"
 
'���� BillEvent �ӿ�. ������е�����, �Դ�������¼�
Private WithEvents m_BillInterface  As BillEvent
Attribute m_BillInterface.VB_VarHelpID = -1
 
Public Sub Show(ByVal oBillInterface As Object)
 
    'BillEvent �ӿ�ʵ��
    'ע��: �˷����������, �����޸�
    Set m_BillInterface = oBillInterface
    RegUtils.validateLicenseClient m_BillInterface
End Sub

Private Sub Class_Terminate()
 
    '�ͷŽӿڶ���
    'ע��: �˷����������, �����޸�
    Set m_BillInterface = Nothing

End Sub


Private Sub m_BillInterface_MenuBarClick(ByVal BOSTool As K3ClassEvents.BOSTool, Cancel As Boolean)
    Dim bindingBillTypeNum As String
    Dim sql As String
    Dim rs As ADODB.Recordset
    Dim bindingId As Long
    Dim amountFor As Double
    amountFor = Val(m_BillInterface.GetFieldValue("FAmountFor"))
    bindingId = Val(m_BillInterface.GetFieldValue("FInteger1"))
    bindingBillTypeNum = m_BillInterface.GetFieldValue("FComboBox") '����������
    
    If BOSTool.ToolName = "mnuBinding" Then '����
       If Val(m_BillInterface.GetFieldValue("FCheckerID_CN")) = 0 Then
            MsgBox "δ���,����������", vbInformation, "�����ʾ"
            Exit Sub
       End If
       If Val(m_BillInterface.GetFieldValue("FInteger1")) > 0 Then '����������
            MsgBox "�ѹ�������", vbInformation, "�����ʾ"
            Exit Sub
       End If
       
       frmCashReceiptBinding.ShowForm Me, m_BillInterface
    End If
    
    If BOSTool.ToolName = "mnuUnBinding" Then 'ȡ������
       If Val(m_BillInterface.GetFieldValue("FInteger1")) = 0 Then '����������
            MsgBox "δ��������,����ȡ������.", vbInformation, "�����ʾ"
            Exit Sub
       End If
       
       If MsgBox("�Ƿ�ȡ��������", vbQuestion + vbYesNo, "�����ʾ") = vbYes Then
            If bindingBillTypeNum = "200000028" Then '�������۶���
                sql = "update T_ATS_VehicleSaleOrderEntry " & _
                    "set FReceiptBindingAmount=FReceiptBindingAmount-" & CStr(amountFor) & _
                    " where FID=" & CStr(bindingId)
                m_BillInterface.K3Lib.UpdateData (sql)
            ElseIf bindingBillTypeNum = "200000054" Then '��Ʒ������۶���
                sql = "update T_ATS_DecorationOrder " & _
                    "set FReceiptBindingAmount=FReceiptBindingAmount-" & CStr(amountFor) & _
                    " where FID=" & CStr(bindingId)
                m_BillInterface.K3Lib.UpdateData (sql)
                             
            ElseIf bindingBillTypeNum = "200000045" Then '�������
                sql = "update T_ATS_AgentService " & _
                    "set FReceiptBindingAmount=FReceiptBindingAmount-" & CStr(amountFor) & _
                    " where FID=" & CStr(bindingId)
                m_BillInterface.K3Lib.UpdateData (sql)
                
            End If

            m_BillInterface.SetFieldValue "FInteger1", 0 '������ID
            m_BillInterface.SetFieldValue "FText", "" '����
            m_BillInterface.SetFieldValue "FInteger2", 0 '��������¼ID
            m_BillInterface.SetFieldValue "FInteger", 0 '��������¼�к�
            m_BillInterface.SetFieldValue "FComboBox", 0 '����������
            
            m_BillInterface.SaveBill
            
            MsgBox "ȡ���������", vbInformation, "�����ʾ"
            
       
       End If
        
    End If
End Sub