package com.dgrigg.skins 
{
	//import com.dgrigg.image.Image;
	import com.dgrigg.minimalcomps.skins.Skin;
	import com.dgrigg.image.PanelImage;	
	import flash.display.Bitmap;	
	import flash.display.BitmapData;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author 
	 * 这是图片拼接的方式
	 */
	public class SkinImagePinjie extends Skin 
	{
		protected var _backgroundImage:Bitmap;		
		public function SkinImagePinjie() 
		{
			super();
			_imageClass = PanelImage;
			_backgroundImage = new Bitmap();
		}
		
		override protected function updateBitmapdata():void
		{
			
			if (hostComponent == null || hostComponent.width==0 || hostComponent.height==0)
			{
				return;
			}
			
			var dataSrc:BitmapData = image.data;
			var dataDest:BitmapData = new BitmapData(hostComponent.width, hostComponent.height);
			var rect:Rectangle = new Rectangle();
			var pt:Point = new Point();
			var i:int;
			var j:int;
			var left:Number = 0;
			var top:Number = 0;
			while (1)
			{
				rect.height = Math.min(dataSrc.height, dataDest.height - pt.y);				
				while (1)
				{					
					rect.width = Math.min(dataSrc.width, dataDest.width - pt.x);
					dataDest.copyPixels(dataSrc, rect, pt);
					pt.x += rect.width;
					if (pt.x >= dataDest.width)
					{
						pt.x = 0;
						break;
					}
				}
				pt.y += rect.height;
				if (pt.y >= dataDest.height)
				{
					break;
				}
			}
			var filter:GlowFilter = new GlowFilter(0, 0.6, 30, 30, 2,1,true);
			_backgroundImage.filters = [filter];
			
			_backgroundImage.bitmapData = dataDest;			
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
			
		}
		public function get image():PanelImage
		{
			return (_image as PanelImage);
		}
		
	}

}