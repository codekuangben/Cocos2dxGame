/**
 * Text.as
 * Keith Peters
 * version 0.9.10
 * 
 * A Text component for displaying multiple lines of text.
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
	//import com.dgrigg.utils.SkinManager;
	//import com.dgrigg.utils.UIConst;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.StyleSheet;
	
	[Event(name="change", type="flash.events.Event")]
	public class Text extends Component
	{
		public var _tf:TextField;
		public var _text:String = "";
		public var _editable:Boolean = true;
		public var _selectable:Boolean = true;
		public var _html:Boolean = false;
		public var _format:TextFormat;
		
		/**
		 * Constructor
		 * @param parent The parent DisplayObjectContainer on which to add this Label.
		 * @param xpos The x position to place this component.
		 * @param ypos The y position to place this component.
		 * @param text The initial text to display in this component.
		 */
		public function Text(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number =  0, text:String = "")
		{
			this.text = text;
			super(parent, xpos, ypos);
			setSize(200, 100);
			
			//skin = SkinManager.getUISkin(UIConst.UISText);
		}
		
		/**
		 * Creates and adds the child display objects of this component.
		 */
		override protected function addChildren():void
		{					
			//_format = new TextFormat(Style.fontName, Style.fontSize, Style.LABEL_TEXT);
			
			_tf = new TextField();
			_tf.x = 2;
			_tf.y = 2;
			_tf.height = _height;
			//_tf.embedFonts = Style.embedFonts;
			_tf.multiline = true;
			_tf.wordWrap = true;
			_tf.selectable = true;
			//_tf.type = TextFieldType.INPUT;
			//_tf.defaultTextFormat = _format;
			_tf.addEventListener(Event.CHANGE, onChange);			
			addChild(_tf);
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
			
			_tf.width = _width;
			_tf.height = _height;
			if(_html)
			{
				_tf.htmlText = _text;
			}
			else
			{
				_tf.text = _text;
				if (_format)
				{
					_tf.setTextFormat(_format);
				}
			}
			if(_editable)
			{
				_tf.mouseEnabled = true;
				_tf.selectable = true;
				_tf.type = TextFieldType.INPUT;
			}
			else
			{
				_tf.mouseEnabled = _selectable;
				_tf.selectable = _selectable;
				_tf.type = TextFieldType.DYNAMIC;
			}
			
		}
		
		///////////////////////////////////
		// event handlers
		///////////////////////////////////
		
		/**
		 * Called when the text in the text field is manually changed.
		 */
		protected function onChange(event:Event):void
		{
			_text = _tf.text;
			dispatchEvent(event);
		}
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		/**
		 * Gets / sets the text of this Label.
		 */
		public function set text(t:String):void
		{
			_text = t;
			if(_text == null) _text = "";
			invalidate();
		}
		public function get text():String
		{
			return _text;
		}
		
		/**
		 * Returns a reference to the internal text field in the component.
		 */
		public function get textField():TextField
		{
			return _tf;
		}
		
		/**
		 * Gets / sets whether or not this text component will be editable.
		 */
		public function set editable(b:Boolean):void
		{
			_editable = b;
			invalidate();
		}
		public function get editable():Boolean
		{
			return _editable;
		}
		
		/**
		 * Gets / sets whether or not this text component will be selectable. Only meaningful if editable is false.
		 */
		public function set selectable(b:Boolean):void
		{
			_selectable = b;
			invalidate();
		}
		public function get selectable():Boolean
		{
			return _selectable;
		}
		
		/**
		 * Gets / sets whether or not text will be rendered as HTML or plain text.
		 */
		public function set html(b:Boolean):void
		{
			_html = b;
			invalidate();
		}
		public function get html():Boolean
		{
			return _html;
		}

		public function setCSS(label:String, obj:Object):void
		{
			var css:StyleSheet = new StyleSheet();
			css.setStyle(label, obj);
			this._tf.styleSheet = css;
		}
        /**
         * Sets/gets whether this component is enabled or not.
         */
        public override function set enabled(value:Boolean):void
        {
            super.enabled = value;
            _tf.tabEnabled = value;
        }
		
		public function set textformat(tf:TextFormat):void
		{
			_format = tf;
		}
	}
}