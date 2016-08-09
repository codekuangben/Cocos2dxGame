/**
 * VScrollBar.as
 * Keith Peters
 * version 0.9.10
 * 
 * A vertical scroll bar for use in other components. 
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
	//import com.dgrigg.image.ButtonImage;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import com.dgrigg.skins.VerticalImageSkin
	
	public class VScrollBar extends ScrollBar
	{
		/**
		 * Constructor
		 * @param parent The parent DisplayObjectContainer on which to add this ScrollBar.
		 * @param xpos The x position to place this component.
		 * @param ypos The y position to place this component.
		 * @param defaultHandler The event handling function to handle the default event for this component (change in this case).
		 */
		public function VScrollBar(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0, defaultHandler:Function=null)
		{
			super(Slider.VERTICAL, parent, xpos, ypos, defaultHandler);
		}
		
		public function setVerticalImageSkinByName(name:String):void
		{
			var image:VerticalImageSkin = new VerticalImageSkin();
			if (false == image.setCommonImageByName(name))
			{
				image = null;
				return;
			}
			this.skin = image;
		}
		
		override protected function addChildren():void
		{
			this.width = 18;
			setVerticalImageSkinByName("scrollbackground");
			
			_scrollSlider = new ScrollSlider(Slider.VERTICAL, this, 0, 10, onChange);	
			_scrollSlider.x = 0;
			_scrollSlider.setHandleVerticalImageByName("scrollthumb");
			_scrollSlider.width = width;
			_scrollSlider.y = width;
			
			
			_upButton = new PushButton(this, 0, 0);
			_upButton.setPanelImageSkin("scrollupbtn");
			_upButton.addEventListener(MouseEvent.MOUSE_DOWN, onUpClick);
			_upButton.setSize(width, width);
			
			_downButton = new PushButton(this, 0, 0);
			_downButton.setPanelImageSkin("scrolldownbtn");
			_downButton.addEventListener(MouseEvent.MOUSE_DOWN, onDownClick);
			_downButton.setSize(width, width);		
			
		}
		override public function set height(h:Number):void
		{
			if (h < (_downButton.height + _upButton.height))
			{
				return;
			}
			super.height = h;
			_scrollSlider.height = h - (_downButton.height + _upButton.height);
			_downButton.y = h - _downButton.height;
		}
	}
}