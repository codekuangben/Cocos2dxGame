package game.ui.uiSysBtn 
{
	import com.bit101.components.Component;
	import com.bit101.components.Panel;
	import com.bit101.components.progressBar.IBarInProgress;
	/**
	 * ...
	 * @author 
	 */
	public class ComExpBar extends Component implements IBarInProgress 
	{
		protected var _value:Number = 0;
		protected var _max:Number = 1;
		public var _barPanel:Panel;
		
		public function ComExpBar() 
		{
			_barPanel = new Panel(this);
		}
		
		public function set maximum(m:Number):void
		{
			_max = m;
			_value = m;
		}
		
		public function set value(v:Number):void
		{
			_value = v;
			_barPanel.scaleX = v / _max;
		}
		public function set initValue(v:Number):void
		{
			
		}
		
		public function initBar():void
		{
			
		}
	}

}