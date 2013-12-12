VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "OtherAP_BillEvent"
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
    Dim dctInsuProduct As KFO.Dictionary
    
   If lSelBillType = 200000046 Then '上牌登记
        m_BillInterface.SetFieldValue "FItemClassID", 8 '核算类别=供应商
        m_BillInterface.LockCell dctInsuProduct, -1, True
        isBotp = True
   End If
   
   If lSelBillType = 200000047 Then '保险登记单
        m_BillInterface.SetFieldValue "FItemClassID", 8 '核算类别=供应商
        isBotp = True
   End If
    
   If lSelBillType = 200000048 Then '按揭登记单
        m_BillInterface.SetFieldValue "FItemClassID", 8 '核算类别=供应商
        Set dctInsuProduct = m_BillInterface.GetFieldInfoByKey("FBase", "", -1)
        m_BillInterface.LockCell dctInsuProduct, -1, True
        isBotp = True
   End If

End Sub


Private Sub m_BillInterface_CompleteQueryData(ByVal lPage As Long, ByVal lEntrySize As Long, ByVal lRowStart As Long, ByVal lRowsRequest As Long, ByVal lRowsResponse As Long)
    Dim i As Integer
    Dim amountFor As Double
    If lPage = 3 And isBotp = True Then
        For i = 1 To m_BillInterface.BillEntrys(2).GridMaxDataRowNum
            amountFor = amountFor + Val(m_BillInterface.GetFieldValue("famountFor_3", i))
        Next i
        m_BillInterface.SetFieldValue "famountFor_2", amountFor, 1
        m_BillInterface.SetFieldValue "famount_2", amountFor, 1
        isBotp = False
    End If
    
    
End Sub

