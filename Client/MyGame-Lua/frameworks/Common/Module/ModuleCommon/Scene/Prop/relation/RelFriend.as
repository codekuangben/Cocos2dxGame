package modulecommon.scene.prop.relation
{
	import com.util.UtilCommon;
	/**
	 * @brief 好友数据
	 */
	public class RelFriend
	{
		public static const eFndLst:uint = 0;			// 好友列表
		//public static const eSlaveLst:uint = 1;		// 奴隶列表
		public static const eRecentLst:uint = 1;		// 最近列表
		public static const eBlackLst:uint = 2;		// 黑名单列表
		
		public static const eFTSingle:uint = 0;		// 单向好友关系
		public static const eFTDouble:uint = 1;		// 双向好友关系
		
		//stUBaseInfo::extra附加信息值byte位
		public static const ExtraHelp:uint = 0;		//好友帮助参与“井”战斗
		
		public var m_fndLst:Vector.<Array>;			// 四个列表, 好友 奴隶 最近 黑名单
		public var m_fndReqLst:Array;					// 好友请求列表
		//public var m_fndAddData:Array;					// 好友请求加入的数据
		//public var m_clkedFnd:stUBaseInfo;				// 好友列表中点击的好友，出现菜单
		
		private var m_timeHelpByFrendsForBaowu:int;	//当天，玩家帮助自己抢夺宝物的次数
		
		public function RelFriend()
		{
			m_fndLst = new Vector.<Array>(3, true);
			var idx:uint = 0;
			while(idx < 3)
			{
				m_fndLst[idx] = [];
				++idx;
			} 
			//m_fndAddData = [];
			m_fndReqLst = [];
		}
		
		public function dispose():void
		{
			
		}
		
		// 判断是否在自己的的关系列表中
		public function isInRelLstByN(type:uint, name:String):Boolean
		{
			var item:stUBaseInfo;
			var list:Array = m_fndLst[type];
			for each(item in list)
			{
				if(item.name == name)
				{
					return true;
				}
			}
			
			return false;
		}
		
		public function isFriend(name:String):Boolean
		{
			return isInRelLstByN(eFndLst, name);
		}
		public function getFriendList():Array
		{
			return m_fndLst[eFndLst];
		}
		
		public function isInRelLstByCharId(type:uint, charid:uint):Boolean
		{
			var item:stUBaseInfo;
			for each(item in m_fndLst[type])
			{
				if(item.charid == charid)
				{
					return true;
				}
			}
			
			return false;
		}
		
		public function getItemFromLst(type:uint, charid:uint):stUBaseInfo
		{
			var item:stUBaseInfo;
			for each(item in m_fndLst[type])
			{
				if(item.charid == charid)
				{
					return item;
				}
			}
			
			return null;
		}
		
		public function getFriendByCharID(id:uint):stUBaseInfo
		{
			var list:Array = m_fndLst[eFndLst];
			var ub:stUBaseInfo;
			for each(ub in list)
			{
				if (ub.charid == id)
				{
					return ub;
				}
			}
			return null;
		}
		public function getFriendNameByCharID(id:uint):String
		{
			var ub:stUBaseInfo = getFriendByCharID(id);
			if (ub)
			{
				return ub.name;
			}
			return "";
		}
		
		//根据好友附加信息获得好友列表  idx 表示stUBaseInfo::extra字段的byte位置
		public function getFriendListByExtra(idx:uint):Array
		{
			var ret:Array = new Array();
			var item:stUBaseInfo;
			
			for each(item in m_fndLst[eFndLst])
			{
				if (!UtilCommon.isSetUint(item.extra, idx))
				{
					ret.push(item);
				}
			}
			
			return ret;
		}
		
		//设置stUBaseInfo::extra相应值
		public function setExtraDataOfFriend(charid:uint, idx:uint, type:uint = eFndLst):void
		{
			var item:stUBaseInfo = getItemFromLst(type, charid);
			if (item && !UtilCommon.isSetUint(item.extra, idx))
			{
				item.extra = UtilCommon.setStateUint(item.extra, idx);
			}
		}
		
		//清除stUBaseInfo::extra相应值
		public function clearExtraDataOfFriend(charid:uint, idx:uint, type:uint = eFndLst):void
		{
			var item:stUBaseInfo = getItemFromLst(type, charid);
			if (item && UtilCommon.isSetUint(item.extra, idx))
			{
				item.extra = UtilCommon.clearStateUint(item.extra, idx);
			}
		}
		
		// 获取在线好友列表
		public function getOnlineFnd():Array
		{
			var onlineArr:Array = [];
			for each(var item:stUBaseInfo in m_fndLst[eFndLst])
			{
				if(item.online)
				{
					onlineArr[onlineArr.length] = item;
				}
			}
			
			return onlineArr;
		}
		public function setTimeHelpByFrendsForBaowu(t:int):void
		{
			m_timeHelpByFrendsForBaowu = t;
		}
		
		public function get timeHelpByFrendsForBaowu():int
		{
			return m_timeHelpByFrendsForBaowu;
		}		
		
		public function process7ClockUserCmd():void
		{
			m_timeHelpByFrendsForBaowu = 0;
			
			//好友列表stUBaseInfo中附加信息字段数据更新
			var list:Array = getFriendList();
			for each(var item:stUBaseInfo in list)
			{
				if (UtilCommon.isSetUint(item.extra, RelFriend.ExtraHelp))
				{
					clearExtraDataOfFriend(item.charid, RelFriend.ExtraHelp);
				}
			}
		}
	}
}