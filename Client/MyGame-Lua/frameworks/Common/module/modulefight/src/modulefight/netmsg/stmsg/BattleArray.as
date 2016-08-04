package modulefight.netmsg.stmsg
{
	//import adobe.utils.CustomActions;
	//import com.gskinner.motion.easing.Back;
	//import adobe.utils.CustomActions;
	import com.pblabs.engine.debug.Logger;
	import com.pblabs.engine.entity.EntityCValue;
	import datast.ListPart;
	//import com.util.DebugBox;
	
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import modulecommon.GkContext;
	//import modulecommon.scene.prop.table.TNpcBattleItem;
	import modulecommon.scene.prop.table.TSkillBaseItem;
	
	import modulefight.FightEn;
	
	/**
	 * ...
	 * @author
	 */
	public class BattleArray
	{
		public var aArmyNo:int; //aInfo数组的下标，如果为255，则与上一个BattleArray的部队相同
		public var bArmyNo:int; //bInfo数组的下标，如果为255，则与上一个BattleArray的部队相同
		public var aIdx:int; // aTeamid 队伍所对应的兵团索引
		
		private var m_pos:uint;	
		public var aCurHp:uint;
		public var aShiQi:uint;
		
		public var skillid:uint;
		public var skillBaseitem:TSkillBaseItem;
		
		public var type:uint;			
		
		public var attackedList:AttackedInfoList;	
		public var selfList:SelfInfoList;
	
		public var strikeBackList:Vector.<stStrikeBack>;
		public var m_tianfuAfterAttack:TianfuPart;	//(普通，或技能)攻击处理完成后，执行的天赋
		
		public var m_rel2Next:uint = uint.MAX_VALUE; // 和下一个战斗的关系,客户端字段
		public var m_fightIdx:int; // 战斗的次数,判断使用
		
		private var m_attackTargetPos:uint = uint.MAX_VALUE;
		public var m_gkContext:GkContext;
		
		public function deserialize(byte:ByteArray):void
		{
			attackedList = new  AttackedInfoList();
			selfList = new SelfInfoList();			
			
			aArmyNo = byte.readUnsignedByte();
			bArmyNo = byte.readUnsignedByte();			
			m_pos = byte.readUnsignedByte();
			
			aShiQi = byte.readUnsignedByte();
			aCurHp = byte.readUnsignedInt();
			
			skillid = byte.readUnsignedInt();
			type = byte.readUnsignedByte();
			
			var defList:ListPart = new ListPart();
			defList.deserialize(byte, DefList);
			
			var size:int = defList.m_list.length;
			var idx:uint = 0;
			var item:DefList;
			var team:int;
			for (idx = 0; idx < size; idx++)
			{
				item = defList.m_list[idx];
				team = s_team(item.pos);
				if (team == aTeamid)
				{
					selfList.addDef(item);
				}
				else
				{
					attackedList.addDef(item);
					//生成反击列表
					if (item.ref_dam > 0)
					{
						if (strikeBackList == null)
						{
							strikeBackList = new Vector.<stStrikeBack>();
						}
						var strikeBackItem:stStrikeBack = new stStrikeBack();
						strikeBackItem.pos = s_gridNO(item.pos);
						strikeBackItem.dam = item.ref_dam;
						strikeBackList.push(strikeBackItem);
					}
				}
			}		
			
			m_tianfuAfterAttack = new TianfuPart();
			m_tianfuAfterAttack.deserialize(byte, stTianFuData);
		}
	
		// 返回暴击类型
		public function bjType():uint
		{			
			if (attackedList.isBaoji)
			{
				if (aTeamid == EntityCValue.RKLeft)
				{
					return EntityCValue.BJer;
				}
				else
				{
					return EntityCValue.BJee;
				}
			}
			
			return EntityCValue.BJNone;
		}
		
		//判断是否有攻击动作目标
		public function get hasAttackActTarget():Boolean
		{
			return (attackedList.isEmpty==false);
		}
		
		//计算攻击的动作目标的位置
		public function getAttackActTargetPos():uint
		{
			if (m_attackTargetPos != uint.MAX_VALUE)
			{
				return m_attackTargetPos;
			}
			m_attackTargetPos = attackedList.getAttackActTargetPos(aGridNO);			
			return m_attackTargetPos;
		}
		
		
		
		public function init(gk:GkContext, dic:Dictionary):void
		{
			m_gkContext = gk;
			if (skillid != 0)
			{
				skillBaseitem = dic[skillid] as TSkillBaseItem;
				if (skillBaseitem == null)
				{
					skillBaseitem = gk.m_skillMgr.skillItem(skillid);
					dic[skillid] = skillBaseitem;
				}
				
				// 打日志
				if (skillBaseitem == null)
				{
					Logger.info(null, null, "skillid cannot find: " + skillid);
				}
			}
			
			var buffer:stEntryState;
			attackedList.init(gk);
			selfList.init(gk);			
		}
		public function get aTeamid():int
		{
			return s_team(m_pos);
		}
		
		public function get aGridNO():int
		{
			return s_gridNO(m_pos);
		}
		
		//执行本次攻击时，是否需要更换部队
		public function get isArmyReplaced():Boolean
		{
			if (aArmyNo != 255 || bArmyNo != 255)
			{
				return true;
			}
			
			return false;
		}
		
		public static function s_team(pos:int):int
		{
			return Math.floor(pos / 10);
		}
		
		public static function s_gridNO(pos:int):int
		{
			return pos % 10;
		}
		
		public function generateLog():String
		{
			var log:String = "";
			log += "发起攻击者(" + aTeamid + " ," + aGridNO + ")" + "技能ID:" + skillid;
			return log;
		}
	}
}

//发给客户端的战斗序列
/*struct BattleArray
	{		
		BattleArray()
		{
			aarmyNo = barmyNo = 0;
			aShiQi = skillid = 0;
			aPos = aTeamid = type = defsize = statesize = 0;
		}

		BYTE aarmyNo;   //aInfo数组的下标
		BYTE barmyNo;   //bInfo数组的下标

		BYTE aPos;	//攻击者所在格子下标	
		BYTE aShiQi;	//攻击者士气值		
		DWORD aCurHp;
		DWORD skillid;		//使用技能id	
		BYTE type;      //0:普通攻击,1:战术，2:锦囊
		BYTE defsize;
		DefList defList[0];  //被攻击者信息
		BYTE tfsize;
		stTianFuData tflist[0];
	};*/