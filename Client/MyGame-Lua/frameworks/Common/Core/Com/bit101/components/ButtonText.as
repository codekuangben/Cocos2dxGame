package com.bit101.components
{
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	//import flash.events.Event;
	import com.dgrigg.utils.UIConst;
	
	public class ButtonText extends PushButton
	{
		
		public var _label:Label;	
		
		protected var _normalColor:uint = 0xeeeeee;
		protected var _overColor:uint = 0xffffff;
		protected var _downColor:uint = 0xaaaaaa;		
				
		protected var _letterSpacing:uint = 0;
		protected var _labelNormalPosX:Number;
		protected var _labelNormalPosY:Number;
		protected var _autoAdjustLabelPos:Boolean;
		protected var _labelWidthComputetype:int;
		
		public function ButtonText(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0, label:String = "", defaultHandler:Function = null)
		{
			super(parent, xpos, ypos, defaultHandler);
			_autoAdjustLabelPos =  true;
			_label = new Label(this, 0, 0, label, _normalColor, 12);		
		}		
		
		public function set normalColor(color:uint):void
		{
			_normalColor = color;
			fontColor = color;
		}
		public function set overColor(color:uint):void
		{
			_overColor = color;
		}
		public function set downColor(color:uint):void
		{
			_downColor = color;
		}
		
				
		public function set fontColor(color:uint):void
		{		
			_label.setFontColor(color);			
		}
		
		public function set fontSize(size:uint):void
		{					
			_label.setFontSize(size);			
		}		
		override public function draw():void 
		{
			super.draw();
			onLabelResize();
		}
		
		public function setParam(size:int=12, bold:Boolean=false, handler:Function = null, labelWidthComputetype:int=0, normalColor:uint=0xeeeeee, overColor:uint=0xffffff, downColor:uint=0xaaaaaa):void
		{
			_labelWidthComputetype = labelWidthComputetype;
			_label.setFontSize(size);	
			_label.setBold(bold);
			_normalColor = normalColor;
			fontColor = normalColor;
			_overColor = overColor;
			_downColor = downColor;
			
			if (handler)
			{
				addEventListener(MouseEvent.CLICK, handler);
			}
		}
		protected function onLabelResize():void
		{
			if (_autoAdjustLabelPos)
			{
				var w:int;
				var h:int;
				if (_labelWidthComputetype == LabelWidthComputetype_auto || _label.vertical)
				{
					w = _label.width;
					h = _label.height;
				}
				else
				{					
					w = labelStrW;
					h = labelStrH;
				}
				_labelNormalPosX = _label.x = (this.width - w) / 2;
				_labelNormalPosY = _label.y = (this.height - h) / 2;
			}
		}
		
		public function set label(str:String):void
		{			
			if (_letterSpacing == 0 || _letterSpacing == 6)
			{
				if (str.length == 3)
				{
					_letterSpacing = 4;
				}
				else if (str.length >= 4)
				{
					_letterSpacing = 1;
				}
				else
				{
					_letterSpacing = 6;
				}
			}
			_label.setLetterSpacing(_letterSpacing);
			_label.text = str;		
		}
		
		override protected function updateSkin(state:uint):void
		{
			super.updateSkin(state);
			var curColor:uint;
			switch(state)
			{
				case UIConst.EtBtnNormal:
					{
						curColor = _normalColor;
					}
					break;
				case UIConst.EtBtnDown:
					{
						curColor = _downColor;
					}
					break;
				case UIConst.EtBtnOver:
					{
						curColor = _overColor;
					}
					break;				
			}
			fontColor = curColor;	
			
		}
		
		public function LablePosChangeOnStateChange(offsetX:Number, offsetY:Number):void
		{
			_label.x = _labelNormalPosX + offsetX;
			_label.y = _labelNormalPosY + offsetY;
		}
		
		public function get label():String
		{
			return _label.text;
		}
		
		public function get labelStrW():Number
		{
			var ret:Number;
			var len:int = label.length;
			
			if (len > 1)
			{
				ret = len * _label.fontSize + (len - 1) * (_letterSpacing + 1);
			}
			
			ret += 4;
			
			return ret;
		}
		
		//按钮上字只有一行
		public function get labelStrH():Number
		{
			var ret:Number = 4 + _label.fontSize;
			
			return ret;
		}
		
		public function set letterSpacing(space:int):void
		{
			_letterSpacing = space;
			_label.setLetterSpacing(_letterSpacing);			
		}
		
		public function get labelComponent():Label
		{
			return _label;
		}
		
		public function set autoAdjustLabelPos(b:Boolean):void
		{
			_autoAdjustLabelPos = b;
		}
	
	}

}