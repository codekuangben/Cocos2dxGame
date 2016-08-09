package com.dgrigg.skins 
{
	//import com.dgrigg.image.Image;
	import com.dgrigg.minimalcomps.skins.Skin;
	import com.dgrigg.image.ImageForm;
	//import com.pblabs.engine.resource.SWFResource;
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	import flash.display.Bitmap;
	public class SkinForm extends Skin 
	{
		protected var _backgroundImage:Bitmap;		
		protected var _onSetFormSkin:Function;
		public function SkinForm() 
		{
			super();
			_imageClass = ImageForm;
			_backgroundImage = new Bitmap();
		}	
			
		override protected function updateBitmapdata():void
		{
			if (hostComponent != null && hostComponent.width > 100 && hostComponent.height > 100)
			{
				generateBitmapData();
				if (_onSetFormSkin != null)
				{
					_onSetFormSkin();
				}
			}
			super.updateBitmapdata();
		}
		
		protected function generateBitmapData():void
		{
			_backgroundImage.bitmapData = image.create(hostComponent.width, hostComponent.height);
			_backgroundImage.width = _backgroundImage.bitmapData.width;
			_backgroundImage.height = _backgroundImage.bitmapData.height;
			hostComponent.width = _backgroundImage.width;
			hostComponent.height = _backgroundImage.height;
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
		protected function get image():ImageForm
		{
			return (_image as ImageForm);
		}
		
		override public function draw():void 
		{
			if (hostComponent != null && image)
			{
				if (hostComponent.width != _backgroundImage.width || hostComponent.height != _backgroundImage.height)
				{
					generateBitmapData();
				}
			}
		}
		
		public function set onSetFormSkin(fun:Function):void
		{
			_onSetFormSkin = fun;
		}
		override public function get width():int
		{
			if (_backgroundImage)
			{
				return _backgroundImage.width;
			}
			return 0;
		}
		
		override public function get height():int
		{
			if (_backgroundImage)
			{
				return _backgroundImage.height;
			}
			return 0;
		}		
	}

}