package modulecommon.scene.prop.object 
{
	//import adobe.utils.CustomActions;
	import com.dgrigg.image.PanelImage;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import modulecommon.GkContext;
	/**
	 * ...
	 * @author ...
	 * 装备Tips中的宝石draw
	 */
	public class GemDrawTool 
	{
		private var m_gkContext:GkContext;
		private var m_container:Sprite;
		private var m_frameBitmap:Bitmap;
		private var m_objectBitmap:Bitmap;
		public function GemDrawTool(gk:GkContext) 
		{
			m_gkContext = gk;			
		}
		
		public function draw(image:PanelImage, bitMD:BitmapData):void
		{
			m_objectBitmap.bitmapData = image.data;
			m_objectBitmap.width = 20;
			m_objectBitmap.height = 20;
			bitMD.draw(m_container);
		}
		
		public function init():void
		{				
			m_container = new Sprite();
			m_frameBitmap = new Bitmap();
			m_objectBitmap = new Bitmap();
			m_container.addChild(m_objectBitmap);
			m_container.addChild(m_frameBitmap);			
			
			var panelImage:PanelImage = m_gkContext.m_context.m_commonImageMgr.getImage("icon.gemframe") as PanelImage;
			m_frameBitmap.bitmapData = panelImage.data;
		}
	}

}