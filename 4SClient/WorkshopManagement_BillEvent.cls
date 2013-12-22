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

Private Sub m_BillInterface_MenuBarClick(ByVal BOSTool As K3ClassEvents.BOSTool, Cancel As Boolean)
 
    Select Case BOSTool.ToolName
    Case "a1"
        '�˴����Ӵ���a1 �˵������ Click �¼�
 
    Case "a2"
        '�˴����Ӵ���a2 �˵������ Click �¼�
 
    Case "a3"
        '�˴����Ӵ���a3 �˵������ Click �¼�
 
    Case "a4"
        '�˴����Ӵ���a4 �˵������ Click �¼�
 
    Case "a5"
        '�˴����Ӵ���a5 �˵������ Click �¼�
 
    Case "a6"
        '�˴����Ӵ���a6 �˵������ Click �¼�
 
    Case "a7"
        '�˴����Ӵ���a7 �˵������ Click �¼�
 
    Case "a8"
        '�˴����Ӵ���a8 �˵������ Click �¼�
 
    Case "a9"
        '�˴����Ӵ���a9 �˵������ Click �¼�
 
    Case "a10"
        '�˴����Ӵ���a10 �˵������ Click �¼�
 
    Case Else
    End Select

End Sub

Private Sub m_BillInterface_MenuBarInitialize(ByVal oMenuBar As K3ClassEvents.MenuBar)
 
    Dim oTool   As K3ClassEvents.BOSTool
    Dim oBand   As K3ClassEvents.BOSBand
 
