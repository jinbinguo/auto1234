VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "VehiclePurForecast_BillEvent"
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

Public Sub Change(ByVal dct As KFO.IDictionary, ByVal dctFld As KFO.IDictionary, ByVal Col As Long, ByVal row As Long)
    m_BillInterface_Change dct, dctFld, Col, row, False
End Sub

Private Sub m_BillInterface_Change(ByVal dct As KFO.IDictionary, ByVal dctFld As KFO.IDictionary, ByVal Col As Long, ByVal row As Long, Cancel As Boolean)
    
    If (dct("FKey") = "FBase1") Then '车系
        Dim seriesId As Integer
        seriesId = Val(dctFld("FFLD"))
        '车型过滤
        If seriesId > 0 Then
            m_BillInterface.DataSrv.TableInfo(m_BillInterface.TableInfo("Map")("FBase2"))("FFilter") = "v_ats_model.FSeriesID=" & seriesId
        Else
            m_BillInterface.DataSrv.TableInfo(m_BillInterface.TableInfo("Map")("FBase2"))("FFilter") = ""
        End If
    
    ElseIf (dct("FKey") = "FBase2") Then '车型
        Dim modelId As Integer
        modelId = Val(dctFld("FFLD"))
        loadModelInfo modelId, row
    ElseIf (dct("FKey") = "FDate" Or dct("FKey") = "FDate1") Then  '填报月份 '提车月份
        Dim d As Date
        d = Format(dctFld("FFLD"), "yyyy-mm-dd")
        Dim dday As Integer
        dday = Day(d)
        m_BillInterface.SetFieldValue dct("FKey"), DateAdd("d", 1 - dday, d), row
    ElseIf (dct("FKey") = "") Then '启动多级审核
    
    
    End If
    
    
End Sub

Private Sub setModelInfo(rs As ADODB.Recordset, lRow As Long)
    Dim isLock As Boolean
    If rs Is Nothing Then
        m_BillInterface.SetFieldValue "FBaseProperty", "", lRow
        m_BillInterface.SetFieldValue "FBase1", "", lRow
        m_BillInterface.SetFieldValue "FBase2", "", lRow

        isLock = False
    Else
        m_BillInterface.SetFieldValue "FBase1", rs!FSeriesNum, lRow
        m_BillInterface.SetFieldValue "FBaseProperty", rs!FMakerModel, lRow
        m_BillInterface.SetFieldValue "FBaseProperty1", rs!FMakerModelNum, lRow
        m_BillInterface.SetFieldValue "FBaseProperty2", rs!FCfgDesc, lRow
        m_BillInterface.SetFieldValue "FBase5", rs!FICItemNum, lRow
        m_BillInterface.SetFieldValue "FBase6", rs!FUnitNum, lRow
        
        isLock = True
    End If
    m_BillInterface.LockCell m_BillInterface.GetFieldInfoByKey("FBase1", "", -1), lRow, isLock



End Sub

Private Sub loadModelInfo(modelId As Integer, lRow As Long)
    
    Dim rs As ADODB.Recordset
    Dim sql As String
    If (modelId > 0) Then
        sql = "select b.FNumber FSeriesNum,a.FCfgDesc,c.FNumber FICItemNum," & _
             "d.FNumber FUnitNum,a.FMakerModelNum,a.FBrandName,a.FGearboxName,a.FPowerFormName," & _
             "a.FStereotypeName , a.FDriverFormName, a.FCarSourceName, a.FDisplacementName,a.FMakerModel,a.FMakerModelNum " & _
             "from v_ats_model a " & _
             "left join T_ATS_Series b on b.FID<>0 and b.FID=a.FSeriesID " & _
             "left join t_ICItem c on c.FItemID<>0 and c.FItemID=a.FICItemID " & _
             "left join t_MeasureUnit d on d.FItemID<> 0 and d.FItemID=a.FUnitID" & _
             " where a.FID=" & CStr(modelId)
        Set rs = m_BillInterface.K3Lib.GetData(sql)
     End If
     setModelInfo rs, lRow
End Sub


Private Sub m_BillInterface_F7LookUp(ByVal dct As KFO.IDictionary, ByVal vCurValue As Variant, ByVal lRow As Long, strFilter As String, sRetMsg As String, bCancel As Boolean)
    Dim seriesId As Integer
    Dim modelId As Integer

    seriesId = Val(m_BillInterface.GetFieldValue("FBase1", lRow))
    modelId = Val(m_BillInterface.GetFieldValue("FBase2", lRow))
    
    If (dct("FKey") = "FBase2") Then  '车型
        If seriesId > 0 Then
         strFilter = "v_ats_model.FSeriesID=" & seriesId
        End If
    ElseIf (dct("FKey") = "FBase1") Then '车系
        
    End If
End Sub



Private Sub m_BillInterface_MenuBarClick(ByVal BOSTool As K3ClassEvents.BOSTool, Cancel As Boolean)
    If BOSTool.ToolName = "mnuFileImportBill" Then
        Dim importCls As Object
        Set importCls = New VehiclePurForecastImport
        importCls.setBillInterface m_BillInterface, Me
        ExcelUtils.openFile importCls
    ElseIf BOSTool.ToolName = "mnuEditStartMultiCheck" Then '启用多级审核
'        Dim sql As String
'        Dim rs As ADODB.Recordset
'        Dim purDate As Date
'        Dim supplierId As Long
'        Dim strPurDate As String
'        purDate = m_BillInterface.GetFieldValue("FDate")
'        purDate = DateAdd("m", 1, purDate)
'        supplierId = m_BillInterface.GetFieldValue("FBase")
'        strPurDate = Format(purDate, "yyyy-mm")
'        sql = "select b.FDate,a.FPurMonth,sum(a.FQty) as FTotalQty from T_ATS_VehiclePurForecastEntry a" & _
'              " inner join T_ATS_VehiclePurForecast b on a.FID=b.FID" & _
'              " where b.fid<>" & CStr(m_BillInterface.CurBillID) & " and convert(varchar(7),a.FPurMonth,120)='" & strPurDate & "' and b.FSupplierID=" & CStr(supplierId) & _
'              " group by b.FDate,a.FPurMonth "
'
'        Set rs = m_BillInterface.K3Lib.GetData(sql)
'        If Not rs.EOF Then
'
'
'
'        End If
'         Cancel = True
        
    ElseIf BOSTool.ToolName = "mnuUpdatePuredQty" Then '更新已下单数量
        Dim sql As String
        Dim rs As ADODB.Recordset
        sql = "update a " & _
           " set FPuredQty = isnull((select sum(fqty) from T_ATS_VehiclePurOrderEntry aa" & _
           "                 inner join T_ATS_VehiclePurOrder bb on aa.FID=bb.FID" & _
           "                 where bb.FMultiCheckStatus='16' and aa.FSeriesID=a.FSeriesID and aa.FModelID=a.FModelID" & _
           "                 and aa.FColorID=a.FColorID and aa.FInteriorID=a.FInteriorID and aa.FOptional=a.FOptional" & _
           "                and convert(varchar(7),bb.FDate,120)=convert(varchar(7),a.FPurMonth ,120)" & _
           "                 and bb.FSupplierID=b.FSupplierID" & _
           "                 ),0)" & _
           " from T_ATS_VehiclePurForecastEntry a" & _
           " inner join T_ATS_VehiclePurForecast b on a.FID=b.FID" & _
           " where b.FMultiCheckStatus='16'"
        m_BillInterface.K3Lib.UpdateData sql
        m_BillInterface.RefreshBill
        MsgBoxEx.showInfo "更新完成"
    
    End If
    
    
    
End Sub


