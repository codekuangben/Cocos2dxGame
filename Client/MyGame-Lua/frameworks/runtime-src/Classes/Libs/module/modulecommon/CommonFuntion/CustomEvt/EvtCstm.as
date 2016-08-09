package modulecommon.commonfuntion.customevt
{
	import flash.events.Event;
	/**
	 * @brief 自定义事件
	 */
	public class EvtCstm extends Event
	{
		public var m_data:Object;		// 自定义数据
		
		public function EvtCstm(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable)
		}	
	}
}