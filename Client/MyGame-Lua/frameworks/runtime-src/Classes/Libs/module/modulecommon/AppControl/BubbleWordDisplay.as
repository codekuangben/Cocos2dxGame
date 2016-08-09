package modulecommon.appcontrol 
{
	import com.bit101.components.Panel;
	import com.dgrigg.display.DisplayImageListBase;
	import com.dgrigg.image.Image;
	import com.dgrigg.image.ImageGrid9;
	import com.dgrigg.image.PanelImage;
	
	import common.Context;
	
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	//import com.dgrigg.skins.PanelImageSkin;
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	public class BubbleWordDisplay extends DisplayImageListBase 
	{
		protected var m_bSizeLegal:Boolean;
		protected var m_textWidth:uint;
		protected var m_textheight:uint;	//文字部分的高度
		protected var m_height:uint;		//总高度，包括上部分和下面的箭头
		protected var m_bitMapData:BitmapData;
		protected var m_onComposed:Function;
		protected var m_mousePanel:Panel;
		public function BubbleWordDisplay(con:Context, parent:DisplayObjectContainer = null) 
		{
			super(con, parent);
			m_bSizeLegal = false;
			m_mousePanel = new Panel();
			this.load("commoncontrol/combine/gpp_bubble.swf");
		}
		override protected function onLoaded(image:Image):void
		{
			super.onLoaded(image);
			if (m_bSizeLegal == true)
			{
				compose();
			}
		}
		protected function compose():void
		{		
			var imageGrid9:ImageGrid9 = m_imagList.getImage(0) as ImageGrid9;
			var imagePanel:PanelImage = m_imagList.getImage(1) as PanelImage;			
			var dataGrid9:BitmapData = imageGrid9.create(m_textWidth, m_textheight);
			if (dataGrid9 == null)
			{
				return;
			}
			var rect:Rectangle = new Rectangle(0,0,m_textWidth, m_textheight);
			var pt:Point = new Point();
			
			m_bitMapData = new BitmapData(m_textWidth, m_height, true, 0);
			m_bitMapData.copyPixels(dataGrid9, rect, pt);
			
			rect.width = imagePanel.width;
			rect.height = imagePanel.height;
			pt.x = (m_textWidth - imagePanel.width) / 2;
			pt.y = m_height - imagePanel.height;
			m_bitMapData.copyPixels(imagePanel.data, rect, pt);
			
			this.bitmapData = m_bitMapData;
			this.width = m_textWidth;
			this.height = m_height;
			
			m_mousePanel.setPanelImageSkinByImage(m_imagList.getImage(2) as PanelImage);
			m_mousePanel.visible = false;
			if (m_onComposed != null)
			{
				m_onComposed();
			}
		}
		public function set onComposed(fun:Function):void
		{
			m_onComposed = fun;
		}
		public function setTextSize(w:uint, h:uint):void
		{
			m_textWidth = w;
			m_textheight = h;
			m_height = m_textheight + 18;
			m_bSizeLegal = true;
			
			if (m_imagList != null && m_imagList.loaded)
			{
				compose();
			}
		}
		
		public function get mousePanel():Panel
		{
			return m_mousePanel;
		}
	}

}