package modulefight.tianfu 
{
	/**
	 * ...
	 * @author ...
	 * 连营:所有被其攻击的武将均士气下降25点
	 * 在攻击之前显示连营效果（文字表现），数值是在攻击结束 后处理
	 */
	import modulefight.FightEn;	
	import modulefight.netmsg.stmsg.stEntryState;
	import modulefight.scene.fight.FightGrid;
	
	public class Tianfu_LianYing extends TianfuBase 
	{
		
		public function Tianfu_LianYing() 
		{
			super();
			m_type = TYPE_AttackBegin;
		}
		
		override public function isTriger(param:Object = null):Boolean 
		{
			return true;
		}
		
		/*//找到持有“飞将”天赋的武将的攻击目标，使降士气
		public function subtractShiqi_Attack(grid:FightGrid):void
		{
			grid.shiqi -= tianfuXiaoguo;
			grid.emitNamePic(FightEn.NTDn, stEntryState.PICName_Xiajiang);
		}*/
	}

}