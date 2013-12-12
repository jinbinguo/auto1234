VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "SaleIssue_Industry"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Attribute VB_Description = "This is Industry Bill Interface Class, made by K3BOSPLUGINSWIZAED"
 
'定义插件对象接口. 必须具有的声明, 以此来获得事件
Private WithEvents m_BillTransfer   As K3BillTransfer.Bill
Attribute m_BillTransfer.VB_VarHelpID = -1
 
Private vehicleIndex As Long
Private modelNameIndex As Long
Private vinIndex As Long
Private plateNumIndex As Long


Public Sub Show(ByVal oBillTransfer As Object)
 
    '接口实现
    '注意: 此方法必须存在, 请勿修改
    Set m_BillTransfer = oBillTransfer
    
    
 
End Sub

Private Sub Class_Terminate()
 
    '释放接口对象
    '注意: 此方法必须存在, 请勿修改
    Set m_BillTransfer = Nothing

End Sub

Private Sub m_BillTransfer_BillInitialize()
    vehicleIndex = GetCtlIndexByFld("FVehicleID")
    plateNumIndex = GetCtlIndexByFld("FPlateNum")
    vinIndex = GetCtlIndexByFld("FVin")
    modelNameIndex = GetCtlIndexByFld("FModelName")
    conn = m_BillTransfer.Cnnstring
    
End Sub


Private Sub resetVehicleInfo(ByVal rs As ADODB.Recordset)
    If rs Is Nothing Then
        m_BillTransfer.SetHead plateNumIndex, ""
        m_BillTransfer.SetHead vinIndex, ""
        m_BillTransfer.SetHead modelNameIndex, ""
    Else
        m_BillTransfer.SetHead plateNumIndex, rs!FPlateNum
        m_BillTransfer.SetHead vinIndex, rs!FVin
        m_BillTransfer.SetHead modelNameIndex, rs!FModelName
    
    End If

End Sub

Private Sub m_BillTransfer_HeadChange(ByVal CtlIndex As Long, ByVal Value As Variant, ByVal bNewBill As Boolean, Cancel As Boolean)
    Dim sql As String
    Dim rs As ADODB.Recordset
    If (CtlIndex = vehicleIndex) Then
        If (Value = "") Then
            resetVehicleInfo rs
        Else
            sql = "select FSeriesName,FModelName,FVin,FBrandName,FDriverFormName,FPowerFormName,FInteriorName,FColorName," & _
                 "FOptional,FDisplacementName,FStereotypeName,FCfgDesc,FEngineNum,FGearboxName,FPlateNum from V_ATS_Vehicle where FNumber='" & Value & "'"
            Set rs = queryExt(sql)
            resetVehicleInfo rs
        End If
    End If

End Sub

Private Sub m_BillTransfer_LoadBillEnd(ByVal ShowType As Long)
    Dim vehicleNum As String
    If (ShowType = 0) Then
        vehicleNum = m_BillTransfer.HeadCtl(vehicleIndex).Number
        m_BillTransfer_HeadChange vehicleIndex, vehicleNum, True, False
    End If
End Sub



Public Function GetCtlIndexByFld(ByVal fldName As String, Optional ByVal IsEntry As Boolean = False) As Long
    Dim LctlIdx As Long
    Dim i As Integer
    Dim bIsFind As Boolean
    Dim vValue As Variant
    fldName = UCase(fldName)
    bIsFind = False
    With m_BillTransfer
        If IsEntry Then
            For i = LBound(.EntryCtl) To UBound(.EntryCtl)
                If UCase(.EntryCtl(i).FieldName) = fldName Then
                    LctlIdx = .EntryCtl(i).FCtlOrder
                    bIsFind = True
                    Exit For
                End If
            Next i
        Else
            For i = LBound(.HeadCtl) To UBound(.HeadCtl)
                If UCase(.HeadCtl(i).FieldName) = fldName Then
                    LctlIdx = .HeadCtl(i).FCtlIndex
                    bIsFind = True
                    Exit For
                End If
            Next i
        End If
    End With
    If bIsFind = True Then
      GetCtlIndexByFld = LctlIdx
    Else
      GetCtlIndexByFld = 0
    End If
    
End Function

