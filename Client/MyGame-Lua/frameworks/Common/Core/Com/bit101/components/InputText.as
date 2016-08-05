/**
 * InputText.as
 * Keith Peters
 * version 0.9.10
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
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	
	public class InputText extends PanelContainer
	{
		protected var _password:Boolean = false;
		protected var _number:Boolean = false; //true-表示只能输入数字
		protected var _minNumber:int = 0;
		protected var _maxNumber:int = int.MAX_VALUE;
		protected var _text:String = "";
		protected var _tf:TextField;
		protected var _back:Sprite;
		protected var _marginLeft:Number = 0;
		
		/**
		 * Constructor
		 * @param parent The parent DisplayObjectContainer on which to add this InputText.
		 * @param xpos The x position to place this component.
		 * @param ypos The y position to place this component.
		 * @param text The string containing the initial text of this component.
		 * @param defaultHandler The event handling function to handle the default event for this component (change in this case).
		 */
		public function InputText(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0, text:String = "", defaultHandler:Function = null)
		{
			this.text = text;
			super(parent, xpos, ypos);
			if (defaultHandler != null)
			{
				addEventListener(Event.CHANGE, defaultHandler);
			}
			
			_tf = new TextField();
			_tf.selectable = true;
			_tf.type = TextFieldType.INPUT;
			_tf.defaultTextFormat = new TextFormat("Courier New", 14, 0x333333);
			addChild(_tf);
			_tf.addEventListener(Event.CHANGE, onChange);
			this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			setSize(100, 16);
		}
		
		/**
		 * Initializes the component.
		 */
		/*override protected function init():void
		{
			super.init();
			setSize(100, 16);
		}*/
		
		public function setTextFormat(color:uint = 0xfbdda2, size:uint = 12, bold:Boolean = false, letterSpacing:int = 1):void
		{
			var tformat:TextFormat = new TextFormat(null, size, color, bold);
			tformat.letterSpacing = letterSpacing;
			_tf.defaultTextFormat = tformat;
		}
		
		private function onMouseDown(e:MouseEvent):void
		{
			if (e.target != _tf)
			{
				if (focus == false)
				{
					focus = true;
				}
				var pos:int;
				if (e.localX <= _tf.x)
				{
					pos = 0;
				}
				else
				{
					pos = _tf.length;
				}
				_tf.setSelection(pos, pos);
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
			super.draw();
			_tf.displayAsPassword = _password;
			
			if (_tf.autoSize != TextFieldAutoSize.CENTER)
			{
				_tf.width = _width - 4;
				
				_tf.x = _marginLeft;
				
			}
			else
			{
				_tf.x = 0;
				_tf.width = this.width;
			}
			
			if (_text != null)
			{
				_tf.text = _text;
			}
			else
			{
				_tf.text = "";
			}
			
			if (_tf.text == "")
			{
				_tf.text = "X";
				_tf.height = _tf.textHeight +4;
				_tf.text = "";
			}
			else
			{
				_tf.height = _tf.textHeight +4;
			}
			
			_tf.y = Math.round((_height - _tf.height)*0.5);
		
		}
		
		public function showBack():void
		{
			_back = new Sprite();
			_back.filters = [getShadow(2, true)];
			addChild(_back);
			this.setChildIndex(_back, 0);
			
			_back.graphics.clear();
			_back.graphics.beginFill(0xCCCCCC);
			_back.graphics.drawRect(0, 0, _width, _height);
			_back.graphics.endFill();
		}
		
		///////////////////////////////////
		// event handlers
		///////////////////////////////////
		
		/**
		 * Internal change handler.
		 * @param event The Event passed by the system.
		 */
		protected function onChange(event:Event):void
		{
			_text = _tf.text;
			if (_number)
			{
				var n:Number = parseInt(_text);
				if (isNaN(n))
				{
					n = _minNumber;
				}
				var newValue:Number;
				if (n < _minNumber)
				{
					newValue = _minNumber;
				}
				else if (n > _maxNumber)
				{
					newValue = _maxNumber;
				}
				else
				{
					newValue = n;
				}
				if (n != newValue)
				{
					_text = newValue.toString();
					this.draw();
				}
			}
			event.stopImmediatePropagation();
			dispatchEvent(event);
		}
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		/**
		 * Gets / sets the text shown in this InputText.
		 */
		public function set text(t:String):void
		{
			_text = t;
			if (_text == null)
				_text = "";
			invalidate();
		}
		
		public function get text():String
		{
			return _text;
		}
		
		//获取内容的数字形式
		public function get intText():int
		{
			return parseInt(_text);
		}
		
		//获取内容的数字形式
		public function set intText(n:int):void
		{
			text = n.toString();
		}
		
		/**
		 * Returns a reference to the internal text field in the component.
		 */
		public function get textField():TextField
		{
			return _tf;
		}
		
		/**
		 * Gets / sets the list of characters that are allowed in this TextInput.
		 */
		public function set restrict(str:String):void
		{
			_tf.restrict = str;
		}
		
		public function get restrict():String
		{
			return _tf.restrict;
		}
		
		/**
		 * Gets / sets the maximum number of characters that can be shown in this InputText.
		 */
		public function set maxChars(max:int):void
		{
			_tf.maxChars = max;
		}
		
		public function get maxChars():int
		{
			return _tf.maxChars;
		}
		
		/**
		 * Gets / sets whether or not this input text will show up as password (asterisks).
		 */
		public function set password(b:Boolean):void
		{
			_password = b;
			invalidate();
		}
		
		public function get password():Boolean
		{
			return _password;
		}
		
		public function set number(b:Boolean):void
		{
			_number = b;
			_tf.restrict = "0-9";
		}
		
		public function set maxNumber(n:int):void
		{
			_maxNumber = n;
		}
		
		public function get maxNumber():int
		{
			return _maxNumber;
		}
		
		public function set minNumber(n:int):void
		{
			_minNumber = n;
		}
		
		public function get minNumber():int
		{
			return _minNumber;
		}
		
		/**
		 * Sets/gets whether this component is enabled or not.
		 */
		public override function set enabled(value:Boolean):void
		{
			super.enabled = value;
			_tf.tabEnabled = value;
		}
		
		public function set align(align:int):void
		{
			if (align == Component.CENTER)
			{
				//_tf.width = 4;
				_tf.autoSize = TextFieldAutoSize.CENTER;
				//_tf.width = this.width;
				_tf.x = (_width-_tf.width)/2;
				
			}
		}
		
		public function set focus(b:Boolean):void
		{
			if (b)
			{
				_tf.setSelection(_tf.length, _tf.length);
				m_con.m_mainStage.focus = _tf;
			}
			else
			{
				if (m_con.m_mainStage.focus != _tf)
				{
					m_con.m_mainStage.focus = null;
				}
			}
		}
		
		public function get focus():Boolean
		{
			return m_con.m_mainStage.focus == _tf;
		}
		
		public function set marginLeft(value:Number):void
		{
			_marginLeft = value;
		}
	}
}