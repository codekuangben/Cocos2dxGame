package com.dgrigg.skins 
{
	import com.bit101.components.ButtonText;
	import com.bit101.components.PushButton;
	import com.dgrigg.image.PanelImage;
	import com.dgrigg.minimalcomps.skins.Skin;	
	import flash.display.Bitmap;
	import com.dgrigg.utils.UIConst;
	/**
	 * ...
	 * @author 
	 * 只提供按钮的一个状态的图片。其它状态是filter来实现
	 */
	public class SkinButton1Image extends Skin 
	{
		protected var _bitmap:Bitmap;
		
		
		public function SkinButton1Image() 
		{
			_imageClass = PanelImage;
			_bitmap = new Bitmap();
		}
		override public function init():void
		{
			hostComponent.addBackgroundChild(_bitmap);			
		}
		
		override protected function updateBitmapdata():void
		{			
			var index:int = 0;
			if (hostComponent != null)
			{
				_bitmap.bitmapData = image.data;
				if (hostComponent.autoSizeByImage)
				{
					if (hostComponent.width != image.width || hostComponent.height != image.height)
					{
						hostComponent.setSize(_bitmap.bitmapData.width, _bitmap.bitmapData.height);
					}
				}
				else
				{
					_bitmap.width = hostComponent.width;
					_bitmap.height = hostComponent.height;
				}
			}
			super.updateBitmapdata();
		}
		
		override public function btnStateChange(state:uint):void
		{			
			var posY:Number = 0;
			var posX:Number = 0;
			switch(state)
			{
				case UIConst.EtBtnNormal: posY = 0; posX = 0; break;
				case UIConst.EtBtnOver: posY = 0; posX = 0; break;
				case UIConst.EtBtnDown: posY = 1; posX = 1; break;
			}
			
			_bitmap.x = posX;
			_bitmap.y = posY; 
			_bitmap.filters = PushButton.s_funGetFilters(state);
			
			if (hostComponent is ButtonText)
			{
				(hostComponent as ButtonText).LablePosChangeOnStateChange(posX,posY);
			}
		}
		
		
		override public function unInstall():void
		{			
			hostComponent.removeBackgroundChild(_bitmap);
			super.unInstall();
		}
		protected function get image():PanelImage
		{
			return (_image as PanelImage);
		}		
		public function get bitmap():Bitmap
		{
			return _bitmap;
		}
	}

}