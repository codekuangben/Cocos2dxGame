package com.bit101.drag 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;	
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	public class DragResPool 
	{
		private var m_bitmap:Bitmap;
		private var m_bimapData:BitmapData;
		public function DragResPool() 
		{
			
		}
		public function getBitmap():Bitmap
		{
			if (m_bitmap == null)
			{
				m_bitmap = new Bitmap();
			}
			return m_bitmap;
		}
		
		public function getBitmapData(width:uint, height:uint):BitmapData
		{
			if (m_bimapData && m_bimapData.width == width && m_bimapData.height == height)
			{
				return m_bimapData;
			}
			m_bimapData = new BitmapData(width, height, true, 0x00ffffff);
			return m_bimapData;
		}
		
	}

}