package modulefight.scene.fight.rank 
{
	/**
	 * ...
	 * @author 
	 */
	import com.pblabs.engine.entity.EntityCValue;
	import modulefight.FightEn;
	import modulefight.netmsg.stmsg.BattleArray;
	import modulefight.netmsg.stmsg.DefList;
	import modulefight.netmsg.stmsg.SelfInfoGrid;
	import modulefight.netmsg.stmsg.SelfInfoList;
	import modulefight.netmsg.stmsg.stEntryState;
	import modulefight.scene.fight.FightDB;
	import modulefight.scene.fight.FightGrid;
	public class RankSelfTeamEffectAction implements IRankFightAction 
	{
		protected var m_battleArray:BattleArray;
		protected var m_fightDB:FightDB;
		protected var m_fEnd:Function;			// 结束回调 
		public function RankSelfTeamEffectAction(battleArray:BattleArray, fightDB:FightDB) 
		{
			m_battleArray = battleArray;
			m_fightDB = fightDB;
		}
		public function onEnter():void
		{
			
		}
		
		protected function process():void
		{
			var list:Vector.<SelfInfoGrid> = m_battleArray.selfList.list;
			var selfGrids:Vector.<FightGrid> = m_fightDB.m_fightGrids[m_battleArray.aTeamid];
			var selfInfo:SelfInfoGrid;
			for each(selfInfo in list)
			{
				selfGrids[selfInfo.gridNO].onZengyiByBattleArray(m_battleArray);
			}			
		}
		
		public function onEnd():void
		{
			m_fEnd(this);
		}
		public function onTick(deltaTime:Number):void
		{
			process();
			onEnd();
		}
		public function actType():uint
		{
			return EntityCValue.RKACTSelfTeamEffect;
		}
		public function dispose():void
		{
			m_battleArray = null;
			m_fightDB = null;
			m_fEnd = null;
		}
		public function inAction(list:Vector.<FightGrid>):Boolean
		{			
			return false;
		}	
		public function set fEnd(value:Function):void 
		{
			m_fEnd = value;
		}
		
		public function get battleArray():BattleArray
		{
			return m_battleArray;
		}
		public function get fightIdx():int
		{
			return m_battleArray.m_fightIdx;
		}
	}

}