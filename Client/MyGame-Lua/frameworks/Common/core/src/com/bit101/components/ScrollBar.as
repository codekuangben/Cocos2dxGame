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
	//import adobe.utils.CustomActions;
	
	//import com.dgrigg.utils.SkinManager;
	//import com.dgrigg.utils.UIConst;
	
	import flash.display.DisplayObjectContainer;
	//import flash.display.Shape;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	[Event(name="change", type="flash.events.Event")]
	public class ScrollBar extends Component
	{
		protected const DELAY_TIME:int = 500;
		protected const REPEAT_TIME:int = 100; 
		protected const UP:String = "up";
		protected const DOWN:String = "down";

        public var _autoHide:Boolean = true;
		public var _hideSlider:Boolean;
		public var _upButton:PushButton;
		public var _downButton:PushButton;
		public var _scrollSlider:ScrollSlider;
		public var _orientation:String;
		protected var _lineSize:int = 1;
		protected var _delayTimer:Timer;
		protected var _repeatTimer:Timer;
		protected var _direction:String;
		protected var _shouldRepeat:Boolean = false;
		protected var _numTotalData:int = 0;	//数据的总数量
		protected var m_changeCB:Function;
		
		/**
		 * Constructor
		 * @param orientation Whether this is a vertical or horizontal slider.
		 * @param parent The parent DisplayObjectContainer on which to add this Slider.
		 * @param xpos The x position to place this component.
		 * @param ypos The y position to place this component.
		 * @param defaultHandler The event handling function to handle the default event for this component (change in this case).
		 */
		public function ScrollBar(orientation:String, parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0, defaultHandler:Function = null)
		{
			_orientation = orientation;
			super(parent, xpos, ypos);
			if(defaultHandler != null)
			{
				m_changeCB = defaultHandler;
				addEventListener(Event.CHANGE, defaultHandler);
			}
			
			if(_orientation == Slider.HORIZONTAL)
			{
				setSize(100, 10);
			}
			else
			{
				//setSize(10, 100);
			}
			_delayTimer = new Timer(DELAY_TIME, 1);
			_delayTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onDelayComplete);
			_repeatTimer = new Timer(REPEAT_TIME);
			_repeatTimer.addEventListener(TimerEvent.TIMER, onRepeat);
			this.visible = false;
		}
		
		override public function dispose():void
		{
			if(m_changeCB != null)
			{
				removeEventListener(Event.CHANGE, m_changeCB);
				m_changeCB = null;
 			}
			
			_delayTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, onDelayComplete);
			_repeatTimer.removeEventListener(TimerEvent.TIMER, onRepeat);

			super.dispose();
		}		
	
		///////////////////////////////////
		// public methods
		///////////////////////////////////
		
		/**
		 * Convenience method to set the three main parameters in one shot.
		 * @param min The minimum value of the slider.
		 * @param max The maximum value of the slider.
		 * @param value The value of the slider.
		 */
		public function setSliderParams(min:Number, max:Number):void
		{
			_scrollSlider.setSliderParams(min, max);
		}
		
	

		///////////////////////////////////
		// getter/setters
		///////////////////////////////////

        /**
         * Sets / gets whether the scrollbar will auto hide when there is nothing to scroll.
         */
        public function set autoHide(value:Boolean):void
        {
            _autoHide = value;
			if (_autoHide == false)
			{
				this.visible = true;
			}
            invalidate();
        }
        public function get autoHide():Boolean
        {
            return _autoHide;
        }
		
		

		/**
		 * Sets / gets the current value of this scroll bar.
		 */
		public function set value(v:Number):void
		{
			_scrollSlider.value = v;
		}
		public function get value():Number
		{
			return _scrollSlider.value;
		}
		
		/**
		 * Sets / gets the minimum value of this scroll bar.
		 */
		public function set minimum(v:Number):void
		{
			_scrollSlider.minimum = v;
		}
		public function get minimum():Number
		{
			return _scrollSlider.minimum;
		}
		
		/**
		 * Sets / gets the maximum value of this scroll bar.
		 */
		public function set maximum(v:Number):void
		{
			_scrollSlider.maximum = v;
		}
		public function get maximum():Number
		{
			return _scrollSlider.maximum;
		}
		
		/**
		 * Sets / gets the amount the value will change when up or down buttons are pressed.
		 */
		public function set lineSize(value:int):void
		{
			_lineSize = value;
		}
		public function get lineSize():int
		{
			return _lineSize;
		}
		
		/**
		 * Sets / gets the amount the value will change when the back is clicked.
		 */
		public function set pageSize(value:int):void
		{
			_scrollSlider.pageSize = value;
			invalidate();
		}
		public function get pageSize():int
		{
			return _scrollSlider.pageSize;
		}
		
		public function set numTotalData(num:int):void
		{			
			if (_scrollSlider.numTotalData == num)
			{
				return;
			}
			_scrollSlider.numTotalData = num;	
			var bNeedScroll:Boolean = num > _scrollSlider.pageSize ? true : false;
			
			_scrollSlider.setSliderParams(0, bNeedScroll ?   num - _scrollSlider.pageSize:0);
			if (this.autoHide)
			{				
				if (_hideSlider)
				{
					if (bNeedScroll != _scrollSlider.visible)
					{
						_scrollSlider.visible = bNeedScroll;
						upButton.enabled = bNeedScroll;
						downButton.enabled = bNeedScroll;
					}
				}
				else
				{
					if (bNeedScroll != this.visible)
					{
						this.visible = bNeedScroll;
					}
				}				
			}
		}
		public function get orientation():String 
		{
			return _orientation;
		}
		
		public function set orientation(value:String):void 
		{
			_orientation = value;
		}
		
		public function get upButton():PushButton 
		{
			return _upButton;
		}
		
		public function set upButton(value:PushButton):void 
		{
			_upButton = value;
		}
		
		public function get downButton():PushButton 
		{
			return _downButton;
		}
		
		public function set downButton(value:PushButton):void 
		{
			_downButton = value;
		}
		
		public function get scrollSlider():ScrollSlider 
		{
			return _scrollSlider;
		}
		
		public function set scrollSlider(value:ScrollSlider):void 
		{
			_scrollSlider = value;
		}		
		
		///////////////////////////////////
		// event handlers
		///////////////////////////////////
		
		protected function onUpClick(event:MouseEvent):void
		{
			goUp();
			_shouldRepeat = true;
			_direction = UP;
			_delayTimer.start();
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseGoUp);
		}
				
		protected function goUp():void
		{
			_scrollSlider.value -= _lineSize;
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		protected function onDownClick(event:MouseEvent):void
		{
			goDown();
			_shouldRepeat = true;
			_direction = DOWN;
			_delayTimer.start();
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseGoUp);
		}
		
		protected function goDown():void
		{
			_scrollSlider.value = _scrollSlider.value + _lineSize;
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		protected function onMouseGoUp(event:MouseEvent):void
		{
			_delayTimer.stop();
			_repeatTimer.stop();
			_shouldRepeat = false;
		}
		
		protected function onChange(event:Event):void
		{
			dispatchEvent(event);
		}
		
		protected function onDelayComplete(event:TimerEvent):void
		{
			if(_shouldRepeat)
			{
				_repeatTimer.start();
			}
		}
		
		protected function onRepeat(event:TimerEvent):void
		{
			if(_direction == UP)
			{
				goUp();
			}
			else
			{
				goDown();
			}
		}
	}
}