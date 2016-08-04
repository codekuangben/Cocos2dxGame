package modulefight.scene.fight
{
	import modulefight.netmsg.fight.stAttackResultUserCmd;
	import modulefight.netmsg.stmsg.BattleArray;
	/**
	 * ...
	 * @author 
	 * @brief 战斗必要的信息 
	 */
	public class FightInfo 
	{
		//public var m_direct:uint = 0;	// 战斗方向，从左向右还是从右向左   EntityCValue.RKDIRLeft(0) - 从右向左，EntityCValue.RKDIRRight(1) - 从左向右
		//public var m_attackedList:Vector.<BattleArray> = new Vector.<BattleArray>();	// 攻击过的列表 
		//public var m_curAttList:Vector.<BattleArray> = new Vector.<BattleArray>();	// 当前攻击的列表 
		public var m_fightProcess:stAttackResultUserCmd;		// 整个战斗流程    
	}
}