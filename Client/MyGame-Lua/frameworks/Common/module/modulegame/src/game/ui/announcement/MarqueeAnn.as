package game.ui.announcement 
{
	import com.bit101.components.Marquee;
	import common.Context;
	import flash.display.DisplayObjectContainer;
	import flash.filters.GlowFilter;
	
	import flash.filters.BitmapFilterQuality;
	import flash.filters.DropShadowFilter;
	import com.util.UtilFont;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;	
	/**
	 * ...
	 * @author ...
	 */
	public class MarqueeAnn extends Marquee 
	{
		private var m_tf:TextField;
		public function MarqueeAnn(cont:Context, parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0) 
		{
			super(cont, parent, xpos, ypos);
			
			var filter:GlowFilter = new GlowFilter(0xEB3ACF, 0.9, 6,6,2, BitmapFilterQuality.HIGH, false, false);
			
			var dropFilter:DropShadowFilter = new DropShadowFilter(0, 45, 0xEB3ACF, 0.5, 16, 16, 5, BitmapFilterQuality.HIGH, false, false );
			var arFilter:Array = [filter, dropFilter];

			var format:TextFormat = new TextFormat();
			format.size = 24;
			format.bold = true;
			format.font = UtilFont.NAME_HuawenXinwei;
			format.color = 0xeeeeee;

			m_tf = new TextField();
			content = m_tf;
			m_tf.y = 23;
			
			m_tf.filters = arFilter;
			m_tf.defaultTextFormat = format;
			m_bLoop = false;
			this.setPos(20,11);
			setSize(444, 90);
			m_speed = 80;
		}
		
		public function setText(text:String):void
		{
			m_tf.text = text;
			this.m_tf.width = m_tf.textWidth + 4;
		}
		
	}

}