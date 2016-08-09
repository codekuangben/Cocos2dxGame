package com.bit101.components.progressBar 
{
	import com.bit101.components.Component;
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	public class BarInProgressDefault extends Component implements IBarInProgress 
	{		
		protected var _value:Number = 0;
		protected var _max:Number = 1;
		
		public function BarInProgressDefault() 
		{
			
		}
		public function set maximum(m:Number):void
		{
			_max = m;
		}
		
		public function set initValue(v:Number):void
		{
			
		}
		
		public function initBar():void
		{
			
		}
		public function set value(v:Number):void
		{
			this.scaleX = v / _max;
		}
	}
}