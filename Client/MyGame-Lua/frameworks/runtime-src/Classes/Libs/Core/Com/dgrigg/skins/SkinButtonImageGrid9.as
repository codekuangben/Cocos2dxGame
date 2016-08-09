package com.dgrigg.skins 
{
	import com.bit101.components.PushButton;
	import com.dgrigg.image.ImageButtonGrid9;
	import com.dgrigg.minimalcomps.skins.Skin;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	//import com.dgrigg.utils.UIConst;
	/**
	 * ...
	 * @author 
	 */
	public class SkinButtonImageGrid9 extends Skin 
	{
		protected var _bitmap:Bitmap;
		protected var m_dataList:Vector.<BitmapData>;
		
		public function SkinButtonImageGrid9() 
		{
			super();
			_imageClass = ImageButtonGrid9;
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
			
			initBitmapData();
			super.updateBitmapdata();
		}
		override public function draw():void 
		{
			for (var i:int = 0; i < 4; i++)
			{
				m_dataList[i] = null;
			}
			initBitmapData();
			
		}
		
		private function initBitmapData():void
		{
			if (image != null && hostComponent&&hostComponent.width&& hostComponent.height)
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
			m_dataList[state] = image.createData(state, hostComponent.width, hostComponent.height);
			return m_dataList[state];			
		}
		protected function get image():ImageButtonGrid9
		{
			return (_image as ImageButtonGrid9);
		}
	}

}