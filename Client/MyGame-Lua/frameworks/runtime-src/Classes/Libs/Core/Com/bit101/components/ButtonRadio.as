/**
 * RadioButton.as
 * Keith Peters
 * version 0.9.10
 * 
 * A basic radio button component, meant to be used in groups, where only one button in the group can be selected.
 * Currently only one group can be created.
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
	
	public class ButtonRadio extends Button2State 
	{
		protected var _groupID:int;		
		
	
		public function ButtonRadio(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0, defaultHandler:Function = null) 
		{
			super(parent, xpos, ypos, defaultHandler);			
		}	
		
		override public function set selected(value:Boolean):void
		{
			if (_selected == value)
			{
				return;
			}
			
			_selected = value;
			if (value == true)
			{
				notifyOthers();
			}
			
			updateSkin(this.state);			
		}
		
		protected function notifyOthers():void
		{
			if (this.parent != null)
			{
				var i:int;
				var btn:ButtonRadio;
				for (i = 0; i < this.parent.numChildren; i++)
				{
					btn = this.parent.getChildAt(i) as ButtonRadio;
					if (btn != null && btn != this && this.goupID == btn.goupID)
					{
						btn.selected = false;
					}
				}
			}
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