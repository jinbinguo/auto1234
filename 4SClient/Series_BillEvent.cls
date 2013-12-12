VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "Series_BillEvent"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Attribute VB_Description = "This is BillEvent Interface Class, made by K3BOSPLUGINSWIZAED"
 
'定义 BillEvent 接口. 必须具有的声明, 以此来获得事件
Private WithEvents m_BillInterface  As BillEvent
Attribute m_BillInterface.VB_VarHelpID = -1
'开始删除动作，包含删除所有行
Private startDel As Boolean
 
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


Private Sub m_BillInterface_BeforeDeleteRow(ByVal Index As Long, ByVal lRow As Long, Cancel As Boolean)
    
    If (Val(m_BillInterface.GetDataFldbyKey("FCombobox")("FFLD")) < 2) Then
        Exit Sub
    End If
    If Not startDel Then
        Cancel = True
        Exit Sub
    End If
    Dim entryIndex As Integer
    Dim entry As BillEntry
    Dim i As Integer
    Dim isNullRow As Boolean
    isNullRow = True
    entryIndex = Index - m_BillInterface.BillHeads.Count
    Set entry = m_BillInterface.BillEntrys(entryIndex)
    For i = 4 To entry.BOSFields.Count
        If (entry.BOSFields(i).Value <> "") Then
            isNullRow = False
            Exit For
        End If
    Next i
    If Not isNullRow And (Val(m_BillInterface.GetDataFldbyKey("FCombobox")("FFLD")) >= 2) Then
        MsgBox "已启用或已禁用不能删除分录！"
        Cancel = True
        startDel = False
    End If
End Sub


 
Private Sub m_BillInterface_MenuBarClick(ByVal BOSTool As K3ClassEvents.BOSTool, Cancel As Boolean)
    If (BOSTool.ToolName = "mnuEditDelRow" Or BOSTool.ToolName = "mnuEditDelEntry") Then
        startDel = True
    End If
    
End Sub
