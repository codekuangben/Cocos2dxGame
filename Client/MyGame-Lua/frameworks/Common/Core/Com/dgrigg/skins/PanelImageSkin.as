package com.dgrigg.skins 
{
	
	//import com.dgrigg.image.Image;
	import com.dgrigg.minimalcomps.skins.Skin;
	import com.dgrigg.image.PanelImage;	
	import flash.display.Bitmap;	
	/**
	 * ...
	 */
	//PanelImage
	public class PanelImageSkin extends Skin
	{
		protected var _backgroundImage:Bitmap;		
		public function PanelImageSkin() 
		{
			super();
			_imageClass = PanelImage;
			_backgroundImage = new Bitmap();
		}
		
		override protected function updateBitmapdata():void
		{
			_backgroundImage.bitmapData = image.data;
			if (hostComponent != null && _image != null)
			{
				if (hostComponent.autoSizeByImage)
				{
					if (hostComponent.width != image.width || hostComponent.height != image.height)
					{
						hostComponent.setSize(image.width,image.height);
					}
					_backgroundImage.width = image.width;
					_backgroundImage.height = image.height;
				}
				else
				{
					_backgroundImage.width = hostComponent.width;
					_backgroundImage.height = hostComponent.height;
				}
			}
			super.updateBitmapdata();
		}
		
		override public function init():void
		{
			hostComponent.addBackgroundChild(_backgroundImage);		
		}
	
		override public function unInstall():void
		{			
			hostComponent.removeBackgroundChild(_backgroundImage);
			super.unInstall();
		}
		override public function draw():void 
		{
			if (hostComponent != null && _image != null)
			{
				if (hostComponent.autoSizeByImage == false)
				{
					_backgroundImage.width = hostComponent.width;
					_backgroundImage.height = hostComponent.height;
				}				
			}
		}
		public function get image():PanelImage
		{
			return (_image as PanelImage);
		}
	}
}