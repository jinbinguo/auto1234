VERSION 5.00
Object = "{0ECD9B60-23AA-11D0-B351-00A0C9055D8E}#6.0#0"; "MSHFLXGD.OCX"
Begin VB.Form frmCashReceiptBinding 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "����"
   ClientHeight    =   3735
   ClientLeft      =   45
   ClientTop       =   390
   ClientWidth     =   7980
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   3735
   ScaleWidth      =   7980
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  '����������
   Begin VB.CommandButton btnQuery 
      Caption         =   "��ѯ"
      Height          =   375
      Left            =   6480
      TabIndex        =   3
      Top             =   1080
      Width           =   1215
   End
   Begin VB.ComboBox cmbBillType 
      Height          =   300
      ItemData        =   "frmCashReceiptBinding.frx":0000
      Left            =   1680
      List            =   "frmCashReceiptBinding.frx":0002
      Style           =   2  'Dropdown List
      TabIndex        =   2
      Top             =   120
      Width           =   1815
   End
   Begin VB.CommandButton btnBinding 
      Caption         =   "����"
      Height          =   375
      Left            =   6480
      TabIndex        =   1
      Top             =   1680
      Width           =   1215
   End
   Begin MSHierarchicalFlexGridLib.MSHFlexGrid gridBill 
      Height          =   3015
      Left            =   240
      TabIndex        =   0
      Top             =   600
      Width           =   6135
      _ExtentX        =   10821
      _ExtentY        =   5318
      _Version        =   393216
      WordWrap        =   -1  'True
      SelectionMode   =   1
      _NumberOfBands  =   1
      _Band(0).Cols   =   2
      _Band(0).GridLinesBand=   1
      _Band(0).TextStyleBand=   0
      _Band(0).TextStyleHeader=   0
   End
   Begin VB.Label contBillType 
      Caption         =   "����������"
      BeginProperty Font 
         Name            =   "����"
         Size            =   10.5
         Charset         =   134
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   375
      Left            =   360
      TabIndex        =   4
      Top             =   120
      Width           =   1335
   End
End
Attribute VB_Name = "frmCashReceiptBinding"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Declare Function SetWindowPos Lib "user32" (ByVal hwnd As Long, ByVal hWndInsertAfter As Long, ByVal x As Long, ByVal y As Long, ByVal cx As Long, ByVal cy As Long, ByVal wFlags As Long) As Long


Dim m_BillInterface As BillEvent
Dim dctBillType As KFO.Dictionary
Dim bindingBillTypeNum As String

Public Function ShowForm(ByVal owner, billInterface As BillEvent) As String

    Set m_BillInterface = billInterface
    
    Set dctBillType = New KFO.Dictionary
    Dim i As Integer
    dctBillType("200000028") = "�������۶���"
    dctBillType("200000054") = "��Ʒ������۶���"
    dctBillType("200000045") = "�������"
    
    
    For i = 1 To dctBillType.Count
        cmbBillType.AddItem dctBillType.Value(dctBillType.Name(i)), i - 1
    Next i
    
    bindingBillTypeNum = m_BillInterface.GetFieldValue("FComboBox") '����
    If dctBillType.Lookup(bindingBillTypeNum) Then
        cmbBillType.Text = dctBillType.Value(bindingBillTypeNum)
        btnQuery_Click
    End If
     
    Me.Show vbModal

    
    
    Unload Me

End Function




