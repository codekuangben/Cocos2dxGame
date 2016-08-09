package com.bit101.components
{
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	//import com.dgrigg.minimalcomps.skins.VScrollSliderSkin;
	import com.dgrigg.utils.UIConst;
	
	//import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	
	public class ButtonTab extends PushButton
	{
		protected var _selected:Boolean = false;
		protected var _groupID:int;
		
		public function ButtonTab(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0, defaultHandler:Function = null)
		{
			super(parent, xpos, ypos, defaultHandler);
			this.addEventListener(MouseEvent.CLICK, onClick);
		}
		
		override public function dispose():void
		{
			this.removeEventListener(MouseEvent.CLICK, onClick);
			super.dispose();
		}
		
		protected function onClick(e:MouseEvent):void
		{
			if (_selected != true)
			{
				selected = true;
			}
		}
		
		override protected function onMouseGoDown(event:MouseEvent):void
		{
			if (_selected == false)
			{
				_down = true;
				updateSkin(UIConst.EtBtnDown);
				
				stage.addEventListener(MouseEvent.MOUSE_UP, onMouseGoUp);
			}
		}
		
		override protected function onMouseOver(event:MouseEvent):void
		{
			if (_selected == false)
			{
				_over = true;
				updateSkin(UIConst.EtBtnOver);
				addEventListener(MouseEvent.ROLL_OUT, onMouseOut);
			}
		}
		
		override protected function onMouseOut(event:MouseEvent):void
		{
			_over = false;
			if (_down == false)
			{
				if (_selected == true)
				{
					updateSkin(UIConst.EtBtnSelected);
				}
				else
				{
					updateSkin(UIConst.EtBtnNormal);
				}
			}
			
			removeEventListener(MouseEvent.ROLL_OUT, onMouseOut);
		}
		
		override protected function onMouseGoUp(event:MouseEvent):void
		{
			_down = false;
			if (_over == true)
			{
				updateSkin(UIConst.EtBtnOver);
			}
			else
			{
				if (_selected == true)
				{
					updateSkin(UIConst.EtBtnSelected);
				}
				else
				{
					updateSkin(UIConst.EtBtnNormal);
				}
			}
			stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseGoUp);
		}
		
		override public function onSetSkin():void
		{
			super.onSetSkin();
			if (_selected == true)
			{
				updateSkin(UIConst.EtBtnSelected);
			}
			else
			{
				updateSkin(UIConst.EtBtnNormal);
			}
		}
		
		/**
		 * Sets / gets the label text shown on this Pushbutton.
		 */
		public function set selected(value:Boolean):void
		{
			if (_selected == value)
			{
				return;
			}
			_selected = value;
			if (_selected)
			{
				updateSkin(UIConst.EtBtnSelected);
				notifyOthers();
			}
			else
			{
				updateSkin(UIConst.EtBtnNormal);
			}
		}
		
		protected function notifyOthers():void
		{
			if (this.parent != null)
			{
				var i:int;
				var btn:ButtonTab;
				for (i = 0; i < this.parent.numChildren; i++)
				{
					btn = this.parent.getChildAt(i) as ButtonTab;
					if (btn != null && btn != this && this.goupID == btn.goupID)
					{
						btn.selected = false;
					}
				}
			}
		}
		
		public function get selected():Boolean
		{
			return _selected;
		}
		
		public function set goupID(id:int):void
		{
			_groupID = id;
		}
		
		public function get goupID():int
		{
			return _groupID;
		}
	}

}