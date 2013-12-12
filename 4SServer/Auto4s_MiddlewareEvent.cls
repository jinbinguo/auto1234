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
'/*����:�༶���ǰ��չ��������
'/*����:
'/*@ nClassID           Long            ҵ�������������
'/*@ nFBillID           Long            ҵ�񵥾�����
'/*@ nFPage             Long            ҵ�񵥾�ҳ��
'/*@ nFBillEntryID      Long            ҵ�񵥾ݷ�¼����
'/*@ dctBillCheckRecord KFO.Dictionary  ���·�����ݰ�
'/*@ sDsn               String          K/3��׼���ݿ����Ӵ�
'/*����ֵ:
'/*����Trueʱ��ʾ��չ���������ɹ�ִ�У�����False���ʾ��չ��������δ�ɹ�ִ��
'/********************************************************************/
        BeforeMultiCheck = True
        'TODO: ���ڴ˴����Ӵ�����Ӧ�¼� BeforeMultiCheck

End Function
 
 
 
Public Function AfterMultiCheck(ByVal sDsn As String, _
                                 ByVal nClassID As Long, _
                                 ByVal nFBillID As Long, _
                                 Optional ByVal nFPage As Long = 1, _
                                 Optional ByVal nFBillEntryID As Long = 0, _
                                 Optional ByVal dctBillCheckRecord As KFO.Dictionary) As Boolean

'/********************************************************************/
'/*����:�༶��˺���չ��������
'/*����:
'/*@ nClassID           Long            ҵ�������������
'/*@ nFBillID           Long            ҵ�񵥾�����
'/*@ nFPage             Long            ҵ�񵥾�ҳ��
'/*@ nFBillEntryID      Long            ҵ�񵥾ݷ�¼����
'/*@ dctBillCheckRecord KFO.Dictionary  ���·�����ݰ�
'/*@ sDsn               String          K/3��׼���ݿ����Ӵ�
'/*����ֵ:
'/*����Trueʱ��ʾ��չ���������ɹ�ִ�У�����False���ʾ��չ��������δ�ɹ�ִ��
'/********************************************************************/
                            
        'TODO: ���ڴ˴����Ӵ�����Ӧ�¼� AfterMultiCheck
        AfterMultiCheck = True

End Function
 
 
 
Public Function AfterSave(ByVal sDsn As String, _
                          ByVal dctClassType As KFO.Dictionary, _
                          ByVal vctClassTypeEntry As KFO.Vector, _
                          ByVal dctTableInfo As KFO.Dictionary, _
                          ByVal dctData As KFO.Dictionary, _
                          ByVal dctLink As KFO.Dictionary)

'/********************************************************************/
'/*����:���ݱ������չ��������
'/*����:
'/*@ dctClassType       KFO.Dictionary  ����������Ϣģ��
'/*@ dctData            KFO.Dictionary  �������ݰ� dctData("FID")Ϊ�����ĵ�������
'/*@ dctLink            KFO.Dictionary  ѡ����ϵģ�壬��ѡ��ΪNothing
'/*@ dctTableInfo       KFO.Dictionary  �����ֶ�ģ����Ϣ
'/*@ vctClassTypeEntry  KFO.Vector      ������ģ����Ϣ
'/*@ sDsn               String          K/3��׼���ݿ����Ӵ�
'/*��ע:���Խ��õ��ݴ����������Ĺ����ڴ˺����д���
'/********************************************************************/
                        
        'TODO: ���ڴ˴����Ӵ�����Ӧ�¼� AfterSave

End Function
 
 
 
Public Function AfterDel(ByVal sDsn As String, _
                            ByVal nClassID As Long, _
                            ByVal dctClassType As KFO.Dictionary, _
                            ByVal nInterID As Long)

'/********************************************************************/
'/*����:����ɾ������չ��������
'/*����:
'/*@ dctClassType       KFO.Dictionary  ����������Ϣģ��
'/*@ nClassID           Long            ��Ӧ�ĵ���ģ��ķ�¼����ֵ
'/*@ nInterID           Long            ���嵥�ݷ�¼��ID��ֵ
'/*@ sDsn               String          K/3��׼���ݿ����Ӵ�
'/********************************************************************/
                            
        'TODO: ���ڴ˴����Ӵ�����Ӧ�¼� AfterDel

End Function
 
 
 
Public Function BeforeSave(ByVal sDsn As String, _
                           ByVal dctClassType As KFO.Dictionary, _
                           ByVal vctClassTypeEntry As KFO.Vector, _
                           ByVal dctTableInfo As KFO.Dictionary, _
                           ByVal dctData As KFO.Dictionary, _
                           ByVal dctLink As KFO.Dictionary)

'/********************************************************************/
'/*����:���ݱ���ǰ��չ��������
'/*����:
'/*@ dctClassType       KFO.Dictionary  ����������Ϣģ��
'/*@ dctData            KFO.Dictionary  �������ݰ� dctData("FID"). Ϊ�����ĵ�������
'/*@ dctLink            KFO.Dictionary  ѡ����ϵģ�壬��ѡ��ΪNothing
'/*@ dctTableInfo       KFO.Dictionary  �����ֶ�ģ����Ϣ
'/*@ vctClassTypeEntry  KFO.Vector      ������ģ����Ϣ
'/*@ sDsn               String          K/3��׼���ݿ����Ӵ�
'/*��ע:���Խ��õ��ݴ����������Ĺ����ڴ˺����д���
'/********************************************************************/
                           
        'TODO: ���ڴ˴����Ӵ�����Ӧ�¼� BeforeSave
    
    RegUtils.validateLicenseServer sDsn
    
    
    
End Function
 
 
 
Public Function BeforeDel(ByVal sDsn As String, _
                            ByVal nClassID As Long, _
                            ByVal dctClassType As KFO.Dictionary, _
                            ByVal nInterID As Long)

'/********************************************************************/
'/*����:����ɾ��ǰ��չ��������
'/*����:
'/*@ dctClassType       KFO.Dictionary  ����������Ϣģ��
'/*@ nClassID           Long            ��Ӧ�ĵ���ģ��ķ�¼����ֵ
'/*@ nInterID           Long            ���嵥�ݷ�¼��ID��ֵ
'/*@ sDsn               String          K/3��׼���ݿ����Ӵ�
'/********************************************************************/
    
        'TODO: ���ڴ˴����Ӵ�����Ӧ�¼� BeforeDel
    
End Function
 
 
 
