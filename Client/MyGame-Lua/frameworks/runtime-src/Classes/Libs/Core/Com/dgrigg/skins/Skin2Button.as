package com.dgrigg.skins 
{
	import com.bit101.components.Button2State;
	import com.dgrigg.image.ButtonImage;
	import com.dgrigg.image.ImageList;
	import com.dgrigg.minimalcomps.skins.Skin;
	import flash.display.Bitmap;
	import com.dgrigg.utils.UIConst;
	/**
	 * ...
	 * @author 
	 */
	public class Skin2Button extends Skin 
	{
		protected var _bitmap:Bitmap;
		public function Skin2Button() 
		{
			_imageClass = ImageList;
			_bitmap = new Bitmap();
		}
		override public function init():void
		{
			hostComponent.addBackgroundChild(_bitmap);			
		}
		
		override protected function updateBitmapdata():void
		{
			var index:int = 0;
			if (hostComponent != null)
			{
				if ((hostComponent as Button2State).selected)
				{
					index = 1;
				}
				
				_bitmap.bitmapData = (image.getImage(index) as ButtonImage).normalData;
				hostComponent.setSize(_bitmap.bitmapData.width, _bitmap.bitmapData.height);
			}		
			super.updateBitmapdata();
		}
		
		override public function btnStateChange(state:uint):void
		{
			if (image == null)
			{
				return;
			}
			var index:int = 0;
			if ((hostComponent as Button2State).selected)
			{
				index = 1;
			}
			var btnImage:ButtonImage = image.getImage(index) as ButtonImage;
			switch(state)
			{
				case UIConst.EtBtnNormal:
					{
						_bitmap.bitmapData = btnImage.normalData;
					}
					break;
				case UIConst.EtBtnDown:
					{
						_bitmap.bitmapData = btnImage.downData;
					}
					break;
				case UIConst.EtBtnOver:
					{
						_bitmap.bitmapData = btnImage.overData;
					}
					break;
				case UIConst.EtBtnSelected:
					{
						_bitmap.bitmapData = btnImage.seletedData;
					}
					break;
				default:
					break;
			}
		}
		
		override public function unInstall():void
		{			
			hostComponent.removeBackgroundChild(_bitmap);
			super.unInstall();
		}
		protected function get image():ImageList
		{
			return (_image as ImageList);
		}
		
	}

}