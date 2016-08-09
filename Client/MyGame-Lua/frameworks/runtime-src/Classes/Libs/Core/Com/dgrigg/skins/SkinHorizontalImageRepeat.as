package com.dgrigg.skins 
{
	import com.dgrigg.image.ImageHorizontalRepeat;
	import com.dgrigg.minimalcomps.skins.Skin;
	import flash.display.Bitmap;	
	/**
	 * ...
	 * @author 
	 */
	public class SkinHorizontalImageRepeat extends Skin 
	{
		protected var _bitmap:Bitmap;
		public function SkinHorizontalImageRepeat() 
		{
			_imageClass = ImageHorizontalRepeat;
			_bitmap = new Bitmap();
		}
		override public function init():void
		{
			hostComponent.addBackgroundChild(_bitmap);			
		}
						
		//这里，处理成可以拉伸的方式
		override protected function updateBitmapdata():void
		{
			if (hostComponent != null)
			{
				_bitmap.bitmapData = image.create(hostComponent.width);
				_bitmap.width = hostComponent.width;	
				if (hostComponent.autoSizeByImage)
				{
					hostComponent.height = _bitmap.bitmapData.height;
				}
				else
				{
					_bitmap.height = hostComponent.height;
				}
				
			}
			super.updateBitmapdata();
		}
		
		override public function unInstall():void
		{			
			hostComponent.removeBackgroundChild(_bitmap);
			super.unInstall();			
		}
		protected function get image():ImageHorizontalRepeat
		{
			return (_image as ImageHorizontalRepeat);
		}	
	}

}