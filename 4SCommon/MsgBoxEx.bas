Attribute VB_Name = "MsgBoxEx"
Public Sub showInfo(ByVal msg As String)
    MsgBox msg, vbInformation, "�����ʾ"
End Sub


Public Function confirm(ByVal msg As String) As Integer
   confirm = MsgBox(msg, vbExclamation + vbYesNo, "�����ʾ")
End Function
