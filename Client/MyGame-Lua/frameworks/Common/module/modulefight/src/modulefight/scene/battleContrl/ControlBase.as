package modulefight.scene.battleContrl 
{
	/**
	 * ...
	 * @author ...
	 */
	
	//import com.pblabs.engine.entity.EntityCValue;
	import modulefight.scene.fight.FightDB;
	import modulefight.scene.fight.FightGrid;
	import modulefight.scene.fight.FightLogicCB;
	import modulefight.netmsg.stmsg.BattleArray;
	import modulefight.scene.fight.rank.IRankFightAction;
	//import modulefight.scene.fight.rank.RankAttHurtEnd;
	//import modulefight.scene.fight.rank.RankCAttackAction;
	import modulefight.scene.roundcontrol.RoundControl;
	import flash.utils.getQualifiedClassName;
	public class ControlBase 
	{
		protected var m_battleArray:BattleArray;
		protected var m_fightDB:FightDB;
		protected var m_fightLogicCB:FightLogicCB;
		protected var m_roundControl:RoundControl;
		protected var m_actionList:Vector.<IRankFightAction>;
		
		protected var m_attgrid:FightGrid;
		protected var m_funOnEnd:Function;
		protected var m_bEndState:Boolean = false;
		public function ControlBase(fightDB:FightDB, fightLogicCB:FightLogicCB,roundControl:RoundControl, bat:BattleArray) 
		{
			m_fightLogicCB = fightLogicCB;
			m_roundControl = roundControl;
			m_fightDB = fightDB;
			m_battleArray = bat;
			
			m_actionList = new Vector.<IRankFightAction>();
			m_attgrid = m_fightDB.m_fightGrids[m_battleArray.aTeamid][m_battleArray.aGridNO];
		}
		public function set funOnEnd(fun:Function):void
		{
			m_funOnEnd = fun;
		}
		
		public function get battleArray():BattleArray
		{
			return m_battleArray;
		}
		
		public function onTick(deltaTime:Number):void
		{
			if (m_fightDB.m_gkcontext.m_battleMgr.m_stopInfo)
			{
				var str:String = getQualifiedClassName(this) + ":" + "m_actionList长度=" + m_actionList.length;
				m_fightDB.m_gkcontext.addLog(str);
			}
			var act:IRankFightAction;
			var list:Vector.<IRankFightAction> = new Vector.<IRankFightAction>();
			for each (act in m_actionList)
			{
				list.push(act);
			}
			for each (act in list)
			{
				if (m_fightDB.m_gkcontext.m_battleMgr.m_stopInfo)
				{
					str = "action类型：" + getQualifiedClassName(act);
					m_fightDB.m_gkcontext.addLog(str);
				}
				act.onTick(deltaTime);
			}
		}
		//流程处理完毕后，调用此函数
		protected function processOver():void
		{
			m_bEndState = true;
			tryOver()
		}
		protected function addToActionList(act:IRankFightAction):void
		{
			m_actionList.push(act);
		}
		
		protected function deleteFromActionList(act:IRankFightAction):void
		{
			var i:int = m_actionList.indexOf(act);
			if (i != -1)
			{
				m_actionList.splice(i, 1);
			}
			act.dispose();
			tryOver();
		
		}
		public function begin():void
		{
		
		}
		protected function tryOver():void
		{
			
		}
		public function dispose():void
		{
			var act:IRankFightAction;
			for each (act in m_actionList)
			{
				act.dispose();
			}
			m_funOnEnd = null;
		}
		public function isEnd():Boolean
		{
			return m_actionList.length == 0;
		}
	}

}