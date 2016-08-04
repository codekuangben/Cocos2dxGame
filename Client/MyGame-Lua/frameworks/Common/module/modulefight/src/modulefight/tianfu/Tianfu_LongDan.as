package modulefight.tianfu 
{
	/**
	 * ...
	 * @author 
	 * 龙胆
	 */
	public class Tianfu_LongDan extends TianfuBase 
	{
		
		public function Tianfu_LongDan() 
		{
			super();			
			m_type = TYPE_AttackBegin;
		}
		
		override public function isTriger(param:Object = null):Boolean 
		{
			if (m_fightGrid.curHp <= Math.floor(m_fightGrid.maxHp * 0.5))
			{
				return true;
			}
			return false;
		}		
		
	}

}