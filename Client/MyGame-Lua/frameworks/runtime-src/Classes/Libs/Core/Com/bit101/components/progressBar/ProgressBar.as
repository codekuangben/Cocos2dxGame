/**
 * ProgressBar.as
 * Keith Peters
 * version 0.9.10
 * 
 * A progress bar component for showing a changing value in relation to a total.
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
 
package com.bit101.components.progressBar
{
	import com.bit101.components.Component;
	import com.bit101.components.PanelContainer;
	import flash.display.DisplayObjectContainer;
	//import flash.events.Event;
	
	public class ProgressBar extends PanelContainer
	{		
		protected var _bar:IBarInProgress;
		protected var _value:Number = 0;
		protected var _max:Number = 1;

		/**
		 * Constructor
		 * @param parent The parent DisplayObjectContainer on which to add this ProgressBar.
		 * @param xpos The x position to place this component.
		 * @param ypos The y position to place this component.
		 */
		public function ProgressBar(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number =  0)
		{
			super(parent, xpos, ypos);		
		}
		
		//需要先设置ProgressBar的width,然后再调用setBar，否则_bar.setTotalWidth的参数是不正确的
		public function setBar(bar:IBarInProgress):void
		{
			_bar = bar;
			this.addChild(_bar as Component);			
		}	
	
		override public function set opaqueBackground(value:Object):void 
		{
			super.opaqueBackground = value;
		}
		
		public function set initValue(v:Number):void
		{			
			_bar.initValue = v;
		}
		public function initBar():void
		{			
			_bar.initBar();
		}
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		/**
		 * Gets / sets the maximum value of the ProgressBar.
		 */
		public function set maximum(m:Number):void
		{
			_max = m;
			if (_bar != null)
			{
				_bar.maximum = _max;
			}			
		}
		public function get maximum():Number
		{
			return _max;
		}
		
		/**
		 * Gets / sets the current value of the ProgressBar.
		 */
		public function set value(v:Number):void
		{
			_value = Math.min(v, _max);
			if (_bar != null)
			{
				_bar.value = v;
			}
		}
		public function get value():Number
		{
			return _value;
		}
		public function get bar():IBarInProgress
		{
			return _bar;
		}
		
	}
}