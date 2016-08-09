package modulecommon.scene.prop.object
{
	import flash.display.BitmapData;
	import modulecommon.appcontrol.ImageDrawCtrl;
	import modulecommon.GkContext;
	import modulecommon.scene.prop.table.DataTable;
	import modulecommon.scene.prop.table.TObjectBaseItem;
	
	/**
	 * ...
	 * @author ...
	 * 宝石Icon，用于装备Tips中的显示
	 */
	public class GemIcon extends ImageDrawCtrl
	{
		private var m_gemID:uint;
		private var m_resName:String;
		
		public function GemIcon(gk:GkContext)
		{
			super(gk);
			m_gemID = uint.MAX_VALUE;
		}
		
		public function setGemID(id:uint):void
		{
			if (m_gemID == id)
			{
				return;
			}
			if (m_gemID != uint.MAX_VALUE)
			{
				unLoad();
			}
			else
			{
				this.addChild(m_bitmap);
			}
			m_gemID = id;
			if (m_gemID == uint.MAX_VALUE)
			{
				return;
			}
			if (m_gemID == 0)
			{
				m_resName = "commoncontrol/panel/unxiangqian.png";
			}
			else
			{
				var base:TObjectBaseItem = m_gkContext.m_dataTable.getItem(DataTable.TABLE_OBJECT, m_gemID) as TObjectBaseItem;
				m_resName = base.pathIconName();
			}
			load(m_resName);
		
		}
		
		public function removeGem():void
		{
			if (m_gemID != uint.MAX_VALUE)
			{
				unLoad();
				m_gemID = uint.MAX_VALUE;
				this.removeChild(m_bitmap);
			}
		}
		
		override public function draw():void
		{
			if (m_gemID == uint.MAX_VALUE || m_image == null)
			{
				return;
			}
			if (m_gemID == 0)
			{
				m_bitmap.bitmapData = m_image.data;
			}
			else
			{
				var bitMD:BitmapData;				
				bitMD = new BitmapData(20, 20);
				m_bitmap.bitmapData = bitMD;
				m_bitmap.width = 20;
				m_bitmap.height = 20;
				
				m_gkContext.m_gemDrawTool.draw(m_image, bitMD);
			}
		}
		
		override public function dispose():void
		{
			removeGem();
		}
		
		protected function unLoad():void
		{
			if (m_gemID != uint.MAX_VALUE)
			{
				if (m_image != null)
				{
					m_gkContext.m_context.m_commonImageMgr.unLoad(m_image.name);
					m_image = null;
				}
				else
				{
					m_gkContext.m_context.m_commonImageMgr.removeFun(m_resName, onLoaded, onFailed);
				}
			}
		}
	}

}