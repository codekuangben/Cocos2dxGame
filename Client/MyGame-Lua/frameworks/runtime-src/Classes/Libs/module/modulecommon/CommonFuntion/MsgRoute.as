package modulecommon.commonfuntion
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	/**
	 * @brief 有些不能全局访问的事件通过这个消息传递
	 */
	public class MsgRoute 
	{
		public static const EtEnterFight:String = "EtEnterFight";		// 进入战斗
		public static const EtExpseClk:String = "EtExpseClk";			// 表情单击
		public static const EtExpseRemEvt:String = "EtExpseRemEvt";		// 表情请求移除事件监听器
		
		public var m_enterFightDisp:EventDispatcher;		// 进入战斗开始事件分发器
		public var m_expseDisp:EventDispatcher;		// 表情界面点击事件或者请求事件监听器移除监听器
		
		public function MsgRoute()
		{
			m_enterFightDisp = new EventDispatcher();
			m_expseDisp = new EventDispatcher();
		}
	}
}