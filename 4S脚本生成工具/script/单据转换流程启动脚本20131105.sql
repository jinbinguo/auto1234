begin try
begin tran
--���ҵǼ�ת����Ӧ����
update ICClassLink set FIsUsed=2 where FSourClassTypeID =200000048 and FDestClassTypeID=1000022;

--���յǼǵ�ת����Ӧ����
update ICClassLink set FIsUsed=2 where FSourClassTypeID =200000047 and FDestClassTypeID=1000022;

--�������ת���ҵǼ�
update ICClassLink set FIsUsed=2 where FSourClassTypeID =200000045 and FDestClassTypeID=200000048;

--�������ת���յǼǵ�
update ICClassLink set FIsUsed=2 where FSourClassTypeID =200000045 and FDestClassTypeID=200000047;

--�������ת����Ӧ�յ�
update ICClassLink set FIsUsed=2 where FSourClassTypeID =200000045 and FDestClassTypeID=1000021;

--�������ת���ƵǼ�
update ICClassLink set FIsUsed=2 where FSourClassTypeID =200000045 and FDestClassTypeID=200000046;

--��Ʒ��װ��ת�������ñ��
update ICClassLink set FIsUsed=2 where FSourClassTypeID =200000058 and FDestClassTypeID=200000062;

--��Ʒ������۶���ת��Ʒ��װ��
update ICClassLink set FIsUsed=2 where FSourClassTypeID =200000054 and FDestClassTypeID=200000058;

--��Ʒ������۶���ת���۳���
update ICClassLink set FIsUsed=2 where FSourClassTypeID =200000054 and FDestClassTypeID=-21;

--��Ʒ������۶���ת������ֵ˰��Ʊ
update ICClassLink set FIsUsed=2 where FSourClassTypeID =200000054 and FDestClassTypeID=1000002;

--���ƵǼ�ת����Ӧ����
update ICClassLink set FIsUsed=2 where FSourClassTypeID =200000046 and FDestClassTypeID=1000022;

--�����ɹ�����ת�ɹ���ֵ˰��Ʊ
update ICClassLink set FIsUsed=2 where FSourClassTypeID =200000023 and FDestClassTypeID=1000004;

--�����ɹ�����ת������ⵥ
update ICClassLink set FIsUsed=2 where FSourClassTypeID =200000023 and FDestClassTypeID=200000059;

--�����ɹ�����ת�������յ�
update ICClassLink set FIsUsed=2 where FSourClassTypeID =200000023 and FDestClassTypeID=200000038;

--�����ɹ��ƻ���ת�����ɹ�����
update ICClassLink set FIsUsed=2 where FSourClassTypeID =200000066 and FDestClassTypeID=200000023;

--�������ⵥת������ֵ˰��Ʊ
update ICClassLink set FIsUsed=2 where FSourClassTypeID =200000060 and FDestClassTypeID=1000002;

--������ⵥת�ɹ���ֵ˰��Ʊ
update ICClassLink set FIsUsed=2 where FSourClassTypeID =200000059 and FDestClassTypeID=1000004;

--�������۶���ת�������
update ICClassLink set FIsUsed=2 where FSourClassTypeID =200000028 and FDestClassTypeID=200000045;

--�������۶���ת������
update ICClassLink set FIsUsed=2 where FSourClassTypeID =200000028 and FDestClassTypeID=200000029;

--�������۶���ת��Ʒ������۶���
update ICClassLink set FIsUsed=2 where FSourClassTypeID =200000028 and FDestClassTypeID=200000054;

--�������۶���ת�䳵��
update ICClassLink set FIsUsed=2 where FSourClassTypeID =200000028 and FDestClassTypeID=200000036;

--�������۶���ת������ֵ˰��Ʊ
update ICClassLink set FIsUsed=2 where FSourClassTypeID =200000028 and FDestClassTypeID=1000002;

--�������۶���ת�������ⵥ
update ICClassLink set FIsUsed=2 where FSourClassTypeID =200000028 and FDestClassTypeID=200000060;



if @@ERROR = 0 
begin
  commit;
end else
begin
  rollback;
end
end try
begin catch
  declare @errorMsg varchar(4000)
  select @errorMsg=ERROR_MESSAGE();
  raiserror (@errorMsg,16,1)
  rollback;
end catch
