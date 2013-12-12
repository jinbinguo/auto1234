VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "VehicleInsurance_BillEvent"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Attribute VB_Description = "This is BillEvent Interface Class, made by K3BOSPLUGINSWIZAED"
 
'���� BillEvent �ӿ�. ������е�����, �Դ�������¼�
Private WithEvents m_BillInterface  As BillEvent
Attribute m_BillInterface.VB_VarHelpID = -1
 
Dim optInusCheck As Boolean
Dim optInusSettle As Boolean
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


Private Sub m_BillInterface_AfterLoadBill()
    Dim isInsuranceSettle As Boolean
    Dim isInsuranceCheck As Boolean
    optInusCheck = False
    optInusSettle = False

    isInsuranceSettle = m_BillInterface.GetFieldValue("FCheckBox") '���չ�˾����
    isInsuranceCheck = m_BillInterface.GetFieldValue("FCheckBox1") '���չ�˾�˶�

    If m_BillInterface.GetFieldValue("FMultiCheckStatus") = "16" Then
        m_BillInterface.MenuBar.BOSTools.Item("mnuInsuranceCheck").Visible = True
        m_BillInterface.MenuBar.BOSTools.Item("mnuInsuranceSettle").Visible = True
        If isInsuranceCheck = True Then
            m_BillInterface.MenuBar.BOSTools.Item("mnuInsuranceCheck").Caption = "ȡ�����պ˶�"
            m_BillInterface.MenuBar.BOSTools.Item("mnuInsuranceCheck").Description = "ȡ�����պ˶�"
            m_BillInterface.MenuBar.BOSTools.Item("mnuInsuranceCheck").ToolTipText = "ȡ�����պ˶�"
        Else
            m_BillInterface.MenuBar.BOSTools.Item("mnuInsuranceCheck").Caption = "���պ˶�"
            m_BillInterface.MenuBar.BOSTools.Item("mnuInsuranceCheck").Description = "���պ˶�"
            m_BillInterface.MenuBar.BOSTools.Item("mnuInsuranceCheck").ToolTipText = "���պ˶�"
        End If

        If isInsuranceSettle = True Then
             m_BillInterface.MenuBar.BOSTools.Item("mnuInsuranceSettle").Caption = "ȡ�����ս���"
             m_BillInterface.MenuBar.BOSTools.Item("mnuInsuranceSettle").Description = "ȡ�����ս���"
             m_BillInterface.MenuBar.BOSTools.Item("mnuInsuranceSettle").ToolTipText = "ȡ�����ս���"

        Else
            m_BillInterface.MenuBar.BOSTools.Item("mnuInsuranceSettle").Caption = "���ս���"
            m_BillInterface.MenuBar.BOSTools.Item("mnuInsuranceSettle").Description = "���ս���"
            m_BillInterface.MenuBar.BOSTools.Item("mnuInsuranceSettle").ToolTipText = "���ս���"

        End If
    Else
        m_BillInterface.MenuBar.BOSTools.Item("mnuInsuranceCheck").Visible = False
        m_BillInterface.MenuBar.BOSTools.Item("mnuInsuranceSettle").Visible = False
        
    End If
End Sub