Private Sub btnBinding_Click()
    Dim currentRow As Integer
    Dim sql As String
    Dim rs As ADODB.Recordset
    currentRow = gridBill.Row
    
    If currentRow = 0 Then
        MsgBox "��ѡ��������!"
        Exit Sub
    End If
    Dim bindingId As Long
    Dim bindingEntryId As Long
    
    Dim amountFor As Double
    amountFor = m_BillInterface.GetFieldValue("FAmountFor") '���
    gridBill.Col = 1 'FID
    bindingId = Val(gridBill.Text)
    
    gridBill.Col = 3 'FEntryID
    bindingEntryId = Val(gridBill.Text)
    
    
    If bindingBillTypeNum = "200000028" Then '�������۶���
        sql = "select 1 from T_ATS_VehicleSaleOrderEntry where FID=" & CStr(bindingId) & " AND FEntryID=" & CStr(bindingEntryId) & " AND FReceiptBindingAmount+" & CStr(amountFor) & " > FARVehicleAmount"
        Set rs = m_BillInterface.K3Lib.GetData(sql)
        If Not rs.EOF Then
            If MsgBox("�ܹ�����������Ӧ�ս��ϼƣ��Ƿ����", vbYesNo + vbInformation, "�����ʾ") = vbNo Then
                Exit Sub
            End If
            
        End If

        sql = "update T_ATS_VehicleSaleOrderEntry " & _
              "set FReceiptBindingAmount=FReceiptBindingAmount+" & CStr(amountFor) & _
              "where FID=" & CStr(bindingId) & " AND FEntryID=" & CStr(bindingEntryId)
        m_BillInterface.K3Lib.UpdateData (sql)
        
    ElseIf bindingBillTypeNum = "200000054" Then '��Ʒ������۶���
        sql = "select 1 from T_ATS_DecorationOrder where FID=" & CStr(bindingId) & " and FReceiptBindingAmount+" & CStr(amountFor) & " > FTotalARAmount"
        Set rs = m_BillInterface.K3Lib.GetData(sql)
        If Not rs.EOF Then
            If MsgBox("�ܹ���������Ӧ�ս��ϼƣ��Ƿ����", vbYesNo + vbInformation, "�����ʾ") = vbNo Then
                Exit Sub
            End If
            
        End If

        sql = "update T_ATS_DecorationOrder " & _
              "set FReceiptBindingAmount=FReceiptBindingAmount+" & CStr(amountFor) & _
              " where FID=" & CStr(bindingId)
        m_BillInterface.K3Lib.UpdateData (sql)
        
    ElseIf bindingBillTypeNum = "200000045" Then '�������
       sql = "select 1 from T_ATS_AgentService where FID=" & gridBill.Text & " and FReceiptBindingAmount+" & CStr(amountFor) & " > FTotalARAmount"
       Set rs = m_BillInterface.K3Lib.GetData(sql)
       If Not rs.EOF Then
            If MsgBox("�ܹ�������Ӧ�ս��ϼƣ��Ƿ����", vbYesNo + vbInformation, "�����ʾ") = vbNo Then
                Exit Sub
            End If
            
       End If

       sql = "update T_ATS_AgentService " & _
              "set FReceiptBindingAmount=FReceiptBindingAmount+" & CStr(amountFor) & _
              " where FID=" & gridBill.Text
        m_BillInterface.K3Lib.UpdateData (sql)
    Else
        MsgBox "����ѡ����Ч�Ĺ���������", vbInformation, "�����ʾ"
        Exit Sub
    End If
    
    
    
    gridBill.Col = 1 'FID
    m_BillInterface.SetFieldValue "FInteger1", gridBill.Text
    gridBill.Col = 2 '����
    m_BillInterface.SetFieldValue "FText", gridBill.Text
    gridBill.Col = 3 'FEntryID
    m_BillInterface.SetFieldValue "FInteger2", gridBill.Text
    gridBill.Col = 4 '��¼�к�
    m_BillInterface.SetFieldValue "FInteger", gridBill.Text
    
    m_BillInterface.SetFieldValue "FComboBox", bindingBillTypeNum '����������
    
    m_BillInterface.SaveBill
    
    
    MsgBox "�������", vbInformation, "�����ʾ"
    
     Unload Me
    
End Sub

