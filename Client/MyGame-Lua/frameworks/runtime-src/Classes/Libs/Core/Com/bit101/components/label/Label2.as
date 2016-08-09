package com.bit101.components.label 
{
	import com.bit101.components.Component;
	import com.bit101.components.PushButton;
	import com.util.UtilFont;
	import flash.filters.GlowFilter;
	import flash.text.engine.ElementFormat;
	import flash.text.engine.FontDescription;
	import flash.text.engine.FontWeight;
	import flash.text.engine.TextBlock;
	import flash.text.engine.TextElement;
	import flash.text.engine.TextLine;
	import flash.display.DisplayObjectContainer;
	/**
	 * ...
	 * @author 
	 */
	public class Label2 extends Component 
	{
		public static var s_textBlock:TextBlock;		
		
		protected var m_labelFormat:LabelFormat;
		protected var m_textLine:TextLine;
		
		public function Label2(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0)
		{
			super(parent, xpos, ypos);
			m_labelFormat = new LabelFormat();
			m_labelFormat.color = 0xffffff;
			m_labelFormat.size = 12;
			m_labelFormat.fontName = UtilFont.NAME_Songti;
			m_labelFormat.lineRotation = LabelFormat.ROTATE_0;
			this.mouseEnabled = false;
			this.mouseChildren = false;
		}
		
		public function set labelFormat(lf:LabelFormat):void
		{
			if (lf.color)
			{
				m_labelFormat.color = lf.color;
			}
			
			if (lf.size)
			{
				m_labelFormat.size = lf.size;
			}
			
			if (lf.fontName)
			{
				m_labelFormat.fontName = lf.fontName;
			}
			
			m_labelFormat.letterspace = lf.letterspace;
			if (lf.lineRotation)
			{
				m_labelFormat.lineRotation = lf.lineRotation;
			}
			m_labelFormat.bBold = lf.bBold;
			if (lf.text)
			{
				m_labelFormat.text = lf.text;
			}
			m_labelFormat.bMiaobian = lf.bMiaobian;
			
			invalidate();
		}
		public function set text(t:String):void
		{
			m_labelFormat.text = t;
			invalidate();
		}
		public function setFontColor(color:uint):void
		{
			m_labelFormat.color = color;
			invalidate();
		}
		public function set letterspace(v:Number):void
		{
			m_labelFormat.letterspace = v;
			invalidate();
		}
		public function set miaobian(b:Boolean):void
		{
			m_labelFormat.bMiaobian = b;
			invalidate();
		}
		
		public function flush():void
		{
			onInvalidate(null);
		}
		override public function draw():void
		{
			if (m_textLine)
			{
				this.removeChild(m_textLine);
				m_textLine = null;
			}
			if (m_labelFormat.text == null || m_labelFormat.text.length == 0)			
			{
				return;
			}
			var ef:ElementFormat = new ElementFormat();			
			if (m_labelFormat.fontName || m_labelFormat.bBold)
			{
				ef.fontDescription = new FontDescription(m_labelFormat.fontName==null?"Times New Roman":m_labelFormat.fontName, m_labelFormat.bBold?FontWeight.BOLD:FontWeight.NORMAL);
			}
			ef.fontSize = m_labelFormat.size;
			ef.color = m_labelFormat.color;
			ef.trackingLeft = m_labelFormat.letterspace;
			
			var textEle:TextElement = new TextElement(m_labelFormat.text, ef);
			s_textBlock.content = textEle;
			s_textBlock.lineRotation = m_labelFormat.lineRotation;
			m_textLine = s_textBlock.createTextLine(null);
			m_textLine.mouseEnabled = false;
			this.addChild(m_textLine);
			m_textLine.x = 2;
			_width = m_textLine.width + 4;
			
			if(m_labelFormat.bMiaobian)
			{
				var filter:GlowFilter = new GlowFilter(m_labelFormat.miaobianColor, 1, 2, 2, 16);
				m_textLine.filters = [ filter ];
			}
			
			if (m_labelFormat.lineRotation == LabelFormat.ROTATE_0)
			{
				m_textLine.y = m_labelFormat.size + 1;
				_height = m_labelFormat.size + 6;
			}
			else
			{
				_height = m_textLine.height;
			}
			
			if (this.parent is PushButton)
			{
				(this.parent as PushButton).invalidate();
			}
		}	
			
		override public function set width(value:Number):void 
		{
			this._width = value;
		}
		
		override public function set height(value:Number):void 
		{
			_height = value;
		}
		override public function setSize(w:Number, h:Number):void 
		{
			this._width = w;
			_height = h;
		}
	}

}