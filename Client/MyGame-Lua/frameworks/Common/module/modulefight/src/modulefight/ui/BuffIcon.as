package modulefight.ui 
{
	import com.dgrigg.image.Image;
	//import com.pblabs.engine.entity.EntityCValue;
	//import flash.display.BitmapData;
	import modulecommon.appcontrol.ImageDrawCtrl;
	import modulecommon.GkContext;
	import modulefight.netmsg.stmsg.stEntryState;
	/**
	 * ...
	 * @author 
	 */
	public class BuffIcon extends ImageDrawCtrl
	{
		private var m_iconPath:String;
		private var m_bufferState:stEntryState;
		
		public function BuffIcon(gk:GkContext) 
		{
			super(gk);			
		}		
		public function setIconPath(iconPath:String):void
		{
			if (iconPath == null)
			{
				return;
			}
			if (m_iconPath != null)
			{
				unLoad();
			}
			else
			{
				this.addChild(m_bitmap);
			}
			m_iconPath = iconPath;
			load("bufficon/" + m_iconPath + ".png");
		}
		
		public function removeIconPath():void
		{
			if (m_iconPath != null)
			{
				unLoad();
				m_iconPath = null;
				this.removeChild(m_bitmap);
			}
		}
		
		override public function draw():void
		{
			if (!m_image || m_image.loadState != Image.Loaded)
			{
				return;
			}
			//var bitMD:BitmapData;
			//if (m_bitmap.bitmapData != null)
			//{
				//bitMD = m_bitmap.bitmapData;
			//}
			//else
			//{
				//bitMD = new BitmapData(40, 40);
				//m_bitmap.bitmapData = bitMD;
				//m_bitmap.width = 40;
				//m_bitmap.height = 40;
			//}
			//m_gkContext.m_objectTool.draw(m_zObject, m_image, bitMD, m_bDrag);
			m_bitmap.bitmapData = m_image.data;
		}
		
		protected function unLoad():void
		{
			if (m_iconPath != null)
			{
				if (m_image != null)
				{
					m_gkContext.m_context.m_commonImageMgr.unLoad(m_image.name);
					m_image = null;
				}
				else
				{
					m_gkContext.m_context.m_commonImageMgr.removeFun("bufficon/" + m_iconPath + ".png", onLoaded, onFailed);
				}
			}
		}
		override public function dispose():void
		{
			removeIconPath();
			super.dispose();
		}
	}
}