'*************** ��ʼ���� BOS �˵� ***************
 
    '���� a1 �˵����󣬲���������
    Set oTool = oMenuBar.BOSTools.Add("a1")
    With oTool
        .Caption = "�ɹ�"
        .ToolTipText = "�ɹ�"
        .Description = "�ɹ�"
        .ShortcutKey = 0
        .Visible = True
        .Enabled = True
        .BeginGroup = True
    End With
 
    Set oBand = oMenuBar.BOSBands("BandToolBar")
    oBand.BOSTools.InsertBefore "mnuFileNew", oTool '���˵��������ָ��������
 
    '���� a2 �˵����󣬲���������
    Set oTool = oMenuBar.BOSTools.Add("a2")
    With oTool
        .Caption = "���ɹ�"
        .ToolTipText = "���ɹ�"
        .Description = "���ɹ�"
        .ShortcutKey = 0
        .Visible = True
        .Enabled = True
        .BeginGroup = False
    End With
 
    Set oBand = oMenuBar.BOSBands("BandToolBar")
    oBand.BOSTools.InsertBefore "mnuFileNew", oTool '���˵��������ָ��������
 
    '���� a3 �˵����󣬲���������
    Set oTool = oMenuBar.BOSTools.Add("a3")
    With oTool
        .Caption = "ά���ж�"
        .ToolTipText = "ά���ж�"
        .Description = "ά���ж�"
        .ShortcutKey = 0
        .Visible = True
        .Enabled = True
        .BeginGroup = True
    End With
 
    Set oBand = oMenuBar.BOSBands("BandToolBar")
    oBand.BOSTools.InsertBefore "mnuFileNew", oTool '���˵��������ָ��������
 
    '���� a4 �˵����󣬲���������
    Set oTool = oMenuBar.BOSTools.Add("a4")
    With oTool
        .Caption = "��ά���ж�"
        .ToolTipText = "��ά���ж�"
        .Description = "��ά���ж�"
        .ShortcutKey = 0
        .Visible = True
        .Enabled = True
        .BeginGroup = False
    End With
 
    Set oBand = oMenuBar.BOSBands("BandToolBar")
    oBand.BOSTools.InsertBefore "mnuFileNew", oTool '���˵��������ָ��������
 
    '���� a5 �˵����󣬲���������
    Set oTool = oMenuBar.BOSTools.Add("a5")
    With oTool
        .Caption = "��ʱ�Ǽ�"
        .ToolTipText = "��ʱ�Ǽ�"
        .Description = "��ʱ�Ǽ�"
        .ShortcutKey = 0
        .Visible = True
        .Enabled = True
        .BeginGroup = True
    End With
 
    Set oBand = oMenuBar.BOSBands("BandToolBar")
    oBand.BOSTools.InsertBefore "mnuFileNew", oTool '���˵��������ָ��������
 
    '���� a6 �˵����󣬲���������
    Set oTool = oMenuBar.BOSTools.Add("a6")
    With oTool
        .Caption = "����ʱ�Ǽ�"
        .ToolTipText = "����ʱ�Ǽ�"
        .Description = "����ʱ�Ǽ�"
        .ShortcutKey = 0
        .Visible = True
        .Enabled = True
        .BeginGroup = False
    End With
 
    Set oBand = oMenuBar.BOSBands("BandToolBar")
    oBand.BOSTools.InsertBefore "mnuFileNew", oTool '���˵��������ָ��������
 
    '���� a7 �˵����󣬲���������
    Set oTool = oMenuBar.BOSTools.Add("a7")
    With oTool
        .Caption = "�ʼ�"
        .ToolTipText = "�ʼ�"
        .Description = "�ʼ�"
        .ShortcutKey = 0
        .Visible = True
        .Enabled = True
        .BeginGroup = False
    End With
 
    Set oBand = oMenuBar.BOSBands("BandToolBar")
    oBand.BOSTools.InsertBefore "mnuFileNew", oTool '���˵��������ָ��������
 
    '���� a8 �˵����󣬲���������
    Set oTool = oMenuBar.BOSTools.Add("a8")
    With oTool
        .Caption = "���ʼ�"
        .ToolTipText = "���ʼ�"
        .Description = "���ʼ�"
        .ShortcutKey = 0
        .Visible = True
        .Enabled = True
        .BeginGroup = False
    End With
 
    Set oBand = oMenuBar.BOSBands("BandToolBar")
    oBand.BOSTools.InsertBefore "mnuFileNew", oTool '���˵��������ָ��������
 
    '���� a9 �˵����󣬲���������
    Set oTool = oMenuBar.BOSTools.Add("a9")
    With oTool
        .Caption = "ϴ��"
        .ToolTipText = "ϴ��"
        .Description = "ϴ��"
        .ShortcutKey = 0
        .Visible = True
        .Enabled = True
        .BeginGroup = False
    End With
 
    Set oBand = oMenuBar.BOSBands("BandToolBar")
    oBand.BOSTools.InsertBefore "mnuFileNew", oTool '���˵��������ָ��������
 
    '���� a10 �˵����󣬲���������
    Set oTool = oMenuBar.BOSTools.Add("a10")
    With oTool
        .ToolTipText = "��ϴ��"
        .Description = "��ϴ��"
        .ShortcutKey = 0
        .Visible = True
        .Enabled = True
        .BeginGroup = False
    End With
 
    Set oBand = oMenuBar.BOSBands("BandToolBar")
    oBand.BOSTools.InsertBefore "mnuFileNew", oTool '���˵��������ָ��������
     

    '���� a11 �˵����󣬲���������
    Set oTool = oMenuBar.BOSTools.Add("a11")
    With oTool
            .ToolTipText = "����ų�"
        .Description = "����ų�"
        .ShortcutKey = 0
        .Visible = True
        .Enabled = True
        .BeginGroup = False
    End With
 
    Set oBand = oMenuBar.BOSBands("BandToolBar")
    oBand.BOSTools.InsertBefore "mnuFileNew", oTool  '���˵��������ָ��������
    
     '���� a12 �˵����󣬲���������
    Set oTool = oMenuBar.BOSTools.Add("a12")
    With oTool
        .ToolTipText = "������"
        .Description = "������"
        .ShortcutKey = 0
        .Visible = True
        .Enabled = True
        .BeginGroup = False
    End With
 
    Set oBand = oMenuBar.BOSBands("BandToolBar")
    oBand.BOSTools.InsertBefore "mnuFileNew", oTool '���˵��������ָ��������
     
     
 
'*************** �������� BOS �˵� ***************
 

End Sub