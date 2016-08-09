package com.dgrigg.skins 
{
	import com.bit101.components.Component;
	//import com.dgrigg.image.Image;
	import com.dgrigg.image.ImageGrid9;
	import com.dgrigg.minimalcomps.skins.Skin;
	import flash.display.Bitmap;
	//import flash.display.BitmapData;
	//import com.pblabs.engine.resource.SWFResource;
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	public class SkinGrid9Image9 extends Skin 
	{
		protected var _bitmapUpLeft:Bitmap;
		protected var _bitmapUpCenter:Bitmap;
		protected var _bitmapUpRight:Bitmap;
		
		protected var _bitmapCenterLeft:Bitmap;
		protected var _bitmapCenterCenter:Bitmap;
		protected var _bitmapCenterRight:Bitmap;
		
		protected var _bitmapBottomLeft:Bitmap;
		protected var _bitmapBottomCenter:Bitmap;
		protected var _bitmapBottomRight:Bitmap;
		
		public function SkinGrid9Image9() 
		{
			_imageClass = ImageGrid9;
			_bitmapUpLeft = new Bitmap();
			_bitmapUpCenter = new Bitmap();
			_bitmapUpRight = new Bitmap();
			
			_bitmapCenterLeft = new Bitmap();
			_bitmapCenterCenter = new Bitmap();
			_bitmapCenterRight = new Bitmap();
			
			_bitmapBottomLeft = new Bitmap();
			_bitmapBottomCenter = new Bitmap();
			_bitmapBottomRight = new Bitmap();
		}
		
		override public function init():void
		{
			hostComponent.addBackgroundChild(_bitmapUpLeft);			
			hostComponent.addBackgroundChild(_bitmapUpCenter);
			hostComponent.addBackgroundChild(_bitmapUpRight);
			
			hostComponent.addBackgroundChild(_bitmapCenterLeft);
			hostComponent.addBackgroundChild(_bitmapCenterCenter);
			hostComponent.addBackgroundChild(_bitmapCenterRight);
			
			hostComponent.addBackgroundChild(_bitmapBottomLeft);
			hostComponent.addBackgroundChild(_bitmapBottomCenter);
			hostComponent.addBackgroundChild(_bitmapBottomRight);
		}
		
		//直接加载公用图片
		public function setImageByName(imageName:String):void
		{
			Skin.m_cont.m_commonImageMgr.loadImage(imageName, ImageGrid9, onLoaded, onFailed);
		}
				
		
		override protected function updateBitmapdata():void
		{			
			_bitmapUpLeft.bitmapData = image.m1;
			_bitmapUpCenter.bitmapData = image.ma;
			_bitmapUpRight.bitmapData = image.m2;
			
			_bitmapCenterLeft.bitmapData = image.mb;			
			_bitmapCenterCenter.bitmapData = image.me;
			_bitmapCenterRight.bitmapData = image.md;			
			
			_bitmapBottomLeft.bitmapData = image.m3;
			_bitmapBottomCenter.bitmapData = image.mc;
			_bitmapBottomRight.bitmapData = image.m4;
			
			//-----------------------------------------
			_bitmapUpLeft.width = image.m1.width;
			_bitmapUpLeft.height = image.m1.height;
			
			_bitmapUpCenter.height = image.ma.height;
			_bitmapUpRight.width = image.m2.width;
			_bitmapUpRight.height = image.m2.height;
			
			_bitmapCenterLeft.width = image.mb.width;			
			_bitmapCenterRight.width = image.md.width;
			
			
			
			_bitmapBottomLeft.width = image.m3.width;
			_bitmapBottomLeft.height = image.m3.height;
			
			_bitmapBottomCenter.height = image.mc.height;
			_bitmapBottomRight.width = image.m4.width;
			_bitmapBottomRight.height = image.m4.height;
			
			//-----------------------			
			_bitmapUpCenter.x = _bitmapUpLeft.width;
			
			_bitmapCenterLeft.y = _bitmapUpLeft.height;
			_bitmapCenterCenter.x = _bitmapCenterLeft.width;
			_bitmapCenterCenter.y = _bitmapUpCenter.height;
			_bitmapCenterRight.y = _bitmapUpRight.height;
			
			_bitmapBottomCenter.x = _bitmapUpCenter.x;
			
			
			
			if (hostComponent != null)
			{
				hostComponent.draw();
			}
			
			super.updateBitmapdata();
		}
		
		override public function draw():void 
		{
			if (hostComponent == null)
			{
				return;
			}
			_bitmapUpCenter.width = hostComponent.width - (_bitmapUpLeft.width + _bitmapUpRight.width);
			_bitmapUpRight.x = hostComponent.width - _bitmapUpRight.width;
			
			_bitmapCenterLeft.height = hostComponent.height - (_bitmapUpLeft.height + _bitmapBottomLeft.height);
			_bitmapCenterCenter.width = hostComponent.width - (_bitmapCenterLeft.width + _bitmapCenterRight.width);
			_bitmapCenterCenter.height = hostComponent.height - (_bitmapUpCenter.height + _bitmapBottomCenter.height);
			_bitmapCenterRight.height = hostComponent.height - (_bitmapUpRight.height + _bitmapBottomRight.height);
			
			_bitmapBottomCenter.width = hostComponent.width - (_bitmapBottomLeft.width + _bitmapBottomRight.width);
			
			//--------
			_bitmapUpRight.x = hostComponent.width - _bitmapUpRight.width;
			_bitmapCenterRight.x = hostComponent.width - _bitmapCenterRight.width;
			_bitmapBottomLeft.y = hostComponent.height - _bitmapBottomLeft.height;
			_bitmapBottomCenter.y = _bitmapBottomLeft.y;
			
			_bitmapBottomRight.x = _bitmapUpRight.x;
			_bitmapBottomRight.y = _bitmapBottomCenter.y;
			
		}
		
		override public function set hostComponent(value:Component):void 
		{
			super.hostComponent = value;
			value.cacheAsBitmap = true;
		}		
		
		override public function unInstall():void
		{			
			hostComponent.removeBackgroundChild(_bitmapUpLeft);			
			hostComponent.removeBackgroundChild(_bitmapUpCenter);
			hostComponent.removeBackgroundChild(_bitmapUpRight);
			
			hostComponent.removeBackgroundChild(_bitmapCenterLeft);
			hostComponent.removeBackgroundChild(_bitmapCenterCenter);
			hostComponent.removeBackgroundChild(_bitmapCenterRight);
			
			hostComponent.removeBackgroundChild(_bitmapBottomLeft);
			hostComponent.removeBackgroundChild(_bitmapBottomCenter);
			hostComponent.removeBackgroundChild(_bitmapBottomRight);
			
			super.unInstall();			
		}
		
		protected function get image():ImageGrid9
		{
			return (_image as ImageGrid9);
		}
	}

}