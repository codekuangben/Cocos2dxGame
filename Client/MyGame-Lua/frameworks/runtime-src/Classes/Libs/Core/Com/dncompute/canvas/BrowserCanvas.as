package com.dncompute.canvas {
	/**
	 * 
	 *  Copyright (c) 2008 Noel Billig (http://www.dncompute.com)
	 * 
	 *	Permission is hereby granted, free of charge, to any person obtaining a copy
	 *	of this software and associated documentation files (the "Software"), to deal
	 *	in the Software without restriction, including without limitation the rights
	 *	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
	 *	copies of the Software, and to permit persons to whom the Software is
	 *	furnished to do so, subject to the following conditions:
	 *	
	 *	The above copyright notice and this permission notice shall be included in
	 *	all copies or substantial portions of the Software.
	 *	
	 *	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	 *	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	 *	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
	 *	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
	 *	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
	 *	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
	 *	THE SOFTWARE. 
	 *	
	 */
	 
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.external.ExternalInterface;

	/**
	 *
	 *	This class encapsulates all of the code to resize an embedded
	 *	flash movie on an HTML page.
	 *
	 *	This class currently applies a collection of browser "hacks" to help
	 *	ease the use of this class cross browser. However, depending on how
	 *	complicated your usage is, it may be worthwhile to turn off hacks that
	 *	are not necessary to use. For instance, if you don't use any of the
	 *	min/max settings, you can turn off the IEReparenting.
	 *
	 *	If you run into any issues with this class, please post comments into
	 *	my blog so I can look into issues. Even better is if you can post fixes
	 *	for any issues you run into ;-)
	 *
	 * 
	 */
	public class BrowserCanvas {
		public static const HACK_MARGIN_BOTTOM:String = "marginBottom"; //Adds a negative bottom margin to object tags to compensate for browser weirdness
		public static const HACK_IE_REPARENT:String = "IEReparent"; //In IE, create a container div which encapsulates the object tag in order to hav min/max sizes work
		public static const HACK_UNIQUE_ID:String = "uniqueId"; //If you put both an embed and object tag with the same id, this tries to compensate
		
		private var stage:Stage;
		
		private var containerId:String;
		
		private var _width:String;
		private var _minWidth:String;
		private var _maxWidth:String;
		
		private var _height:String;
		private var _minHeight:String;
		private var _maxHeight:String;
		
		private var timerSprite:Sprite;
		
		/**
		 * 
		 * @param stage - A reference to the stage. We use the url of the stages loaderinfo object
		 *    as a way to figure out if we are targeting the right flash movie (for cases where an
		 *    id is not passed)
		 *    
		 * @param containerId - We use the containerId as a reference to the div/obj/embed we should 
		 *    resize. You should always send a containerId if you have multiple instances of the 
		 *    same flash movie embedded in a page.
		 *    
		 * @param browserHacks - A list of flags indicating which hacks to apply. This defaults to 
		 *    applying all hacks. In order to overcome browser differences and HMTL errors, you can 
		 *    turn these hacks on or off by sending in the appropriate flag. To turn them all off, 
		 *    send in an empty array.
		 */
		public function BrowserCanvas(stage:Stage,containerId:String=null,browserHacks:Array=null) {
			//trace("BrowserCanvas - Copyright (c) 2008 Noel Billig (http://www.dncompute.com)");
			
			this.stage = stage;
			
			timerSprite = new Sprite();
			_width = String( stage.stageWidth );
			_height = String( stage.stageHeight );
			if (browserHacks == null) browserHacks = [HACK_MARGIN_BOTTOM,HACK_IE_REPARENT,HACK_UNIQUE_ID];
			
			this.containerId = containerId;
			if (this.containerId == null) 
			{
				if (ExternalInterface.available)
				{
					this.containerId = ExternalInterface.objectID;
				}
			}
			if (this.containerId == null) 
			{
				if (ExternalInterface.available)
				{
					this.containerId = ExternalInterface.call(JSScripts.GET_FLASH_ID, stage.loaderInfo.url);
				}
			}
			
			if (browserHacks.length != 0) {
				if (ExternalInterface.available)
				{
					this.containerId = ExternalInterface.call(JSScripts.INSERT_BROWSER_HACKS, this.containerId, browserHacks.join(","));
				}
			}
		}
		
		public function set width(newWidth:String):void {
			this._width = formatSize(newWidth);
			invalidate();
		}
		
		public function set minWidth(newWidth:String):void {
			this._minWidth = formatSize(newWidth);
			invalidate();
		}
		
		public function set maxWidth(newWidth:String):void {
			this._maxWidth = formatSize(newWidth);
			invalidate();
		}
		
		public function set height(newHeight:String):void {
			this._height = formatSize(newHeight);
			invalidate();
		}
		
		public function set minHeight(newHeight:String):void {
			this._minHeight = formatSize(newHeight);
			invalidate();
		}
		
		public function set maxHeight(newHeight:String):void {
			this._maxHeight = formatSize(newHeight);
			invalidate();
		}
		
		private function formatSize(size:String):String {
			if (size == null) return ""; //Null causes opera to never clear the appropriate values, so use empty string
			return (int(size) == 0) ? size : size+"px";
		}
		
		private function invalidate():void {
			timerSprite.addEventListener(Event.ENTER_FRAME,update);
		}
		
		private function update(event:Event):void {
			timerSprite.removeEventListener(Event.ENTER_FRAME, update);
			if (ExternalInterface.available)
			{
				ExternalInterface.call(JSScripts.RESIZE_CONTAINER, containerId, _width, _height, _minWidth, _minHeight, _maxWidth, _maxHeight);
			}
		}
	}
}