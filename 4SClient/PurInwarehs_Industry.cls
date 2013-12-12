VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "PurInwarehs_Industry"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Attribute VB_Description = "This is Industry Bill Interface Class, made by K3BOSPLUGINSWIZAED"
 
'定义插件对象接口. 必须具有的声明, 以此来获得事件
Private WithEvents m_BillTransfer   As K3BillTransfer.Bill
Attribute m_BillTransfer.VB_VarHelpID = -1
 
 
Private vehicleIndex As Long
Private seriesNameIndex As Long
Private modelNameIndex As Long
Private vinIndex As Long
Private brandIndex As Long
Private driverFormIndex As Long
Private powerFormIndex As Long
Private interiorIndex As Long
Private colorIndex As Long
Private optionalIndex As Long
Private displacementIndex As Long
Private stereotypeIndex As Long
Private cfgDescIndex As Long
Private engineNumIndex As Long
Private gearboxIndex As Long


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


Private Sub m_BillTransfer_GridChange(ByVal Col As Long, ByVal row As Long, ByVal Value As Variant, ByVal bNewBill As Boolean, Cancel As Boolean)
    Dim sql As String
    Dim rs As ADODB.Recordset
    If (Col = vehicleIndex) Then '车辆
       If (Value = "") Then
         resetVehicleInfo rs, row
         Exit Sub
      End If
       sql = "select FSeriesName,FModelName,FVin,FBrandName,FDriverFormName,FPowerFormName,FInteriorName,FColorName," & _
                 "FOptional,FDisplacementName,FStereotypeName,FCfgDesc,FEngineNum,FGearboxName from V_ATS_Vehicle where FNumber='" & Value & "'"
       Set rs = queryExt(sql)
       resetVehicleInfo rs, row
    End If

End Sub

Private Sub resetVehicleInfo(ByVal rs As ADODB.Recordset, ByVal row As Long)
    If (rs Is Nothing) Then
       m_BillTransfer.SetGridText row, seriesNameIndex, ""
       m_BillTransfer.SetGridText row, modelNameIndex, ""
       m_BillTransfer.SetGridText row, vinIndex, ""
       m_BillTransfer.SetGridText row, brandIndex, ""
       m_BillTransfer.SetGridText row, driverFormIndex, ""
       m_BillTransfer.SetGridText row, powerFormIndex, ""
       m_BillTransfer.SetGridText row, interiorIndex, ""
       m_BillTransfer.SetGridText row, colorIndex, ""
       m_BillTransfer.SetGridText row, optionalIndex, ""
       m_BillTransfer.SetGridText row, displacementIndex, ""
       m_BillTransfer.SetGridText row, stereotypeIndex, ""
       m_BillTransfer.SetGridText row, cfgDescIndex, ""
       m_BillTransfer.SetGridText row, engineNumIndex, ""
       m_BillTransfer.SetGridText row, gearboxIndex, ""
    Else
        
        m_BillTransfer.SetGridText row, seriesNameIndex, rs!FSeriesName
        m_BillTransfer.SetGridText row, modelNameIndex, rs!FModelName
        m_BillTransfer.SetGridText row, vinIndex, rs!FVin
        m_BillTransfer.SetGridText row, brandIndex, rs!FBrandName
        m_BillTransfer.SetGridText row, driverFormIndex, rs!FDriverFormName
        m_BillTransfer.SetGridText row, powerFormIndex, rs!FPowerFormName
        m_BillTransfer.SetGridText row, interiorIndex, rs!FInteriorName
        m_BillTransfer.SetGridText row, colorIndex, rs!FColorName
        m_BillTransfer.SetGridText row, optionalIndex, rs!FOptional
        m_BillTransfer.SetGridText row, displacementIndex, rs!FDisplacementName
        m_BillTransfer.SetGridText row, stereotypeIndex, rs!FStereotypeName
        m_BillTransfer.SetGridText row, cfgDescIndex, rs!FCfgDesc
        m_BillTransfer.SetGridText row, engineNumIndex, rs!FEngineNum
        m_BillTransfer.SetGridText row, gearboxIndex, rs!FGearboxName
    End If
    

End Sub

Private Sub m_BillTransfer_LoadBillEnd(ByVal ShowType As Long)
    Conn = m_BillTransfer.Cnnstring
 
    vehicleIndex = GetCtlIndexByFld("FVehicleID", True) '车辆序号
    seriesNameIndex = GetCtlIndexByFld("FSeriesName", True) '车系序号
    modelNameIndex = GetCtlIndexByFld("FModelName", True) '车型序号
    vinIndex = GetCtlIndexByFld("FVin", True) '底盘号
    brandIndex = GetCtlIndexByFld("FBrandName", True) '品牌名称序号
    driverFormIndex = GetCtlIndexByFld("FDriverFormName", True) '驱动形式名称序号
    powerFormIndex = GetCtlIndexByFld("FPowerFormName", True) '动力形式名称序号
    interiorIndex = GetCtlIndexByFld("FInteriorName", True) '内饰名称序号
    colorIndex = GetCtlIndexByFld("FColorName", True) '颜色名称序号
    optionalIndex = GetCtlIndexByFld("FOptional", True) '选装序号
    displacementIndex = GetCtlIndexByFld("FDisplacementName", True) '排量名称序号
    stereotypeIndex = GetCtlIndexByFld("FStereotypeName", True) '型/版名称序号
    cfgDescIndex = GetCtlIndexByFld("FCfgDesc", True) '配置说明序号
    engineNumIndex = GetCtlIndexByFld("FEngineNum", True) '发动机号名称序号
    gearboxIndex = GetCtlIndexByFld("FGearboxName", True) '变速箱名称序号
   
    If (ShowType = 0) Then
        For i = LBound(m_BillTransfer.EntryCtl(vehicleIndex).DNumber) To UBound(m_BillTransfer.EntryCtl(vehicleIndex).DNumber)
            If (m_BillTransfer.EntryCtl(vehicleIndex).DNumber(i) = "") Then
                   GoTo Continue
            End If
            vehicleNum = m_BillTransfer.EntryCtl(vehicleIndex).DNumber(i)
            m_BillTransfer_GridChange vehicleIndex, i, vehicleNum, True, False
            GoTo Continue
Continue:
            Next i
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

