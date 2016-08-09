package com.bit101.components 
{
	
	//import flash.display.Sprite;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	public class PanelContainer extends Component 
	{
		protected var _backgroundContainer:Panel;
		public function PanelContainer(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number =  0)
		{
			super(parent, xpos, ypos);			
		}		
		
		override protected function addChildren():void
		{
			_backgroundContainer = new Panel();
			_backgroundContainer.mouseEnabled = false;
			this.addChild(_backgroundContainer);
		}

		/**
		 * Overridden to add new child to content.
		 */
		public override function addBackgroundChild(child:DisplayObject):DisplayObject
		{
			_backgroundContainer.addChild(child);			
			return child;
		}

		public override function removeBackgroundChild(child:DisplayObject):DisplayObject
		{
			_backgroundContainer.removeChild(child);
			return child;
		}	
	}
}