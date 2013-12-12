VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "SettlementCheck_BillEvent"
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
    
    Dim dct As Object
    
    Set dct = m_BillInterface.GetDataFldbyKey("FBase")

    If (Not (dct Is Nothing) And m_BillInterface.BillStatus = Enu_BillStatusExt_New) Then '��� �����Զ�������������ֵ
        m_BillInterface.SetFieldValue "FBase", dct("FFND")
    End If
    RegUtils.validateLicenseClient m_BillInterface
    
    
    
    
    
 
End Sub

Private Sub Class_Terminate()
 
    '�ͷŽӿڶ���
    'ע��: �˷����������, �����޸�
    Set m_BillInterface = Nothing

End Sub


Private Sub m_BillInterface_CompleteQueryData(ByVal lPage As Long, ByVal lEntrySize As Long, ByVal lRowStart As Long, ByVal lRowsRequest As Long, ByVal lRowsResponse As Long)
    Dim saleOrderId As Long
    Dim saleOrderEntryId As Long
    saleOrderId = Val(m_BillInterface.GetFieldValue("FID_SRC"))
    saleOrderEntryId = Val(m_BillInterface.GetFieldValue("FEntryID_SRC"))
    Dim sql As String
    Dim rs As ADODB.Recordset
    Dim Row As Integer
    Dim totalReceiveAmt As Double
          '�������۶��� ��Ʒ���۶��� �������
    sql = "select FDate,FNumber,FAmount_CN from t_RP_NewReceiveBill " & _
           " where FClassID_Binding=200000028 and FID_Binding=" & saleOrderId & " and FEntryID_Binding=" & saleOrderEntryId & _
           " union " & _
           " select FDate,FNumber,FAmount_CN from t_RP_NewReceiveBill a" & _
           " inner join T_ATS_DecorationOrderSource b on b.FID=a.FID_Binding" & _
           " where a.FClassID_Binding=200000054 and b.FID_SRC=" & saleOrderId & " and b.FEntryID_SRC=" & saleOrderEntryId & _
           " union " & _
           " select FDate,FNumber,FAmount_CN from t_RP_NewReceiveBill a" & _
           " inner join T_ATS_AgentServiceSource b on b.FID=a.FID_Binding" & _
           " where a.FClassID_Binding=200000045 and b.FID_SRC=" & saleOrderId & " and b.FEntryID_SRC=" & saleOrderEntryId & _
           " Order by FDate"
    Set rs = m_BillInterface.K3Lib.GetData(sql)
    
    For Row = m_BillInterface.BillEntrys(1).GridMaxDataRowNum To 1 Step -1
        m_BillInterface.BillEntrys(1).RemoveRow True, Row
    Next Row
    Row = 1
    While Not rs.EOF
        m_BillInterface.InsertNewRowAndFill 2, Row, "FDate1", "2011-1-1" ' , "FText", rs!FNumber, "FAmount", rs!FAmount_CN, "FText1", "�ֽ��տ"

        m_BillInterface.SetFieldValue "FDate1", rs!FDate, Row
        m_BillInterface.SetFieldValue "FText", rs!FNumber, Row
        m_BillInterface.SetFieldValue "FAmount", rs!FAmount_CN, Row
        m_BillInterface.SetFieldValue "FText1", "�ֽ��տ", Row
        totalReceiveAmt = totalReceiveAmt + rs!FAmount_CN
        rs.MoveNext
        Row = Row + 1
    Wend
    m_BillInterface.SetFieldValue "FAmount12", Val(m_BillInterface.GetFieldValue("FAmount1")) - totalReceiveAmt
End Sub

