package com.dgrigg.skins 
{
	import com.dgrigg.image.ImageGrid9;
	import com.dgrigg.minimalcomps.skins.Skin;
	import flash.display.Bitmap;	
	/**
	 * ...
	 * @author zouzhiqiang
	 * 用于显示九风格图片，该Skin会创建新的BitmapData对象(采用像素拷贝的方式)
	 */
	public class SkinGrid9ImageOne extends Skin 
	{
		protected var _bitmap:Bitmap;
		
		public function SkinGrid9ImageOne() 
		{
			_imageClass = ImageGrid9;
			_bitmap = new Bitmap();		
		}
		
		override public function init():void
		{
			hostComponent.addBackgroundChild(_bitmap);			
		}
		
				
		override protected function updateBitmapdata():void
		{
			if (hostComponent != null)
			{
				_bitmap.bitmapData = image.create(hostComponent.width, hostComponent.height);				
			}
			super.updateBitmapdata();
		}
		
		override public function unInstall():void
		{			
			hostComponent.removeBackgroundChild(_bitmap);
			super.unInstall();			
		}
		protected function get image():ImageGrid9
		{
			return (_image as ImageGrid9);
		}		
	}

}