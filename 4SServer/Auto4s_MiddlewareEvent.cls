VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "Base_MiddlewareEvent"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Attribute VB_Description = "This is MiddleWareEvents Interface Class [ BeforeMultiCheck ], made by K3BOSPLUGINSWIZAED"
Public Function BeforeMultiCheck(ByVal sDsn As String, _
                                 ByVal nClassID As Long, _
                                 ByVal nFBillID As Long, _
                                 Optional ByVal nFPage As Long = 1, _
                                 Optional ByVal nFBillEntryID As Long = 0, _
                                 Optional ByVal dctBillCheckRecord As KFO.Dictionary) As Boolean


'/********************************************************************/
'/*描述:多级审核前扩展处理方法
'/*参数:
'/*@ nClassID           Long            业务对象事务类型
'/*@ nFBillID           Long            业务单据内码
'/*@ nFPage             Long            业务单据页码
'/*@ nFBillEntryID      Long            业务单据分录内码
'/*@ dctBillCheckRecord KFO.Dictionary  审核路线数据包
'/*@ sDsn               String          K/3标准数据库连接串
'/*返回值:
'/*返回True时表示扩展处理方法成功执行，返回False则表示扩展处理方法未成功执行
'/********************************************************************/
        BeforeMultiCheck = True
        'TODO: 请在此处添加代码响应事件 BeforeMultiCheck

End Function
 
 
 
Public Function AfterMultiCheck(ByVal sDsn As String, _
                                 ByVal nClassID As Long, _
                                 ByVal nFBillID As Long, _
                                 Optional ByVal nFPage As Long = 1, _
                                 Optional ByVal nFBillEntryID As Long = 0, _
                                 Optional ByVal dctBillCheckRecord As KFO.Dictionary) As Boolean

'/********************************************************************/
'/*描述:多级审核后扩展处理方法
'/*参数:
'/*@ nClassID           Long            业务对象事务类型
'/*@ nFBillID           Long            业务单据内码
'/*@ nFPage             Long            业务单据页码
'/*@ nFBillEntryID      Long            业务单据分录内码
'/*@ dctBillCheckRecord KFO.Dictionary  审核路线数据包
'/*@ sDsn               String          K/3标准数据库连接串
'/*返回值:
'/*返回True时表示扩展处理方法成功执行，返回False则表示扩展处理方法未成功执行
'/********************************************************************/
                            
        'TODO: 请在此处添加代码响应事件 AfterMultiCheck
        AfterMultiCheck = True

End Function
 
 
 
Public Function AfterSave(ByVal sDsn As String, _
                          ByVal dctClassType As KFO.Dictionary, _
                          ByVal vctClassTypeEntry As KFO.Vector, _
                          ByVal dctTableInfo As KFO.Dictionary, _
                          ByVal dctData As KFO.Dictionary, _
                          ByVal dctLink As KFO.Dictionary)

'/********************************************************************/
'/*描述:单据保存后扩展处理方法
'/*参数:
'/*@ dctClassType       KFO.Dictionary  单据整体信息模板
'/*@ dctData            KFO.Dictionary  单据数据包 dctData("FID")为保存后的单据内码
'/*@ dctLink            KFO.Dictionary  选单关系模板，无选单为Nothing
'/*@ dctTableInfo       KFO.Dictionary  单据字段模板信息
'/*@ vctClassTypeEntry  KFO.Vector      单据体模板信息
'/*@ sDsn               String          K/3标准数据库连接串
'/*备注:可以将该单据触发器处理的过程在此函数中处理
'/********************************************************************/
                        
        'TODO: 请在此处添加代码响应事件 AfterSave

End Function
 
 
 
Public Function AfterDel(ByVal sDsn As String, _
                            ByVal nClassID As Long, _
                            ByVal dctClassType As KFO.Dictionary, _
                            ByVal nInterID As Long)

'/********************************************************************/
'/*描述:单据删除后扩展处理方法
'/*参数:
'/*@ dctClassType       KFO.Dictionary  单据整体信息模板
'/*@ nClassID           Long            对应的单据模板的分录主键值
'/*@ nInterID           Long            具体单据分录的ID键值
'/*@ sDsn               String          K/3标准数据库连接串
'/********************************************************************/
                            
        'TODO: 请在此处添加代码响应事件 AfterDel

End Function
 
 
 
Public Function BeforeSave(ByVal sDsn As String, _
                           ByVal dctClassType As KFO.Dictionary, _
                           ByVal vctClassTypeEntry As KFO.Vector, _
                           ByVal dctTableInfo As KFO.Dictionary, _
                           ByVal dctData As KFO.Dictionary, _
                           ByVal dctLink As KFO.Dictionary)

'/********************************************************************/
'/*描述:单据保存前扩展处理方法
'/*参数:
'/*@ dctClassType       KFO.Dictionary  单据整体信息模板
'/*@ dctData            KFO.Dictionary  单据数据包 dctData("FID"). 为保存后的单据内码
'/*@ dctLink            KFO.Dictionary  选单关系模板，无选单为Nothing
'/*@ dctTableInfo       KFO.Dictionary  单据字段模板信息
'/*@ vctClassTypeEntry  KFO.Vector      单据体模板信息
'/*@ sDsn               String          K/3标准数据库连接串
'/*备注:可以将该单据触发器处理的过程在此函数中处理
'/********************************************************************/
                           
        'TODO: 请在此处添加代码响应事件 BeforeSave
    
    RegUtils.validateLicenseServer sDsn
    
    
    
End Function
 
 
 
Public Function BeforeDel(ByVal sDsn As String, _
                            ByVal nClassID As Long, _
                            ByVal dctClassType As KFO.Dictionary, _
                            ByVal nInterID As Long)

'/********************************************************************/
'/*描述:单据删除前扩展处理方法
'/*参数:
'/*@ dctClassType       KFO.Dictionary  单据整体信息模板
'/*@ nClassID           Long            对应的单据模板的分录主键值
'/*@ nInterID           Long            具体单据分录的ID键值
'/*@ sDsn               String          K/3标准数据库连接串
'/********************************************************************/
    
        'TODO: 请在此处添加代码响应事件 BeforeDel
    
End Function
 
 
 

