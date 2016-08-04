package com.dgrigg.skins 
{
	import com.bit101.components.PushButton;
	import com.dgrigg.minimalcomps.skins.Skin;
	import flash.display.Bitmap;
	import com.dgrigg.image.ImageButtonVertical;
	//import com.dgrigg.image.Image
	//import com.dgrigg.utils.UIConst;
	import flash.display.BitmapData;
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	public class SkinButtonVertical extends Skin 
	{
		protected var _bitmap:Bitmap;
		protected var m_dataList:Vector.<BitmapData>;
		public function SkinButtonVertical()
		{
			super();
			_imageClass = ImageButtonVertical;
			_bitmap = new Bitmap();
			m_dataList = new Vector.<BitmapData>(4);
		}
		
		override public function init():void
		{
			hostComponent.addBackgroundChild(_bitmap);			
		}
		
		override public function unInstall():void
		{			
			hostComponent.removeBackgroundChild(_bitmap);
			super.unInstall();
		}
		
		override protected function updateBitmapdata():void
		{						
			if (image != null && hostComponent != null && hostComponent.height > 0)
			{
				_bitmap.bitmapData = getData((hostComponent as PushButton).state);
				//hostComponent.height = _bitmap.bitmapData.height;				
			}
			super.updateBitmapdata();
		}
		
		override public function draw():void 
		{
			for (var i:int = 0; i < 4; i++)
			{
				m_dataList[i] = null;
			}
			
			if (_image&&hostComponent && hostComponent.height > 0)
			{
				_bitmap.bitmapData = getData((hostComponent as PushButton).state);
			}
		}
			
		override public function btnStateChange(state:uint):void
		{			
			if (image == null)
			{
				return;
			}
			_bitmap.bitmapData = getData(state);			
		}
		
		protected function getData(state:int):BitmapData
		{
			if (m_dataList[state] != null)
			{
				return m_dataList[state];
			}
			m_dataList[state] = image.createData(state, hostComponent.height);
			return m_dataList[state];			
		}
		
		protected function get image():ImageButtonVertical
		{
			return (_image as ImageButtonVertical);
		}
	}

}