Private Sub m_BillInterface_BeforeSave(bCancel As Boolean)
    Dim classId_src As Long
    Dim billNo_src As String
    Dim vehicleId As Long
    Dim Row As Long
    Dim insuCompanyId As Long
    Dim insuType As String '��������
    Dim insuProductType As String '�������
    Dim vehVesTaxAmount As Double '����˰
    Dim forcedAmount As Double '��ǿ�ձ������
    Dim forcedSaleAmount As Double '��ǿ�����۽��

    Dim businessAmount As Double '��ҵ�ձ������
    Dim businessSaleAmount As Double '��ҵ�����۽��

    
    
    vehicleId = Val(m_BillInterface.GetFieldValue("FBase1")) '����
    insuType = m_BillInterface.GetFieldValue("FCombobox1") '�������� 1->����;2->�԰�
    If vehicleId = 0 Then
        MsgBox "��������Ϊ��", vbInformation, "�����ʾ"
        bCancel = True
        Exit Sub
    End If
    classId_src = Val(m_BillInterface.GetFieldValue("FClassID_SRC"))
    billNo_src = m_BillInterface.GetFieldValue("FBillNo_SRC")
    If classId_src = 0 Or billNo_src = "" Then
        MsgBox "���յǼǱ�������������", vbInformation, "�����ʾ"
        bCancel = True
        Exit Sub
    End If
    If insuType = "1" Then '����
        
        insuCompanyId = Val(m_BillInterface.GetFieldValue("FBase2")) '���չ�˾
        If insuCompanyId = 0 Then
            MsgBox "���չ�˾����Ϊ��", vbInformation, "�����ʾ"
        bCancel = True
        Exit Sub
        End If
    End If
    
    If optInusCheck = True Then
        If m_BillInterface.GetFieldValue("FDate4") = "" Then
            MsgBox "���չ�˾�˶����ڲ���Ϊ��", vbInformation, "�����ʾ"
            bCancel = True
            Exit Sub
        End If
        
        m_BillInterface.SetFieldValue "FCheckBox1", 1
        optInusCheck = False
    End If
    
    If optInusSettle = True Then
        If m_BillInterface.GetFieldValue("FDate3") = "" Then
            MsgBox "���չ�˾�������ڲ���Ϊ��", vbInformation, "�����ʾ"
            bCancel = True
            Exit Sub
        End If
        m_BillInterface.SetFieldValue "FCheckBox", 1
        optInusSettle = False
    End If
    
    
    For Row = 1 To m_BillInterface.BillEntrys(1).GridMaxDataRowNum
        insuProductType = m_BillInterface.GetFieldValue("FBaseProperty4", Row) '�������
        If insuProductType = "1" Then '1=��ǿ��
            forcedAmount = forcedAmount + m_BillInterface.GetFieldValue("FAmount7", Row) '����
            forcedSaleAmount = forcedSaleAmount + m_BillInterface.GetFieldValue("FAmount8", Row) '����
            
        ElseIf insuProductType = "2" Then '2=��ҵ��
            businessAmount = businessAmount + m_BillInterface.GetFieldValue("FAmount7", Row) '����
            businessSaleAmount = businessSaleAmount + m_BillInterface.GetFieldValue("FAmount8", Row) '����
        ElseIf insuProductType = "3" Then '3=����˰
            vehVesTaxAmount = vehVesTaxAmount + m_BillInterface.GetFieldValue("FAmount8", Row)
        End If
    
    Next Row
    
    m_BillInterface.SetFieldValue "FAmount", vehVesTaxAmount '����˰
    m_BillInterface.SetFieldValue "FAmount1", forcedAmount '��ǿ�ձ������
    m_BillInterface.SetFieldValue "FAmount2", forcedSaleAmount '��ǿ�����۽��
    m_BillInterface.SetFieldValue "FAmount3", businessAmount '��ҵ�ձ������
    m_BillInterface.SetFieldValue "FAmount4", businessSaleAmount '��ҵ�����۽��
    m_BillInterface.SetFieldValue "FAmount5", forcedSaleAmount + businessSaleAmount '�����ܶ�
    setReturnAmount

End Sub

Private Sub m_BillInterface_AfterSelBill(ByVal lSelBillType As Long)
    Dim vehicleId As Integer
    vehicleId = Val(m_BillInterface.GetFieldValue("FBase1")) '����
    loadVehicleInfo vehicleId, -1
    loadVehicleSEOrderInfo lSelBillType
    

End Sub




Private Sub loadVehicleSEOrderInfo(ByVal lSelBillType As Long)
    If lSelBillType <> 200000045 Then '�������
        Exit Sub
    End If
    
    Dim sql As String
    Dim rs As ADODB.Recordset
    Dim sourceId As Integer
    sourceId = m_BillInterface.GetFieldValue("FID_SRC") '��Դ��ID
    sql = "select FID_SRC,FBillNo_SRC,FEntryID_SRC,FIndex_SRC from T_ATS_AgentServiceSource where FClassID_SRC = 200000028 AND FID=" & sourceId
    Set rs = m_BillInterface.K3Lib.GetData(sql)
    If Not rs.EOF Then
        m_BillInterface.SetFieldValue "FID_SRC1", rs!FID_SRC '���۶�������
        m_BillInterface.SetFieldValue "FBillNo_Src1", rs!FBillNo_SRC '���۶������
        m_BillInterface.SetFieldValue "FEntryID_Src1", rs!FEntryID_SRC '���۶�����¼����
        m_BillInterface.SetFieldValue "FInteger", rs!FIndex_SRC '���۶�����¼��
      '  m_BillInterface.SetFieldValue "FClassID_Src1", 200000028 '���۶�������
        
    End If
    

