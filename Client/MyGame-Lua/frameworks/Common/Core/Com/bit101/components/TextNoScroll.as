package com.bit101.components 
{
	import com.util.UtilFont;
	import flash.filters.GlowFilter;
	import flash.text.StyleSheet;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.display.DisplayObjectContainer;
	
	/**
	 * ...
	 * @author ...
	 * 用于显示多行文本，没有滚动条。文字
	 */
	public class TextNoScroll extends TextField 
	{
		
		public function TextNoScroll(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number =  0) 
		{
			if (parent)
			{
				parent.addChild(this);
			}
			this.x = xpos;
			this.y = ypos;
			
			multiline = true;
			wordWrap = true;
			mouseEnabled = false;			
		}
		
		override public function set text(value:String):void 
		{
			super.text = value;			
			this.height = this.textHeight + 4;
		}
		
		public function setMiaobian():void
		{
			var filter:GlowFilter = new GlowFilter(0x101010, 1, 2, 2, 16);
			filters = [ filter ];
		}
		override public function set htmlText(value:String):void 
		{
			super.htmlText = value;
			this.height = this.textHeight + 4;
		}
		
		public function set ishtml(bFlag:Boolean):void
		{
			this.styleSheet = new StyleSheet();
		}
		public function setCSS(label:String, obj:Object):void
		{
			var css:StyleSheet = new StyleSheet();
			css.setStyle(label, obj);
			styleSheet = css;
		}
		public function setBodyCSS(color:uint, size:int, letterSpacing:int = 1, leading:int = 4, fontName:String=UtilFont.NAME_Songti):void
		{
			this.setCSS("body", {leading:leading, fontSize: size, color:"#"+color.toString(16),letterSpacing:letterSpacing, fontFamily:fontName});
		}
		public function setBodyHtml(value:String):void
		{
			super.htmlText = "<body>"+value+"</body>";
			this.height = this.textHeight + 4;
		}
		
		
		public function setFont(color:uint, size:uint = 12, fontname:String = null):void
		{
			var tf:TextFormat = new TextFormat(fontname, size, color);
			this.defaultTextFormat = tf;
		}
	}

}