Private Sub m_BillInterface_MenuBarInitialize(ByVal oMenuBar As K3ClassEvents.MenuBar)
    oMenuBar.BOSTools.Item("mnuFileSave").Caption = "����ͨ��"
    oMenuBar.BOSTools.Item("mnuFileSave").Description = "����ͨ��"
    oMenuBar.BOSTools.Item("mnuFileSave").ToolTipText = "����ͨ��"
    oMenuBar.BOSBands("BandToolBar").BOSTools.Item("mnuFileSave").Caption = "����ͨ��"
    oMenuBar.BOSBands("BandToolBar").BOSTools.Item("mnuFileSave").Description = "����ͨ��"
    oMenuBar.BOSBands("BandToolBar").BOSTools.Item("mnuFileSave").ToolTipText = "����ͨ��"
End Sub


Private Sub m_BillInterface_AfterSave(bCancel As Boolean)
 
    'TODO: ���ڴ˴����Ӵ�����Ӧ�¼�
    Dim sourceId As Integer
    Dim sourceEntryID As Integer
    
    Dim sql As String
    Dim rs As ADODB.Recordset
    Dim checkStatus As String
    Dim checkBillID As Integer

    checkBillID = m_BillInterface.GetFieldValue("FID")
    sourceId = m_BillInterface.GetFieldValue("FID_SRC")
    sourceEntryID = m_BillInterface.GetFieldValue("FEntryID_SRC")
    checkStatus = m_BillInterface.GetFieldValue("FComboBox") '����״̬
    
    '�������۶�����������Ϣ
    sql = "update T_ATS_VehicleSaleOrderEntry " & _
          "set FCheckStatus ='" & checkStatus & "'," & _
          "FSettlementCheckID=" & checkBillID & _
          " where FID=" & sourceId & " and FEntryID=" & sourceEntryID
   m_BillInterface.K3Lib.UpdateData (sql)
   
   MsgBox "������ɹ�", vbInformation, "�����ʾ"
   m_BillInterface.BillCtl.BillStatus = Enu_BillStatusExt_View
   m_BillInterface.RefreshBill
   
   
   

End Sub