End Sub



Private Sub loadVehicleInfo(vehicleId As Integer, lRow As Long)
    Dim rs As ADODB.Recordset
    Dim sql As String
    If (vehicleId > 0) Then
        sql = "select a.FBrandName,a.FModelName,a.FSeriesName,a.FCfgDesc,isnull(h.FNumber,'') FInsuCompanyNum  " & _
            "from V_ATS_Vehicle a " & _
            "left join t_Item h on h.FItemId=a.FInsuCompanyID and h.FItemClassID=1 and h.FItemId<>0 " & _
            "where a.FID=" & CStr(vehicleId)
        Set rs = m_BillInterface.K3Lib.GetData(sql)
        setVehicleInfo rs, lRow
    End If
    
End Sub

Private Sub setVehicleInfo(rs As ADODB.Recordset, lRow As Long)
    If rs Is Nothing Then
        Exit Sub
    End If
    If (Not rs.EOF) Then
        m_BillInterface.SetFieldValue "FBaseProperty", rs!FBrandName, lRow
        m_BillInterface.SetFieldValue "FBaseProperty1", rs!FSeriesName, lRow
        m_BillInterface.SetFieldValue "FBaseProperty2", rs!FModelName, lRow
        m_BillInterface.SetFieldValue "FBaseProperty3", rs!FCfgDesc, lRow
        m_BillInterface.SetFieldValue "FBase3", FInsuCompanyNum, lRow '��һ�걣�չ�˾
    End If
End Sub


Private Sub m_BillInterface_Change(ByVal dct As KFO.IDictionary, ByVal dctFld As KFO.IDictionary, ByVal Col As Long, ByVal Row As Long, Cancel As Boolean)
    If dct("FKey") = "FAmount1" Or dct("FKey") = "FAmount3" Or dct("FKey") = "FBase2" Or dct("FKey") = "FComboBox" Then '��ǿ�ձ������\��ҵ�ձ������\���չ�˾\��������
        setReturnAmount
    End If
    
End Sub

Private Sub setReturnAmount()
    Dim forcedAmount As Double
    Dim businessAmount As Double
    Dim insuCompanyId As Integer
    Dim sql As String
    Dim rs As ADODB.Recordset
    Dim insuType As String 'Ͷ������1->�ױ�; 2->�̱�
    
    forcedAmount = Val(m_BillInterface.GetFieldValue("FAmount2")) '��ǿ��
    businessAmount = Val(m_BillInterface.GetFieldValue("FAmount4")) '��ҵ��
    insuCompanyId = Val(m_BillInterface.GetFieldValue("FBase2")) '���չ�˾
    insuType = m_BillInterface.GetFieldValue("FCombobox") 'Ͷ������
    If insuCompanyId = 0 Then
        MsgBox "���չ�˾����Ϊ��", vbInformation, "�����ʾ"
        Exit Sub
    End If
    If insuType = "1" Then '�ױ�
        sql = "select FNewFInsuRtnRate FRate,FNewBInsuRtnRate BRate from T_ATS_InsuranceReturn where FInsuCompanyID =" & insuCompanyId
    ElseIf insuType = "2" Then '�̱�
        sql = "select FOldFInsuRtnRate FRate,FOldBInsuRtnRate BRate from T_ATS_InsuranceReturn where FInsuCompanyID =" & insuCompanyId
    Else
       MsgBox "�������Ͳ���Ϊ��", vbInformation, "�����ʾ"
        Exit Sub
    End If
    Set rs = m_BillInterface.K3Lib.GetData(sql)
    If Not rs.EOF Then
       m_BillInterface.SetFieldValue "FAmount6", forcedAmount * rs!FRate / 100# + businessAmount * rs!BRate / 100#   '�������
    Else
        MsgBox "��Ӧ���չ�˾δ���÷�����", vbInformation, "�����ʾ"
        Exit Sub
    End If
End Sub


