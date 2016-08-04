package modulefight.scene.battleContrl 
{
	/**
	 * ...
	 * @author 
	 */
	import com.pblabs.engine.entity.EntityCValue;
	import modulefight.netmsg.stmsg.BattleArray;
	import modulefight.scene.fight.FightDB;
	import modulefight.scene.fight.FightLogicCB;
	import modulefight.scene.fight.rank.IRankFightAction;
	import modulefight.scene.fight.rank.RankAttackAction;
	//import modulefight.scene.fight.rank.RankBufEffAction;
	import modulefight.scene.fight.rank.RankHurtAction;
	//import modulefight.scene.fight.rank.RankSelfTeamEffectAction;
	import modulefight.scene.roundcontrol.RoundControl;
	public class BattleControlFarAttack extends BattleControlBase 
	{		
		public function BattleControlFarAttack(fightDB:FightDB, fightLogicCB:FightLogicCB, roundControl:RoundControl, bat:BattleArray) 
		{
			super(fightDB, fightLogicCB, roundControl, bat);
		}
		override protected function prcessAttack():void
		{
			super.prcessAttack();
			processValueEffect();
			var actAttack:RankAttackAction = createRankAttackAction();
			var actHurt:RankHurtAction = createRankHurtAction();
			if (actHurt)
			{
				m_attgrid.xlastPos = m_attgrid.xPos;
				m_attgrid.ylastPos = m_attgrid.yPos;
				setParamForAttack(m_battleArray, actAttack, actHurt);
			}
			createRankSelfTeamEffectAction();
			createRankBufEffAction();
			
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