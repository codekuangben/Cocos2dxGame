package com.dgrigg.skins 
{
	import com.bit101.utils.PanelDrawCreator;
	import com.dgrigg.image.Image;
	//import com.dgrigg.minimalcomps.skins.Skin;
	import common.event.UIEvent;
	/**
	 * ...
	 * @author 
	 */
	public class SkinButton1ImagePanelDraw extends SkinButton1Image 
	{
		private var m_panelDrawCreator:PanelDrawCreator;
		public function SkinButton1ImagePanelDraw() 
		{
			super();
		}
		override protected function updateBitmapdata():void
		{			
			var index:int = 0;
			if (hostComponent != null&& m_panelDrawCreator)
			{
				_bitmap.bitmapData = m_panelDrawCreator.bitmapData;
				if (hostComponent.autoSizeByImage)
				{
					if (hostComponent.width != m_panelDrawCreator.width || hostComponent.height != m_panelDrawCreator.height)
					{
						hostComponent.setSize(m_panelDrawCreator.width, m_panelDrawCreator.height);
					}
				}
				else
				{
					_bitmap.width = hostComponent.width;
					_bitmap.height = hostComponent.height;
				}
			}
			//super.updateBitmapdata();
		}
		override public function dispose():void 
		{
			m_panelDrawCreator.dispose();
			super.dispose();
		}
		//调用此函数时，表示已经将内容放入PanelDrawCreator对象中
		public function setPanelDrawCreator(creator:PanelDrawCreator):void
		{
			m_panelDrawCreator = creator;
			m_panelDrawCreator.funOnDraw = onPanelDraw;
			m_panelDrawCreator.endAdd();
		}
		
		private function onPanelDraw(creator:PanelDrawCreator):void
		{
			updateBitmapdata();
			_loadState = Image.Loaded;
			if (_hostComponent != null)
			{				
				_hostComponent.dispatchEvent(new UIEvent(UIEvent.IMAGELOADED, true, this));
			}
		}
		
	}

}