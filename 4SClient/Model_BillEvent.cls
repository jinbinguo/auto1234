VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 1  'vbSimpleBound
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "Model_BillEvent"
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




Private Sub m_BillInterface_AfterFirstNewBill()
'
End Sub


Private Sub m_BillInterface_AfterLoadBill()
'
End Sub

Private Sub m_BillInterface_AfterNewBill()
    Dim sql As String
    Dim rs As ADODB.Recordset
    sql = "select b.FNumber,b.FName from T_ATS_ModelICItemConfig a left join t_Item  b on b.FItemID=a.FICItemClassID"
    Set rs = m_BillInterface.K3Lib.GetData(sql)
    If Not rs.EOF Then
        m_BillInterface.SetFieldValue "FBase9", rs!FNumber '物料分类
    End If
End Sub

Private Sub m_BillInterface_BillHeadKeyDown(ByVal Index As Integer, ByVal KeyCode As Integer, ByVal Shift As Integer, ByVal sKey As String, bCancel As Boolean)
           
'   If m_BillInterface.BillStatus = Enu_BillStatusExt_View Then
'     Exit Sub
'   End If
'
'   Dim dct As KFO.Dictionary
'   Dim f7ui As F7QueryUI
'   Set f7ui = New F7QueryUI
'   Dim sql As String
'   Dim searchField As New KFO.Dictionary
'   Dim returnFormat As New KFO.Dictionary
'
'   m_BillInterface.GetActiveField dct, 0, 0
'   If dct("FKey") = "FText5" Then
'        Dim oldValue As String
'        oldValue = m_BillInterface.GetFieldValue("FText5")
'        If Shift = 2 And KeyCode = vbKeyV Then
'            MsgBox "F7控件不能使用粘贴，请按F7查询"
'            m_BillInterface.SetFieldValue "FText5", oldValue
'            Exit Sub
'        End If
'        If KeyCode = vbKeyControl Or Shift > 0 Then
'            Exit Sub
'        End If
'
'        sql = "select a.FID 内码ID,a.fnumber 代码,a.FName 车系名称,b.FName 品牌,b.FNumber 品牌代码 from T_ATS_Series a " & _
'                   "left join t_ats_brand b on b.fid=a.FBrandID where 1=1"
'
'        searchField("a.fnumber") = "代码"
'        searchField("a.fname") = "名称"
'        searchField("b.fname") = "品牌"
'
'
'        returnFormat("FInteger") = "内码ID"
'        returnFormat("FText5") = "车系名称"
'        returnFormat("FBase8") = "品牌代码"
'        If KeyCode = vbKeyF7 Then
'
'
'          f7ui.ShowForm Me, m_BillInterface, sql, searchField, returnFormat, "a.fname", m_BillInterface.GetActiveCtl.Text
'
'          If Not F7UIModule.isCancel Then
'            '按返回值给分录列付值
'               For i = 1 To returnFormat.Count
'                  m_BillInterface.SetFieldValue returnFormat.Name(i), F7UIModule.returnValue.Value(returnFormat.Name(i))
'               Next i
'          End If
'        m_BillInterface.SetActiveCell "FText5"
'
'        ElseIf KeyCode = vbKeyDelete Or KeyCode = vbKeyBack Then
'            For i = 1 To returnFormat.Count
'                m_BillInterface.SetFieldValue returnFormat.Name(i), ""
'            Next i
'            With m_BillInterface
'                .SetFieldValue "FBase", ""
'                .SetFieldValue "FBase1", ""
'                .SetFieldValue "FBase2", ""
'                .SetFieldValue "FBase3", ""
'                .SetFieldValue "FBase4", ""
'                .SetFieldValue "FText8", ""
'
'            End With
'        Else
'            MsgBox "F7控件不能使用手工修改，请按F7查询"
'            m_BillInterface.SetFieldValue "FText5", oldValue
'        End If
'
'
'   End If
    
