/**
	解决：安装后，BOS单据关联信息设置被还原为开发环境问题
*/

delete icCLassUnionQuery where exists (select 1 from icCLassUnionQuery_4SBAK where FSourClassTypeID=icCLassUnionQuery.FSourClassTypeID);
insert into icCLassUnionQuery (FSourClassTypeID,FUnionObjectID,FObjectType,FShowIndex,FSelected,FFilter,FIsUserDefine,FUserID)
 select FSourClassTypeID,FUnionObjectID,FObjectType,FShowIndex,FSelected,FFilter,FIsUserDefine,FUserID from icCLassUnionQuery_4SBAK;

delete icCLassUnionQueryEntry where exists (select 1 from icCLassUnionQueryEntry_4SBAK where FSourClassTypeID=icCLassUnionQueryEntry.FSourClassTypeID);
insert into icCLassUnionQueryEntry(FSourClassTypeID,FUnionObjectID,FSourPage,FSourFKey,FDestPage,FDestFKey,FShowIndex,FUserID)
 select FSourClassTypeID,FUnionObjectID,FSourPage,FSourFKey,FDestPage,FDestFKey,FShowIndex,FUserID from icCLassUnionQueryEntry_4SBAK;


