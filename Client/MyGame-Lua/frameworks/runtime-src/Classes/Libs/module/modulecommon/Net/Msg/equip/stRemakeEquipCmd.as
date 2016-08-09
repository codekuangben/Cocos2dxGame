package modulecommon.net.msg.equip
{
	import common.net.endata.EnNet;
	import common.net.msg.basemsg.stNullUserCmd;
	/**
	 * ...
	 * @author 
	 */
	public class stRemakeEquipCmd extends stNullUserCmd
	{
		public static const REQ_EQUIP_ENCHANCE_USERCMD:uint = 1;
		public static const RET_EQUIP_REMAKE_RESULT_USERCMD:uint = 2;
		public static const REQ_EQUIP_GEM_EMBED_USERCMD:uint = 3;
		public static const REQ_TAKEDOWN_GEM_FROM_EQUIP_USERCMD:uint = 4;
		
		public static const REQ_START_XILIAN_USERCMD:uint = 5;
		public static const RET_XILIAN_PROPLIST_USERCMD:uint = 6;
		public static const REQ_USE_XILIAN_PROP_USERCMD:uint = 7;
		public static const REQ_EQUIP_DECOMPOSE_USERCMD:uint = 8;
		public static const REQ_EQUIPCOMPOSE_USERCMD:uint = 9;
		public static const RET_EQUIP_ENCHANCE_COLD_USERCMD:uint = 10;
		public static const REQ_SPEED_ENCHANCE_COLD_USERCMD:uint = 11;
		public static const REQ_OPEN_ENCHANCEUI_INFO_USERCMD:uint = 12;
		public static const PARA_EQUIP_ADVANCE_USERCMD:uint = 13;
		public static const PARA_EQUIP_LEVELUP_USERCMD:uint = 14;
		public static const PARA_UNLOCK_EQUIP_SMALL_ATTR_USERCMD:uint = 15;
		public function stRemakeEquipCmd() 
		{
			super();
			byCmd = REMAKEEQUIP_USERCMD;
		}
	}
}

///装备改造相关指令
//struct stRemakeEquipCmd : public stNullUserCmd
//{
	//stRemakeEquipCmd()
	//{
		//byCmd = REMAKEEQUIP_USERCMD;
	//}
//};