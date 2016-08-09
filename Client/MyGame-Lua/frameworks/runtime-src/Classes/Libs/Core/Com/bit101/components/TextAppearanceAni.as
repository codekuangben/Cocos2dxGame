package com.bit101.components
{
	/**
	 * ...
	 * @author
	 */
	import com.ani.AniPropertys;
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextLineMetrics;
	import flash.text.StyleSheet;
	
	public class TextAppearanceAni extends Component
	{
		private var m_tf:TextField;
		private var m_shape:Shape;
		private var m_aniProperty:AniPropertys;
		private var m_progress:Number;
		private var m_speed:Number = 1;
		
		public function TextAppearanceAni(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0)
		{
			super(parent, xpos, ypos);
			m_tf = new TextField();
			this.addChild(m_tf);
			m_tf.wordWrap = true;
			m_tf.multiline = true;
			m_tf.mouseEnabled = false;
			m_tf.mouseWheelEnabled = false;
			
			m_shape = new Shape();
			m_shape.x = 2;
			m_shape.y = 2;
			
			m_aniProperty = new AniPropertys();
			m_aniProperty.sprite = this;
			m_aniProperty.onEnd = onEnd;
			
			this.addChild(m_shape);			
			addEventListener(Event.RESIZE, onResize);
		}
		
		public function set htmlText(str:String):void
		{
			m_tf.htmlText = str;
		}
		public function setCSS(label:String, obj:Object):void
		{
			var css:StyleSheet = new StyleSheet();
			css.setStyle(label, obj);
			m_tf.styleSheet = css;
		}
		public function begin():void
		{
			var i:int;
			var n:int = m_tf.numLines;
			var lenTotal:Number=0;
			var mat:TextLineMetrics;
			for (i = 0; i < n; i++)
			{
				mat = m_tf.getLineMetrics(i);
				lenTotal += mat.width;
			}
			
			progress = 0;
			m_aniProperty.resetValues({progress: lenTotal});
			m_aniProperty.duration = lenTotal / m_speed;
			m_aniProperty.begin();			
		}
		
		public function set progress(v:Number):void
		{
			m_progress = v;
			
			var gf:Graphics = m_shape.graphics;
			gf.clear();
			var n:int = m_tf.numLines;
			
			var mat:TextLineMetrics;
			var lenRemain:Number = m_progress;
			var lenDraw:Number;
			var top:int=0;
			var i:int;
			
			
			gf.beginFill(0xff0000);
			for (i = 0; i < n; i++)
			{
				if (lenRemain <= 0)
				{
					break;
				}
				mat = m_tf.getLineMetrics(i);
				if (lenRemain <= mat.width)
				{
					lenDraw = lenRemain;
					lenRemain = 0;
				}
				else
				{
					lenDraw = mat.width;
					lenRemain = lenRemain - mat.width;
				}
				gf.drawRect(0, top, lenDraw, mat.height);
				top += mat.height;
			}
			gf.endFill();
			m_tf.mask = m_shape;
		}
		
		public function get progress():Number
		{
			return m_progress;
		}
		
		public function set speed(v:Number):void
		{
			m_speed = v;
		}
		
		protected function onEnd():void
		{
			this.dispatchEvent(new Event(Event.COMPLETE));
		}
		
		protected function onResize(event:Event):void
		{
			m_tf.width = this.width;
			m_tf.height = this.height;
		}
		
		public function get tf():TextField
		{
			return m_tf;
		}
	
	}

}