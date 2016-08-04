package modulefight.tianfu 
{
	/**
	 * ...
	 * @author 
	 * 许褚	猛毒:被其攻击的目标造成毒杀效果强制损失(6%/8%/10%/12%)上限的兵力	每次攻击时表现
	 */
	public class Tianfu_Mengdu extends TianfuBase 
	{
		
		public function Tianfu_Mengdu() 
		{
			super();
			m_type = TYPE_AttackBegin;
		}
		override public function isTriger(param:Object = null):Boolean 
		{
			return true;
		}
	}

}