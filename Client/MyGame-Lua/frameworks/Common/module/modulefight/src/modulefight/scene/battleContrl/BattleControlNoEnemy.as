package modulefight.scene.battleContrl 
{
	/**
	 * ...
	 * @author
	 * 敌方没人受伤，没人加buffer
	 */
	import modulecommon.scene.prop.table.TNpcBattleItem;
	import modulecommon.scene.prop.table.TSkillBaseItem;
	import modulefight.scene.beings.NpcBattle;
	import modulefight.scene.fight.FightDB;
	import modulefight.scene.fight.FightLogicCB;
	import modulefight.netmsg.stmsg.BattleArray;
	import com.pblabs.engine.entity.EntityCValue;
	import modulefight.scene.fight.rank.IRankFightAction;
	import modulefight.scene.roundcontrol.RoundControl;
	
	public class BattleControlNoEnemy extends BattleControlBase 
	{		
		public function BattleControlNoEnemy(fightDB:FightDB, fightLogicCB:FightLogicCB, roundControl:RoundControl, bat:BattleArray) 
		{
			super(fightDB, fightLogicCB, roundControl, bat);
		}
		override protected function prcessAttack():void
		{
			super.prcessAttack();
			createRankAttackAction();			
			createRankSelfTeamEffectAction();
			setEffetParam();
			createRankBufEffAction();
			processValueEffect();
		}
		
		protected function setEffetParam():void
		{
			var skillitem:TSkillBaseItem;
			var battlenpcitem:TNpcBattleItem;
			var effFrameRateList:Vector.<uint>;
			var effFrameRateList1:Vector.<uint>;
			
			if (m_battleArray.type == 1) // 技能攻击
			{
				skillitem = m_battleArray.skillBaseitem;
				effFrameRateList = skillitem.m_effFrameRateList;
				effFrameRateList1 = skillitem.m_effFrameRateList1;
			}
			else
			{
				battlenpcitem = m_attgrid.npcBaseItem;
				effFrameRateList = battlenpcitem.npcBattleModel.m_effFrameRateList;
				effFrameRateList1 = battlenpcitem.npcBattleModel.m_effFrameRateList1;
			}
			var battlenpc:NpcBattle;
			for each (battlenpc in m_attgrid.beingList)
			{
				battlenpc.effFrameRateList = effFrameRateList;
				battlenpc.effFrameRateList1 = effFrameRateList1;
				battlenpc.m_effectSpeed = 0;
			}
		}
		
		override protected function onAttackActEnd(act:IRankFightAction):void
		{
			m_roundControl.nextAttCB(EntityCValue.ASAttacked, m_battleArray);
			m_roundControl.nextAttCB(EntityCValue.ASIned, m_battleArray);
			deleteFromActionList(act);
			processOver();
		}
	}

}