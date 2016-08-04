package com.bit101.components
{
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	import com.bit101.components.label.Label2;
	import com.bit101.components.label.LabelFormat;
	import common.event.UIEvent;
	import flash.text.engine.TextRotation;
	//import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import com.dgrigg.utils.UIConst;
	import flash.events.MouseEvent;
	
	public class ButtonTabText extends ButtonTab
	{
		protected var m_label:Label2;
		protected var _labelText:String = "";
		protected var _normalColor:uint = 0xaaaaaa;
		protected var _overColor:uint = 0xffffff;
		protected var _downColor:uint = 0xffffff;
		protected var _seletedColor:uint = 0xffffff;
	
		public function ButtonTabText(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0, label:String = "", defaultHandler:Function = null)
		{
			super(parent, xpos, ypos, defaultHandler);
			
			m_label = new Label2(this, 0, 0);			
			this.label = label;
		}
		
		public function setParam(size:int=12, bold:Boolean=false, handler:Function = null, normalColor:uint=0x999999, overColor:uint=0xffffff, downColor:uint=0xaaaaaa, miaobianColor:uint = 0x101010):void
		{
			var lf:LabelFormat = new LabelFormat();
			lf.size = size;
			lf.bBold = bold;
			lf.color = normalColor;
			lf.miaobianColor = miaobianColor;			
			m_label.letterspace = strlenToletterSpacing(_labelText.length);
			m_label.labelFormat = lf;
			
			_normalColor = normalColor;	
			_overColor = overColor;
			_downColor = downColor;
			
			if (handler)
			{
				addEventListener(MouseEvent.CLICK, handler);
			}
		}
		
		public function setParamByFormat(fomat:ButtonTextFormat):void
		{
			var lf:LabelFormat = new LabelFormat();
			lf.size = fomat.m_size;
			lf.bBold = fomat.m_bold;
			lf.color = fomat.m_normalColor;
			lf.miaobianColor = fomat.m_miaobianColor;
			if (fomat.m_vertical)
			{
				lf.lineRotation = TextRotation.ROTATE_90;
			}
			if (fomat.m_letterSpace == 0)
			{
				lf.letterspace = strlenToletterSpacing(_labelText.length);
			}
			else
			{
				lf.letterspace = fomat.m_letterSpace;
			}
			m_label.labelFormat = lf;
			
			_normalColor = fomat.m_normalColor;	
			_overColor = fomat.m_overColor;
			_downColor = fomat.m_downColor;
			_seletedColor = fomat.m_seletedColor
			if (fomat.m_handler)
			{
				addEventListener(MouseEvent.CLICK, fomat.m_handler);
			}
		}
		
		override public function draw():void
		{
			super.draw();
			onLabelResize();
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
		
		public function set seletedColor(color:uint):void
		{
			_seletedColor = color;
		}
		
		protected function set fontColor(color:uint):void
		{
			m_label.setFontColor(color);
		}		
	
		protected function onLabelResize():void
		{		
			m_label.x = (this.width - m_label.width) / 2;
			m_label.y = (this.height - m_label.height) / 2;		
		}
		
		public function set label(str:String):void
		{
			_labelText = str;			
			m_label.letterspace = strlenToletterSpacing(str.length);
			m_label.text = str;
		}
		
		private function strlenToletterSpacing(strlen):int
		{			
			var letterSpacing:int = 6;		
			if (strlen == 3)
			{
				letterSpacing = 4;
			}
			else if (strlen == 4)
			{
				letterSpacing = 3;
			}
			return letterSpacing;
		}
		
		override protected function updateSkin(state:uint):void
		{
			super.updateSkin(state);
			var curColor:uint;
			switch (state)
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
				case UIConst.EtBtnSelected: 
				{
					curColor = _seletedColor;
				}
					break;
			}
			fontColor = curColor;
		
		}
		
		public function get label():String
		{
			return _labelText;
		}
		
	/*	public function get labelComponent():Label
		{
			return _label;
		}*/
		
		/*public function get labelStrW():Number
		{
			var ret:Number;
			var len:int = _labelText.length;
			
			if (len > 1)
			{
				ret = len * (_label.fontSize) + (len - 1) * _letterSpacing;
			}
			
			ret += 4;
			
			return ret;
		}
		
		//按钮上字只有一行
		public function get labelStrH():Number
		{
			var ret:Number = 4 + _label.fontSize;
			
			return ret;
		}*/
		
		public function setLetterSpacing(letterSpacing:uint):void
		{		
			m_label.letterspace = letterSpacing;
		}
	
	}

}