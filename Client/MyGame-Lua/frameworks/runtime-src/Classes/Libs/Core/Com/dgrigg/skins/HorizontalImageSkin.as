package com.dgrigg.skins 
{
	//import com.dgrigg.image.Image;
	import com.dgrigg.minimalcomps.skins.Skin;
	import com.dgrigg.image.HorizontalImage;
	import flash.display.Bitmap;
	
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	//HorizontalImage
	public class HorizontalImageSkin extends Skin 
	{	
		protected var _leftBitmap:Bitmap;		//左半部分
		protected var _centerBitmap:Bitmap;		//中间部分
		protected var _rightBitmap:Bitmap;		//右半部分		
		
		public function HorizontalImageSkin() 
		{
			super();
			_imageClass = HorizontalImage;
			_leftBitmap = new Bitmap();
			_centerBitmap = new Bitmap();
			_rightBitmap = new Bitmap();
		}
		
		override public function init():void
		{
			hostComponent.addBackgroundChild(_leftBitmap);
			hostComponent.addBackgroundChild(_centerBitmap);
			hostComponent.addBackgroundChild(_rightBitmap);
		}
		
		override public function unInstall():void
		{			
			hostComponent.removeBackgroundChild(_leftBitmap);
			hostComponent.removeBackgroundChild(_centerBitmap);
			hostComponent.removeBackgroundChild(_rightBitmap);
			super.unInstall();
		}	
		
		
		override public function draw():void 
		{			
			var widthCenter:int;
			widthCenter = hostComponent.width - _leftBitmap.width - _rightBitmap.width;
			_centerBitmap.width = widthCenter;
			_rightBitmap.x = _leftBitmap.width + _centerBitmap.width;	
			
		}
		override protected function updateBitmapdata():void
		{
			_leftBitmap.bitmapData = image.leftData;
			_centerBitmap.bitmapData = image.centerData;
			_rightBitmap.bitmapData = image.rightData;		
						
			_leftBitmap.width = image.leftWidth;
			_leftBitmap.height = image.height;
						
			_centerBitmap.x = image.leftWidth;
			_centerBitmap.height = image.height;
			
			_rightBitmap.width = image.rightWidth;
			_rightBitmap.height = image.height;
			
			if (hostComponent != null)
			{
				if (hostComponent.autoSizeByImage)
				{
					hostComponent.height = image.height;
				}
				draw();
			}
			super.updateBitmapdata();
		}
		protected function get image():HorizontalImage
		{
			return (_image as HorizontalImage);
		}
	}

}