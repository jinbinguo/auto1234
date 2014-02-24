Attribute VB_Name = "PublicUtils"
Function CharacterLen(s_str As String) As Integer
    Dim i_num As Integer
    Dim i_index As Integer
    Dim i_len As Integer
    i_len = Len(s_str)
    For i_index = 1 To i_len
        If Asc(Mid(s_str, i_index, 1)) < 0 Then
            i_num = i_num + 1
        End If
    Next
    CharacterLen = i_len + i_num
End Function
