Attribute VB_Name = "ENUtils"
Option Explicit
Private Declare Function GetVolumeInformation& Lib "kernel32" Alias "GetVolumeInformationA" (ByVal lpRootPathName As String, ByVal pVolumeNameBuffer As String, ByVal nVolumeNameSize As Long, lpVolumeSerialNumber As Long, lpMaximumComponentLength As Long, lpFileSystemFlags As Long, ByVal lpFileSystemNameBuffer As String, ByVal nFileSystemNameSize As Long)
Private Const MAX_FILENAME_LEN = 256
Dim Key() As Byte

Private Sub initKey(ByVal s As String)
    Key() = StrConv(s, vbUnicode)
End Sub
    

' lockedKey ==> 密匙
' plainCode ==> 明文
Public Function encode(ByVal lockedKey As String, ByVal plainCode As String) As String  '加密
    On Error GoTo myerr
    initKey lockedKey
    Dim buff() As Byte
    Dim s As String
    s = encrypt(plainCode, Len(lockedKey))
    buff = StrConv(s, vbFromUnicode)
    Dim i As Long
    Dim j As Long
    Dim k As Long
    k = UBound(Key) + 1
    For i = 0 To UBound(buff)
        j = i Mod k
        buff(i) = buff(i) Xor Key(j)
    Next
    Dim mStr As String
    mStr = "abcdefghijklmnopqrstuvwxyz0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    Dim outstr As String
    Dim temps  As String
    For i = 0 To UBound(buff)
            k = buff(i) \ Len(mStr)
            j = buff(i) Mod Len(mStr)
            temps = Mid(mStr, j + 1, 1) + Mid(mStr, k + 1, 1)
            outstr = outstr + temps
    Next
    encode = outstr
    Exit Function
myerr:
    MsgBox "加密失败"
    encode = ""
End Function
    
' lockedKey ==> 密匙
' plainCode ==> 密文
Public Function decode(ByVal lockedKey As String, ByVal ciphertext As String) As String  '解密
    Dim i     As Long
    Dim j     As Long
    Dim temps     As String
    Dim s     As String
    Dim arr     As Variant
    Dim strSource As String
    strSource = decrypt(lockedKey, ciphertext)
    i = Len(strSource)
    If i Mod 2 = 1 Then
            '待解密的字串不符合要求
            decode = ""
            Exit Function
    End If
    Dim buff()     As Byte
    Dim k     As Long
    k = 0
    For i = 1 To Len(strSource) Step 2
            temps = Mid(strSource, i, 2)
            j = Val("&H" & temps)
            j = j Xor Len(lockedKey)
            ReDim Preserve buff(k)
            buff(k) = j
            k = k + 1
    Next
    decode = StrConv(buff, vbUnicode)
End Function
    
  '加密
Private Function encrypt(ByVal plainCode As String, ByVal Key As Byte) As String
    Dim i As Long
    Dim j As Byte
    Dim temps As String
    Dim s As String
    Dim arr() As Byte
    arr = StrConv(plainCode, vbFromUnicode)
    For i = 0 To UBound(arr)
        j = arr(i) Xor Key
        temps = Right("00" & Hex(j), 2)
        s = s + temps
    Next
    encrypt = s
  End Function
  '解密
Private Function decrypt(ByVal lockedKey As String, ByVal ciphertext As String) As String
    On Error GoTo myerr
    initKey lockedKey
    Dim i     As Long, j       As Long
    Dim k     As Long, n       As Long
    Dim mStr     As String
    mStr = "abcdefghijklmnopqrstuvwxyz0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    Dim s As String
    s = ciphertext
    Dim outstr     As String
    Dim temps     As String
    If Len(s) Mod 2 = 1 Then
            decrypt = ""
            Exit Function
    End If
    Dim t1     As String
    Dim t2     As String
    Dim buff()     As Byte
    Dim m     As Long
    m = 0
    For i = 1 To Len(s) Step 2
        t1 = Mid(s, i, 1)
        t2 = Mid(s, i + 1, 1)
        j = InStr(1, mStr, t1)
        k = InStr(1, mStr, t2)
        n = j - 1 + (k - 1) * Len(mStr)
        ReDim Preserve buff(m)
        buff(m) = n
        m = m + 1
    Next
    k = UBound(Key) + 1
    For i = 0 To UBound(buff)
        j = i Mod k
        buff(i) = buff(i) Xor Key(j)
    Next
    decrypt = StrConv(buff, vbUnicode)
    Exit Function
myerr:
    decrypt = ""
  End Function
  
  Public Function getDiskKey()
    Dim RetVal As Long
    Dim str As String * MAX_FILENAME_LEN
    Dim str2 As String * MAX_FILENAME_LEN
    Dim A As Long
    Dim B As Long
    Call GetVolumeInformation("C:\", str, MAX_FILENAME_LEN, RetVal, A, B, str2, MAX_FILENAME_LEN)
    getDiskKey = RetVal
  End Function
