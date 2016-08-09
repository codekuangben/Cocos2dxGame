package com.dgrigg.skins 
{
	import com.dgrigg.minimalcomps.skins.Skin;
	import com.dgrigg.image.ImageVertical;
	import com.dgrigg.image.Image;
	import flash.display.Bitmap;
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	//VerticalImage
	public class VerticalImageSkin extends Skin 
	{	
		protected var _upBitmap:Bitmap;			//上半部分
		protected var _centerBitmap:Bitmap;		//中间部分
		protected var _downBitmap:Bitmap;		//下半部分
		
		public function VerticalImageSkin() 
		{
			super();
			_imageClass = ImageVertical;
			_upBitmap = new Bitmap();
			_centerBitmap = new Bitmap();
			_downBitmap = new Bitmap();
		}
		
		override public function init():void
		{
			hostComponent.addBackgroundChild(_upBitmap);
			hostComponent.addBackgroundChild(_centerBitmap);
			hostComponent.addBackgroundChild(_downBitmap);			
		}
		
		override public function unInstall():void
		{			
			hostComponent.removeBackgroundChild(_upBitmap);
			hostComponent.removeBackgroundChild(_centerBitmap);
			hostComponent.removeBackgroundChild(_downBitmap);
			super.unInstall();	
		}
		
		
		override public function draw():void 
		{			
			if (image == null)
			{
				return;
			}
			if (hostComponent.height <= image.upHeight + image.bottomHeight)
			{
				_centerBitmap.height = 0;
			}
			else
			{
				_centerBitmap.height = hostComponent.height - image.upHeight - image.bottomHeight;
			}
			
			_downBitmap.y = _upBitmap.height + _centerBitmap.height;
			_downBitmap.height = hostComponent.height - _downBitmap.y;	
		}
		
		override protected function updateBitmapdata():void
		{
			_upBitmap.bitmapData = image.upData;
			_centerBitmap.bitmapData = image.centerData;
			_downBitmap.bitmapData = image.bottomData;			
			
			_upBitmap.width = image.width;
			_centerBitmap.width = image.width;
			_downBitmap.width = image.width;
			
			_centerBitmap.y = image.upHeight;
			super.updateBitmapdata();
		}
			
		override public function get width():int
		{
			if (image != null)
			{
				return image.width;
			}
			
			return 0;
		}		
		protected function get image():ImageVertical
		{
			return (_image as ImageVertical);
		}
	}

}