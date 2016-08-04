package game.ui.uibenefithall.eventmsg
{
	import flash.events.Event;
	/**
	 * @brief 点击 list 中的按钮发送的事件
	 */
	public class EventLstBtnClk extends Event
	{
		public var m_idxClk:int;

		public function EventLstBtnClk(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}	
	}
}