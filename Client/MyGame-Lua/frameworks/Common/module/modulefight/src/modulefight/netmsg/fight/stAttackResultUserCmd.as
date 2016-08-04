package modulefight.netmsg.fight
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import modulecommon.net.msg.fight.stAttackVictoryInfoUserCmd;
	import modulefight.netmsg.stmsg.stJNCastInfo;
	
	import modulecommon.GkContext;
	import modulecommon.net.msg.fight.stScenePkCmd;
	
	//import modulefight.FightEn;
	import modulefight.netmsg.stmsg.BattleArray;
	import modulefight.netmsg.stmsg.stArmy;
	import modulefight.netmsg.stmsg.stMatrixInfo;
	import modulefight.netmsg.stmsg.stRound;
	//import modulefight.netmsg.stmsg.stUserInfo;
	
	import org.ffilmation.engine.datatypes.IntPoint;
	
	/**
	 * ...
	 * @author
	 */
	public class stAttackResultUserCmd extends stScenePkCmd
	{
		public static const VERSION:int = 2;	//消息的版本号
		public var m_gkContext:GkContext;
		public var m_version:int;
		public var roundlist:Vector.<stRound>;
		public var aArmylist:Vector.<stArmy>;
		public var bArmylist:Vector.<stArmy>;
		public var m_stAttackVictoryInfoUserCmd:stAttackVictoryInfoUserCmd;
		public function stAttackResultUserCmd()
		{
			super();
			byParam = PARA_ATTACK_RESULT_USERCMD;
		}
		
		override public function deserialize(byte:ByteArray):void
		{
			super.deserialize(byte);
			var idx:int = 0;
			roundlist = new Vector.<stRound>(roundSize);
			aArmylist = new Vector.<stArmy>(aArmySize);
			bArmylist = new Vector.<stArmy>(bArmySize);
			
			m_version = byte.readUnsignedByte();
			var roundSize:int = byte.readUnsignedShort();
			
			idx = 0;
			var armyIndex:IntPoint = new IntPoint(0, 0);
			var roundItem:stRound;
			while (idx < roundSize)
			{
				roundItem = new stRound();
				roundlist[idx] = roundItem;
				roundItem.deserialize(byte, armyIndex);
				roundItem.roundIndex = idx;				
				++idx;
			}	
			//----------
			var aArmySize:int = byte.readUnsignedByte();			
			var army:stArmy;
			for (idx = 0; idx < aArmySize; idx++)
			{
				army = new stArmy(0);
				army.deserialize(byte);
				aArmylist[idx] = army;
			}
			//------------
			var bArmySize:int = byte.readUnsignedByte();
			for (idx = 0; idx < bArmySize; idx++)
			{
				army = new stArmy(1);
				army.deserialize(byte);
				bArmylist[idx] = army;
			}
			//----------
			var jNCastSize:int = byte.readUnsignedByte();			
			if (jNCastSize > 0)
			{
				var jNCastInfo:stJNCastInfo;				
				for (idx = 0; idx < jNCastSize; idx++)
				{
					jNCastInfo = new stJNCastInfo();
					jNCastInfo.deserialize(byte);					
					roundlist[jNCastInfo.round].setJinnangProcess(jNCastInfo);
				}				
			}
		}
		
		public function getNextBattleMark(mark:IntPoint):IntPoint
		{
			var ret:IntPoint = new IntPoint();
			if (mark.x >= roundlist.length)
			{
				return null;
			}
			if (mark.y + 1 >= roundlist[mark.x].numBattle)
			{
				ret.x = mark.x + 1;
				ret.y = 0;
				if (ret.x >= roundlist.length || ret.y >= roundlist[ret.x].numBattle)
				{
					return null;
				}
				return ret;
			}
			else
			{
				ret.x = mark.x;
				ret.y = mark.y + 1;
				return ret;
			}
		}
		
		public function getBattleArray(mark:IntPoint):BattleArray
		{
			return roundlist[mark.x].m_BattleList[mark.y];
		}
		
		public function init(gk:GkContext):void
		{
			m_gkContext = gk;
			var i:int;
			var count:int = aArmylist.length;
			for (i = 0; i < count; i++)
			{
				aArmylist[i].init(gk);
			}
			count = bArmylist.length;
			for (i = 0; i < count; i++)
			{
				bArmylist[i].init(gk);
			}
			
			var dic:Dictionary = new Dictionary();
			count = roundlist.length;
			for (i = 0; i < count; i++)
			{
				roundlist[i].init(gk, dic);
			}
		}
		
		public function getMaxtrixList():Vector.<stMatrixInfo>
		{
			var ret:Vector.<stMatrixInfo> = new Vector.<stMatrixInfo>();
			var i:int;
			var count:int = aArmylist.length;
			for (i = 0; i < count; i++)
			{
				ret = ret.concat(aArmylist[i].matrixList);
			}
			count = bArmylist.length;
			for (i = 0; i < count; i++)
			{
				ret = ret.concat(bArmylist[i].matrixList);
			}
			return ret;
		}
		
		public function getAllBattleArray():Vector.<BattleArray>
		{
			var ret:Vector.<BattleArray> = new Vector.<BattleArray>;
			for (var i:uint = 0; i < roundlist.length; i++)
			{
				ret = ret.concat(roundlist[i].m_BattleList);
			}
			return ret;
		}
		
		// 获取某一个格子索引	noarmy:兵团号, lorR:左边还是右边队伍, noIdx:队伍索引
		public function getOneMatrix(noarmy:uint, lorR:uint, noIdx:uint):stMatrixInfo
		{
			if (0 == lorR)
			{
				return aArmylist[noarmy].getMatrix(noIdx);
			}
			else
			{
				return bArmylist[noarmy].getMatrix(noIdx);
			}
		}
		
		/*
		 * 计算玩家属于哪个队
		 * return 0 - 左边队伍
		 * return 1 - 右边队伍
		 * return -1 - 不属于任何队伍
		 */ 
		public function teamOfPlayer(charid:uint):int
		{
			var army:stArmy;
			for each(army in aArmylist)
			{
				if (army.isPlayerInThisArmy(charid))
				{
					return 0;
				}
			}
			
			for each(army in bArmylist)
			{
				if (army.isPlayerInThisArmy(charid))
				{
					return 1;
				}
			}
			return -1;
		}
		
		/*
		 * 计算玩家是否赢了
		 * return 0 - 赢了
		 * return 1 - 输了
		 * return -1 - 不知输赢
		 */
		public function isSelfVictory():int
		{
			if (m_stAttackVictoryInfoUserCmd)
			{
				if (m_stAttackVictoryInfoUserCmd.pkType == stAttackVictoryInfoUserCmd.PKTYPE_MainPlayerOnLeft)
				{					
					return m_stAttackVictoryInfoUserCmd.victoryTeam;
				}
				var charid:uint = m_gkContext.playerMain.charID;
				var team:int = teamOfPlayer(charid);
				if (m_stAttackVictoryInfoUserCmd.victoryTeam == team)
				{
					return 0;
				}
				else
				{
					return 1;
				}
				
			}
			else
			{
				return -1;
			}
		}
		public function generateLog():String
		{
			var log:String = "战斗日志\n";
			log += "左边兵团列表("+aArmylist.length+"):\n";
			var i:int;
			for (i = 0; i < aArmylist.length; i++)
			{
				log += "第一个兵团:"
				log += aArmylist[i];
			}
			
			log += "右边边兵团列表("+bArmylist.length+"):\n";
			for (i = 0; i < bArmylist.length; i++)
			{
				log += "第一个兵团:"
				log += bArmylist[i];
			}
			return log;
		}
	}
}

//返回攻击序列
/*const BYTE PARA_ATTACK_RESULT_USERCMD = 3;
   struct stAttackResultUserCmd : public stScenePkCmd
   {
   BYTE version;
  WORD roundsize;
		stRound round[0];
		BYTE aNum;
		stArmy aInfo[0];
		BYTE bNum;
		stArmy bInfo[0];
		BYTE castnum;
		stJNCastInfo jncastinfo[0];
 };*/