Private Sub btnQuery_Click()
    Dim sql As String
    Dim i As Integer
    Dim bindingBillTypeName As String
   
    Dim customerId As Long
    Dim modelId As Long
    
    bindingBillTypeName = cmbBillType.Text
    bindingBillTypeNum = ""
     
    If bindingBillTypeName = "" Then
        MsgBox "����ѡ�����������", vbInformation, "�����ʾ"
        Exit Sub
    End If
    For i = 1 To dctBillType.Count
        If bindingBillTypeName = dctBillType.Value(dctBillType.Name(i)) Then
            bindingBillTypeNum = dctBillType.Name(i)
            Exit For
        End If
        
    Next i
    
    Dim gridRowCount As Integer
    Dim j As Integer
    gridRowCount = gridBill.Rows
    For i = 1 To gridRowCount - 1
        If gridBill.Rows = 2 Then
            gridBill.Row = 1
            For j = 1 To gridBill.Cols - 1
                gridBill.Col = j
                gridBill.Text = ""
            Next j
        Else
            gridBill.RemoveItem gridBill.Rows - 1
        End If

    Next i
    
    If bindingBillTypeNum = "" Then
        MsgBox "ѡ�еĹ��������Ͳ���Ӧ�÷�Χ������������Ա�鿴", vbInformation, "�����ʾ"
        Exit Sub
    End If
    
    customerId = Val(m_BillInterface.GetFieldValue("FCustomer")) '�ͻ�
    modelId = Val(m_BillInterface.GetFieldValue("FBase")) '����
    
    If bindingBillTypeNum = "200000028" Then '�������۶���
        Caption = "�������۶���"
        sql = "select b.FID,b.FBillNo ����,a.FEntryID,a.FIndex ��¼�к�,c.FVin ���̺�,d.FName �ͻ� from T_ATS_VehicleSaleOrderEntry a " & _
              "left join T_ATS_VehicleSaleOrder b on a.fid=b.fid and b.FID<>0 " & _
              "left join T_ATS_Vehicle c on c.fid=a.FVehicleID and c.FID<>0 " & _
              "left join t_Organization d on d.FItemID=b.FCustomerID and d.FItemID<>0 " & _
              "where b.FMultiCheckStatus='16'and b.FCustomerID=" & customerId & " and a.FModelId=" & modelId
            
    ElseIf bindingBillTypeNum = "200000054" Then '��Ʒ������۶���
        sql = "select a.FID,a.FBillNo ����,0 FEntryID,0 FIndexID,b.FVIN ���̺�,c.FName �ͻ�,d.FBillNo_SRC �������۶��� from T_ATS_DecorationOrder  a " & _
              "left join T_ATS_Vehicle b on b.FID=a.FVehicleID and b.FID <> 0 " & _
              "left join t_Organization c on c.FItemID =a.FCustomerID and c.FItemID<>0 " & _
              "left join T_ATS_DecorationOrderSource d on d.FID=a.FID and d.FClassID_SRC=200000028 and d.FID<>0" & _
              "where a.FMultiCheckStatus='16' and a.FCustomerID = " & customerId & " And b.FModelId = " & modelId
    
    ElseIf bindingBillTypeNum = "200000045" Then '�������
        sql = "select a.FID,a.FBillNo ����,0 FEntryID,0 FIndexID,b.FVIN ���̺�,c.FName �ͻ�, d.FBillNo_SRC �������۶��� from T_ATS_AgentService a " & _
              "left join T_ATS_Vehicle b on b.FID=a.FVehicleID and b.FID <> 0 " & _
              "left join t_Organization c on c.FItemID =a.FCustomerID and c.FItemID<>0 " & _
              "left join T_ATS_AgentServiceSource d on d.FID=a.FID and d.FClassID_SRC=200000028 and d.FID<>0 " & _
              "where a.FMultiCheckStatus='16' and a.FCustomerID = " & customerId & " And b.FModelId = " & modelId
    Else
        MsgBox "����ѡ����Ч�Ĺ���������", vbInformation, "�����ʾ"
        Exit Sub
    
    End If
    
    Set gridBill.Recordset = m_BillInterface.K3Lib.GetData(sql)
    
    If gridBill.Rows > 1 Then
        gridBill.FixedRows = 0
        gridBill.FixedRows = 1
    End If
    
    gridBill.TextMatrix(0, 0) = "���"
    For i = 1 To gridBill.Rows - 1
        gridBill.TextMatrix(i, 0) = i
    Next i
    gridBill.ColWidth(0) = 500
    For i = 1 To gridBill.Cols - 1
        gridBill.Row = 0
        gridBill.Col = i
        gridBill.ColWidth(i) = 1300
        If InStr(gridBill.Text, "ID") > 0 Then
            gridBill.ColWidth(i) = 0
        End If

    Next i
    
    
    
End Sub
