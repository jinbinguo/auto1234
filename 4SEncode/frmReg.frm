VERSION 5.00
Begin VB.Form regForm 
   Caption         =   "�ӽ��ܹ���"
   ClientHeight    =   5175
   ClientLeft      =   120
   ClientTop       =   465
   ClientWidth     =   9825
   LinkTopic       =   "Form1"
   ScaleHeight     =   5175
   ScaleWidth      =   9825
   StartUpPosition =   3  '����ȱʡ
   Begin VB.TextBox txtMachine 
      Height          =   390
      Left            =   1680
      TabIndex        =   12
      Text            =   "1918421108"
      Top             =   120
      Width           =   3380
   End
   Begin VB.TextBox txtDecode 
      Height          =   390
      Left            =   1680
      TabIndex        =   9
      Top             =   4440
      Width           =   3380
   End
   Begin VB.TextBox txtSQL 
      Height          =   2175
      Left            =   360
      MultiLine       =   -1  'True
      ScrollBars      =   3  'Both
      TabIndex        =   8
      Top             =   2160
      Width           =   7695
   End
   Begin VB.TextBox txtEndDate 
      Height          =   390
      Left            =   1680
      TabIndex        =   6
      Text            =   "2013-4-3"
      Top             =   1560
      Width           =   3380
   End
   Begin VB.TextBox txtBeginDate 
      Height          =   390
      Left            =   1680
      TabIndex        =   4
      Text            =   "2013-1-3"
      Top             =   1080
      Width           =   3380
   End
   Begin VB.TextBox txtOrgName 
      Height          =   390
      Left            =   1680
      TabIndex        =   2
      Text            =   "Ȫ���ղ��������޹�˾"
      Top             =   600
      Width           =   3380
   End
   Begin VB.CommandButton btnDecode 
      Caption         =   "����"
      Height          =   495
      Left            =   6360
      TabIndex        =   1
      Top             =   4440
      Width           =   1695
   End
   Begin VB.CommandButton btnEncode 
      Caption         =   "����"
      Height          =   495
      Left            =   6360
      TabIndex        =   0
      Top             =   120
      Width           =   1695
   End
   Begin VB.Label Label5 
      Caption         =   "���ڸ�ʽ��2013-08-09"
      Height          =   375
      Left            =   5520
      TabIndex        =   13
      Top             =   1320
      Width           =   1215
   End
   Begin VB.Label Label4 
      Caption         =   "������"
      Height          =   255
      Left            =   360
      TabIndex        =   11
      Top             =   240
      Width           =   1215
   End
   Begin VB.Label Label1 
      Caption         =   "���ܴ�"
      Height          =   255
      Left            =   360
      TabIndex        =   10
      Top             =   4560
      Width           =   1095
   End
   Begin VB.Label Label3 
      Caption         =   "ʧЧ����"
      Height          =   255
      Left            =   360
      TabIndex        =   7
      Top             =   1680
      Width           =   975
   End
   Begin VB.Label Label2 
      Caption         =   "��Ч����"
      Height          =   255
      Left            =   360
      TabIndex        =   5
      Top             =   1200
      Width           =   855
   End
   Begin VB.Label labKey 
      Caption         =   "��������"
      Height          =   255
      Left            =   360
      TabIndex        =   3
      Top             =   720
      Width           =   1095
   End
End
Attribute VB_Name = "regForm"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False

Private Sub btnDecode_Click()
     If txtMachine.Text = "" Then
        MsgBox "�����벻��Ϊ��", vbExclamation, "�����ʾ"
        Exit Sub
    End If
    
     If txtOrgName.Text = "" Then
        MsgBox "�������Ʋ���Ϊ��", vbExclamation, "�����ʾ"
        Exit Sub
    End If
    
   txtSQL.Text = ENUtils.decode(txtOrgName.Text, txtDecode.Text) '����
End Sub

Private Sub btnEncode_Click() '����
    If txtMachine.Text = "" Then
        MsgBox "�����벻��Ϊ��", vbExclamation, "�����ʾ"
        Exit Sub
    End If
    
     If txtOrgName.Text = "" Then
        MsgBox "�������Ʋ���Ϊ��", vbExclamation, "�����ʾ"
        Exit Sub
    End If
    
     If txtBeginDate.Text = "" Then
        MsgBox "��Ч���ڲ���Ϊ��", vbExclamation, "�����ʾ"
        Exit Sub
    End If
    
     If txtEndDate.Text = "" Then
        MsgBox "ʧЧ���ڲ���Ϊ��", vbExclamation, "�����ʾ"
        Exit Sub
    End If
    
    Dim beginDate As String
    Dim endDate As String
    On Error GoTo errDate
    beginDate = Format(CDate(txtBeginDate.Text), "yyyy-mm-dd")
    endDate = Format(CDate(txtEndDate.Text), "yyyy-mm-dd")
    
    If DateDiff("d", beginDate, endDate) < 0 Then
         MsgBox "��Ч���ڲ��ܴ���ʧЧ����", vbExclamation, "�����ʾ"
        Exit Sub
    End If
    Dim sql As String
    Dim FMachineCiphertext As String
    Dim FOrgNameCiphertext As String
    Dim FBeginDateCiphertext As String
    Dim FEndDateCiphertext As String
    FMachineCiphertext = ENUtils.encode(txtOrgName.Text, txtMachine.Text)
    FOrgNameCiphertext = ENUtils.encode(txtOrgName.Text, txtOrgName.Text)
    FBeginDateCiphertext = ENUtils.encode(txtOrgName.Text, txtBeginDate.Text)
    FEndDateCiphertext = ENUtils.encode(txtOrgName.Text, txtEndDate.Text)
    
    sql = "truncate table T_ATS_RegInfo " & vbCrLf
    
    sql = sql & "insert into T_ATS_RegInfo(FMachineCiphertext,FOrgNameCiphertext,FBeginDateCiphertext,FEndDateCiphertext) " & _
        "values('" & FMachineCiphertext & "','" & FOrgNameCiphertext & "','" & FBeginDateCiphertext & "','" & FEndDateCiphertext & "')"
        
    txtSQL.Text = sql & vbCrLf & vbCrLf & vbCrLf
    
    txtSQL.Text = txtSQL.Text & "����������   = " & FMachineCiphertext & vbCrLf
    txtSQL.Text = txtSQL.Text & "������������ = " & FOrgNameCiphertext & vbCrLf
    txtSQL.Text = txtSQL.Text & "��Ч�������� = " & FBeginDateCiphertext & vbCrLf
    txtSQL.Text = txtSQL.Text & "ʧЧ�������� = " & FEndDateCiphertext & vbCrLf
    
    Exit Sub
errDate:
    MsgBox "���ڸ�ʽ����ȷ", vbExclamation, "�����ʾ"
End Sub

Private Sub Form_Load()
    txtBeginDate.Text = Format(Date, "YYYY-MM-DD")
    txtEndDate.Text = Format(DateAdd("m", 6, Date), "YYYY-MM-DD")
End Sub