Private Sub m_BillInterface_MenuBarClick(ByVal BOSTool As K3ClassEvents.BOSTool, Cancel As Boolean)
    Dim isInsuranceSettle As Boolean
    Dim isInsuranceCheck As Boolean
    isInsuranceSettle = m_BillInterface.GetFieldValue("FCheckBox") '���չ�˾����
    isInsuranceCheck = m_BillInterface.GetFieldValue("FCheckBox1")  '���չ�˾�˶�
    Dim dctCheckDate As KFO.Dictionary '�˶�����
    Dim dctSettleDate As KFO.Dictionary '��������
    Dim dctReturnAmount As KFO.Dictionary '�������
    Dim dctInsuranceBillNum As KFO.Dictionary '���չ�˾�վݺ�
    Dim dctInsuranceInvoiceNum As KFO.Dictionary '���չ�˾��Ʊ��
    Dim multiCheckStatus As String
    multiCheckStatus = m_BillInterface.GetFieldValue("FMultiCheckStatus")
    
    Set dctSettleDate = m_BillInterface.GetFieldInfoByKey("FDate3", "", -1)
    Set dctCheckDate = m_BillInterface.GetFieldInfoByKey("FDate4", "", -1)
    Set dctReturnAmount = m_BillInterface.GetFieldInfoByKey("FAmount6", "", -1)
    Set dctInsuranceBillNum = m_BillInterface.GetFieldInfoByKey("FText2", "", -1)
    Set dctInsuranceInvoiceNum = m_BillInterface.GetFieldInfoByKey("FText3", "", -1)
    
    
    
    If BOSTool.ToolName = "mnuInsuranceCheck" Then '�˶�
        If multiCheckStatus <> "16" Then
            MsgBox "δ���״̬���������պ˶�", vbInformation, "�����ʾ"
            Cancel = True
            Exit Sub
        End If
        If isInsuranceCheck = True Then
            
            If MsgBox("�Ƿ�ȡ�����պ˶�", vbQuestion + vbYesNo, "�����ʾ") <> vbYes Then
                Cancel = True
                Exit Sub
            End If
            
            m_BillInterface.SetFieldValue "FDate4", "" '�˶�����
            m_BillInterface.SetFieldValue "FCheckBox1", 0 '���չ�˾�˶�
            m_BillInterface.SaveBill
        
        Else
            If isInsuranceSettle = False Then
                MsgBox "δ���ս��㣬���������պ˶�", vbInformation, "�����ʾ"
                Cancel = True
                Exit Sub
            End If
            
            optInusCheck = True
            m_BillInterface.BillCtl.BillStatus = Enu_BillStatusExt_New
            m_BillInterface.MenuBar.BOSTools.Item("mnuFileSave").Enabled = True
            m_BillInterface.MenuBar.BOSTools.Item("mnuFileSave").Visible = True
            dctCheckDate("FLock") = 24
            m_BillInterface.LockCell dctCheckDate, 1, False
            m_BillInterface.LockBillEntry 1
        End If
    End If
    
    If BOSTool.ToolName = "mnuInsuranceSettle" Then '����
        If multiCheckStatus <> "16" Then
            MsgBox "δ���״̬���������ս���", vbInformation, "�����ʾ"
            Cancel = True
            Exit Sub
        End If
        
        If isInsuranceSettle = True Then
            If isInsuranceCheck = True Then
                MsgBox "�ѱ��պ˶ԣ�������ȡ�����ս���", vbInformation, "�����ʾ"
                Cancel = True
                Exit Sub
            End If
            
            If MsgBox("�Ƿ�ȡ�����ս���", vbQuestion + vbYesNo, "�����ʾ") <> vbYes Then
                Cancel = True
                Exit Sub
            End If
            
            m_BillInterface.SetFieldValue "FDate3", "" '��������
            m_BillInterface.SetFieldValue "FCheckBox", 0 '���չ�˾����
            
            m_BillInterface.SaveBill
        
        Else
            optInusSettle = True
            m_BillInterface.BillCtl.BillStatus = Enu_BillStatusExt_New
            m_BillInterface.MenuBar.BOSTools.Item("mnuFileSave").Enabled = True
            m_BillInterface.MenuBar.BOSTools.Item("mnuFileSave").Visible = True
            dctSettleDate("FLock") = 24
            m_BillInterface.LockCell dctSettleDate, -1, False
            m_BillInterface.LockCell dctReturnAmount, -1, False
            m_BillInterface.LockCell dctInsuranceBillNum, -1, False
            m_BillInterface.LockCell dctInsuranceInvoiceNum, -1, False
            m_BillInterface.LockBillEntry 1
        
        End If
    End If
    
End Sub

