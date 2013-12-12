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
    
'定义 BillEvent 接口. 必须具有的声明, 以此来获得事件
Private WithEvents m_BillInterface  As BillEvent
Attribute m_BillInterface.VB_VarHelpID = -1
 
Public Sub Show(ByVal oBillInterface As Object)
 
    'BillEvent 接口实现
    '注意: 此方法必须存在, 请勿修改
    Set m_BillInterface = oBillInterface
    RegUtils.validateLicenseClient m_BillInterface
End Sub

Private Sub Class_Terminate()
 
    '释放接口对象
    '注意: 此方法必须存在, 请勿修改
    Set m_BillInterface = Nothing

End Sub





Private Sub m_BillInterface_MenuBarClick(ByVal BOSTool As K3ClassEvents.BOSTool, Cancel As Boolean)
    Dim isAssign As Boolean
    isAssign = m_BillInterface.BillEntrys(1).BOSFields("FCheckbox1").Value '是否已配车
    Dim checkStatus As String
    checkStatus = m_BillInterface.BillEntrys(1).BOSFields("FCombobox").Value '是否已结算检查

    If BOSTool.ToolName = "mnuEditAssign" Then '配车
        If (m_BillInterface.GetFieldValue("FMultiCheckStatus") <> 16) Then
            MsgBox "未审核，不能配车", vbInformation, "金蝶提示"
            Cancel = True
            Exit Sub
        End If
        If (isAssign) Then
            If MsgBox("已配车,是否查看配车单", vbQuestion + vbYesNo, "金蝶提示") = vbNo Then
                Cancel = True
                Exit Sub
            End If
        End If
        showAssignBill
        
    End If
    
    If BOSTool.ToolName = "mnuEditSettlementCheck" Then '结算检查
        If (isAssign) Then '已配车
            If (checkStatus <> "1") Then
               If MsgBox("已结算检查通过,是否查看结算检查单", vbQuestion + vbYesNo, "金蝶提示") = vbNo Then
                    Cancel = True
                    Exit Sub
               End If
            End If
            showSettlementCheckBill
            
        Else '未配车
            MsgBox "未配车，不能做结算检查", vbExclamation, "金蝶提示"
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
    checkBillID = Val(m_BillInterface.BillEntrys(1).BOSFields("FInteger1").Value) '结算单ID
    checkStatus = m_BillInterface.BillEntrys(1).BOSFields("FCombobox").Value '结算检查状态
     
    On Error GoTo err_ctr
    Set oDataSrv = m_BillInterface.K3Lib.CreateK3Object("K3ClassTpl.DataSrv")
     
    oDataSrv.ClassTypeID = 200000037
    If checkBillID = 0 Then '未生成结算单
       Dim oTableInfo As Object
       Set oTableInfo = oDataSrv.TableInfo
       Dim oData As Object
       Set oData = oDataSrv.GetEmptyBill
       oData("Page1")(oTableInfo("map")("FBillNo_SRC"))("FFLD") = m_BillInterface.GetFieldValue("FBillNo") '源单据编号
       oData("Page1")(oTableInfo("map")("FEntryID_SRC"))("FFLD") = m_BillInterface.BillEntrys(1).BOSFields("FEntryID2").Value '源单据分录ID
       oData("Page1")(oTableInfo("map")("FInteger"))("FFLD") = m_BillInterface.BillEntrys(1).BOSFields("FIndex2").Value '源单据分录序号
       oData("Page1")(oTableInfo("map")("FID_SRC"))("FFLD") = m_BillInterface.BillEntrys(1).BOSFields("FID2").Value '源单据ID
       oData("Page1")(oTableInfo("map")("FClassID_SRC"))("FFLD") = 200000028 '源单据类型
       oData("Page1")(oTableInfo("map")("FBase"))("FFND") = m_BillInterface.BillEntrys(1).BOSFields("FBase2").Number  '车辆编码
       oData("Page1")(oTableInfo("map")("FBase"))("FFLD") = m_BillInterface.BillEntrys(1).BOSFields("FBase2").Value  '车辆内码
       oData("Page1")(oTableInfo("map")("FBase"))("FDSP") = m_BillInterface.BillEntrys(1).BOSFields("FBase2").Text  '车辆名称
       
      ' oData("Page1")(oTableInfo("map")("FAmount"))("FFLD") = Val(m_BillInterface.BillEntrys(1).BOSFields("FPrice").Value)  '厂家指导价
      ' oData("Page1")(oTableInfo("map")("FAmount1"))("FFLD") = Val(m_BillInterface.BillEntrys(1).BOSFields("FPrice1").Value)  '公司指导价
      ' oData("Page1")(oTableInfo("map")("FAmount2"))("FFLD") = Val(m_BillInterface.BillEntrys(1).BOSFields("FAmount2").Value)  '整车销售价
     '  oData("Page1")(oTableInfo("map")("FAmount3"))("FFLD") = Val(m_BillInterface.BillEntrys(1).BOSFields("FAmount9").Value)  '整车折扣价
     '  oData("Page1")(oTableInfo("map")("FAmount4"))("FFLD") = Val(m_BillInterface.BillEntrys(1).BOSFields("FAmount10").Value)  '整车优惠价
       oData("Page1")(oTableInfo("map")("FAmount5"))("FFLD") = Val(m_BillInterface.BillEntrys(1).BOSFields("FAmount8").Value)  '整车应收金额
      ' oData("Page1")(oTableInfo("map")("FAmount6"))("FFLD") = Val(m_BillInterface.BillEntrys(1).BOSFields("FAmount11").Value)  '选装价
       oData("Page1")(oTableInfo("map")("FAmount7"))("FFLD") = Val(m_BillInterface.BillEntrys(1).BOSFields("FAmount3").Value)  '精品应收金额
       oData("Page1")(oTableInfo("map")("FAmount8"))("FFLD") = Val(m_BillInterface.BillEntrys(1).BOSFields("FAmount7").Value)  '代办应收金额
       oData("Page1")(oTableInfo("map")("FAmount1"))("FFLD") = Val(m_BillInterface.BillEntrys(1).BOSFields("FAmount4").Value)  '总应收金额
     '  oData("Page1")(oTableInfo("map")("FAmount10"))("FFLD") = Val(m_BillInterface.BillEntrys(1).BOSFields("FAmount5").Value)  '总已收金额
       oData("Page1")(oTableInfo("map")("FAmount11"))("FFLD") = Val(m_BillInterface.BillEntrys(1).BOSFields("FAmount6").Value)  '置换二手车收购价
      ' oData("Page1")(oTableInfo("map")("FAmount12"))("FFLD") = Val(m_BillInterface.BillEntrys(1).BOSFields("FAmount4").Value) - Val(m_BillInterface.BillEntrys(1).BOSFields("FAmount5").Value)  '差额
       
    End If
     
    
    Set oBill = m_BillInterface.K3Lib.CreateK3Object("K3SingleClassBill.ClassInfoManager")
    With oBill
      .DataSrv = oDataSrv
      .ISNetControl = True
      .ISCheckRight = True
      If checkStatus <> "1" And checkBillID > 0 Then  '已结算检查
         .Show checkBillID, False, 0
      ElseIf checkStatus = "1" And checkBillID > 0 Then '未检查，但已生成检查单
          .Show checkBillID, False, 2, oData
      Else '新增检查单
          .Show 0, False, 1, oData
      End If
    
      '**********************
      'Show 参数类型
      '第一个参数 Optional ByVal lID As Long = 0 ；描述修改或查看的单据ID
      '第二个参数 Optional ByVal bShowGroup As Boolean = False ；如是基础资料时，是否显示分组
      '第三个参数 Optional ByVal BillStatus As Long = Enu_BillStatus_New ；显示方式 0—查看；1—新增；2—修改
      '第四个参数 Optional ByVal dctData As KFO.Dictionary '单据初始值
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
     assignBillId = Val(m_BillInterface.BillEntrys(1).BOSFields("FInteger").Value) '配车单ID
     isAssign = m_BillInterface.BillEntrys(1).BOSFields("FCheckbox1").Value '是否配车
     
     On Error GoTo err_ctr
     Set oDataSrv = m_BillInterface.K3Lib.CreateK3Object("K3ClassTpl.DataSrv")
     
     oDataSrv.ClassTypeID = 200000036
     If assignBillId = 0 Then '未生成配车单
        Dim oTableInfo As Object
        Set oTableInfo = oDataSrv.TableInfo
        Dim oData As Object
        Set oData = oDataSrv.GetEmptyBill
        oData("Page1")(oTableInfo("map")("FNote"))("FFLD") = m_BillInterface.GetFieldValue("FNote2") '配车备注
        oData("Page1")(oTableInfo("map")("FBillNo_SRC"))("FFLD") = m_BillInterface.GetFieldValue("FBillNo") '源单据编号
        oData("Page1")(oTableInfo("map")("FID_SRC"))("FFLD") = m_BillInterface.BillEntrys(1).BOSFields("FID2").Value '源单据ID
        oData("Page1")(oTableInfo("map")("FEntryID_SRC"))("FFLD") = m_BillInterface.BillEntrys(1).BOSFields("FEntryID2").Value '源单据分录ID
        oData("Page1")(oTableInfo("map")("FClassID_SRC"))("FFLD") = 200000028 '源单据类型
        oData("Page1")(oTableInfo("map")("FInteger"))("FFLD") = m_BillInterface.BillEntrys(1).BOSFields("FIndex2").Value '单据分录序号
        oData("Page1")(oTableInfo("map")("FBase2"))("FFND") = m_BillInterface.BillEntrys(1).BOSFields("FBase3").Number  '车型编码
        oData("Page1")(oTableInfo("map")("FBase2"))("FFLD") = m_BillInterface.BillEntrys(1).BOSFields("FBase3").Value  '车型内码
        oData("Page1")(oTableInfo("map")("FBase2"))("FDSP") = m_BillInterface.BillEntrys(1).BOSFields("FBase3").Text  '车型名称
        
        oData("Page1")(oTableInfo("map")("FBase3"))("FFND") = m_BillInterface.BillEntrys(1).BOSFields("FBase8").Number  '颜色编码
        oData("Page1")(oTableInfo("map")("FBase3"))("FFLD") = m_BillInterface.BillEntrys(1).BOSFields("FBase8").Value  '颜色内码
        oData("Page1")(oTableInfo("map")("FBase3"))("FDSP") = m_BillInterface.BillEntrys(1).BOSFields("FBase8").Text  '颜色名称
        
        oData("Page1")(oTableInfo("map")("FBase4"))("FFND") = m_BillInterface.BillEntrys(1).BOSFields("FBase7").Number  '内饰编码
        oData("Page1")(oTableInfo("map")("FBase4"))("FFLD") = m_BillInterface.BillEntrys(1).BOSFields("FBase7").Value  '内饰内码
        oData("Page1")(oTableInfo("map")("FBase4"))("FDSP") = m_BillInterface.BillEntrys(1).BOSFields("FBase7").Text  '内饰名称
        
        oData("Page1")(oTableInfo("map")("FText"))("FFLD") = m_BillInterface.BillEntrys(1).BOSFields("FText").Text  '选装
        
     End If
     
    
     Set oBill = m_BillInterface.K3Lib.CreateK3Object("K3SingleClassBill.ClassInfoManager")
     With oBill
       .DataSrv = oDataSrv
       .ISNetControl = True
       .ISCheckRight = True
       If isAssign And assignBillId > 0 Then '已配车
          .Show assignBillId, False, 0
       ElseIf Not isAssign And assignBillId > 0 Then '未配车，但已生成配车单
           .Show assignBillId, False, 2
       Else '新增配车单
          .Show 0, False, 1, oData
       End If
    
       '**********************
       'Show 参数类型
       '第一个参数 Optional ByVal lID As Long = 0 ；描述修改或查看的单据ID
       '第二个参数 Optional ByVal bShowGroup As Boolean = False ；如是基础资料时，是否显示分组
       '第三个参数 Optional ByVal BillStatus As Long = Enu_BillStatus_New ；显示方式 0—查看；1—新增；2—修改
       '第四个参数 Optional ByVal dctData As KFO.Dictionary '单据初始值
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


