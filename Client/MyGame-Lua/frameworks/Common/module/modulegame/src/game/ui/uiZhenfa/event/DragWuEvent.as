package game.ui.uiZhenfa.event 
{
	import flash.events.Event;
	import modulecommon.scene.wu.WuProperty;
	
	/**
	 * ...
	 * @author zouzhiqiang
	 * 在阵法界面，用鼠标拿起武将，或放下武将时，会发出这个事件
	 */
	public class DragWuEvent extends Event 
	{
		public static const DRAG_WU:String = "DragWujiang";
		public static const DROP_WU:String = "DropWujiang";
		private var m_wu:WuProperty;
		public function DragWuEvent(type:String, data:WuProperty) 
		{
			super(type, true);
			m_wu = data;
		}
		
		public function get wu():WuProperty
		{
			return m_wu;
		}
		
	}

}