Private Sub m_BillInterface_MenuBarClick(ByVal BOSTool As K3ClassEvents.BOSTool, Cancel As Boolean)
    Dim sql As String
    Dim sourceId As Integer
    Dim sourceEntryID As Integer
    Dim checkBillID As Integer
    Dim rs As ADODB.Recordset
    Dim diffAmt As Double
    sourceId = Val(m_BillInterface.GetFieldValue("FID_SRC")) '���۶���ID
    sourceEntryID = Val(m_BillInterface.GetFieldValue("FEntryID_SRC")) '���۶�����¼ID
    checkBillID = Val(m_BillInterface.GetFieldValue("FID")) '��鵥ID
    diffAmt = Val(m_BillInterface.GetFieldValue("FAmount12")) '���
    
    
    If BOSTool.ToolName = "mnuFileSave" Then '����ͨ��
        sql = "select 1 from T_ATS_VehicleSaleOrderEntry where FCheckStatus<>'1' and FID=" & sourceId & " and FEntryID=" & sourceEntryID
        Set rs = m_BillInterface.K3Lib.GetData(sql)
        If (Not rs.EOF) Then
            MsgBox "�ѽ�����ͨ�����������¼�飬��ִ�����¼�����", vbInformation, "�����ʾ"
            Cancel = True
            Exit Sub
        End If
        If (diffAmt > 0) Then
           MsgBox "���ս��С��Ӧ�ս��в��δ�գ���������ͨ����", vbInformation, "�����ʾ"
           Cancel = True
           Exit Sub
        End If
        
        
        If MsgBox("�Ƿ��������ͨ����", vbQuestion + vbYesNo, "�����ʾ") = vbNo Then
                Cancel = True
                Exit Sub
        End If
        m_BillInterface.SetFieldValue "FCombobox", "2"
    End If
    
    If BOSTool.ToolName = "mnuSpecialPass" Then '����ͨ��
        sql = "select 1 from T_ATS_VehicleSaleOrderEntry where FCheckStatus<>'1' and FID=" & sourceId & " and FEntryID=" & sourceEntryID
        Set rs = m_BillInterface.K3Lib.GetData(sql)
        If (Not rs.EOF) Then
            MsgBox "�ѽ�����ͨ�����������¼�飬��ִ�����¼�����", vbInformation, "�����ʾ"
            Cancel = True
            Exit Sub
        End If
        Dim specialChecker As KFO.Dictionary
        Set specialChecker = m_BillInterface.GetDataFldbyKey("FBase2") '������
        
        If specialChecker("FFLD") = "" Then
            MsgBox "����ͨ���������˲���Ϊ�գ�", vbInformation, "�����ʾ"
            Cancel = True
            Exit Sub
        End If
        
        If MsgBox("�Ƿ����������ͨ����", vbQuestion + vbYesNo, "�����ʾ") = vbNo Then
                Cancel = True
                Exit Sub
        End If
        m_BillInterface.SetFieldValue "FCombobox", "3"
        m_BillInterface.SaveBill
        m_BillInterface.BillCtl.BillStatus = Enu_BillStatusExt_View
        m_BillInterface.RefreshBill
        MsgBox "����������ͨ���ɹ�", vbInformation, "�����ʾ"
    
    End If
    
    If BOSTool.ToolName = "mnuUnPass" Then '��ͨ��
        sql = "select 1 from T_ATS_VehicleSaleOrderEntry where FCheckStatus<>'1' and FID=" & sourceId & " and FEntryID=" & sourceEntryID
        Set rs = m_BillInterface.K3Lib.GetData(sql)
        If (Not rs.EOF) Then
            MsgBox "�ѽ�����ͨ�����������¼�飬��ִ�����¼�����", vbInformation, "�����ʾ"
            Cancel = True
            Exit Sub
        End If
        
        If MsgBox("�Ƿ�����鲻ͨ����", vbQuestion + vbYesNo, "�����ʾ") = vbNo Then
                Cancel = True
                Exit Sub
        End If
        m_BillInterface.SetFieldValue "FCombobox", "4"
        m_BillInterface.SaveBill
        m_BillInterface.BillCtl.BillStatus = Enu_BillStatusExt_View
        m_BillInterface.RefreshBill
        MsgBox "�����鲻ͨ���ɹ�", vbInformation, "�����ʾ"
    End If
    
    If BOSTool.ToolName = "mnuReCheck" Then '���¼��
        sql = "select 1 from T_ATS_VehicleSaleOrderEntry where FCheckStatus='1' and FID=" & sourceId & " and FEntryID=" & sourceEntryID
        Set rs = m_BillInterface.K3Lib.GetData(sql)
        If (Not rs.EOF) Then
            MsgBox "δ�����飬�������¼��", vbInformation, "�����ʾ"
            Cancel = True
            Exit Sub
        End If
        sql = "select 1 from T_ATS_VehicleSaleOrderEntry where FIsIssue=1 and FID=" & sourceId & " and FEntryID=" & sourceEntryID
        Set rs = m_BillInterface.K3Lib.GetData(sql)
        If (Not rs.EOF) Then
            MsgBox "�����ѳ��⣬���������¼��", vbInformation, "�����ʾ"
            Cancel = True
            Exit Sub
        End If
        
        If MsgBox("�Ƿ����½����飿", vbQuestion + vbYesNo, "�����ʾ") = vbNo Then
            Cancel = True
            Exit Sub
        End If
        
        '��������
        sql = "update T_ATS_VehicleSaleOrderEntry " & _
              "set FCheckStatus='1' " & _
              "where FID=" & sourceId & " and FEntryID=" & sourceEntryID
        '��������Ϣ
        m_BillInterface.K3Lib.UpdateData (sql)
        sql = "update t_ats_SettlementCheck " & _
              "set FStatus = '1'," & _
              "FChecker=0,FDate=null,FSpecialChecker=0,FNOTE='' " & _
              "where FID=" & checkBillID
         m_BillInterface.K3Lib.UpdateData (sql)
         m_BillInterface.BillCtl.BillStatus = Enu_BillStatusExt_Modify
         m_BillInterface.RefreshBill
         MsgBox "���½�����ɹ�", vbInformation, "�����ʾ"
         
        
    End If
    
    
    
End Sub
