// ActionScript file
package modulefight.netmsg.stmsg
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import modulecommon.GkContext;
	import org.ffilmation.engine.datatypes.IntPoint;
	public class stRound
	{ 
		public var roundIndex:uint;	//表示当前是第几回合，zero-based
		public var m_jinnangProcess:JinNangProcess;
		public var m_tianfu_roundBegin:TianfuPart;
		public var m_BattleList:Vector.<BattleArray>;	
		public var effList:Vector.<stValueEffect>;
		public var m_tianfu_Eff:TianfuPart;	//这是由effList的执行，可能引发的天赋（比如武将的死亡，引起的天赋）
		public function get numBattle():uint
		{
			return m_BattleList.length;
		}
		public function deserialize(byte:ByteArray, lastArmyIndex:IntPoint):void
		{
			m_tianfu_roundBegin = new TianfuPart();
			m_tianfu_roundBegin.deserialize(byte, stTianFuData);
			
			var size:uint = byte.readUnsignedByte();			
			m_BattleList = new Vector.<BattleArray>(size);
			var bat:BattleArray;
			for(var i:int = 0; i < size; i++)
			{
				bat = new BattleArray();
				bat.deserialize(byte);
				m_BattleList[i] = bat;
				if(bat.aTeamid == 0)
				{
					bat.aIdx = bat.aArmyNo;
				}
				else
				{
					bat.aIdx = bat.bArmyNo;
				}
				
				if (lastArmyIndex.x == bat.aArmyNo)
				{
					bat.aArmyNo = 255;
				}
				else
				{
					lastArmyIndex.x = bat.aArmyNo;
				}
				if (lastArmyIndex.y == bat.bArmyNo)
				{
					bat.bArmyNo = 255;
				}
				else
				{
					lastArmyIndex.y = bat.bArmyNo;
				}
			}
			var effListSize:uint = byte.readUnsignedByte();
			if (effListSize)
			{
				effList = effList = stValueEffect.readList(effListSize,byte);						
			}
			
			m_tianfu_Eff = new TianfuPart();
			m_tianfu_Eff.deserialize(byte, stTianFuData);
		}
		
		public function init(gk:GkContext, dic:Dictionary):void
		{
			var size:int = m_BattleList.length;
			for(var i:int = 0; i < size; i++)
			{
				m_BattleList[i].init(gk, dic);
			}
			
			// 有锦囊的技能初始化
			if(m_jinnangProcess && m_jinnangProcess.m_battleArray && m_jinnangProcess.m_battleArray.skillid)
			{
				m_jinnangProcess.m_battleArray.init(gk, dic);
			}
		}
		
		public function setJinnangProcess(jn:stJNCastInfo):void
		{
			m_jinnangProcess = new JinNangProcess();
			m_jinnangProcess.m_JNCastInfo = jn;
			if (m_BattleList[0].type == 2)
			{
				m_jinnangProcess.m_battleArray = m_BattleList[0];
				m_BattleList.shift();
			}
		}
		
		public function generateLog():String
		{
			var log:String;
			log = "第 " + (roundIndex + 1) + " 回合\n";
			if (m_jinnangProcess)
			{
				log += "锦囊释放：比拼结果 - ";
				if (m_jinnangProcess.m_battleArray)
				{
					log += "有一方胜出\n";
					log += m_jinnangProcess.m_battleArray.generateLog();
				}
				else
				{
					log += "双方都未释放出\n";
				}
			}
			
			var i:int;
			for (i = 0; i < m_BattleList.length; i++)
			{
				log += "第 " + i + " 攻击\n";
				log += m_BattleList[i].generateLog();
			}
			log += "\n";
			return log;
		}
	}
}

/*struct stRound
    {   
        BYTE tfsize1;
        stTianFuData tflist1[0];
        BYTE basize;
        BattleArray result[0];
        BYTE efflistsize;
        stValueEffect effList[0];
        BYTE tfsize2;
        stTianFuData tflist2[0];
    };  */