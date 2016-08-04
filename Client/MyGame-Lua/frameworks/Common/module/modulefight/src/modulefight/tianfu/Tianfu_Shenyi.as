package modulefight.tianfu 
{
	import modulefight.scene.fight.FightGrid;
	/**
	 * ...
	 * @author ...
	 * 神医:全军恢复兵力效果提升30%
	 * 有多个神医安装2一个神医算
	 */
	public class Tianfu_Shenyi extends TianfuBase 
	{
		
		public function Tianfu_Shenyi() 
		{
			super();
			m_type = TYPE_RestoreHP;
		}
		
		override public function isTriger(param:Object = null):Boolean 
		{
			/*var grid:FightGrid = param as FightGrid;
			if (grid.side == this.m_fightGrid.side)
			{
				return true;
			}*/
			return true;
		}
		
	}

}