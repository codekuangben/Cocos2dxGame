package game.ui.uibackpack.wujiang 
{
	import com.bit101.components.Component;
	import com.bit101.components.label.Label2;
	import com.bit101.components.Panel;
	import flash.display.DisplayObjectContainer;
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	public class AttrItemOne extends AttrItemBase 
	{
		public var m_lableValue:Label2;		
		public function AttrItemOne(parent:DisplayObjectContainer = null)
		{
			super(parent);
		}
		override protected function addChildren():void
		{
			super.addChildren();	
			m_lableValue = new Label2(this);
		}
		
	}

}