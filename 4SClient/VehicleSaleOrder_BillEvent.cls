VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "VehicleSaleOrder_BillEvent"
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





Private Sub m_BillInterface_MenuBarClick(ByVal BOSTool As K3ClassEvents.BOSTool, Cancel As Boolean)
    Dim isAssign As Boolean
    isAssign = m_BillInterface.BillEntrys(1).BOSFields("FCheckbox1").Value '�Ƿ����䳵
    Dim checkStatus As String
    checkStatus = m_BillInterface.BillEntrys(1).BOSFields("FCombobox").Value '�Ƿ��ѽ�����

    If BOSTool.ToolName = "mnuEditAssign" Then '�䳵
        If (m_BillInterface.GetFieldValue("FMultiCheckStatus") <> 16) Then
            MsgBox "δ��ˣ������䳵", vbInformation, "�����ʾ"
            Cancel = True
            Exit Sub
        End If
        If (isAssign) Then
            If MsgBox("���䳵,�Ƿ�鿴�䳵��", vbQuestion + vbYesNo, "�����ʾ") = vbNo Then
                Cancel = True
                Exit Sub
            End If
        End If
        showAssignBill
        
    End If
    
    If BOSTool.ToolName = "mnuEditSettlementCheck" Then '������
        If (isAssign) Then '���䳵
            If (checkStatus <> "1") Then
               If MsgBox("�ѽ�����ͨ��,�Ƿ�鿴�����鵥", vbQuestion + vbYesNo, "�����ʾ") = vbNo Then
                    Cancel = True
                    Exit Sub
               End If
            End If
            showSettlementCheckBill
            
        Else 'δ�䳵
            MsgBox "δ�䳵��������������", vbExclamation, "�����ʾ"
            Cancel = True
            Exit Sub
        End If
    
    End If
End Sub


