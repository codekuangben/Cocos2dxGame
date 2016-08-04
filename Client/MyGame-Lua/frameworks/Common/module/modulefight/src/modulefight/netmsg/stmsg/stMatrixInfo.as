package modulefight.netmsg.stmsg
{
	import flash.utils.ByteArray;
	import modulecommon.GkContext;
	import ui.player.PlayerResMgr;
	import modulecommon.scene.beings.NpcBattleBaseMgr;
	import modulecommon.scene.prop.table.DataTable;
	import modulecommon.scene.prop.table.TNpcBattleItem;
	import modulecommon.scene.prop.table.TSkillBaseItem;
	import modulecommon.scene.prop.table.TWuPropertyItem;
	import modulecommon.scene.wu.WuHeroProperty;
	import com.util.UtilColor;
	import modulefight.FightEn;
	
	/**
	 * ...
	 * @author
	 */
	public class stMatrixInfo
	{
		//格子上面生物的类型
		public static var BEINGTYPE_Player:int = 0; //玩家
		public static var BEINGTYPE_Wu:int = 1; //玩家的武将
		public static var BEINGTYPE_BOSS:int = 2; //boss
		public static var BEINGTYPE_Jingying:int = 3; //精英怪
		public static var BEINGTYPE_Monster:int = 4; //普通小怪
		
		public var gridNo:uint;
		public var tempid:uint; // 如果这个值是 -1 ，就是主角
		public var initHP:uint;
		public var maxhp:uint;
		public var level:uint;
		public var actnum:uint;
		public var speed:uint; //出手速度
		public var initshiqi:uint;
		public var masterid:uint;
		public var userInfo:stUserInfo;
		public var m_npcBase:TNpcBattleItem;
		protected var m_wuPropertyBase:TWuPropertyItem;
		
		private var m_isComputeActiveTianfuSkillItem:Boolean = false;
		protected var m_activeTianfuSkillItem:TSkillBaseItem; //对于第4个天赋，其实际等级对应的技能表
		public var m_beingType:int; //其取值见BEINGTYPE_Player定义
		public var m_gkContext:GkContext;
		
		public function stMatrixInfo():void
		{
		
		}
		
		public function get isPlayer():Boolean
		{
			return m_beingType == BEINGTYPE_Player;
		}
		
		//判断是否是武将
		public function get isWu():Boolean
		{
			return m_beingType == BEINGTYPE_Wu;
		}
		
		//返回武将加数（鬼，仙，神）
		public function get add():int
		{
			return tempid % 10;
		}
		
		//这个函数只对武将有意义
		public function getWuPropertyBase():TWuPropertyItem
		{
			if (m_wuPropertyBase == null)
			{
				m_wuPropertyBase = m_gkContext.m_dataTable.getItem(DataTable.TABLE_WUPROPERTY, m_npcBase.m_uID * 10 + m_npcBase.m_uColor) as TWuPropertyItem;
			}
			return m_wuPropertyBase;
		}
		
		public function get activeTianfuSkillItem():TSkillBaseItem
		{
			if (m_isComputeActiveTianfuSkillItem == false)
			{
				m_isComputeActiveTianfuSkillItem = true;
				if (isWu)
				{
					var WuPropertyItem:TWuPropertyItem = getWuPropertyBase();
					if (WuPropertyItem.m_tianfu.length == 4)
					{
						var tianfuIDBase:uint = WuPropertyItem.m_tianfu[3];
						if (tianfuIDBase)
						{
							var levelLocal:int;
							levelLocal = add;
							if (actnum == 4)
							{
								levelLocal++;
							}
							if (levelLocal)
							{
								var tianfuID:int = tianfuIDBase + levelLocal - 1;
								m_activeTianfuSkillItem = m_gkContext.m_skillMgr.skillItem(tianfuID);
							}
						}
					}
				}
				
			}
			return m_activeTianfuSkillItem;
		}
		
		public function get job():uint
		{
			if (isPlayer)
			{
				return userInfo.job;
			}
			else
			{
				return m_npcBase.job;
			}
		}
		
		public function get attackType():uint
		{
			if (job == PlayerResMgr.JOB_JUNSHI)
			{
				return FightEn.DAM_Strategy;
			}
			else
			{
				return FightEn.DAM_Physical;
			}
		}
		
		public function get name():String
		{
			var ret:String;
			if (m_beingType == BEINGTYPE_Player)
			{
				ret = userInfo.name;
			}
			else if (m_beingType == BEINGTYPE_Wu)
			{
				ret = WuHeroProperty.s_fullName(tempid % 10, m_npcBase.m_name);
			}
			else
			{
				ret = m_npcBase.m_name;
			}
			return ret;
		}
		
		public function get zhanshuID():uint
		{
			if (isPlayer)
			{
				return userInfo.zhanshuID;
			}
			else
			{
				return this.m_npcBase.m_uZhanshu;
			}
		}
		
		public function get zhanshuName():String
		{
			return m_gkContext.m_skillMgr.getName(zhanshuID);
		}
		
		public function get nameColor():uint
		{
			if (m_beingType == BEINGTYPE_Wu)
			{
				return NpcBattleBaseMgr.colorValue(m_npcBase.m_uColor);
			}
			else
			{
				return UtilColor.WHITE;
			}
		}
		
		public function deserialize(byte:ByteArray):void
		{
			gridNo = byte.readUnsignedByte();
			tempid = byte.readUnsignedInt();
			initHP = byte.readUnsignedInt();
			maxhp = byte.readUnsignedInt();
			speed = byte.readUnsignedInt();
			initshiqi = byte.readUnsignedInt();
			masterid = byte.readUnsignedInt();
			level = byte.readUnsignedByte();
			actnum = byte.readUnsignedByte();
		}
	}
}

/*struct stMatrixInfo
   {
   BYTE gridno;	//格子编号
   DWORD tempid;	//（玩家：charid)，（武将或战斗Npc: npcid）
   DWORD inithp;	//初始血量
   DWORD maxhp;	//最大血量
   DWORD  speed;	//速度
   DWORD initshiqi;	//初始士气、
   DWORD masterid;		//所属主人id；如果是战斗npc，该字段是0
   BYTE level;
   BYTE actnum;	//激活武将数量
 };*/