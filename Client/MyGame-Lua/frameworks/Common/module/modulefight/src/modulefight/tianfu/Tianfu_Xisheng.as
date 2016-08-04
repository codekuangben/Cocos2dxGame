package modulefight.tianfu 
{
	/**
	 * ...
	 * @author 
	 * 蔡文姬	牺牲:每次损失兵力(锦囊掉血与自身技能掉血除外),自身士气提升25~100点(神武将100点,普通25)	每次被他人攻击时触发,不包含锦囊和毒掉血,自身表现"士气上升"
	 */
	public class Tianfu_Xisheng extends TianfuBase 
	{
		
		public function Tianfu_Xisheng() 
		{
			super();
			m_type = TYPE_Attacked;
		}
		override public function isTriger(param:Object = null):Boolean 
		{
			//var bat:BattleArray = param["BattleArray"];
			var isJinnang:Boolean = param["Jinnang"];
			if (isJinnang==false)
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