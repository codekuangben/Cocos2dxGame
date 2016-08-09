package  com.dgrigg.minimalcomps.skins 
{
	import com.dgrigg.minimalcomps.skins.Skin;
	//import com.bit101.components.Component;
	import flash.display.Bitmap;
	//import flash.display.BitmapData;
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	public class ImageSkin extends Skin
	{
		protected var _backgroundImage:Bitmap;
		public function ImageSkin():void
		{
			
		}
		/*public function setImage(asset:Class ):void
		{
			var bitMapdat:BitmapData = new asset();
			_backgroundImage = new Bitmap();
			_backgroundImage.bitmapData = bitMapdat;
		}*/
		override public function init():void
		{
			hostComponent.addChild(_backgroundImage);	
			_backgroundImage.width = hostComponent.width;
			_backgroundImage.height = hostComponent.height;
		}
		override public function draw():void
		{
			_backgroundImage.width = hostComponent.width;
			_backgroundImage.height = hostComponent.height;
		}
		
		override public function unInstall():void
		{
			hostComponent.removeChild(_backgroundImage);
			super.unInstall();
		}
		
	}

}