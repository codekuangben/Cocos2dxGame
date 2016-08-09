package modulecommon.scene.prop.object
{
	import com.dgrigg.image.PanelImage;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.text.TextFormat;
	import modulecommon.GkContext;
	import com.util.UtilFilter;
	//import flash.filters.GlowFilter;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author zouzhiqiang
	 * 绘制道具Icon的工具类
	 */
	public class ObjectTool
	{
		public static const COLOR_WHITE:int = 0;
		public static const COLOR_GREEN:int = 1;
		public static const COLOR_BLUE:int = 2;
		public static const COLOR_PURPLE:int = 3;
		public static const COLOR_GOLD:int = 4;
		
		private var m_gkContext:GkContext;
		private var m_vecBG:Vector.<PanelImage>;
		private var m_frameImage:PanelImage;
		private var m_container:Sprite;
		private var m_bgBitmap:Bitmap;
		private var m_objectBitmap:Bitmap;
		private var m_frameBitmap:Bitmap;
		private var m_redMask:Shape;
		
		public function ObjectTool(gk:GkContext):void
		{
			m_gkContext = gk;			
		}
		
		public function drawIconDragged(obj:ZObject, image:PanelImage, bitMD:BitmapData):void
		{
			m_bgBitmap.bitmapData = m_vecBG[obj.iconColor].data;
			m_objectBitmap.bitmapData = image.data;
			loadFrameBitmap();
			m_container.filters = null;
			m_container.addChild(m_frameBitmap);
			bitMD.draw(m_container);
			m_container.removeChild(m_frameBitmap);
		}
		
		/*
		 * 玩家得到道具时，调用此函数
		 */
		protected function loadFrameBitmap():void
		{
			if (m_frameBitmap == null)
			{
				m_frameBitmap = new Bitmap();
				m_frameBitmap.bitmapData = m_frameImage.data;
				m_frameBitmap.width = m_frameImage.width;
				m_frameBitmap.height = m_frameImage.height;
			}
		}
		
		public function drawGetObj(obj:ZObject, image:PanelImage, bitMD:BitmapData):void
		{
			m_bgBitmap.bitmapData = m_vecBG[obj.iconColor].data;
			m_objectBitmap.bitmapData = image.data;
			m_container.filters = null;
			loadFrameBitmap();
			m_container.addChild(m_frameBitmap);
			bitMD.draw(m_container);
			m_container.removeChild(m_frameBitmap);
		}
		
		public function draw(obj:ZObject, image:PanelImage, bitMD:BitmapData, bDrag:Boolean, bShowNum:Boolean=true, bRedMask:Boolean=false):void
		{
			m_bgBitmap.bitmapData = m_vecBG[obj.iconColor].data;
			m_objectBitmap.bitmapData = image.data;
			if (bDrag == true)
			{
				m_container.filters = [UtilFilter.createGrayFilter()];
			}
			else
			{
				m_container.filters = null;
			}
			var tf:TextField;
			if (obj.maxNum > 1 && bShowNum)
			{
				tf = m_gkContext.m_context.m_globalObj.tf;
				tf.defaultTextFormat = new TextFormat(null, 12, 0xffffff);
				
				tf.y = 25;
				tf.filters = m_gkContext.m_context.m_globalObj.glowFilter;
				
				tf.text = obj.m_object.num.toString();
				tf.x = bitMD.width - (tf.textWidth + 4);
				m_container.addChild(tf);
			}
			if (bRedMask)
			{
				if (m_redMask == null)
				{
					m_redMask = new Shape();
					m_redMask.graphics.beginFill(0xff0000, 0.2);
					m_redMask.graphics.drawRect(0, 0, 40, 40);
					m_redMask.graphics.endFill();
				}
				
				m_container.addChild(m_redMask);
			}
			
			bitMD.draw(m_container);
			if (tf != null)
			{
				m_container.removeChild((tf));
			}	
			
			if (m_redMask && m_redMask.parent)
			{
				m_container.removeChild(m_redMask);
			}
		}
		
		public function init():void
		{
			m_vecBG = new Vector.<PanelImage>(5);
			m_vecBG[COLOR_WHITE] = m_gkContext.m_context.m_commonImageMgr.getImage("icon.bgWhite") as PanelImage;
			m_vecBG[COLOR_GREEN] = m_gkContext.m_context.m_commonImageMgr.getImage("icon.bgGreen") as PanelImage;
			m_vecBG[COLOR_BLUE] = m_gkContext.m_context.m_commonImageMgr.getImage("icon.bgBlue") as PanelImage;
			m_vecBG[COLOR_PURPLE] = m_gkContext.m_context.m_commonImageMgr.getImage("icon.bgPurple") as PanelImage;
			m_vecBG[COLOR_GOLD] = m_gkContext.m_context.m_commonImageMgr.getImage("icon.bgGold") as PanelImage;
			m_frameImage = m_gkContext.m_context.m_commonImageMgr.getImage("icon.frame") as PanelImage;
			
			m_container = new Sprite();
			m_bgBitmap = new Bitmap();
			m_objectBitmap = new Bitmap();
			
			m_container.addChild(m_bgBitmap);
			m_container.addChild(m_objectBitmap);
		}
	}

}