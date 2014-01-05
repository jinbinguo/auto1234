VERSION 5.00
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "mscomctl.ocx"
Begin VB.Form frmImportDlg 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "导入"
   ClientHeight    =   7590
   ClientLeft      =   45
   ClientTop       =   390
   ClientWidth     =   9765
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   7590
   ScaleWidth      =   9765
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  '所有者中心
   Begin VB.TextBox txtMsg 
      Height          =   5055
      Left            =   120
      Locked          =   -1  'True
      MultiLine       =   -1  'True
      ScrollBars      =   3  'Both
      TabIndex        =   8
      Text            =   "frmImportDlg.frx":0000
      Top             =   2040
      Width           =   9495
   End
   Begin VB.CommandButton btnExit 
      Caption         =   "退出"
      Height          =   495
      Left            =   7440
      TabIndex        =   6
      Top             =   960
      Width           =   1335
   End
   Begin VB.CommandButton btnImport 
      Caption         =   "导入"
      Height          =   495
      Left            =   5880
      TabIndex        =   5
      Top             =   960
      Width           =   1215
   End
   Begin VB.CommandButton btnCheck 
      Caption         =   "检查"
      Height          =   495
      Left            =   4320
      TabIndex        =   4
      Top             =   960
      Width           =   1215
   End
   Begin VB.CommandButton btnBrowse 
      Caption         =   "浏览..."
      Height          =   375
      Left            =   8640
      TabIndex        =   3
      Top             =   360
      Width           =   975
   End
   Begin VB.TextBox txtFileName 
      Height          =   375
      HideSelection   =   0   'False
      Left            =   720
      Locked          =   -1  'True
      TabIndex        =   2
      Text            =   "请选择导入文件。。。"
      Top             =   360
      Width           =   7815
   End
   Begin MSComctlLib.ProgressBar ProgressBar1 
      Height          =   375
      Left            =   0
      TabIndex        =   0
      Top             =   7200
      Width           =   9735
      _ExtentX        =   17171
      _ExtentY        =   661
      _Version        =   393216
      Appearance      =   1
   End
   Begin VB.Label labMsg 
      Caption         =   "信息："
      Height          =   255
      Left            =   120
      TabIndex        =   7
      Top             =   1680
      Width           =   4575
   End
   Begin VB.Label Label1 
      Caption         =   "文件"
      Height          =   375
      Left            =   120
      TabIndex        =   1
      Top             =   480
      Width           =   495
   End
End
Attribute VB_Name = "frmImportDlg"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private m_isChoiceSheet As Boolean '是否需要选择Excel页签
Private m_defaultSuffix As String '默认文件后缀
Private m_isRun As Boolean '是否正在运行
Private m_importCls As Object '执行导入类

Public Sub setImportCls(importCls As Object)
    Set m_importCls = importCls
End Sub

Public Sub showForm(ByVal isChoiceSheet As Boolean, ByVal defaultSuffix As String)
    m_isChoiceSheet = isChoiceSheet
    m_defaultSuffix = defaultSuffix
    Me.Show vbModal
End Sub

Private Sub btnBrowse_Click()
    Dim fileName As String
    fileName = Dir(txtFileName.Text)
    If (fileName <> "") Then
        frmChoiceFile.setDefualtFile (txtFileName.Text)
    End If
    frmChoiceFile.showForm m_isChoiceSheet, m_defaultSuffix
End Sub

Private Sub btnCheck_Click()
    runCheck
End Sub

Public Function runCheck()
    m_importCls.runCheck
End Function

Public Function runImport()
    m_importCls.runImport
End Function

Private Sub btnExit_Click()
     Unload Me
End Sub

Private Sub btnImport_Click()
    runImport
End Sub


Private Sub Form_Unload(Cancel As Integer)
    If m_isRun Then
        MsgBoxEx.showInfo "正在运行中，不允许退出"
        Cancel = 1
    End If
End Sub



