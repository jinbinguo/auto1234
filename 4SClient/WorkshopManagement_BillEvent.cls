VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "WorkshopManagement_BillEvent"
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

Private Sub m_BillInterface_MenuBarClick(ByVal BOSTool As K3ClassEvents.BOSTool, Cancel As Boolean)
 
    Select Case BOSTool.ToolName
    Case "a1"
        '此处添加处理a1 菜单对象的 Click 事件
 
    Case "a2"
        '此处添加处理a2 菜单对象的 Click 事件
 
    Case "a3"
        '此处添加处理a3 菜单对象的 Click 事件
 
    Case "a4"
        '此处添加处理a4 菜单对象的 Click 事件
 
    Case "a5"
        '此处添加处理a5 菜单对象的 Click 事件
 
    Case "a6"
        '此处添加处理a6 菜单对象的 Click 事件
 
    Case "a7"
        '此处添加处理a7 菜单对象的 Click 事件
 
    Case "a8"
        '此处添加处理a8 菜单对象的 Click 事件
 
    Case "a9"
        '此处添加处理a9 菜单对象的 Click 事件
 
    Case "a10"
        '此处添加处理a10 菜单对象的 Click 事件
 
    Case Else
    End Select

End Sub

Private Sub m_BillInterface_MenuBarInitialize(ByVal oMenuBar As K3ClassEvents.MenuBar)
 
    Dim oTool   As K3ClassEvents.BOSTool
    Dim oBand   As K3ClassEvents.BOSBand
 
