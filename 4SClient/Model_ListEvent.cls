VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "Model_ListEvent"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Attribute VB_Description = "This is ListEvents Interface Class, made by K3BOSPLUGINSWIZAED"
 
'定义 ListEvents 接口. 必须具有的声明, 以此来获得事件
Private WithEvents m_ListInterface  As ListEvents
Attribute m_ListInterface.VB_VarHelpID = -1
 
Public Sub Show(ByVal oListInterface As Object)
 
    'ListEvents 接口实现
    '注意: 此方法必须存在, 请勿修改
    Set m_ListInterface = oListInterface
 
End Sub

Private Sub Class_Terminate()
 
    '释放接口对象
    '注意: 此方法必须存在, 请勿修改
    Set m_ListInterface = Nothing

End Sub

Private Sub m_ListInterface_MenuBarClick(ByVal BOSTool As K3ClassEvents.BOSTool, Cancel As Boolean)
 
    'TODO: 请在此处添加代码响应事件
    Dim vec As Vector
    Dim sql As String
    Dim i As Integer
    Dim procName As String
    procName = "proc_createICItemForAuto"
    Dim userID As Long
    userID = m_ListInterface.K3Lib.User.userID
    Dim procSQL As String
    Dim rs As ADODB.Recordset
    
    Select Case BOSTool.ToolName
    Case "mnuEditUse"
        If MsgBox("启用后，将自动生成对应物料，是否继续？", vbQuestion + vbYesNo, "金蝶提示") = vbYes Then
            Set vec = getSelectedIds
            sql = "UPDATE T_ATS_Model set fstatus='2' where"
            For i = 1 To vec.Size
                sql = sql & " FID=" & vec(i)
                If i <> vec.Size Then
                    sql = sql & " OR"
                End If
                procSQL = "exec " & procName & " " & CStr(vec(i)) & ", " & CStr(userID)
                Set rs = m_ListInterface.K3Lib.GetData(procSQL)
            Next i
            
            m_ListInterface.K3Lib.UpdateData sql
            MsgBox "启用成功", vbInformation, "金蝶提示"
            m_ListInterface.RefreshList
        End If
    Case "mnuEditUnUse"
        Set vec = getSelectedIds
        sql = "UPDATE T_ATS_Model set fstatus='3' where"
        For i = 1 To vec.Size
            sql = sql & " FID=" & vec(i)
            If i <> vec.Size Then sql = sql & " OR"
        Next i
        m_ListInterface.K3Lib.UpdateData sql
        MsgBox "禁用成功", vbInformation, "金蝶提示"
        m_ListInterface.RefreshList
    Case Else
    End Select

End Sub

Private Function getSelectedIds() As Vector
    Dim i As Integer
    Dim vec As New Vector
    Dim vecSelIds As Vector
    Set vecSelIds = m_ListInterface.GetSelectedBillInfo
    Dim id As Integer
    id = -1
    For i = 1 To vecSelIds.Size
        Dim newId As Integer
        newId = vecSelIds(i)("FID")
        If (newId <> id) Then
            vec.Add (newId)
            id = newId
        End If
    Next i
    Set getSelectedIds = vec
End Function

Private Sub m_ListInterface_MenuBarInitialize(ByVal oMenuBar As K3ClassEvents.MenuBar)
 
    Dim oTool   As K3ClassEvents.BOSTool
    Dim oBand   As K3ClassEvents.BOSBand
 
'*************** 开始新增 BOS 菜单 ***************

    Set oBand = oMenuBar.BOSBands("mnuEdit")
    
    '新增 mnuEditUse 菜单对象，并设置属性
    Set oTool = oMenuBar.BOSTools.Add("mnuEditUse")
    With oTool
        .Caption = "反禁用"
        .ToolTipText = "反禁用"
        .Description = "反禁用"
        .ShortcutKey = 0
        .Visible = True
        .Enabled = True
    End With
 

    oBand.BOSTools.InsertAfter "mnuEditDelete", oTool   '将菜单对象插入指定一级菜单
 
    '新增 mnuEditUnUse 菜单对象，并设置属性
    Set oTool = oMenuBar.BOSTools.Add("mnuEditUnUse")
    With oTool
        .Caption = "禁用"
        .ToolTipText = "禁用"
        .Description = "禁用"
        .ShortcutKey = 0
        .Visible = True
        .Enabled = True
    End With

    oBand.BOSTools.InsertAfter "mnuEditDelete", oTool   '将菜单对象插入指定一级菜单
 
 
'*************** 结束新增 BOS 菜单 ***************
 

End Sub
