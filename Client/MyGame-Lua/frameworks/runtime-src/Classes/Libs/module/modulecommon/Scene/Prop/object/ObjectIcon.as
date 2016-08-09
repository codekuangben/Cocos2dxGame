package modulecommon.scene.prop.object
{
	//import com.bit101.components.Component;
	import com.dgrigg.image.Image;
	//import com.dgrigg.image.PanelImage;
	//import common.Context;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	//import flash.events.Event;
	import modulecommon.appcontrol.DragCtrl;
	import modulecommon.GkContext;	
	//import modulecommon.scene.prop.table.TObjectBaseItem;
	
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	public class ObjectIcon extends DragCtrl
	{			
		protected var m_zObject:ZObject;	
		protected var m_bShowNum:Boolean;
		protected var m_bRedMask:Boolean;	//true - 表示在道具上画红色的遮罩
		
		public function ObjectIcon(gk:GkContext)
		{
			super(gk);
			m_bShowNum = true;
		}
		
		public function setZObject(obj:ZObject):void
		{
			if (m_zObject != null)
			{
				unLoad();
			}
			else
			{
				this.addChild(m_bitmap);
			}
			m_zObject = obj;
			load(m_zObject.pathIconName);
			
			if (this.parent && (this.parent as ObjectPanel))
			{
				(this.parent as ObjectPanel).showIconColorBack(m_zObject.iconColor);
			}
		}
		
		public function removeZObject():void
		{
			if (m_zObject != null)
			{
				unLoad();
				m_zObject = null;
				this.removeChild(m_bitmap);
				
				if (this.parent && (this.parent as ObjectPanel))
				{
					(this.parent as ObjectPanel).hideIconColorBack();
				}
			}
		}
		public function freshIcon():void
		{
			this.invalidate();
		}
		override public function draw():void
		{
			if (m_zObject == null || m_image == null)
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
				bitMD = new BitmapData(ZObject.IconSize, ZObject.IconSize);
				m_bitmap.bitmapData = bitMD;
				m_bitmap.width = 40;
				m_bitmap.height = 40;
			}
			m_gkContext.m_objectTool.draw(m_zObject, m_image, bitMD, m_bDrag, m_bShowNum, m_bRedMask);
			//m_bitmap.bitmapData = m_image.data;
		
		}		
		override public function dispose():void
		{
			removeZObject();
		}
		protected function unLoad():void
		{
			if (m_zObject != null)
			{
				if (m_image != null)
				{
					m_gkContext.m_context.m_commonImageMgr.unLoad(m_image.name);
					m_image = null;
				}
				else
				{
					m_gkContext.m_context.m_commonImageMgr.removeFun(m_zObject.pathIconName, onLoaded, onFailed);
				}
			}
		}		
		/**
		 * Returns the display object for the representation of dragging.
		 */
		override public function getDisplay():DisplayObject
		{
			//Bm代表Bitmap
			var retBm:Bitmap = m_gkContext.m_context.m_dragResPool.getBitmap();
			var retBmData:BitmapData = m_gkContext.m_context.m_dragResPool.getBitmapData(ZObject.IconSize, ZObject.IconSize);
			m_gkContext.m_objectTool.drawIconDragged(m_zObject, m_image, retBmData);			
			
			retBm.bitmapData = retBmData;
			retBm.width = ZObject.IconSize;
			retBm.height = ZObject.IconSize;
			retBm.x = -ZObject.IconSize/2;
			retBm.y = -ZObject.IconSize/2;
			return retBm;
		}
		
		
		
		public function get zObject():ZObject
		{
			return m_zObject;
		}
	
		//bFlag等于true，表示显示数字
		public function set showNum(bFlag:Boolean):void
		{
			m_bShowNum = bFlag;
		}
		
		public function set redMask(bFlag:Boolean):void
		{
			if (m_bRedMask == bFlag)
			{
				return;
			}
			m_bRedMask = bFlag;
			freshIcon();
		}
		public function get redMask():Boolean
		{
			return m_bRedMask;
		}
	}

}