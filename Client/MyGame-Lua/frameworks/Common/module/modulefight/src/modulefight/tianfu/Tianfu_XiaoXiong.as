package modulefight.tianfu 
{
	/**
	 * ...
	 * @author 
	 * 枭雄:攻击敌前军时暴击出现几率提升50%		
	 */
	import modulefight.FightEn;
	import modulefight.scene.fight.FightGrid;
	import modulefight.netmsg.stmsg.AttackedInfoGrid;
	import modulefight.netmsg.stmsg.BattleArray;
	public class Tianfu_XiaoXiong extends TianfuBase 
	{
		
		public function Tianfu_XiaoXiong() 
		{
			super();		
			m_type = TYPE_AttackBegin;
		}
		
		override public function isTriger(param:Object = null):Boolean 
		{
			var bat:BattleArray = param as BattleArray;
			var list:Vector.<AttackedInfoGrid> = bat.attackedList.list;
			var info:AttackedInfoGrid;
			for each(info in list)
			{
				if (info.gridNO < 3)
				{
					return true;
				}
			}
			return false;
		}
	}

}