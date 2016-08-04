package game.ui.uibackpack.wujiang 
{
	import com.bit101.components.Component;
	import flash.display.DisplayObjectContainer;
	import com.bit101.components.label.Label2;
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	public class AttrItemBase extends Component 
	{
		public var m_lableName:Label2;
		public function AttrItemBase(parent:DisplayObjectContainer = null)
		{
			super(parent);
		}
		override protected function addChildren():void
		{
			super.addChildren();
			m_lableName = new Label2(this);
		}
		
	}

}