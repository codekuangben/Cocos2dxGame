/**
 * Label.as
 * Keith Peters
 * version 0.9.10
 *
 * A Label component for displaying a single line of text.
 *
 * Copyright (c) 2011 Keith Peters
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

package com.bit101.components
{
	import com.util.UtilFont;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.filters.GlowFilter;
	import flash.text.StyleSheet;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	[Event(name="resize",type="flash.events.Event")]
	
	public class Label extends Component
	{				
		protected var _text:String = "";
		protected var _tf:TextField;
		
		protected var _autoSize:Boolean = true;
		
		protected var _bold:Boolean = false;
		protected var _fontColor:uint = 0xffffff;
		protected var _bMiaobian:Boolean = true;
		protected var _underLine:Boolean = false;
		protected var _miaoBianColor:uint = 0x101010;
		protected var _fontSize:uint = 12;
		protected var _fontName:String = UtilFont.NAME_Songti;
		protected var _letterSpacing:uint = 1;
		protected var _align:int = Component.LEFT;
		protected var _bVertical:Boolean;
		protected var _bValid:Boolean;
		protected var _isHtmltext:Boolean;
		protected var _bSizeChangeFlag:Boolean;	//可能引起大小变化的标志
		
		/**
		 * Constructor
		 * @param parent The parent DisplayObjectContainer on which to add this Label.
		 * @param xpos The x position to place this component.
		 * @param ypos The y position to place this component.
		 * @param text The string to use as the initial text in this component.
		 */
		public function Label(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0, text:String = "", fontColor:uint = 0xffffff, fontSize:uint = 12)
		{
			super(parent, xpos, ypos);
			_fontColor = fontColor;
			_fontSize = fontSize;
			this.text = text;
			_bSizeChangeFlag = true;
			
			mouseEnabled = false;
			mouseChildren = false;
		}
		
		/**
		 * Creates and adds the child display objects of this component.
		 */
		override protected function addChildren():void
		{
			
			_height = 20;
			_tf = new TextField();
			_tf.height = _height;
			_tf.width = 0;
			//_tf.embedFonts = Style.embedFonts;
			_tf.selectable = false;
			_tf.mouseEnabled = false;
			_tf.autoSize = TextFieldAutoSize.LEFT;
			//_tf.text = _text;
			addChild(_tf);
			//draw();
		}
		
		private function setTextFormat():void
		{
			if (_isHtmltext)
			{
				var css:StyleSheet = new StyleSheet();
				var strColor:String = "#" + _fontColor.toString(16);
				css.setStyle("body", {fontFamily: _fontName, letterSpacing: _letterSpacing, color: strColor, fontSize: _fontSize});
				_tf.styleSheet = css;
			}
			else
			{
				_tf.styleSheet = null;
				var textformat:TextFormat = _tf.defaultTextFormat;
				if (textformat == null)
				{
					textformat = new TextFormat();
				}
				if (textformat != null)
				{
					textformat.color = _fontColor;
					if (_bVertical)
					{
						textformat.leading = _letterSpacing;
					}
					else
					{
						textformat.letterSpacing = _letterSpacing;
					}
					textformat.size = _fontSize;
					textformat.font = _fontName;
					textformat.bold = _bold;
					textformat.underline = _underLine;
					
					_tf.defaultTextFormat = textformat;
				}
			}
			if (_bMiaobian)
			{
				var filter:GlowFilter = new GlowFilter(_miaoBianColor, 1, 2, 2, 16);
				_tf.filters = [filter];
			}
		}
		
		///////////////////////////////////
		// public methods
		///////////////////////////////////
		
		/**
		 * Draws the visual ui of the component.
		 */
		override public function draw():void
		{
			_bValid = true;
			super.draw();
			setTextFormat();
			
			var strDraw:String;
			if (_bVertical)
			{
				var i:int;
				strDraw = "";
				if (_text.length > 0)
				{
					strDraw = _text.charAt(0);
					for (i = 1; i < _text.length; i++)
					{
						strDraw += "\n" + _text.charAt(i);
					}
				}
			}
			else
			{
				strDraw = _text;
			}
			
			if (_isHtmltext)
			{
				_tf.htmlText = strDraw;
			}
			else
			{
				_tf.text = strDraw;
			}
			
			if (_bSizeChangeFlag == false)
			{
				return;
			}
			_bSizeChangeFlag = false;
			if (_autoSize)
			{
				
				var w:Number;
				var h:Number;
				if (_bVertical)
				{
					w = _tf.width;
					h = _tf.height;
				}
				else
				{
					w = _tf.width - _letterSpacing;
					h = _tf.height;
				}
				
				if (_width != w || _height != h)
				{
					this.setSize(w, h);
				}
			}
			else
			{
				//_tf.x = this.width / 2;
				//_tf.width = 0;
				//_tf.text = strDraw;
			}
			//_height = _tf.height = _fontSize + 4;
			
			if (this.parent is PushButton)
			{
				(this.parent as PushButton).invalidate();
			}
		
		}
		
		override public function setSize(w:Number, h:Number):void 
		{
			_width = w;
			_height = h;
		}
		
		override public function set width(w:Number):void
		{
			_width = w;			
		}
		
		override public function set height(h:Number):void
		{
			_height = h;		
		}
		
		public function setFontColor(color:uint):void
		{
			_fontColor = color;
			invalidate();
		}
		
		public function setFontName(fontName:String):void
		{
			_fontName = fontName;
			invalidate();
		}
		
		public function setFontSize(size:uint):void
		{
			_bSizeChangeFlag = true;
			_fontSize = size;
			invalidate();
		}
		
		public function setBold(bold:Boolean):void
		{
			_bSizeChangeFlag = true;
			_bold = bold;
			invalidate();
		}
		
		public function setLetterSpacing(letterSpacing:uint):void
		{
			_bSizeChangeFlag = true;
			_letterSpacing = letterSpacing;
			invalidate();
		}
		
		public function setMiaoBianColor(miaoBianColor:uint):void
		{
			_miaoBianColor = miaoBianColor;
			invalidate();
		}
		
		public function set underline(bFlag:Boolean):void
		{
			_underLine = bFlag;
			invalidate();
		}
		
		public function flush():void
		{
			onInvalidate(null);
		}
		
		override protected function onInvalidate(event:Event):void
		{
			_bValid = false;
			super.onInvalidate(event);
		}
		
		///////////////////////////////////
		// event handlers
		///////////////////////////////////
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		/**
		 * Gets / sets the text of this Label.
		 */
		public function set text(t:String):void
		{
			_bSizeChangeFlag = true;
			_isHtmltext = false;
			if (t == null)
			{
				t = "";
			}
			_text = t;
			invalidate();
		}
		
		public function get intText():int
		{
			return parseInt(_text);
		}
		
		public function set intText(i:int):void
		{
			this.text = i.toString();
		}
		
		public function set htmlText(t:String):void
		{
			_bSizeChangeFlag = true;
			_isHtmltext = true;
			_text = t;
			if (_bold)
			{
				_text = "<b>" + _text +"</b>"
			}
			_text = "<body>" + _text + "</body>";
			invalidate();
		}
		
		public function get text():String
		{
			return _text;
		}
		
		/**
		 * Gets / sets whether or not this Label will autosize.
		 */
		public function set autoSize(b:Boolean):void
		{
			_autoSize = b;
		}
		
		public function get autoSize():Boolean
		{
			return _autoSize;
		}
		
		public function set embedFonts(b:Boolean):void
		{
			_tf.embedFonts = b;
		}
		
		/*
		 * 调用此函数的前提是 _autoSize == false
		 */
		public function set align(align:int):void
		{
			autoSize = false;
			
			_align = align;
			if (_align == Component.CENTER)
			{
				_tf.autoSize = TextFieldAutoSize.CENTER;
				_tf.x = 0;
				if (width < 4)
				{
					this.width = 4
				}
				_tf.width = this.width;
			}
			else if (align == Component.RIGHT)
			{
				_tf.autoSize = TextFieldAutoSize.RIGHT;
				_tf.width = this.width;
			}
		
		}
		
		public function set vertical(v:Boolean):void
		{
			_bVertical = v;
		}
		
		public function get vertical():Boolean
		{
			return _bVertical;
		}
		
		public function get letterSpace():uint
		{
			return _letterSpacing;
		}
		
		public function set miaobian(b:Boolean):void
		{
			_bMiaobian = b;
		}
		
		public function get valid():Boolean
		{
			return _bValid;
		}
		
		public function get fontSize():uint
		{
			return _fontSize;
		}
		
		/**
		 * Gets the internal TextField of the label if you need to do further customization of it.
		 */
		public function get textField():TextField
		{
			return _tf;
		}
		
		// 获取标签中文本的宽度
		public function textWidth():uint
		{
			return _tf.textWidth;
		}
	}
}