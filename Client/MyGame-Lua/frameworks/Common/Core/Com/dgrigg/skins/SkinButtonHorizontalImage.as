package com.dgrigg.skins 
{
	import com.bit101.components.PushButton;
	import com.dgrigg.minimalcomps.skins.Skin;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import com.dgrigg.utils.UIConst;
	import com.dgrigg.image.ImageButtonHorizontal;
	/**
	 * ...
	 * @author 
	 */
	public class SkinButtonHorizontalImage extends Skin 
	{
		protected var _bitmap:Bitmap;
		protected var m_dataList:Vector.<BitmapData>;
		public function SkinButtonHorizontalImage() 
		{
			super();
			_imageClass = ImageButtonHorizontal;
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
			if (image != null && hostComponent != null)
			{
				_bitmap.bitmapData = getData(UIConst.EtBtnNormal);
				hostComponent.setSize(_bitmap.bitmapData.width, _bitmap.bitmapData.height);
				(hostComponent as PushButton).onSetSkin();
			}
			super.updateBitmapdata();
		}
		
		override public function draw():void 
		{
			for (var i:int = 0; i < 4; i++)
			{
				m_dataList[i] = null;
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
			m_dataList[state] = image.createData(state, hostComponent.width);
			return m_dataList[state];			
		}
		protected function get image():ImageButtonHorizontal
		{
			return (_image as ImageButtonHorizontal);
		}
	}

}