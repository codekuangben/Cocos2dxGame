package com.dgrigg.skins
{

	import com.bit101.components.PushButton;
	import com.dgrigg.minimalcomps.skins.Skin;
	import com.dgrigg.image.ButtonImage;
	import flash.display.Bitmap;
	import com.dgrigg.utils.UIConst;
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	public class ButtonImageSkin extends Skin
	{		
		protected var _bitmap:Bitmap;
		
		public function ButtonImageSkin()
		{
			super();
			_imageClass = ButtonImage;
			_bitmap = new Bitmap();
		}
		
		
		override public function init():void
		{
			hostComponent.addBackgroundChild(_bitmap);			
		}
		
		override protected function updateBitmapdata():void
		{
			_bitmap.bitmapData = image.normalData;	
			if (hostComponent != null)
			{
				draw();
				(hostComponent as PushButton).onSetSkin();
				if (hostComponent.autoSizeByImage)
				{
					if (hostComponent.width != image.width || hostComponent.height != image.height)
					{
						hostComponent.setSize(image.width,image.height);
					}
					_bitmap.width = image.width;
					_bitmap.height = image.height;
				}
				else
				{
					_bitmap.width = hostComponent.width;
					_bitmap.height = hostComponent.height;
				}
			}
			super.updateBitmapdata();
		}
		override public function draw():void 
		{
			_bitmap.width = hostComponent.width;
			_bitmap.height = hostComponent.height;	
			
			if (hostComponent != null && _image != null)
			{
				if (hostComponent.autoSizeByImage == false)
				{
					_bitmap.width = hostComponent.width;
					_bitmap.height = hostComponent.height;
				}				
			}
		}
		override public function btnStateChange(state:uint):void
		{			
			if (image == null)
			{
				return;
			}			
			switch(state)
			{
				case UIConst.EtBtnNormal:
					{
						_bitmap.bitmapData = image.normalData;
					}
					break;
				case UIConst.EtBtnDown:
					{
						_bitmap.bitmapData = image.downData;
					}
					break;
				case UIConst.EtBtnOver:
					{
						_bitmap.bitmapData = image.overData;
					}
					break;
				case UIConst.EtBtnSelected:
					{
						_bitmap.bitmapData = image.seletedData;
					}
					break;
				default:
					break;
			}
			//_bitmap.width = hostComponent.width;
			//_bitmap.height = hostComponent.height;	
		}
		
		override public function unInstall():void
		{			
			hostComponent.removeBackgroundChild(_bitmap);
			super.unInstall();
		}
		protected function get image():ButtonImage
		{
			return (_image as ButtonImage);
		}
	
	}

}