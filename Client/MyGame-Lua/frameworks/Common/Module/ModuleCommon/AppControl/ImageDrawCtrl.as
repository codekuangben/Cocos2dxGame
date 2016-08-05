package modulecommon.appcontrol 
{
	import com.bit101.components.Component;
	import modulecommon.GkContext;
	import flash.display.Bitmap;
	import com.dgrigg.image.Image;
	import com.dgrigg.image.PanelImage;
	import com.pblabs.engine.debug.Logger;
	
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	public class ImageDrawCtrl extends Component 
	{
		protected var m_bitmap:Bitmap;
		protected var m_image:PanelImage;
		protected var m_gkContext:GkContext;
		public function ImageDrawCtrl(gk:GkContext) 
		{
			m_gkContext = gk;
			m_bitmap = new Bitmap();
		}
		
		override public function dispose():void
		{
			m_gkContext = null;
			super.dispose();
		}
		
		protected function load(name:String):void
		{
			m_gkContext.m_context.m_commonImageMgr.loadImage(name, PanelImage, onLoaded, onFailed);
		}
		public function get loaded():Boolean
		{
			return m_image && m_image.loaded;
		}
		protected function onLoaded(image:Image):void
		{
			m_image = image as PanelImage;
			invalidate();
		}
		protected function onFailed(fileName:String):void
		{
			Logger.error(null, null, "faile" + fileName);
			m_image = m_gkContext.m_context.m_commonImageMgr.getImage("icon.bgWhite") as PanelImage;
			m_image.increase();
			invalidate();
		}
	}

}