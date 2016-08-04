package modulefight.tianfu 
{
	import modulefight.netmsg.stmsg.BattleArray;
	/**
	 * ...
	 * @author 
	 * 神隐:有10%~25%的几率完全抵抗敌中军造成的伤害 	被中军武将攻击时触发
	 */
	
	public class Tianfu_Shenyin extends TianfuBase 
	{
		
		public function Tianfu_Shenyin() 
		{
			super();
			m_type = TYPE_Attacked;
		}
		override public function isTriger(param:Object = null):Boolean 
		{
			var bat:BattleArray = param["BattleArray"];
			if (bat.aGridNO >= 3 && bat.aGridNO <= 5)
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