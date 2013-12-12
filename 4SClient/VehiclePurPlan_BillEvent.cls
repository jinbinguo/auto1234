VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "VehiclePurPlan_BillEvent"
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
    RegUtils.validateLicenseClient m_BillInterface
End Sub

Private Sub Class_Terminate()
 
    '�ͷŽӿڶ���
    'ע��: �˷����������, �����޸�
    Set m_BillInterface = Nothing

End Sub


Private Sub initData()
    Dim strYear As String
    Dim strMonth As String
    strYear = Format(Date, "yyyy")
    strMonth = Format(Date, "mm")
    m_BillInterface.SetFieldValue "FComboBox1", strYear
    m_BillInterface.SetFieldValue "FComboBox2", strMonth
    

End Sub


Private Sub m_BillInterface_AfterLoadBill()
    If m_BillInterface.BillStatus = Enu_BillStatusExt_View Then
        m_BillInterface.MenuBar.BOSTools("mnuCreatePurOrder").Enabled = False
        m_BillInterface.MenuBar.BOSTools("mnuGenPurOrder").Enabled = True
    End If


End Sub

Private Sub m_BillInterface_AfterNewBill()
    initData
End Sub

Private Sub showPurOrder()
    Dim oDataSrv As Object
    Dim oBill As Object
    Dim dctRow As KFO.Dictionary
    
    Dim i As Integer
    m_BillInterface.SetActiveCell "FBase2", -1
    
    Dim totalCurrentPurQty As Double '���βɹ������ۼ�
    Dim purQty As Double '�мƻ��ɹ���
    Dim totalPurQty As Double '���ۼ����¶�����
    Dim currentPurQty As Double '�б��βɹ�����
    Dim isOver As Boolean
    isOver = False
    For i = 1 To m_BillInterface.BillEntrys(1).GridMaxDataRowNum
        purQty = Val(m_BillInterface.GetFieldValue("FQty", i)) '�мƻ��ɹ���
        totalPurQty = Val(m_BillInterface.GetFieldValue("FQty4", i)) '���ۼ����¶�����
        currentPurQty = Val(m_BillInterface.GetFieldValue("FQty1", i)) '�б��βɹ�����
        If purQty < totalPurQty + currentPurQty Then '���βɹ�����+���¶�����>�ƻ��ɹ���
            isOver = True
        End If
        totalCurrentPurQty = totalCurrentPurQty + currentPurQty
    Next i
    If totalCurrentPurQty <= 0 Then
        MsgBox "���βɹ����������0", vbInformation, "�����ʾ"
        Exit Sub
    End If
    If isOver = True Then
        If MsgBox("�ۼƲɹ��µ��������ƻ��ɹ������Ƿ����", vbExclamation + vbYesNo, "�����ʾ") = vbNo Then
            Exit Sub
        End If
    End If
    
     
    On Error GoTo err_ctr
    Set oDataSrv = m_BillInterface.K3Lib.CreateK3Object("K3ClassTpl.DataSrv")
     
    oDataSrv.ClassTypeID = 200000023 '�ɹ�����
    Dim oTableInfo As Object
    Set oTableInfo = oDataSrv.TableInfo
    Dim oData As Object
    Set oData = oDataSrv.GetEmptyBill
   
    
    oData("Page1")(oTableInfo("map")("FBase"))("FFND") = m_BillInterface.BillHeads(1).BOSFields("FBase1").Number  '�ɹ���ʽ����
    oData("Page1")(oTableInfo("map")("FBase"))("FFLD") = m_BillInterface.BillHeads(1).BOSFields("FBase1").Value  '�ɹ���ʽ����
    oData("Page1")(oTableInfo("map")("FBase"))("FDSP") = m_BillInterface.BillHeads(1).BOSFields("FBase1").Text  '�ɹ���ʽ����
    
    oData("Page1")(oTableInfo("map")("FBase1"))("FFND") = m_BillInterface.BillHeads(1).BOSFields("FBase2").Number  '�ɹ�Ա����
    oData("Page1")(oTableInfo("map")("FBase1"))("FFLD") = m_BillInterface.BillHeads(1).BOSFields("FBase2").Value  '�ɹ�Ա����
    oData("Page1")(oTableInfo("map")("FBase1"))("FDSP") = m_BillInterface.BillHeads(1).BOSFields("FBase2").Text  '�ɹ�Ա����
    
    oData("Page1")(oTableInfo("map")("FBase2"))("FFND") = m_BillInterface.BillHeads(1).BOSFields("FBase").Number  '��Ӧ�̱���
    oData("Page1")(oTableInfo("map")("FBase2"))("FFLD") = m_BillInterface.BillHeads(1).BOSFields("FBase").Value  '��Ӧ������
    oData("Page1")(oTableInfo("map")("FBase2"))("FDSP") = m_BillInterface.BillHeads(1).BOSFields("FBase").Text  '��Ӧ������
    
    oData("Page1")(oTableInfo("map")("FNote"))("FFLD") = m_BillInterface.GetFieldValue("FNote") '��ע
    Set dctRow = oData("Page2")(1).CloneAll()
    Dim rowPurOrder As Integer
    Dim rowPurPlan As Integer
    Dim Row As Integer
    For rowPurPlan = 1 To m_BillInterface.BillEntrys(1).GridMaxDataRowNum
        For rowPurOrder = 1 To Val(m_BillInterface.GetFieldValue("FQty1", rowPurPlan)) '���βɹ�����
            Row = Row + 1
            If Row > 1 Then
                oData("Page2").Add dctRow.CloneAll()
            End If
            oData("Page2")(Row)(oTableInfo("map")("FBase8"))("FFND") = m_BillInterface.GetFieldValue("FBase3", rowPurPlan, Enu_ValueType_FFND) '��ϵ����
            oData("Page2")(Row)(oTableInfo("map")("FBase8"))("FFLD") = m_BillInterface.GetFieldValue("FBase3", rowPurPlan, Enu_ValueType_FFLD) '��ϵ����
            oData("Page2")(Row)(oTableInfo("map")("FBase8"))("FDSP") = m_BillInterface.GetFieldValue("FBase3", rowPurPlan, Enu_ValueType_FDSP) '��ϵ����
            
            oData("Page2")(Row)(oTableInfo("map")("FBase9"))("FFND") = m_BillInterface.GetFieldValue("FBase4", rowPurPlan, Enu_ValueType_FFND) '���ͱ���
            oData("Page2")(Row)(oTableInfo("map")("FBase9"))("FFLD") = m_BillInterface.GetFieldValue("FBase4", rowPurPlan, Enu_ValueType_FFLD) '��������
            oData("Page2")(Row)(oTableInfo("map")("FBase9"))("FDSP") = m_BillInterface.GetFieldValue("FBase4", rowPurPlan, Enu_ValueType_FDSP) '��������
            
            oData("Page2")(Row)(oTableInfo("map")("FBaseProperty6"))("FDSP") = m_BillInterface.GetFieldValue("FBaseProperty", rowPurPlan) '����˵��
            
            oData("Page2")(Row)(oTableInfo("map")("FBase5"))("FFND") = m_BillInterface.GetFieldValue("FBase5", rowPurPlan, Enu_ValueType_FFND) '���α���
            oData("Page2")(Row)(oTableInfo("map")("FBase5"))("FFLD") = m_BillInterface.GetFieldValue("FBase5", rowPurPlan, Enu_ValueType_FFLD) '��������
            oData("Page2")(Row)(oTableInfo("map")("FBase5"))("FDSP") = m_BillInterface.GetFieldValue("FBase5", rowPurPlan, Enu_ValueType_FDSP) '��������
            
            oData("Page2")(Row)(oTableInfo("map")("FBase6"))("FFND") = m_BillInterface.GetFieldValue("FBase6", rowPurPlan, Enu_ValueType_FFND) '��ɫ����
            oData("Page2")(Row)(oTableInfo("map")("FBase6"))("FFLD") = m_BillInterface.GetFieldValue("FBase6", rowPurPlan, Enu_ValueType_FFLD) '��ɫ����
            oData("Page2")(Row)(oTableInfo("map")("FBase6"))("FDSP") = m_BillInterface.GetFieldValue("FBase6", rowPurPlan, Enu_ValueType_FDSP) '��ɫ����
            
            oData("Page2")(Row)(oTableInfo("map")("FText5"))("FFLD") = m_BillInterface.GetFieldValue("FText", rowPurPlan)   'ѡװ
            oData("Page2")(Row)(oTableInfo("map")("FNOTE1"))("FFLD") = m_BillInterface.GetFieldValue("FNOTE", rowPurPlan)   '�б�ע
            
            oData("Page2")(Row)(oTableInfo("map")("FBase4"))("FFND") = m_BillInterface.GetFieldValue("FBase8", rowPurPlan, Enu_ValueType_FFND) '������λ����
            oData("Page2")(Row)(oTableInfo("map")("FBase4"))("FFLD") = m_BillInterface.GetFieldValue("FBase8", rowPurPlan, Enu_ValueType_FFLD) '������λ����
            oData("Page2")(Row)(oTableInfo("map")("FBase4"))("FDSP") = m_BillInterface.GetFieldValue("FBase8", rowPurPlan, Enu_ValueType_FDSP) '������λ����
            
            oData("Page2")(Row)(oTableInfo("map")("FQty"))("FFLD") = 1 '����
            
            '--�۸��� ��������ۣ���������ֶ��Զ����㣬���ú�˰����ȴ������
            oData("Page2")(Row)(oTableInfo("map")("FPrice"))("FFLD") = m_BillInterface.GetFieldValue("FPrice", rowPurPlan) / (1 + 17 / 100#) '����
            
            oData("Page2")(Row)(oTableInfo("map")("FBase3"))("FFND") = m_BillInterface.GetFieldValue("FBase7", rowPurPlan, Enu_ValueType_FFND) '���ϱ���
            oData("Page2")(Row)(oTableInfo("map")("FBase3"))("FFLD") = m_BillInterface.GetFieldValue("FBase7", rowPurPlan, Enu_ValueType_FFLD) '��������
            oData("Page2")(Row)(oTableInfo("map")("FBase3"))("FDSP") = m_BillInterface.GetFieldValue("FBase7", rowPurPlan, Enu_ValueType_FDSP) '��������
            
            oData("Page2")(Row)(oTableInfo("map")("FBillNo_SRC"))("FFLD") = m_BillInterface.GetFieldValue("FBillNo") 'Դ���ݱ��
            oData("Page2")(Row)(oTableInfo("map")("FID_SRC"))("FFLD") = m_BillInterface.GetFieldValue("FID2", rowPurPlan) 'Դ����ID
            oData("Page2")(Row)(oTableInfo("map")("FEntryID_SRC"))("FFLD") = m_BillInterface.GetFieldValue("FEntryID2", rowPurPlan) 'Դ���ݷ�¼ID
            oData("Page2")(Row)(oTableInfo("map")("FClassID_SRC"))("FFLD") = 200000066 'Դ��������
            
        Next rowPurOrder
        
    Next rowPurPlan
    
     Set oBill = m_BillInterface.K3Lib.CreateK3Object("K3SingleClassBill.ClassInfoManager")
     With oBill
       .DataSrv = oDataSrv
       .ISNetControl = True
       .ISCheckRight = True
       .Show 0, False, 1, oData
    
       '**********************
       'Show ��������
       '��һ������ Optional ByVal lID As Long = 0 �������޸Ļ�鿴�ĵ���ID
       '�ڶ������� Optional ByVal bShowGroup As Boolean = False �����ǻ�������ʱ���Ƿ���ʾ����
       '���������� Optional ByVal BillStatus As Long = Enu_BillStatus_New ����ʾ��ʽ 0���鿴��1��������2���޸�
       '���ĸ����� Optional ByVal dctData As KFO.Dictionary '���ݳ�ʼֵ
       '**********************
     End With
    
     Set oDataSrv = Nothing
     Set oBill = Nothing
     m_BillInterface.BillCtl.BillStatus = Enu_BillStatusExt_View
     m_BillInterface.RefreshBill
     m_BillInterface.MenuBar.BOSTools("mnuGenPurOrder").Enabled = True
     m_BillInterface.LockBillEntry 2
    Exit Sub
err_ctr:
    Set oDataSrv = Nothing
    Set oBill = Nothing


End Sub

Private Sub m_BillInterface_MenuBarClick(ByVal BOSTool As K3ClassEvents.BOSTool, Cancel As Boolean)
    Dim dctCurrentPurQty As KFO.Dictionary
    Set dctCurrentPurQty = m_BillInterface.GetFieldInfoByKey("FQty1", "", -1)
    If BOSTool.ToolName = "mnuGenPurOrder" Then 'ִ�вɹ��µ�
        If Not m_BillInterface.GetFieldValue("FMultiCheckStatus") = "16" Then
            MsgBox "�����״̬������ִ�вɹ��µ�", vbInformation, "�����ʾ"
            Cancle = True
            Exit Sub
        End If
     
        m_BillInterface.MenuBar.BOSTools("mnuCreatePurOrder").Enabled = True
        'm_BillInterface.MenuBar.BOSBands("BandToolBar").BOSTools.Item("mnuCreatePurOrder").Enabled = True
        dctCurrentPurQty("FLock") = 0
        m_BillInterface.LockCell dctCurrentPurQty, -1, False
    End If
    
    If BOSTool.ToolName = "mnuCreatePurOrder" Then '���ɲɹ�����
        showPurOrder
    End If
End Sub

Private Sub m_BillInterface_Change(ByVal dct As KFO.IDictionary, ByVal dctFld As KFO.IDictionary, ByVal Col As Long, ByVal Row As Long, Cancel As Boolean)
    
    If (dct("FKey") = "FBase3") Then '��ϵ
        Dim seriesId As Integer
        seriesId = Val(dctFld("FFLD"))
        '���͹���
        If seriesId > 0 Then
            m_BillInterface.DataSrv.TableInfo(m_BillInterface.TableInfo("Map")("FBase4"))("FFilter") = "v_ats_model.FSeriesID=" & seriesId
        Else
            m_BillInterface.DataSrv.TableInfo(m_BillInterface.TableInfo("Map")("FBase4"))("FFilter") = ""
        End If
    
    ElseIf (dct("FKey") = "FBase4") Then '����
        Dim modelId As Integer
        modelId = Val(dctFld("FFLD"))
        loadModelInfo modelId, Row
    End If
    
    
End Sub

Private Sub setModelInfo(rs As ADODB.Recordset, lRow As Long)
    Dim isLock As Boolean
    If rs Is Nothing Then
        m_BillInterface.SetFieldValue "FBaseProperty", "", lRow
        m_BillInterface.SetFieldValue "FBase3", "", lRow
        m_BillInterface.SetFieldValue "FBase4", "", lRow

        isLock = False
    Else
        m_BillInterface.SetFieldValue "FBase3", rs!FSeriesNum, lRow
        m_BillInterface.SetFieldValue "FBaseProperty", rs!FCfgDesc, lRow
        m_BillInterface.SetFieldValue "FBase7", rs!FICItemNum, lRow
        m_BillInterface.SetFieldValue "FBase8", rs!FUnitNum, lRow
        m_BillInterface.SetFieldValue "FPrice", rs!FPurTaxPrice, lRow
        
        isLock = True
    End If
    m_BillInterface.LockCell m_BillInterface.GetFieldInfoByKey("FBase3", "", -1), lRow, isLock



End Sub

Private Sub loadModelInfo(modelId As Integer, lRow As Long)
    
    Dim rs As ADODB.Recordset
    Dim sql As String
    If (modelId > 0) Then
        sql = "select b.FNumber FSeriesNum,a.FCfgDesc,c.FNumber FICItemNum," & _
             "d.FNumber FUnitNum,a.FMakerModelNum,a.FBrandName,a.FGearboxName,a.FPowerFormName," & _
             "a.FStereotypeName , a.FDriverFormName, a.FCarSourceName, a.FDisplacementName,a.FPurTaxPrice " & _
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

    seriesId = Val(m_BillInterface.GetFieldValue("FBase3", lRow))
    modelId = Val(m_BillInterface.GetFieldValue("FBase4", lRow))
    
    If (dct("FKey") = "FBase4") Then  '����
        If seriesId > 0 Then
         strFilter = "v_ats_model.FSeriesID=" & seriesId
        End If
    ElseIf (dct("FKey") = "FBase3") Then '��ϵ
        
    End If
End Sub
