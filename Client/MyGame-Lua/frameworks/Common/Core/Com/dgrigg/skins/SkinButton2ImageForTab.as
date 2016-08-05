package com.dgrigg.skins
{
	/**
	 * ...
	 * @author
	 */
	
	import com.bit101.components.PushButton;
	import com.dgrigg.utils.UIConst;
	
	public class SkinButton2ImageForTab extends SkinButtonImageCaption
	{	
		override public function btnStateChange(state:uint):void
		{
			if (image == null)
			{
				return;
			}
			
			var posY:Number = 0;
			var posX:Number = 0;
			
			if (state == UIConst.EtBtnDown)
			{
				posY = 1;
				posX = 1;
			}
			else
			{
				posY = 0;
				posX = 0;
			}
			
			_bitmap.x = posX;
			_bitmap.y = posY;
			m_captionPanel.setPos(m_captionPanelPosX + posX, m_captionPanelPosY + posY);			
		
			if (state == UIConst.EtBtnSelected)
			{
				_bitmap.bitmapData = image.seletedData;
				if (_bitmap.filters)
				{
					_bitmap.filters = null;
					m_captionPanel.filters = null;
				}			
			}
			else
			{
				_bitmap.bitmapData = image.normalData;				
				_bitmap.filters = PushButton.s_funGetFilters(state);
				var captionPanelFilterState:uint;
				if (state == UIConst.EtBtnNormal)
				{
					captionPanelFilterState = UIConst.EtBtnDown;					
				}
				else
				{
					captionPanelFilterState = state;
				}
				m_captionPanel.filters = PushButton.s_funGetFilters(captionPanelFilterState);
			}
		
		}
	}

}