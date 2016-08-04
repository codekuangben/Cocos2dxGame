package modulefight.tianfu 
{
	/**
	 * ...
	 * @author ...
	 * 神射:攻击敌军中军或后军时,出现暴击几率提升50%
	 * 当攻击目标内有敌中军或后军目标时,每次攻击时在部队上出现(无论普通攻击与技能攻击)
	 */
	import modulefight.netmsg.stmsg.AttackedInfoGrid;
	import modulefight.netmsg.stmsg.BattleArray;
	import modulefight.scene.fight.FightGrid;
	public class Tianfu_ShenShe extends TianfuBase 
	{
		
		public function Tianfu_ShenShe() 
		{
			super();
			m_type = TYPE_AttackBegin;
		}
		override public function isTriger(param:Object = null):Boolean 
		{
			var bat:BattleArray = param as BattleArray;
			var list:Vector.<AttackedInfoGrid> = bat.attackedList.list;
			var item:AttackedInfoGrid;
			for each(item in list)
			{
				if (item.gridNO >= 3)
				{
					return true;
				}
			}			
			return false;
		}
	}

}