package game.ui.uibackpack.wujiang 
{
	import com.bit101.components.Panel;
	import flash.display.DisplayObjectContainer;
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	public class AttrItemTwo extends AttrItemOne 
	{
		public var m_lableBG:Panel;
		public function AttrItemTwo(parent:DisplayObjectContainer = null)
		{
			super(parent);
		}
		override protected function addChildren():void
		{
			m_lableBG = new Panel(this, 0, 0);
			super.addChildren();			
		}
	}

}