package modulefight.digitani 
{
	import com.dgrigg.display.DisplayCombinationBase;
	import com.dgrigg.image.Image;
	import common.Context;
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	public class DigitDisplay extends DisplayCombinationBase 
	{
		protected var m_uValue:uint;
		protected var m_bitMapData:BitmapData;
		protected var m_onComposed:Function;
		public function DigitDisplay(con:Context, parent:DisplayObjectContainer = null) 
		{
			super(con,parent);
		}		
		
		override protected function onLoaded(image:Image):void
		{
			super.onLoaded(image);
			compose();
		}
		override public function dispose():void 
		{
			super.dispose();
			m_onComposed = null;
		}
		public function set value(value:uint):void
		{
			m_uValue = value;
			if (m_imagList != null)
			{
				compose();
			}
		}
		protected function compose():void
		{
			
		}
		public function set onComposed(fun:Function):void
		{
			m_onComposed = fun;
		}
		
	}

}