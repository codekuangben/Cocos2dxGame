package modulecommon.net.msg.propertyUserCmd 
{
	import common.net.msg.basemsg.stNullUserCmd;
	
	import common.net.endata.EnNet;
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	public class stPropertyUserCmd extends stNullUserCmd 
	{
		public function stPropertyUserCmd() 
		{
			super();
			byCmd = PROPERTY_USERCMD;
		}
		
		public static const ADDUSEROBJ_PROPERTY_USRECMD:uint = 1;		
		public static const REMOVEUSEROBJ_PROPERTY_USRECMD:uint = 2;
		public static const SWAPUSEROBJ_PROPERTY_USRECMD:uint = 3;
		public static const USEUSEROBJ_PROPERTY_USRECMD:uint = 4;
		public static const PICKUPOBJ_PROPERTY_USRECMD:uint = 5;
		public static const SPLITOBJ_PROPERTY_USRECMD:uint = 6;
		public static const ADDUSEROBJECT_LIST_PROPERTY_USERCMD:uint = 7;
		
		public static const ADD_MAPOBJECT_PROPERTY_USERCMD:uint = 8;
		public static const RM_MAPOBJECT_PROPERTY_USERCMD:uint = 9;
		public static const ADD_LOST_MAPOBJECT_PROPERTY_USERCMD:uint = 10;
		public static const RM_LOST_MAPOBJECT_PROPERTY_USERCMD:uint = 11;
		public static const PICKUPOBJ_TYPE_NUMBER_PROPERTY_USRECMD:uint = 12;
		public static const REFRESH_OBJ_NUM_PROPERTY_USRECMD:uint = 13;
		public static const REFRESH_OPEN_MAINPACK_GEZI_NUM_USERCMD:uint = 14;
		public static const REQ_OPEN_MAINPACK_GEZI_USERCMD:uint = 15;
		public static const VIEWED_USER_EQUIP_LIST_PROPERTY_USERCMD:uint = 16;
		
		public static const PARA_REQ_CAISHEN_ZHAOCAI_PROPERTY_USERCMD:uint = 17;	//财神招财
		public static const PARA_RET_ZHAOCAI_RESULT_PROPERTY_USERCMD:uint = 18;		//财神返回消息
		public static const PARA_CAISHEN_ONLINE_PROPERTY_USERCMD:uint = 19;			//财神上线数据
		
		public static const PARA_DAZUO_ONLINE_PROPERTY_USERCMD:uint = 20;	//打坐上线数据
		public static const PARA_SET_DAZUOSTATE_PROPERTY_USERCMD:uint = 21;		//设置打坐状态
		public static const PARA_RET_DAZUO_DATA_PROPERTY_USERCMD:uint = 22;		//返回请求打坐的数据
		public static const PARA_DZDATA_CHANGE_PROPERTY_USERCMD:uint = 23;	
		public static const PARA_END_DAZUO_PROPERTY_USERCMD:uint = 24;		//结束打坐领取奖励
		public static const PARA_SALEFUYOUEXP_TO_SYS_PROPERTY_USERCMD:uint = 25;	//卖浮游经验给系统
		public static const PARA_FUYOUTIME_CHANGE_PROPERTY_USERCMD:uint = 26;	//浮游时间变化
		public static const PARA_BUY_FUYOUEXP_PROPERTY_USERCMD:uint = 27;		//购买浮游时间
		public static const PARA_INCOME_CHANGE_PROPERTY_USERCMD:uint = 28;		//收益变化
		public static const PARA_BUYTIMES_CHANGE_PROPERTY_USERCMD:uint = 29;	//购买浮游时间次数变化
		public static const PARA_BUY_GAMETOKEN_PROPERTY_USERCMD:uint = 30;
		public static const PARA_REQ_OTHER_FUYOUTIME_PROPERTY_USERCMD:uint = 31;
		public static const PARA_RET_OTHER_FUYOUTIME_PROPERTY_USERCMD:uint = 32;
		
		public static const PARA_REQ_BATCH_MOVE_OBJ_PROPERTY_USERCMD:uint = 33;
		public static const PARA_SALE_OBJ_PROPERTY_USERCMD:uint = 34;	//售出道具
		public static const PARA_AUTO_OPEN_MPGZ_LEFTTIME_PROPERTY_USERCMD:uint = 35;
		public static const RET_PICKUPOBJ_PROPERTY_USRECMD:uint = 36;
		public static const REQ_SORT_MAIN_PACKAGE_USERCMD:uint = 37;
		public static const RET_SORT_MAIN_PACKAGE_USERCMD:uint = 38;
		public static const PARA_REQ_FREE_LINGPAI_INFO_USERCMD:uint = 39;	//请求令牌信息
		public static const PARA_RET_FREE_LINGPAI_INFO_USERCMD:uint = 40;
		public static const PARA_REQ_GET_FREE_LINGPAI_USERCMD:uint = 41;	//请求领取免费令牌
		public static const PARA_BUY_EQUIP_TO_HERO_USERCMD:uint = 42;
		public static const PARA_BATCH_MOVE_OBJ_ACTION_USERCMD:uint = 43;
		public static const PARA_PLAY_GAIN_OBJ_ANI_USERCMD:uint = 44;
		public static const GM_ADDUSEROBJECT_LIST_PROPERTY_USERCMD :uint = 45;
		public static function initMsg():void
		{
			pushDic(PARA_REQ_BATCH_MOVE_OBJ_PROPERTY_USERCMD, "stReqBatchMoveObjPropertyUserCmd--stPropertyUserCmd");
		}
		
		public static function pushDic(param:uint, name:String):void
		{
			s_dicMsg[s_toKey(PROPERTY_USERCMD, param)] = name;
		}

		

	}
}