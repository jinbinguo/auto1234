Attribute VB_Name = "MsgBoxEx"
Public Sub showInfo(ByVal msg As String)
    MsgBox msg, vbInformation, "金蝶提示"
End Sub


Public Function confirm(ByVal msg As String) As Integer
   confirm = MsgBox(msg, vbExclamation + vbYesNo, "金蝶提示")
End Function
