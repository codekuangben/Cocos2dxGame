package modulecommon.scene.prop.skill 
{
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	//import com.bit101.components.Component;
	import com.dgrigg.image.Image;
	//import com.dgrigg.image.PanelImage;
	//import com.dnd.DraggingImage;
	//import common.Context;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	//import flash.events.Event;
	import modulecommon.appcontrol.DragCtrl;
	import modulecommon.GkContext;	
	import modulecommon.scene.wu.JinnangItem;
	//import flash.geom.Point;
	//import flash.geom.Rectangle;
	
	public class JinnangIcon  extends DragCtrl
	{
		private var m_jinnang:JinnangItem;
		protected var m_bShowNum:Boolean;
		
		public function JinnangIcon(gk:GkContext) 
		{
			super(gk);
			m_bShowNum = true;
		}
		public function setSkillID(item:JinnangItem):void
		{
			if (m_jinnang != null)
			{
				unLoad();
			}
			else
			{
				this.addChild(m_bitmap);
			}
			m_jinnang = item;
			if (m_jinnang == null)
			{
				return;
			}
			load(m_gkContext.m_skillMgr.iconResName(m_jinnang.idLevel));
		}
		public function remove():void
		{
			if (m_jinnang != null)
			{
				unLoad();
				m_jinnang = null;
				this.removeChild(m_bitmap);
				if(m_bitmap.bitmapData)
				{
					m_bitmap.bitmapData.dispose();
					m_bitmap.bitmapData = null;
				}
			}
		}
		
		override public function dispose():void
		{
			if(m_bitmap && m_bitmap.bitmapData)
			{
				m_bitmap.bitmapData.dispose();
				m_bitmap.bitmapData = null;
			}
			remove();
			super.dispose();
		}
		
		override public function draw():void
		{
			if (m_jinnang == null || m_image == null)
			{
				return;
			}
			if (m_image.loadState != Image.Loaded)
			{
				return;
			}
			var bitMD:BitmapData;
			if (m_bitmap.bitmapData != null)
			{
				bitMD = m_bitmap.bitmapData;
			}
			else
			{
				bitMD = new BitmapData(SkillMgr.ICONSIZE_Normal, SkillMgr.ICONSIZE_Normal);
				m_bitmap.bitmapData = bitMD;
				m_bitmap.width = SkillMgr.ICONSIZE_Normal;
				m_bitmap.height = SkillMgr.ICONSIZE_Normal;
			}
			m_gkContext.m_skillDrawTool.drawJinnang(m_jinnang, m_image, bitMD, m_bDrag, m_bShowNum);		
		}		
		override public function getDisplay():DisplayObject
		{
			//Bm代表Bitmap
			var retBm:Bitmap = m_gkContext.m_context.m_dragResPool.getBitmap();
			var retBmData:BitmapData = m_gkContext.m_context.m_dragResPool.getBitmapData(SkillMgr.ICONSIZE_Normal, SkillMgr.ICONSIZE_Normal);
			
			m_gkContext.m_skillDrawTool.drawDragJinnang(m_jinnang, m_image, retBmData);
			retBm.bitmapData = retBmData;
			
			retBm.width = SkillMgr.ICONSIZE_Normal;
			retBm.height = SkillMgr.ICONSIZE_Normal;
			retBm.x = 0;
			retBm.y = 0;
			return retBm;			
		}
		protected function unLoad():void
		{
			if (m_jinnang != null)
			{
				if (m_image != null)
				{
					m_gkContext.m_context.m_commonImageMgr.unLoad(m_image.name);
					m_image = null;
				}
				else
				{
					m_gkContext.m_context.m_commonImageMgr.removeFun(m_gkContext.m_skillMgr.iconResName(m_jinnang.idLevel), onLoaded, onFailed);
				}
			}
		}
		
		public function get jinnang():JinnangItem
		{
			return m_jinnang;
		}
		public function get iconLoaded():Boolean
		{
			return (m_image && m_image.loaded);
		}
		
		//bFlag等于true，表示显示数字
		public function set showNum(bFlag:Boolean):void
		{
			m_bShowNum = bFlag;
		}
	}
}