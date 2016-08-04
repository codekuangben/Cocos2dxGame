package game.ui.uiTeamFBSys.iteamzx.event
{
	import flash.events.Event;

	/**
	 * @brief 拖放事件
	 * */
	public class TeamDragEvent extends Event
	{
		public static const DRAG_TEAMMEM:String = "DRAG_TEAMMEM";	// 拖放队伍中的成员的顺序

		public static const DRAG_WU:String = "DragWujiang";		// 拖武将的时候发出的事件
		public static const DROP_WU:String = "DropWujiang";		// 放武将的时候发出的事件
		
		private var m_data:Object;		// 拖放传递的数据

		public function TeamDragEvent(type:String, data:Object)
		{
			super(type, true);
			m_data = data;
		}
		
		public function get data():Object
		{
			return m_data;
		}
	}
}