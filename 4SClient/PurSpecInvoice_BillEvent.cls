VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "PurSpecInvoice_BillEvent"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Attribute VB_Description = "This is BillEvent Interface Class, made by K3BOSPLUGINSWIZAED"
 
'定义 BillEvent 接口. 必须具有的声明, 以此来获得事件
Private WithEvents m_BillInterface  As BillEvent
Attribute m_BillInterface.VB_VarHelpID = -1
Private isBotp As Boolean
 
Public Sub Show(ByVal oBillInterface As Object)
 
    'BillEvent 接口实现
    '注意: 此方法必须存在, 请勿修改
    Set m_BillInterface = oBillInterface
    isBotp = False
    RegUtils.validateLicenseClient m_BillInterface
End Sub

Private Sub Class_Terminate()
 
    '释放接口对象
    '注意: 此方法必须存在, 请勿修改
    Set m_BillInterface = Nothing

End Sub

Private Sub m_BillInterface_AfterSelBill(ByVal lSelBillType As Long)
    If lSelBillType = 200000023 Then '整车采购订单
        m_BillInterface.SetFieldValue "FItemClassID", 8 '供应商
        m_BillInterface.InsertNewRowAndFill 3, m_BillInterface.BillEntrys(2).GridMaxDataRowNum + 1, nil
        isBotp = True
    End If
    
    If lSelBillType = 200000059 Then '整车入库单
        m_BillInterface.SetFieldValue "FItemClassID", 8 '供应商
        m_BillInterface.InsertNewRowAndFill 3, m_BillInterface.BillEntrys(2).GridMaxDataRowNum + 1, nil
        isBotp = True
    End If
    
End Sub



Private Sub resetICItemInfo()
    Dim i As Integer
    Dim rs As ADODB.Recordset
    Dim sql As String
    Dim icitemId As Long
    
    For i = 1 To m_BillInterface.BillEntrys(2).GridMaxDataRowNum
        icitemId = Val(m_BillInterface.GetFieldValue("FItemID", i))
        sql = "select a.FNumber icItemNum,a.FName icitemName,isnull(a.FModel,'') FModel,b.FName unitName,b.FNumber unitNumber from t_ICItem a " & _
              "left join t_MeasureUnit b on b.FItemID=a.FUnitID and b.FItemID <>0 " & _
              "where a.FItemID=" & icitemId
        If icitemId > 0 Then
            Set rs = m_BillInterface.K3Lib.GetData(sql)
            If Not rs.EOF Then
                m_BillInterface.SetFieldValue "FItemID36422", rs!icitemName, i
                m_BillInterface.SetFieldValue "FItemID36436", rs!FModel, i
                m_BillInterface.SetFieldValue "FBaseUnit", rs!unitName, i
            
            End If
        End If
    Next i


End Sub


Private Sub m_BillInterface_CompleteQueryData(ByVal lPage As Long, ByVal lEntrySize As Long, ByVal lRowStart As Long, ByVal lRowsRequest As Long, ByVal lRowsResponse As Long)
    If lPage = 3 And isBotp = True Then
        m_BillInterface.SetFieldValue "fdate_2", Format(Now, "yyyy-mm-dd"), 1
        resetICItemInfo
        isBotp = False
    End If
    
    
End Sub

