package com.bit101.components 
{
	/**
	 * ...
	 * @author
	 * 这是双状态按钮。比如单选按钮，复选按钮
	 */
	import com.dgrigg.skins.Skin2Button;
	import flash.display.DisplayObjectContainer;
	//import com.dgrigg.utils.UIConst;
	import flash.events.MouseEvent;
	
	public class Button2State extends PushButton 
	{
		protected var _selected:Boolean = false;
		public function Button2State(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0, defaultHandler:Function = null) 
		{
			this.addEventListener(MouseEvent.CLICK, onClick);
			super(parent, xpos, ypos, defaultHandler);			
		}
		
		public function set selected(value:Boolean):void
		{
			if (_selected == value)
			{
				return;
			}
			_selected = value;
			updateSkin(this.state);			
		}
		    
		protected function onClick(e:MouseEvent):void
		{
			if (_selected != true)
			{
				selected = true;
			}
			else
			{
				selected = false;
			}
		}
		
		override public function setPanelImageSkin(name:String):void
		{
			var localSkin:Skin2Button = new Skin2Button();		
			this.skin = localSkin;			
			localSkin.setCommonImageByName(name);
		}
		
		public function get selected():Boolean
		{
			return _selected;
		}
		
	}

}