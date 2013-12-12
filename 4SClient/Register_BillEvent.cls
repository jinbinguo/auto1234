VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "Register_BillEvent"
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

End Sub

Private Sub Class_Terminate()
 
    '�ͷŽӿڶ���
    'ע��: �˷����������, �����޸�
    Set m_BillInterface = Nothing

End Sub


Private Sub m_BillInterface_AfterFirstNewBill()
 m_BillInterface.SetBillFormCaption "����4Sע����Ϣ"
End Sub



Private Sub m_BillInterface_AfterLoadBill()
     m_BillInterface.SetBillFormCaption "����4Sע����Ϣ"
End Sub

Private Sub m_BillInterface_CommandClick(ByVal CommandName As String, bCancel As Boolean)
    Dim machineId As String
    Dim orgName As String
    machineId = m_BillInterface.GetFieldValue("FText1")
    orgName = m_BillInterface.GetFieldValue("FText")
    If machineId = "" Or orgName = "" Then
        MsgBox "����ִ�л�ȡ��Ϣ", vbInformation, "�����ʾ"
        Exit Sub
    End If
    Clipboard.SetText "��������:" & orgName & vbCrLf & "������:" & machineId
    MsgBox "�ɹ�������Ϣ�ڼ����壡", vbInformation, "�����ʾ"
End Sub

Private Sub m_BillInterface_HeadCtlClick(ByVal ctl As Object, ByVal dct As KFO.IDictionary)
'
End Sub

Private Sub m_BillInterface_MenuBarClick(ByVal BOSTool As K3ClassEvents.BOSTool, Cancel As Boolean)
    If BOSTool.ToolName = "btnGetInfo" Then
        m_BillInterface.SaveBill
        m_BillInterface.SetFieldValue "FTime", Format(Now, "yyyy-MM-dd HH:mm:ss")
        m_BillInterface.SaveBill
    End If
End Sub