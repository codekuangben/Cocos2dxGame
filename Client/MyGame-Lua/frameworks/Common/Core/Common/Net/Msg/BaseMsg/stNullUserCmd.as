package common.net.msg.basemsg
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author ...
	 */
	public class stNullUserCmd extends t_NullCmd
	{
		public static var s_dicMsg:Dictionary = new Dictionary();
		public static const NULL_USERCMD_PARA:uint = 0;
		
		public static const NULL_USERCMD:uint = 0;
		public static const LOGON_USERCMD:uint = 1;
		public static const TIME_USERCMD:uint = 2;
		public static const SCENE_USERCMD:uint = 3;
		public static const SCENEPK_CMD:uint = 4;
		public static const TASK_USERCMD:uint = 5;
		public static const CHAT_USERCMD:uint = 6;
		public static const COPY_USERCMD:uint = 7;
		public static const PROPERTY_USERCMD:uint = 8;
		public static const HERO_USERCMD:uint = 9;
		public static const XINGMAI_USERCMD:uint = 10;
		public static const REMAKEEQUIP_USERCMD:uint = 11;
		public static const ACTIVITY_USERCMD:uint = 12;
		public static const ELITE_BARRIER_CMD:uint = 13;
		public static const MAIL_USERCMD:uint = 14;
		public static const GUANZHI_USERCMD:uint = 15;
		public static const TRIALTOWER_USERCMD:uint = 16;
		public static const GIFT_USERCMD:uint = 17;
		public static const CORPS_USERCMD:uint = 18;
		public static const FRIEND_USERCMD:uint = 19;
		public static const SHOPPING_USERCMD:uint = 20;
		public static const TEAM_USERCMD:uint = 21;
		public static const RESROB_USERCMD:uint = 23;	//三国战场（资源争夺战）
		public static const ZHANXING_USERCMD:uint = 24;
		public static const WORLDBOSS_USERCMD:uint = 25;//世界boss
		public static const MOUNT_USERCMD:uint = 26;	// 坐骑
		public static const WUNV_USERCMD:uint = 27;	// 舞女
		public static const RANK_USERCMD:uint = 28;	// 排行榜
		public static const SGQUNYINGHUI_USERCMD:uint = 29;	// 跨服功能：三国群英会
		public static const BUSINESS_USERCMD:uint = 30;	// 跑商
		
		public var dwTimestamp:uint;
		
		public function stNullUserCmd() 
		{
			dwTimestamp=0;
		}
		
		override public function serialize(byte:ByteArray):void 
		{
			super.serialize(byte);
			byte.writeUnsignedInt(dwTimestamp);
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			dwTimestamp = byte.readUnsignedInt();
		}
		
		public static function s_toKey(cmd:uint, param:uint):uint
		{
			return (cmd << 16) + param;
		}
		
		public static function getMsgName(cmd:uint, param:uint):String
		{
			var ret:String = s_dicMsg[s_toKey(cmd, param)] as String;
			if (ret == null)
			{
				ret = "";
			}
			return ret;
		}
	}
}



//const BYTE NULL_USERCMD_PARA = 0;
//struct stNullUserCmd : t_NullCmd
//{
	//stNullUserCmd():t_NullCmd()
	//{
		//dwTimestamp=0;
	//}
	//DWORD  dwTimestamp;
//};