Private Sub showSettlementCheckBill()
    Dim oDataSrv As Object
    Dim oBill As Object
    Dim ds As KFO.Dictionary
    Dim checkBillID As Integer
    Dim checkStatus As String
    checkBillID = Val(m_BillInterface.BillEntrys(1).BOSFields("FInteger1").Value) '���㵥ID
    checkStatus = m_BillInterface.BillEntrys(1).BOSFields("FCombobox").Value '������״̬
     
    On Error GoTo err_ctr
    Set oDataSrv = m_BillInterface.K3Lib.CreateK3Object("K3ClassTpl.DataSrv")
     
    oDataSrv.ClassTypeID = 200000037
    If checkBillID = 0 Then 'δ���ɽ��㵥
       Dim oTableInfo As Object
       Set oTableInfo = oDataSrv.TableInfo
       Dim oData As Object
       Set oData = oDataSrv.GetEmptyBill
       oData("Page1")(oTableInfo("map")("FBillNo_SRC"))("FFLD") = m_BillInterface.GetFieldValue("FBillNo") 'Դ���ݱ��
       oData("Page1")(oTableInfo("map")("FEntryID_SRC"))("FFLD") = m_BillInterface.BillEntrys(1).BOSFields("FEntryID2").Value 'Դ���ݷ�¼ID
       oData("Page1")(oTableInfo("map")("FInteger"))("FFLD") = m_BillInterface.BillEntrys(1).BOSFields("FIndex2").Value 'Դ���ݷ�¼���
       oData("Page1")(oTableInfo("map")("FID_SRC"))("FFLD") = m_BillInterface.BillEntrys(1).BOSFields("FID2").Value 'Դ����ID
       oData("Page1")(oTableInfo("map")("FClassID_SRC"))("FFLD") = 200000028 'Դ��������
       oData("Page1")(oTableInfo("map")("FBase"))("FFND") = m_BillInterface.BillEntrys(1).BOSFields("FBase2").Number  '��������
       oData("Page1")(oTableInfo("map")("FBase"))("FFLD") = m_BillInterface.BillEntrys(1).BOSFields("FBase2").Value  '��������
       oData("Page1")(oTableInfo("map")("FBase"))("FDSP") = m_BillInterface.BillEntrys(1).BOSFields("FBase2").Text  '��������
       
      ' oData("Page1")(oTableInfo("map")("FAmount"))("FFLD") = Val(m_BillInterface.BillEntrys(1).BOSFields("FPrice").Value)  '����ָ����
      ' oData("Page1")(oTableInfo("map")("FAmount1"))("FFLD") = Val(m_BillInterface.BillEntrys(1).BOSFields("FPrice1").Value)  '��˾ָ����
      ' oData("Page1")(oTableInfo("map")("FAmount2"))("FFLD") = Val(m_BillInterface.BillEntrys(1).BOSFields("FAmount2").Value)  '�������ۼ�
     '  oData("Page1")(oTableInfo("map")("FAmount3"))("FFLD") = Val(m_BillInterface.BillEntrys(1).BOSFields("FAmount9").Value)  '�����ۿۼ�
     '  oData("Page1")(oTableInfo("map")("FAmount4"))("FFLD") = Val(m_BillInterface.BillEntrys(1).BOSFields("FAmount10").Value)  '�����Żݼ�
       oData("Page1")(oTableInfo("map")("FAmount5"))("FFLD") = Val(m_BillInterface.BillEntrys(1).BOSFields("FAmount8").Value)  '����Ӧ�ս��
      ' oData("Page1")(oTableInfo("map")("FAmount6"))("FFLD") = Val(m_BillInterface.BillEntrys(1).BOSFields("FAmount11").Value)  'ѡװ��
       oData("Page1")(oTableInfo("map")("FAmount7"))("FFLD") = Val(m_BillInterface.BillEntrys(1).BOSFields("FAmount3").Value)  '��ƷӦ�ս��
       oData("Page1")(oTableInfo("map")("FAmount8"))("FFLD") = Val(m_BillInterface.BillEntrys(1).BOSFields("FAmount7").Value)  '����Ӧ�ս��
       oData("Page1")(oTableInfo("map")("FAmount1"))("FFLD") = Val(m_BillInterface.BillEntrys(1).BOSFields("FAmount4").Value)  '��Ӧ�ս��
     '  oData("Page1")(oTableInfo("map")("FAmount10"))("FFLD") = Val(m_BillInterface.BillEntrys(1).BOSFields("FAmount5").Value)  '�����ս��
       oData("Page1")(oTableInfo("map")("FAmount11"))("FFLD") = Val(m_BillInterface.BillEntrys(1).BOSFields("FAmount6").Value)  '�û����ֳ��չ���
      ' oData("Page1")(oTableInfo("map")("FAmount12"))("FFLD") = Val(m_BillInterface.BillEntrys(1).BOSFields("FAmount4").Value) - Val(m_BillInterface.BillEntrys(1).BOSFields("FAmount5").Value)  '���
       
    End If
     
    
    Set oBill = m_BillInterface.K3Lib.CreateK3Object("K3SingleClassBill.ClassInfoManager")
    With oBill
      .DataSrv = oDataSrv
      .ISNetControl = True
      .ISCheckRight = True
      If checkStatus <> "1" And checkBillID > 0 Then  '�ѽ�����
         .Show checkBillID, False, 0
      ElseIf checkStatus = "1" And checkBillID > 0 Then 'δ��飬�������ɼ�鵥
          .Show checkBillID, False, 2, oData
      Else '������鵥
          .Show 0, False, 1, oData
      End If
    
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
        
    m_BillInterface.RefreshBill
     Exit Sub
err_ctr:
    Set oDataSrv = Nothing
    Set oBill = Nothing

End Sub

