VERSION 5.00
Begin VB.Form frmChoiceFile 
   BorderStyle     =   3  'Fixed Dialog
   Caption         =   "文件选择"
   ClientHeight    =   4545
   ClientLeft      =   45
   ClientTop       =   375
   ClientWidth     =   8505
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   4545
   ScaleWidth      =   8505
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  '所有者中心
   Begin VB.ComboBox cmbSheetName 
      Height          =   300
      Left            =   2280
      TabIndex        =   5
      Top             =   120
      Width           =   2175
   End
   Begin VB.TextBox txtFileName 
      Height          =   390
      Left            =   0
      Locked          =   -1  'True
      TabIndex        =   4
      Top             =   4080
      Width           =   8415
   End
   Begin VB.CommandButton btnOK 
      Caption         =   "确  定"
      Height          =   375
      Left            =   7200
      TabIndex        =   3
      Top             =   120
      Width           =   1215
   End
   Begin VB.DriveListBox cmbDriver 
      Height          =   300
      Left            =   120
      TabIndex        =   2
      Top             =   120
      Width           =   1935
   End
   Begin VB.FileListBox lstFile 
      Height          =   3150
      Left            =   4440
      TabIndex        =   1
      Top             =   720
      Width           =   3975
   End
   Begin VB.DirListBox lstDir 
      Height          =   3240
      Left            =   0
      TabIndex        =   0
      Top             =   720
      Width           =   4335
   End
End
Attribute VB_Name = "frmChoiceFile"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private m_defaultDriver As String
Private m_defualtDir As String
Private m_defaultFileName As String
Private m_isInitForm As Boolean
Private m_defaultSuffix As String


Public Sub showForm(ByVal isChoiceSheet As Boolean, ByVal defaultSuffix As String)
    m_isInitForm = False
    If isChoiceSheet Then
        cmbSheetName.Visible = True
    Else
        cmbSheetName.Visible = False
    End If
    m_defaultSuffix = defaultSuffix
    lstFile.Pattern = m_defaultSuffix
    Dim i As Long

    If m_defaultDriver <> "" Then
        m_isInitForm = True
        cmbDriver.Drive = m_defaultDriver
        lstDir.Path = m_defualtDir
        lstFile.fileName = m_defaultFileName
        lstFile.Pattern = m_defaultSuffix
        For i = 0 To lstFile.ListCount
            If lstFile.List(i) = m_defaultFileName Then
                lstFile.Selected(i) = True

            End If
        Next i
        lstFile_Click
    End If
    
    Me.Show vbModal
End Sub

Public Sub setDefualtFile(ByVal defaultFile As String)
    m_defaultDriver = Left(defaultFile, 2)
    Dim fileName As String
    m_defualtDir = Left(defaultFile, InStrRev(defaultFile, "\"))
    m_defaultFileName = Right(defaultFile, Len(defaultFile) - Len(m_defualtDir))

End Sub

Private Sub btnOK_Click()
    If m_isInitForm = False Then
        frmImportDlg.txtFileName.Text = txtFileName.Text
        Unload Me
    End If
    If m_isInitForm = True Then
        m_isInitForm = False
    End If
End Sub

Private Sub cmbDriver_Change()
    lstDir.Path = cmbDriver.Drive
    lstFile.Path = lstDir.Path
    lstFile_Click
End Sub

Private Sub lstDir_Change()
    lstFile.Path = lstDir.Path
    lstFile_Click
End Sub

Private Sub lstFile_Click()
    txtFileName.Text = lstDir.Path & "\" & lstFile.fileName
    txtFileName.Text = Replace(txtFileName.Text, "\\", "\")
End Sub

Private Sub lstFile_DblClick()
    btnOK_Click
End Sub
