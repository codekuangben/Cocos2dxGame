/**
 * Window.as
 * Keith Peters
 * version 0.9.10
 * 
 * A draggable window. Can be used as a container for other components.
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
	import com.dgrigg.skins.PanelImageSkin;
	import com.pblabs.engine.resource.SWFResource;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	//import flash.display.FrameLabel;
	//import flash.display.Shape;
	//import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	[Event(name="select", type="flash.events.Event")]
	[Event(name="close", type="flash.events.Event")]
	[Event(name="resize", type="flash.events.Event")]
	public class Window extends Component
	{	
		public static const EXITMODE_HIDE:int = 1;
		public static const EXITMODE_DESTORY:int = 2;
		
		protected var _id:uint;
		protected var _exitMode:int = EXITMODE_DESTORY;
		protected var m_bInitiated:Boolean = false; //已经初始化
		protected var _draggable:Boolean = true;
		//protected var _minimizeButton:Sprite;
		//protected var _hasMinimizeButton:Boolean = false;
		//protected var _minimized:Boolean = false;
		protected var _backgroundContainer:Panel;
		protected var _hitYMax:int = 30;	// 可点击范围 Y 的最大值
		protected var _alignVertial:int = 0;
		protected var _alignHorizontal:int = 0;
	
		protected var _marginLeft:int;
		protected var _marginTop:int;
		protected var _marginRight:int;
		protected var _marginBottom:int;
		/**
		 * Constructor
		 * @param parent The parent DisplayObjectContainer on which to add this Panel.
		 * @param xpos The x position to place this component.
		 * @param ypos The y position to place this component.
		 * @param title The string to display in the title bar.
		 */
		public function Window(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0)
		{			
			super(parent, xpos, ypos);
		}		
		
		override public function dispose():void
		{
			_backgroundContainer.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseGoDown);
			this.removeEventListener(MouseEvent.MOUSE_UP, onFormMouseGoDown);
			super.dispose();
		}
		
		public function get id():uint
		{
			return _id;
		}
		public function set id(id:uint):void
		{
			_id = id;
		}
		
		public function set exitMode(mode:int):void
		{
			_exitMode = mode;
		}
		
		public function get exitMode():int
		{
			return _exitMode;
		}
		
		public function set alignVertial(align:int):void
		{
			_alignVertial = align;
		}
		
		public function set alignHorizontal(align:int):void
		{
			_alignHorizontal = align;
		}
		
		public function set marginLeft(value:int):void
		{
			_marginLeft = value;
		}
		
		public function set marginRight(value:int):void
		{
			_marginRight = value;
		}
		
		public function set marginTop(value:int):void
		{
			_marginTop = value;
		}
		
		public function set marginBottom(value:int):void
		{
			_marginBottom = value;
		}
		
		public function get alignVertial():int
		{
			return _alignVertial;
		}
		
		public function get alignHorizontal():int
		{
			return _alignHorizontal;
		}
		public function onReady():void
		{
			m_bInitiated = true;
		}
		/**
		 * Creates and adds the child display objects of this component.
		 */
		override protected function addChildren():void
		{
			_backgroundContainer = new Panel();
			this.addChild(_backgroundContainer);			
			
			_backgroundContainer.addEventListener(MouseEvent.MOUSE_DOWN, onMouseGoDown);
			this.addEventListener(MouseEvent.MOUSE_DOWN, onFormMouseGoDown);
		}
		
		///////////////////////////////////
		// public methods
		///////////////////////////////////
		
		public override function addBackgroundChild(child:DisplayObject):DisplayObject
		{
			_backgroundContainer.addChild(child);			
			return child;
		}
		public override function removeBackgroundChild(child:DisplayObject):DisplayObject
		{
			_backgroundContainer.removeChild(child);
			return child;
		}		
		///////////////////////////////////
		// event handlers
		///////////////////////////////////
		
		/**
		 * Internal mouseDown handler. Starts a drag.
		 * @param event The MouseEvent passed by the system.
		 */
		protected function onMouseGoDown(event:MouseEvent):void
		{
			if(_draggable && _backgroundContainer.mouseY < _hitYMax)
			{
				this.startDrag();
				stage.addEventListener(MouseEvent.MOUSE_UP, onMouseGoUp);				
			}
			
			//dispatchEvent(new Event(Event.SELECT));
		}
		protected function onFormMouseGoDown(event:MouseEvent):void
		{
			if (parent)
			{
				parent.addChild(this); // move to top
			}
		}
		/**
		 * Internal mouseUp handler. Stops the drag.
		 * @param event The MouseEvent passed by the system.
		 */
		protected function onMouseGoUp(event:MouseEvent):void
		{
			this.stopDrag();
			stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseGoUp);
		}	
		
		protected function onClose(event:MouseEvent):void
		{
			dispatchEvent(new Event(Event.CLOSE));
		}
		
		public function setImageSkinBySWF(swf:SWFResource, name:String):void
		{
			var localSkin:PanelImageSkin = new PanelImageSkin();
			localSkin.setImageBySWF(swf, name);
			this.skin = localSkin;
		}
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////	
					
		/**
		 * Container for content added to this panel. This is just a reference to the content of the internal Panel, which is masked, so best to add children to content, rather than directly to the window.
		 */
		/*public function get content():DisplayObjectContainer
		{
			return _panel.content;
		}
		*/
		/**
		 * Sets / gets whether or not the window will be draggable by the title bar.
		 */
		public function set draggable(b:Boolean):void
		{
			_draggable = b;			
		}
		public function get draggable():Boolean
		{
			return _draggable;
		}
		
		/**
		 * Gets / sets whether or not the window will show a minimize button that will toggle the window open and closed. A closed window will only show the title bar.
		 */
		/*public function set hasMinimizeButton(b:Boolean):void
		{
			_hasMinimizeButton = b;
			if(_hasMinimizeButton)
			{
				super.addChild(_minimizeButton);
			}
			else if(contains(_minimizeButton))
			{
				removeChild(_minimizeButton);
			}
			invalidate();
		}
		public function get hasMinimizeButton():Boolean
		{
			return _hasMinimizeButton;
		}
		
		/**
		 * Gets / sets whether the window is closed. A closed window will only show its title bar.
		 */
		/*public function set minimized(value:Boolean):void
		{
			_minimized = value;
//			_panel.visible = !_minimized;
			if(_minimized)
			{
				//if(contains(_panel)) removeChild(_panel);
				_minimizeButton.rotation = -90;
			}
			else
			{
				//if(!contains(_panel)) super.addChild(_panel);
				_minimizeButton.rotation = 0;
			}
			dispatchEvent(new Event(Event.RESIZE));
		}
		public function get minimized():Boolean
		{
			return _minimized;
		}*/
	
	}
}