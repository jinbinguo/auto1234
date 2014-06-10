VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "DecorationOrder_BillEvent"
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



Private Sub m_BillInterface_AfterLoadBill()
    setDisByVehicleUI
End Sub

Private Sub m_BillInterface_AfterSelBill(ByVal lSelBillType As Long)
    Dim vehicleId As Integer
    vehicleId = Val(m_BillInterface.GetFieldValue("FBase2")) '车辆
    loadVehicleInfo vehicleId, -1
    setDisByVehicleUI
    If (lSelBillType = 200000028) Then '来源单为整车销售订单
        Dim entryId_src As Integer
        Dim id_src As Integer
        Dim rs As ADODB.Recordset
        entryId_src = Val(m_BillInterface.GetFieldValue("FEntryID_SRC"))
        id_src = Val(m_BillInterface.GetFieldValue("FID_SRC"))
        Set rs = m_BillInterface.K3Lib.GetData("select FIndex from T_ATS_VehicleSaleOrderEntry where fid=" & id_src & " and FEntryId=" & entryId_src)
        If Not rs.EOF Then
            m_BillInterface.SetFieldValue "FInteger", rs!FIndex
        End If
    End If
    
End Sub


Private Sub setDisByVehicleUI()
    Dim rs As ADODB.Recordset
    Dim sql As String
    Dim dctDisByVehicle As KFO.Dictionary
    Set dctDisByVehicle = m_BillInterface.GetFieldInfoByKey("FAmount10", "", -1)
    Dim sourceId As Long
    sourceId = Val(m_BillInterface.GetFieldValue("FID_Src"))
    If sourceId > 0 Then
        dctDisByVehicle("FLock") = 24
        m_BillInterface.LockCell dctDisByVehicle, -1, False
    Else
        m_BillInterface.LockCell dctDisByVehicle, -1, True
    End If
    
    '是否转单过来，若转单过来，但未配车，先将销售订单的车辆配置信息带回精品销售订单
    Dim sourceTypeId As Long
    sourceTypeId = Val(m_BillInterface.GetFieldValue("FClassID_SRC"))
    Dim sourceEntryId As Long
    sourceEntryId = Val(m_BillInterface.GetFieldValue("FEntryID_SRC"))
    Dim vehicleId As Integer
    vehicleId = Val(m_BillInterface.GetFieldValue("FBase2")) '车辆
    
    If vehicleId = 0 And sourceTypeId = 200000028 And sourceEntryId > 0 Then '来源为整车销售订单
        sql = "select c.FName FSeriesName,b.FName FModelName,b.FCfgDesc from T_ATS_VehicleSaleOrderEntry a" & _
              " left join T_ATS_Model b on b.FID=a.FModelId and b.FID<>0 " & _
              " left join T_ATS_Series c on c.FID=b.FSeriesID and c.FID<>0 " & _
              " where a.FID=" & sourceId & " and a.FEntryID=" & sourceEntryId
        Set rs = m_BillInterface.K3Lib.GetData(sql)
        If Not rs.EOF Then
            m_BillInterface.SetFieldValue "FBaseProperty1", rs!FSeriesName
            m_BillInterface.SetFieldValue "FBaseProperty2", rs!FModelName
            m_BillInterface.SetFieldValue "FBaseProperty4", rs!FCfgDesc
        End If

    
    End If
    
End Sub

Private Sub loadVehicleInfo(vehicleId As Integer, lRow As Long)
    Dim rs As ADODB.Recordset
    Dim sql As String
    If (vehicleId > 0) Then
        sql = "select FSeriesName,FModelName,FPlateNum,FCfgDesc from V_ATS_Vehicle " & _
            "where FID=" & CStr(vehicleId)
        Set rs = m_BillInterface.K3Lib.GetData(sql)
        setVehicleInfo rs, lRow
    End If
    
End Sub

Private Sub setVehicleInfo(rs As ADODB.Recordset, lRow As Long)
    If rs Is Nothing Then
        Exit Sub
    End If
    If (Not rs.EOF) Then
        m_BillInterface.SetFieldValue "FBaseProperty1", rs!FSeriesName, lRow
        m_BillInterface.SetFieldValue "FBaseProperty2", rs!FModelName, lRow
        m_BillInterface.SetFieldValue "FBaseProperty3", rs!FPlateNum, lRow
        m_BillInterface.SetFieldValue "FBaseProperty4", rs!FCfgDesc, lRow
    End If
End Sub

Private Sub m_BillInterface_BeforeSave(bCancel As Boolean)
    Dim rowIndex As Long
    Dim isInstall As Boolean
    Dim vehicleId As Long
    Dim dctSaleType As KFO.Dictionary
    isInstall = False
    vehicleId = Val(m_BillInterface.GetFieldValue("FBase2"))
    Set dctSaleType = m_BillInterface.GetDataFldbyKey("FBase3")
    
    
    If vehicleId = 0 And dctSaleType("FDSP") = "外销" Then
        For rowIndex = 1 To m_BillInterface.BillEntrys(1).GridMaxDataRowNum
            isInstall = m_BillInterface.GetFieldValue("FCheckBox1", rowIndex)
            If isInstall Then
                Exit For
            End If
        Next rowIndex
        If isInstall Then
            MsgBoxEx.showInfo "需安装精品配件的外销订单，车辆不能为空！"
            bCancel = True
        End If
    End If
    
    
    
End Sub
