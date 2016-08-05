/**
 * ScrollBar.as
 * Keith Peters
 * version 0.9.10
 * 
 * Base class for HScrollBar and VScrollBar
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
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import com.bit101.components.Slider;
	//import com.bit101.components.Style;

	/**
	 * Helper class for the slider portion of the scroll bar.
	 */
	public class ScrollSlider extends Slider
	{		
		protected var _pageSize:int = 1;
		protected var _numTotalData:int = 1;
		
		/**
		 * Constructor
		 * @param orientation Whether this is a vertical or horizontal slider.
		 * @param parent The parent DisplayObjectContainer on which to add this Slider.
		 * @param xpos The x position to place this component.
		 * @param ypos The y position to place this component.
		 * @param defaultHandler The event handling function to handle the default event for this component (change in this case).
		 */
		public function ScrollSlider(orientation:String, parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0, defaultHandler:Function = null)
		{
			super(orientation, parent, xpos, ypos);
			if(defaultHandler != null)
			{
				addEventListener(Event.CHANGE, defaultHandler);
			}
			
			backClick = true;
		}
		
		
		override public function draw():void
		{
			super.draw();	
			this.graphics.beginFill(0, 0);
			this.graphics.drawRect(0, 0, width, height);
			this.graphics.endFill();
			updateHandleHeight();
			positionHandle();
		}		
		
		/**
		 * Adjusts position of handle when value, maximum or minimum have changed.
		 * TODO: Should also be called when slider is resized.
		 */
		protected override function positionHandle():void
		{
			var range:Number;
			if(_orientation == HORIZONTAL)
			{
				range = width - _handle.width;
				_handle.x = (_value - _min) / (_max - _min) * range;
			}
			else
			{
				range = height - _handle.height;
				_handle.y = (_value - _min) / (_max - _min) * range;
			}
		}
		
		///////////////////////////////////
		// event handlers
		///////////////////////////////////
		
		/**
		 * Handler called when user clicks the background of the slider, causing the handle to move to that point. Only active if backClick is true.
		 * @param event The MouseEvent passed by the system.
		 */
		protected override function onBackClick(event:MouseEvent):void
		{
			if (event.target != this)
			{
				return;
			}
			if(_orientation == HORIZONTAL)
			{
				if(mouseX < _handle.x)
				{
					if(_max > _min)
					{
						_value -= _pageSize;
					}
					else
					{
						_value += _pageSize;
					}
					correctValue();
				}
				else
				{
					if(_max > _min)
					{
						_value += _pageSize;
					}
					else
					{
						_value -= _pageSize;
					}
					correctValue();
				}
				positionHandle();
			}
			else
			{
				if(mouseY < _handle.y)
				{
					if(_max > _min)
					{
						_value -= _pageSize;
					}
					else
					{
						_value += _pageSize;
					}
					correctValue();
				}
				else
				{
					if(_max > _min)
					{
						_value += _pageSize;
					}
					else
					{
						_value -= _pageSize;
					}
					correctValue();
				}
				positionHandle();
			}
			dispatchEvent(new Event(Event.CHANGE));
			
		}
		
		/**
		 * Internal mouseDown handler. Starts dragging the handle.
		 * @param event The MouseEvent passed by the system.
		 */
		protected override function onDrag(event:MouseEvent):void
		{
			stage.addEventListener(MouseEvent.MOUSE_UP, onDrop);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onSlide);
			if(_orientation == HORIZONTAL)
			{
				_handle.startDrag(false, new Rectangle(0, 0, _width - _handle.width, 0));
			}
			else
			{
				_handle.startDrag(false, new Rectangle(0, 0, 0, _height - _handle.height));
			}
		}
		
		/**
		 * Internal mouseMove handler for when the handle is being moved.
		 * @param event The MouseEvent passed by the system.
		 */
		protected override function onSlide(event:MouseEvent):void
		{
			var oldValue:Number = _value;
			if(_orientation == HORIZONTAL)
			{
				if(_width == _handle.width)
				{
					_value = _min;
				}
				else
				{
					_value = _handle.x / (_width - _handle.width) * (_max - _min) + _min;
				}
			}
			else
			{
				if(_height == _handle.height)
				{
					_value = _min;
				}
				else
				{
					_value = _handle.y / (_height - _handle.height) * (_max - _min) + _min;
				}
			}
			if(_value != oldValue)
			{
				dispatchEvent(new Event(Event.CHANGE));
			}
		}
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
			
		/**
		 * Sets / gets the amount the value will change when the back is clicked.
		 */
		public function set pageSize(value:int):void
		{
			_pageSize = value;
			this.invalidate();
		}
		public function get pageSize():int
		{
			return _pageSize;
		}

		public function set numTotalData(num:uint):void
		{
			_numTotalData = num;			
			this.invalidate();		
		}
		public function get numTotalData():uint
		{
			return _numTotalData;
		}
		protected function updateHandleHeight():void
		{
			if(_orientation == HORIZONTAL)
			{
				if (_numTotalData <= _pageSize)
				{
					_handle.width = this.width;
				}
				else
				{
					_handle.width = this.width * _pageSize / _numTotalData;
				}
			}
			else
			{
				if (_numTotalData <= _pageSize)
				{
					_handle.height = height;
				}
				else
				{
					_handle.height = Math.floor(height * _pageSize / _numTotalData);
				}
			}
		}
		
	}
}