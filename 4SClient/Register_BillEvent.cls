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
 
'定义 BillEvent 接口. 必须具有的声明, 以此来获得事件
Private WithEvents m_BillInterface  As BillEvent
Attribute m_BillInterface.VB_VarHelpID = -1
 
Public Sub Show(ByVal oBillInterface As Object)
 
    'BillEvent 接口实现
    '注意: 此方法必须存在, 请勿修改
    Set m_BillInterface = oBillInterface

End Sub

Private Sub Class_Terminate()
 
    '释放接口对象
    '注意: 此方法必须存在, 请勿修改
    Set m_BillInterface = Nothing

End Sub


Private Sub m_BillInterface_AfterFirstNewBill()
 m_BillInterface.SetBillFormCaption "汽车4S注册信息"
End Sub



Private Sub m_BillInterface_AfterLoadBill()
     m_BillInterface.SetBillFormCaption "汽车4S注册信息"
End Sub

Private Sub m_BillInterface_CommandClick(ByVal CommandName As String, bCancel As Boolean)
    Dim machineId As String
    Dim orgName As String
    machineId = m_BillInterface.GetFieldValue("FText1")
    orgName = m_BillInterface.GetFieldValue("FText")
    If machineId = "" Or orgName = "" Then
        MsgBox "请先执行获取信息", vbInformation, "金蝶提示"
        Exit Sub
    End If
    Clipboard.SetText "机构名称:" & orgName & vbCrLf & "机器码:" & machineId
    MsgBox "成功复制信息于剪贴板！", vbInformation, "金蝶提示"
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
