package com.dgrigg.skins 
{	
	/**
	 * ...
	 * @author 
	 * 只提供按钮的2个状态的图片(normal and over)。
	 * down状态由normal来替代
	 */
	import com.dgrigg.utils.UIConst;
	public class SkinButton2Image extends ButtonImageSkin 
	{		
		public function SkinButton2Image() 
		{
			super();
		}
		override public function btnStateChange(state:uint):void
		{
			if (image == null)
			{
				return;
			}
			if (state == UIConst.EtBtnNormal)
			{
				_bitmap.bitmapData = image.normalData;
			}
			else
			{
				_bitmap.bitmapData = image.overData;
			}			
		}
	}

}