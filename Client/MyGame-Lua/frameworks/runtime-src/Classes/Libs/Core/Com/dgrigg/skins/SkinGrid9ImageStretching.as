package com.dgrigg.skins 
{
	import com.dgrigg.minimalcomps.skins.Skin;
	import com.dgrigg.image.ImageGrid9;
	import flash.display.Bitmap;
	/**
	 * ...
	 * @author 
	 */
	public class SkinGrid9ImageStretching extends Skin 
	{
		protected var _bitmap:Bitmap;
		public function SkinGrid9ImageStretching() 
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
				_bitmap.bitmapData = image.createStretching(hostComponent.width, hostComponent.height);				
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