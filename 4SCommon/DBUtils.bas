Attribute VB_Name = "DBUtils"
Public conn As String

Private connet_num As Integer
Private cnn As ADODB.Connection
Private rs As ADODB.Recordset
Dim i As Long
'连接数据库
Public Sub connect()
On Error GoTo herror
    Set cnn = New ADODB.Connection
     cnn.ConnectionString = conn


   If cnn.State = adStateOpen Then
     Exit Sub
   End If

    cnn.Open
   If cnn.State <> adStateOpen Then
    GoTo herror
   End If

   Exit Sub
herror:
   MsgBox "服务器连接失败，请检查网络连接，" & conn, , "金蝶提示"
   'end
End Sub
Public Sub disconnect()
   If cnn.State = adStateOpen Then
   cnn.Close
   End If
End Sub

'执行SQL语句
Public Sub sqlExt(ByVal tmpsqlstmt As String)
    Dim cmd As New ADODB.Command
    connect
    Set cmd.ActiveConnection = cnn
    cmd.CommandText = tmpsqlstmt
    cmd.CommandTimeout = 180
    cmd.Execute
    Set cmd = Nothing
    cnn.Close
End Sub

'获取记录集
Public Function queryExt(ByVal tmpsqlstmt As String) As ADODB.Recordset
On Error GoTo herror
    Dim rst As New ADODB.Recordset
    connect
    Set rst.ActiveConnection = cnn
    rst.CursorType = adOpenDynamic
    rst.LockType = adLockOptimistic
    rst.CursorLocation = adUseClient
    
    rst.Open tmpsqlstmt
'      rs.Open tmpsqlstmt, cnn, 1, 3, 1
    Set queryExt = rst
Exit Function
herror:
    MsgBox "数据未正确执行,请检查相关表单是否正确安装", , "金蝶提示"
    'End
End Function
'K3数据库连接组件
Public Function DBquery(ByVal sql As String) As ADODB.Recordset
On Error GoTo herror
Dim rs As ADODB.Recordset
Dim OBJ As Object

    Set OBJ = CreateObject("K3Connection.AppConnection")
    Set rs = OBJ.ExecuteRaiseErr(sql)
    Set OBJ = Nothing
    Set DBquery = rs

'返回记录集方式
'Set rs = obj.Execute("select * from t_icitem")

Exit Function
herror:
    MsgBox "数据未正确执行,请检查相关表单是否正确安装", , "金蝶提示DBquery"

End Function

Public Function GetConnectiongString(ByVal conn As String) As String
    On Error Resume Next
    Dim Result() As String '保存连接字符串

    If InStrRev(conn, "{") > 1 Then
      Result = Split(conn, "{")
      Result = Split(Result(1), "}")
      GetConnectiongString = Result(0)
    Else
     GetConnectiongString = conn
    End If

End Function