'*************** 开始新增 BOS 菜单 ***************
 
    '新增 a1 菜单对象，并设置属性
    Set oTool = oMenuBar.BOSTools.Add("a1")
    With oTool
        .Caption = "派工"
        .ToolTipText = "派工"
        .Description = "派工"
        .ShortcutKey = 0
        .Visible = True
        .Enabled = True
        .BeginGroup = True
    End With
 
    Set oBand = oMenuBar.BOSBands("BandToolBar")
    oBand.BOSTools.InsertBefore "mnuFileNew", oTool '将菜单对象插入指定工具栏
 
    '新增 a2 菜单对象，并设置属性
    Set oTool = oMenuBar.BOSTools.Add("a2")
    With oTool
        .Caption = "反派工"
        .ToolTipText = "反派工"
        .Description = "反派工"
        .ShortcutKey = 0
        .Visible = True
        .Enabled = True
        .BeginGroup = False
    End With
 
    Set oBand = oMenuBar.BOSBands("BandToolBar")
    oBand.BOSTools.InsertBefore "mnuFileNew", oTool '将菜单对象插入指定工具栏
 
    '新增 a3 菜单对象，并设置属性
    Set oTool = oMenuBar.BOSTools.Add("a3")
    With oTool
        .Caption = "维修中断"
        .ToolTipText = "维修中断"
        .Description = "维修中断"
        .ShortcutKey = 0
        .Visible = True
        .Enabled = True
        .BeginGroup = True
    End With
 
    Set oBand = oMenuBar.BOSBands("BandToolBar")
    oBand.BOSTools.InsertBefore "mnuFileNew", oTool '将菜单对象插入指定工具栏
 
    '新增 a4 菜单对象，并设置属性
    Set oTool = oMenuBar.BOSTools.Add("a4")
    With oTool
        .Caption = "反维修中断"
        .ToolTipText = "反维修中断"
        .Description = "反维修中断"
        .ShortcutKey = 0
        .Visible = True
        .Enabled = True
        .BeginGroup = False
    End With
 
    Set oBand = oMenuBar.BOSBands("BandToolBar")
    oBand.BOSTools.InsertBefore "mnuFileNew", oTool '将菜单对象插入指定工具栏
 
    '新增 a5 菜单对象，并设置属性
    Set oTool = oMenuBar.BOSTools.Add("a5")
    With oTool
        .Caption = "工时登记"
        .ToolTipText = "工时登记"
        .Description = "工时登记"
        .ShortcutKey = 0
        .Visible = True
        .Enabled = True
        .BeginGroup = True
    End With
 
    Set oBand = oMenuBar.BOSBands("BandToolBar")
    oBand.BOSTools.InsertBefore "mnuFileNew", oTool '将菜单对象插入指定工具栏
 
    '新增 a6 菜单对象，并设置属性
    Set oTool = oMenuBar.BOSTools.Add("a6")
    With oTool
        .Caption = "反工时登记"
        .ToolTipText = "反工时登记"
        .Description = "反工时登记"
        .ShortcutKey = 0
        .Visible = True
        .Enabled = True
        .BeginGroup = False
    End With
 
    Set oBand = oMenuBar.BOSBands("BandToolBar")
    oBand.BOSTools.InsertBefore "mnuFileNew", oTool '将菜单对象插入指定工具栏
 
    '新增 a7 菜单对象，并设置属性
    Set oTool = oMenuBar.BOSTools.Add("a7")
    With oTool
        .Caption = "质检"
        .ToolTipText = "质检"
        .Description = "质检"
        .ShortcutKey = 0
        .Visible = True
        .Enabled = True
        .BeginGroup = False
    End With
 
    Set oBand = oMenuBar.BOSBands("BandToolBar")
    oBand.BOSTools.InsertBefore "mnuFileNew", oTool '将菜单对象插入指定工具栏
 
    '新增 a8 菜单对象，并设置属性
    Set oTool = oMenuBar.BOSTools.Add("a8")
    With oTool
        .Caption = "反质检"
        .ToolTipText = "反质检"
        .Description = "反质检"
        .ShortcutKey = 0
        .Visible = True
        .Enabled = True
        .BeginGroup = False
    End With
 
    Set oBand = oMenuBar.BOSBands("BandToolBar")
    oBand.BOSTools.InsertBefore "mnuFileNew", oTool '将菜单对象插入指定工具栏
 
    '新增 a9 菜单对象，并设置属性
    Set oTool = oMenuBar.BOSTools.Add("a9")
    With oTool
        .Caption = "洗车"
        .ToolTipText = "洗车"
        .Description = "洗车"
        .ShortcutKey = 0
        .Visible = True
        .Enabled = True
        .BeginGroup = False
    End With
 
    Set oBand = oMenuBar.BOSBands("BandToolBar")
    oBand.BOSTools.InsertBefore "mnuFileNew", oTool '将菜单对象插入指定工具栏
 
    '新增 a10 菜单对象，并设置属性
    Set oTool = oMenuBar.BOSTools.Add("a10")
    With oTool
        .ToolTipText = "反洗车"
        .Description = "反洗车"
        .ShortcutKey = 0
        .Visible = True
        .Enabled = True
        .BeginGroup = False
    End With
 
    Set oBand = oMenuBar.BOSBands("BandToolBar")
    oBand.BOSTools.InsertBefore "mnuFileNew", oTool '将菜单对象插入指定工具栏
     

    '新增 a11 菜单对象，并设置属性
    Set oTool = oMenuBar.BOSTools.Add("a11")
    With oTool
            .ToolTipText = "结算放车"
        .Description = "结算放车"
        .ShortcutKey = 0
        .Visible = True
        .Enabled = True
        .BeginGroup = False
    End With
 
    Set oBand = oMenuBar.BOSBands("BandToolBar")
    oBand.BOSTools.InsertBefore "mnuFileNew", oTool  '将菜单对象插入指定工具栏
    
     '新增 a12 菜单对象，并设置属性
    Set oTool = oMenuBar.BOSTools.Add("a12")
    With oTool
        .ToolTipText = "反结算"
        .Description = "反结算"
        .ShortcutKey = 0
        .Visible = True
        .Enabled = True
        .BeginGroup = False
    End With
 
    Set oBand = oMenuBar.BOSBands("BandToolBar")
    oBand.BOSTools.InsertBefore "mnuFileNew", oTool '将菜单对象插入指定工具栏
     
     
 
'*************** 结束新增 BOS 菜单 ***************
 

End Sub
