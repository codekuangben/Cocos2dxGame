package modulefight.tianfu 
{
	import modulefight.FightEn;
	/**
	 * ...
	 * @author ...
	 * 无为:每回合初回合自身兵力20%
	 * 
	 * 加血时，需要考虑神医（华佗）
	 * 孙权的恢复量=（孙权的血量*20%）（1+己华佗增量30%）（1-敌华佗减量50%）
	 */
	public class Tianfu_WuWei extends TianfuBase 
	{
		
		public function Tianfu_WuWei() 
		{
			super();
			m_type = TYPE_ServerTrigger;
		}		
	}

}