End Sub


Private Sub m_BillInterface_Change(ByVal dct As KFO.IDictionary, ByVal dctFld As KFO.IDictionary, ByVal Col As Long, ByVal Row As Long, Cancel As Boolean)
     If (dct("FKey") = "FBase10") Then
        If dctFld("FFLD") = "" Then
           With m_BillInterface
              .SetFieldValue "FBaseProperty", ""
              .SetFieldValue "FBase", ""
              .SetFieldValue "FBase1", ""
              .SetFieldValue "FBase2", ""
              .SetFieldValue "FBase3", ""
              .SetFieldValue "FBase4", ""
              .SetFieldValue "FBase5", ""
              .SetFieldValue "FBase6", ""
              .SetFieldValue "FBase7", ""
           
           End With
        
        End If
        
     End If

End Sub

Private Sub m_BillInterface_MenuBarClick(ByVal BOSTool As K3ClassEvents.BOSTool, Cancel As Boolean)
    Dim dctStatus As KFO.Dictionary
    Dim dctICItem As KFO.Dictionary
    Dim dctICItemClass As KFO.Dictionary
    
    If (BOSTool.ToolName = "mnuCancel") Then '禁用
        
        Set dctStatus = m_BillInterface.GetDataFldbyKey("FCombobox")
        
        If (dctStatus("FFLD") = "3") Then
            MsgBox "已禁用状态，不能再禁用！", vbError + vbOKOnly, "金蝶提示"
            Cancel = True
            Exit Sub
        End If
        m_BillInterface.SetFieldValue "FCombobox", 3 '禁用状态
        m_BillInterface.SaveBill
        MsgBox "禁用成功！", vbOKOnly + vbInformation, "金蝶提示"
        
    End If
    If (BOSTool.ToolName = "mnuCancelCancel") Then '启动时，若未成物料，则自动生成一物料
    
        
        Set dctICItem = m_BillInterface.GetDataFldbyKey("FBase5") '对应物料
        
        Set dctICItemClass = m_BillInterface.GetDataFldbyKey("FBase9") '物料分类
        If (dctICItemClass("FFLD") = "") Then
            MsgBox "物料分类不能为空", vbError + vbOKOnly, "金蝶提示"
            Cancel = True
            Exit Sub
        End If

        Set dctStatus = m_BillInterface.GetDataFldbyKey("FCombobox")
        
        If (dctStatus("FFLD") = "2") Then
            MsgBox "已启用状态，不能再启用！", vbError + vbOKOnly, "金蝶提示"
            Cancel = True
            Exit Sub
        End If
        If (dctICItem("FFLD") = "") Then
            If MsgBox("启用后，将自动生成对应物料，是否继续？", vbQuestion + vbYesNo, "金蝶提示") = vbYes Then
                Dim procName As String
                Dim procSQL As String
                Dim modelId As Integer
                Dim rs As ADODB.Recordset
                Dim icitemNum As String
                Dim unitNum As String
                Dim userID As Integer
                procName = "proc_createICItemForAuto"
                userID = m_BillInterface.K3Lib.User.userID
                procSQL = "exec " & procName & " " & CStr(m_BillInterface.Data("FID")) & ", " & CStr(userID)
                Set rs = m_BillInterface.K3Lib.GetData(procSQL)
                If Not rs.EOF Then
                    icitemNum = rs(0)
                    unitNum = rs(1)
               
                    m_BillInterface.SetFieldValue "FBase5", icitemNum '物料
                    m_BillInterface.SetFieldValue "FBase6", unitNum '计量单位
                End If
            Else
                Cancel = True
                Exit Sub
            End If
        End If
        m_BillInterface.SetFieldValue "FCombobox", 2 '启用状态
        m_BillInterface.SaveBill
        MsgBox "启用成功！", vbOKOnly + vbInformation, "金蝶提示"
    
    End If
    
End Sub
