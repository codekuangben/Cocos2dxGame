package modulefight.tianfu 
{
	import modulefight.netmsg.stmsg.BattleArray;
	/**
	 * ...
	 * @author 
	 * 典韦	迂回:有10%~25%的几率完全抵抗敌后军造成的伤害	被后军武将攻击时触发
	 */
	public class Tianfu_Yuhui extends TianfuBase 
	{
		
		public function Tianfu_Yuhui() 
		{
			super();
			m_type = TYPE_Attacked;
		}
		
		override public function isTriger(param:Object = null):Boolean 
		{
			var bat:BattleArray = param["BattleArray"];
			//var isJinnang:Boolean = param["Jinnang"];
			if (bat.aGridNO >= 6)
			{
				return true;
			}
			else
			{
				return false;
			}
		}
	}

}