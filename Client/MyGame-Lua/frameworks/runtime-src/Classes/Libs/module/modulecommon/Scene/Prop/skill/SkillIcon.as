package modulecommon.scene.prop.skill 
{
	import com.bit101.components.Component;
	import com.dgrigg.image.Image;
	import com.dgrigg.image.PanelImage;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import modulecommon.scene.prop.table.TSkillBaseItem;
	//import flash.display.DisplayObjectContainer;
	import modulecommon.GkContext;
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	public class SkillIcon extends Component 
	{
		private static var m_sDragMap:Bitmap;
		
		protected var m_gkContext:GkContext;
		protected var m_uSkillID:uint;
		protected var m_uSkillType:uint;
		protected var m_bitmap:Bitmap;
		protected var m_image:PanelImage;
		protected var m_bDrag:Boolean;
		protected var m_bShowNum:Boolean;
		
		public function SkillIcon(gk:GkContext)
		{
			m_gkContext = gk;
			m_bitmap = new Bitmap();
			m_bShowNum = true;
			m_uSkillType = TSkillBaseItem.TYPE_ZHANSHU;
		}
		public function setSkillID(id:uint):void
		{
			if (m_uSkillID != 0)
			{
				unLoad();
			}
			else
			{
				this.addChild(m_bitmap);
			}
			
			m_uSkillID = id;
			m_uSkillType = m_gkContext.m_skillMgr.getType(m_uSkillID);
			
			load(m_gkContext.m_skillMgr.iconResName(m_uSkillID));
		}
		public function removeSkill():void
		{
			if (m_uSkillID != 0)
			{
				unLoad();
				m_uSkillID = 0;
				this.removeChild(m_bitmap);
			}
		}
		override public function draw():void
		{
			if (m_uSkillID == 0 || m_image == null)
			{
				return;
			}
			if (m_image.loadState != Image.Loaded)
			{
				return;
			}
			//m_bitmap.bitmapData = m_image.data;
			
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
			
			m_gkContext.m_skillDrawTool.drawZhanShu(m_uSkillID, m_image, bitMD, m_bDrag, m_bShowNum, m_uSkillType);
		}
		protected function load(name:String):void
		{
			m_gkContext.m_context.m_commonImageMgr.loadImage(name, PanelImage, onLoaded, onFailed);
		}
		protected function unLoad():void
		{
			if (m_uSkillID != 0)
			{
				if (m_image != null)
				{
					m_gkContext.m_context.m_commonImageMgr.unLoad(m_image.name);
					m_image = null;
				}
				else
				{
					var resIconName:String = m_gkContext.m_skillMgr.iconResName(m_uSkillID);
					if (resIconName != null)
					{
						m_gkContext.m_context.m_commonImageMgr.removeFun(resIconName, onLoaded, onFailed);
					}
					
				}
			}
		}
		protected function onLoaded(image:Image):void
		{
			m_image = image as PanelImage;
			invalidate();
		}
		protected function onFailed(fileName:String):void
		{
			
		}
		public function getDisplay():DisplayObject
		{
			var bitMD:BitmapData;
			if (m_sDragMap == null)
			{
				m_sDragMap = new Bitmap();
			}
			m_sDragMap.bitmapData = m_image.data;
			
			m_sDragMap.width = SkillMgr.ICONSIZE_Normal;
			m_sDragMap.height = SkillMgr.ICONSIZE_Normal;
			return m_sDragMap;		
		}
		public function onDrag():void
		{
			m_bDrag = true;
			this.invalidate();
		}
		public function onDrop():void
		{
			m_bDrag = false;
			this.invalidate();
		}
		public function switchToAcceptImage():void
		{
		}
		
		/**
		 * Paints the image for reject state of dragging.(means drop not allowed)
		 */
		public function switchToRejectImage():void
		{
		}
		
		public function get skillID():uint
		{
			return m_uSkillID;
		}
		
		//m_bShowNum����true����ʾ��ʾ����
		public function set showNum(bFlag:Boolean):void
		{
			m_bShowNum = bFlag;
		}
		
	}

}