Private Sub showAssignBill()
     Dim oDataSrv As Object
     Dim oBill As Object
     Dim ds As KFO.Dictionary
     Dim assignBillId As Integer
     Dim isAssign As Boolean
     assignBillId = Val(m_BillInterface.BillEntrys(1).BOSFields("FInteger").Value) '�䳵��ID
     isAssign = m_BillInterface.BillEntrys(1).BOSFields("FCheckbox1").Value '�Ƿ��䳵
     
     On Error GoTo err_ctr
     Set oDataSrv = m_BillInterface.K3Lib.CreateK3Object("K3ClassTpl.DataSrv")
     
     oDataSrv.ClassTypeID = 200000036
     If assignBillId = 0 Then 'δ�����䳵��
        Dim oTableInfo As Object
        Set oTableInfo = oDataSrv.TableInfo
        Dim oData As Object
        Set oData = oDataSrv.GetEmptyBill
        oData("Page1")(oTableInfo("map")("FNote"))("FFLD") = m_BillInterface.GetFieldValue("FNote2") '�䳵��ע
        oData("Page1")(oTableInfo("map")("FBillNo_SRC"))("FFLD") = m_BillInterface.GetFieldValue("FBillNo") 'Դ���ݱ��
        oData("Page1")(oTableInfo("map")("FID_SRC"))("FFLD") = m_BillInterface.BillEntrys(1).BOSFields("FID2").Value 'Դ����ID
        oData("Page1")(oTableInfo("map")("FEntryID_SRC"))("FFLD") = m_BillInterface.BillEntrys(1).BOSFields("FEntryID2").Value 'Դ���ݷ�¼ID
        oData("Page1")(oTableInfo("map")("FClassID_SRC"))("FFLD") = 200000028 'Դ��������
        oData("Page1")(oTableInfo("map")("FInteger"))("FFLD") = m_BillInterface.BillEntrys(1).BOSFields("FIndex2").Value '���ݷ�¼���
        oData("Page1")(oTableInfo("map")("FBase2"))("FFND") = m_BillInterface.BillEntrys(1).BOSFields("FBase3").Number  '���ͱ���
        oData("Page1")(oTableInfo("map")("FBase2"))("FFLD") = m_BillInterface.BillEntrys(1).BOSFields("FBase3").Value  '��������
        oData("Page1")(oTableInfo("map")("FBase2"))("FDSP") = m_BillInterface.BillEntrys(1).BOSFields("FBase3").Text  '��������
        
        oData("Page1")(oTableInfo("map")("FBase3"))("FFND") = m_BillInterface.BillEntrys(1).BOSFields("FBase8").Number  '��ɫ����
        oData("Page1")(oTableInfo("map")("FBase3"))("FFLD") = m_BillInterface.BillEntrys(1).BOSFields("FBase8").Value  '��ɫ����
        oData("Page1")(oTableInfo("map")("FBase3"))("FDSP") = m_BillInterface.BillEntrys(1).BOSFields("FBase8").Text  '��ɫ����
        
        oData("Page1")(oTableInfo("map")("FBase4"))("FFND") = m_BillInterface.BillEntrys(1).BOSFields("FBase7").Number  '���α���
        oData("Page1")(oTableInfo("map")("FBase4"))("FFLD") = m_BillInterface.BillEntrys(1).BOSFields("FBase7").Value  '��������
        oData("Page1")(oTableInfo("map")("FBase4"))("FDSP") = m_BillInterface.BillEntrys(1).BOSFields("FBase7").Text  '��������
        
        oData("Page1")(oTableInfo("map")("FText"))("FFLD") = m_BillInterface.BillEntrys(1).BOSFields("FText").Text  'ѡװ
        
     End If
     
    
     Set oBill = m_BillInterface.K3Lib.CreateK3Object("K3SingleClassBill.ClassInfoManager")
     With oBill
       .DataSrv = oDataSrv
       .ISNetControl = True
       .ISCheckRight = True
       If isAssign And assignBillId > 0 Then '���䳵
          .Show assignBillId, False, 0
       ElseIf Not isAssign And assignBillId > 0 Then 'δ�䳵�����������䳵��
           .Show assignBillId, False, 2
       Else '�����䳵��
          .Show 0, False, 1, oData
       End If
    
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
        
     m_BillInterface.RefreshBill
     Exit Sub
err_ctr:
    Set oDataSrv = Nothing
    Set oBill = Nothing


End Sub

