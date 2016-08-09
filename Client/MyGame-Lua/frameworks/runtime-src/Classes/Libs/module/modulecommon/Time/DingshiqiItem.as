package modulecommon.time 
{
	/**
	 * ...
	 * @author 	 * 
	 * 定时器结构
	 * 针对服务器时间进行定时, 到达指定时间后,调用m_funOnTimeUp
	 */
	public class DingshiqiItem 
	{
		public var m_funOnTimeUp:Function; // function funOnTimeUp(data:Obejct):void
		public var m_platform:Number;
		public var m_data:Object;
		public function DingshiqiItem() 
		{
			
		}
		
	}

}