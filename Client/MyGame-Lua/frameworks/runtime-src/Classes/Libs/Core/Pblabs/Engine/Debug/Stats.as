/**
 * stats.as
 * https://github.com/mrdoob/Hi-ReS-Stats
 * 
 * Released under MIT license:
 * http://www.opensource.org/licenses/mit-license.php
 *
 * How to use:
 * 
 *	addChild( new Stats() );
 *
 **/

package com.pblabs.engine.debug
{
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.system.Capabilities;
	import flash.system.System;
	import flash.text.StyleSheet;
	import flash.text.TextField;
	import flash.utils.getTimer;	

	public class Stats extends Sprite 
	{
		protected const WIDTH : uint = 80;
		//protected const HEIGHT : uint = 125;
		protected const HEIGHT : uint = 110;
		//protected const TEXTHEIGHT : uint = 75;
		protected const TEXTHEIGHT : uint = 60;
		protected const TIMEOUTINTERVAL:uint = 100;

		protected var xml : XML;

		protected var text : TextField;
		protected var style : StyleSheet;

		protected var timer : uint;
		protected var fps : uint;
		protected var ms : uint;
		protected var ms_prev : uint;
		//protected var ms_max : uint;
		protected var mem : Number;
		protected var mem_max : Number;

		protected var graph : BitmapData;
		protected var rectangle : Rectangle;

		protected var fps_graph : uint;
		protected var mem_graph : uint;
		protected var mem_max_graph : uint;

		protected var colors : Colors = new Colors();
		protected var _localData:Object = new Object();	// 局部数据 client 
		protected var _LocalText:TextField;

		/**
		 * <b>Stats</b> FPS, MS and MEM, all in one.
		 */
		public function Stats() : void 
		{
			ms = 0;
			ms_prev = 0;
			//ms_max = 0;
			mem_max = 0;

			//xml = <xml><fps>FPS:</fps><ms>MS:</ms><msmax>MAX:</msmax><mem>MEM:</mem><memMax>MAX:</memMax><version>VER:</version></xml>;
			xml = <xml><fps>FPS:</fps><ms>MS:</ms><mem>MEM:</mem><memMax>MAX:</memMax><version>VER:</version></xml>;

			style = new StyleSheet();
			style.setStyle('xml', {fontSize:'9px', fontFamily:'_sans', leading:'-2px'});
			style.setStyle('fps', {color: hex2css(colors.fps)});
			style.setStyle('ms', {color: hex2css(colors.ms)});
			style.setStyle('mem', {color: hex2css(colors.mem)});
			style.setStyle('memMax', {color: hex2css(colors.memmax)});
			style.setStyle('version', { color: hex2css(colors.version) } );
			//style.setStyle('msmax', {color: hex2css(colors.memmax)});

			text = new TextField();
			text.width = WIDTH;
			text.height = TEXTHEIGHT;
			text.styleSheet = style;
			text.condenseWhite = true;
			text.selectable = false;
			text.mouseEnabled = false;
			
			_LocalText = new TextField;
			_LocalText.selectable = false;
			_LocalText.mouseEnabled = false;
			_LocalText.textColor = 0x00FF00;
			_LocalText.width = 120;
			_LocalText.height = 25;
			_LocalText.background = true;
			_LocalText.visible = false;

			rectangle = new Rectangle(WIDTH - 1, 0, 1, HEIGHT - TEXTHEIGHT);
			
			addEventListener(Event.ADDED_TO_STAGE, init, false, 0, true);
			addEventListener(Event.REMOVED_FROM_STAGE, destroy, false, 0, true);
		}

		private function init(e : Event) : void 
		{
			// 将事件监听器移除    
			this.removeEventListener(Event.ADDED_TO_STAGE, init);
			
			graphics.beginFill(colors.bg);
			graphics.drawRect(0, 0, WIDTH, HEIGHT);
			graphics.endFill();

			addChild(text);
			this.addChild(_LocalText);
			_LocalText.y = HEIGHT;

			graph = new BitmapData(WIDTH, HEIGHT - TEXTHEIGHT, false, colors.bg);
			graphics.beginBitmapFill(graph, new Matrix(1, 0, 0, 1, 0, TEXTHEIGHT));
			graphics.drawRect(0, TEXTHEIGHT, WIDTH, HEIGHT - TEXTHEIGHT);

			addEventListener(MouseEvent.CLICK, onClick);
			addEventListener(Event.ENTER_FRAME, update);
			
			addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
            addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
		}

		private function destroy(e : Event) : void 
		{
			this.removeEventListener(Event.REMOVED_FROM_STAGE, destroy);
			
			graphics.clear();

			while(numChildren > 0)
				removeChildAt(0);			

			graph.dispose();

			removeEventListener(MouseEvent.CLICK, onClick);
			removeEventListener(Event.ENTER_FRAME, update);
			
			removeEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
            removeEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
		}

		private function update(e : Event) : void 
		{
			timer = getTimer();
			
			// 每一帧都绘制 这个绘制到最前面，这样后面的如果继续绘制就会显示在最上面了，每一帧都绘制好像会影响效率      
			if (timer - ms > TIMEOUTINTERVAL)
			{
				for (var i:int = 0; i < graph.height; i++)
				{
					graph.setPixel32(graph.width - 1, graph.height - i, colors.warning);
				}
			}

			if ( timer - 1000 > ms_prev ) 
			{
				ms_prev = timer;
				mem = Number((System.totalMemory * 0.000000954).toFixed(3));
				mem_max = mem_max > mem ? mem_max : mem;

				fps_graph = Math.min(graph.height, ( fps / stage.frameRate ) * graph.height);
				mem_graph = Math.min(graph.height, Math.sqrt(Math.sqrt(mem * 5000))) - 2;
				mem_max_graph = Math.min(graph.height, Math.sqrt(Math.sqrt(mem_max * 5000))) - 2;

				graph.scroll(-1, 0);

				graph.fillRect(rectangle, colors.bg);
				graph.setPixel(graph.width - 1, graph.height - fps_graph, colors.fps);
				graph.setPixel(graph.width - 1, graph.height - ( ( timer - ms ) >> 1 ), colors.ms);
				graph.setPixel(graph.width - 1, graph.height - mem_graph, colors.mem);
				graph.setPixel(graph.width - 1, graph.height - mem_max_graph, colors.memmax);

				xml.fps = "FPS: " + fps + " / " + stage.frameRate; 
				xml.mem = "MEM: " + mem;
				xml.memMax = "MAX: " + mem_max;			

				fps = 0;

			}

			fps++;
			
			// 第一次的时候就不计算了，这个值比较大，计算没有什么意义，前几帧好像时间很久，不好统计，就不统计这个字段了  
			//if (ms)
			//{
				//if (ms_max < timer - ms)
				//{
					//ms_max = timer - ms;
				//}
			//}
			//xml.msmax = "MSMAX: " + ms_max;

			xml.ms = "MS: " + (timer - ms);
			ms = timer;
			
			xml.version = Capabilities.version.split(" ")[0] + " " + Capabilities.version.split(" ")[1];

			text.htmlText = xml;
		}

		private function onClick(e : MouseEvent) : void 
		{
			mouseY / height > .5 ? stage.frameRate-- : stage.frameRate++;
			xml.fps = "FPS: " + fps + " / " + stage.frameRate;  
			text.htmlText = xml;
		}

		// .. Utils
		private function hex2css( color : int ) : String 
		{
			return "#" + color.toString(16);
		}
		
		public function key2value(key:String, value:String):void
		{
			_LocalText.appendText(key + ": " + value);
		}
		
        private function onMouseOut(event:MouseEvent):void
        {
            _LocalText.visible = false;
        }

        private function onMouseOver(event:MouseEvent):void
        {
            _LocalText.visible = true;
        }
	}
}

class Colors 
{
	public var bg : uint = 0x000033;
	public var fps : uint = 0xffff00;
	public var ms : uint = 0x00ff00;
	public var mem : uint = 0x00ffff;
	public var memmax : uint = 0xff0070;
	public var version : uint = 0xffffff;
	public var warning : uint = 0xFF0000;
}