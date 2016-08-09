package com.dgrigg.image
{
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	import flash.display.BitmapData;
	import com.pblabs.engine.resource.SWFResource;
	import com.util.PBUtil;
	import com.pblabs.engine.debug.Logger;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class PanelImage extends Image
	{
		private var m_data:BitmapData;
		
		public function PanelImage()
		{
		
		}
		
		public function get data():BitmapData
		{
			return m_data;
		}
		
		public function get width():uint
		{
			if (m_data == null)
			{
				return 0;
			}
			return m_data.width;
		}
		
		public function get height():uint
		{
			if (m_data == null)
			{
				return 0;
			}
			return m_data.height;
		}
		
		override public function mirrorImage(mode:String):Image
		{
			if (m_data == null)
			{
				return null;
			}
			var mirror:PanelImage = new PanelImage();
			var bit:BitmapData;
			var pt:Point;
			var rect:Rectangle;
			if (mode == MirrorMode_HOR)
			{
				bit = PBUtil.flipBitmapDataHori(m_data);
			}
			else if (mode == MirrorMode_VER)
			{
				bit = PBUtil.flipBitmapDataVer(m_data);
			}
			else if (mode == MirrorMode_LR)
			{
				bit = composeFromLeftPart(m_data);
			}
			else if (mode == MirrorMode_LT)
			{
				bit = new BitmapData(m_data.width * 2, m_data.height * 2);
				rect = new Rectangle(0, 0, m_data.width, m_data.height);
				pt = new Point();
				bit.copyPixels(m_data, rect, pt);
				
				pt.x = m_data.width;
				var tempBit:BitmapData = PBUtil.flipBitmapDataHori(m_data);
				bit.copyPixels(tempBit, rect, pt);
				
				pt.y = m_data.height;
				tempBit = PBUtil.flipBitmapDataVer(tempBit);
				bit.copyPixels(tempBit, rect, pt);
				
				pt.x = 0;
				tempBit = PBUtil.flipBitmapDataVer(m_data);
				bit.copyPixels(tempBit, rect, pt);
			}
			else if (mode == MirrorMode_L_VER)
			{
				bit = composeFromLeftPart(m_data);				
				bit = PBUtil.flipBitmapDataVer(bit);
			}
			else if (mode == MirrorMode_Top_TopBottom)
			{
				bit = composeFromTopPart(m_data);								
			}
			else if (mode == MirrorMode_ClockwiseRotation90)
			{
				bit = PBUtil.flipBitmapDataClockwiseRotation90(m_data);
			}
			else if (mode == MirrorMode_AnticlockwiseRotation90)
			{
				bit = PBUtil.flipBitmapDataAnticlockwiseRotation90(m_data);
			}
			mirror.m_data = bit;
			mirror.loadState = Image.Loaded;
			mirror.name = this.name + mode;
			return mirror;
		}
		
		override public function parseSWF(swf:SWFResource):Boolean
		{
			var classname:String = "art." + this.name;
			var bit:BitmapData = swf.getExportedAsset(classname) as BitmapData;
			
			if (bit != null)
			{
				parseBitmapData(bit);
				bit.dispose();
				bit = null;
				return true;
			}
			else
			{
				Logger.info(null, null, "PanelImage::parseSWF(加载" + classname + "失败)在" + swf.filename + "中");
			}
			loadState = Image.Failed;
			return false;
		}
		
		override public function parseBitmapData(data:BitmapData):void
		{
			m_data = data.clone();
			loadState = Image.Loaded;
		}
		
		public function setBitmapDataDirect(data:BitmapData):void
		{
			m_data = data;
			loadState = Image.Loaded;
		}
		
		public static function composeFromLeftPart(data:BitmapData):BitmapData
		{
			var ret:BitmapData = new BitmapData(data.width * 2, data.height);
			
			var rightBit:BitmapData = PBUtil.flipBitmapDataHori(data);
			var rect:Rectangle = new Rectangle(0, 0, data.width, data.height);
			var pt:Point = new Point();
			ret.copyPixels(data, rect, pt);
			pt.x = data.width;
			ret.copyPixels(rightBit, rect, pt);
			return ret;
		}
		public static function composeFromTopPart(data:BitmapData):BitmapData
		{
			var ret:BitmapData = new BitmapData(data.width, data.height * 2);
			
			var bottomBit:BitmapData = PBUtil.flipBitmapDataVer(data);
			var rect:Rectangle = new Rectangle(0, 0, data.width, data.height);
			var pt:Point = new Point();
			ret.copyPixels(data, rect, pt);
			pt.y = data.height;
			ret.copyPixels(bottomBit, rect, pt);
			return ret;
		}
	
	}

}