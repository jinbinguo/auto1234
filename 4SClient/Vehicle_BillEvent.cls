VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "Vehicle_BillEvent"
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

Private Sub m_BillInterface_AfterNewBill()
    '
End Sub


Private Sub m_BillInterface_BillHeadKeyDown(ByVal Index As Integer, ByVal KeyCode As Integer, ByVal Shift As Integer, ByVal sKey As String, bCancel As Boolean)
'
' If m_BillInterface.BillStatus = Enu_BillStatusExt_View Then
'     Exit Sub
'   End If
'
'   Dim dct As KFO.Dictionary
'   Dim f7ui As F7QueryUI
'   Set f7ui = New F7QueryUI
'   Dim sql As String
'   Dim searchField As New KFO.Dictionary
'   Dim returnFormat As New KFO.Dictionary
'   Dim rs As New ADODB.Recordset
'   Dim i As Integer
'   Dim oldValue As String
'
'   m_BillInterface.GetActiveField dct, 0, 0
'   If dct("FKey") = "FText" Then
'
'        oldValue = m_BillInterface.GetFieldValue("FText")
'         If Shift = 2 And KeyCode = vbKeyV Then
'            MsgBox "F7控件不能使用粘贴，请按F7查询"
'            m_BillInterface.SetFieldValue "FText5", oldValue
'            Exit Sub
'        End If
'        If KeyCode = vbKeyControl Or Shift > 0 Then
'            Exit Sub
'        End If
'
'        sql = "select FID 内码ID,FNumber 车型代码,FName 车型名称,FDesc 车型说明 from T_ATS_Model where 1=1"
'
'        searchField("FNumber") = "代码"
'        searchField("FName") = "名称"
'        searchField("FDesc") = "说明"
'
'        returnFormat("FInteger") = "内码ID"
'        returnFormat("FText") = "车型名称"
'
'        Dim vecReturn As New KFO.Vector
'        With vecReturn
'            .Add "FBase"
'            .Add "FText2"
'            .Add "FBase1"
'            .Add "Fbase2"
'            .Add "Fbase3"
'            .Add "Fbase4"
'            .Add "Fbase5"
'            .Add "Fbase6"
'        End With
'
'
'        If KeyCode = vbKeyF7 Then
'          f7ui.ShowForm Me, m_BillInterface, sql, searchField, returnFormat, "FName", m_BillInterface.GetActiveCtl.Text
'
'          If Not F7UIModule.isCancel Then
'           '按返回值给分录列付值
'            For i = 1 To returnFormat.Count
'                m_BillInterface.SetFieldValue F7UIModule.returnValue.Name(i), F7UIModule.returnValue.Value(F7UIModule.returnValue.Name(i)), lRow
'            Next i
'
'            sql = "select b.FNumber 品牌, a.FCfgDesc 配置说明,c.FNumber 车辆来源,d.FNumber 排量,e.FNumber 变速箱," & _
'                    "f.Fnumber 型版,g.FNumber 动力形式,h.FNumber 驱动形式 " & _
'                    "from T_ATS_Model a " & _
'                    "left join T_ATS_Brand b on b.FID=a.fbrandid " & _
'                    "left join T_ATS_CarSource c on c.FID=a.FCarSourceID " & _
'                    "left join T_ATS_Displacement d on d.FID=a.FDisplacementID " & _
'                    "left join T_ATS_Gearbox e on e.FID=a.FGearboxID " & _
'                    "left join t_ats_Stereotype f on f.fid=a.FStereotypeID " & _
'                    "left join T_ATS_PowerForm g on g.FID=a.FPowerFormID " & _
'                    "left join T_ATS_DriverForm h on h.FID=a.FDriverFormID " & _
'                    "where a.FID = " & CStr(F7UIModule.returnValue.GetValue("FInteger"))
'            Set rs = m_BillInterface.K3Lib.GetData(sql)
'
'            If rs.RecordCount > 0 Then
'                For i = 1 To vecReturn.Size
'                    If Not IsNull(rs(i - 1)) Then
'                        m_BillInterface.SetFieldValue vecReturn.Item(i), rs(i - 1)
'                    End If
'
'                Next i
'
'            End If
'
'
'          End If
'          m_BillInterface.SetActiveCell "FText"
'
'        ElseIf KeyCode = vbKeyDelete Or KeyCode = vbKeyBack Then
'
'            '清除F7返回值
'            For i = 1 To returnFormat.Count
'                m_BillInterface.SetFieldValue returnFormat.Name(i), ""
'            Next i
'            For i = 1 To vecReturn.Size
'                m_BillInterface.SetFieldValue vecReturn.Item(i), ""
'            Next i
'        Else
'            MsgBox "F7控件不能使用手工修改，请按F7查询"
'            m_BillInterface.SetFieldValue "FText", oldValue
'        End If
'
'   End If
End Sub

Private Sub m_BillInterface_Change(ByVal dct As KFO.IDictionary, ByVal dctFld As KFO.IDictionary, ByVal Col As Long, ByVal Row As Long, Cancel As Boolean)
    Dim dctVehicleStatus As KFO.Dictionary
    Dim dctStock As KFO.Dictionary
    If dct("FKey") = "FComboBox4" Then '车辆来源
       Set dctVehicleStatus = m_BillInterface.GetDataFldbyKey("FComboBox2") '车辆状态
       Set dctStock = m_BillInterface.GetFieldInfoByKey("FBase", "", -1) '仓库
       
       If dctFld("FFLD") = "2" Then '=外来车辆
          m_BillInterface.SetFieldValue "FComboBox2", 4
          m_BillInterface.SetFieldValue "FBase", 0
          
          m_BillInterface.LockCell dctStock, -1, True
       Else
          m_BillInterface.SetFieldValue "FComboBox2", 0
          m_BillInterface.LockCell dctStock, -1, False
        
       End If
    End If
End Sub
