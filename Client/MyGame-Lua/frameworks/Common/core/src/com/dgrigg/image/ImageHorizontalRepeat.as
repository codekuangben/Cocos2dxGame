package com.dgrigg.image
{
	import com.util.PBUtil;
	import flash.display.BitmapData;
	import com.pblabs.engine.resource.SWFResource;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import org.ffilmation.engine.helpers.fUtil;
	
	/**
	 * ...
	 * @author
	 * 中段重复
	 */
	public class ImageHorizontalRepeat extends Image
	{
		private var m_LeftData:BitmapData;
		private var m_CenterData:BitmapData;
		private var m_RightData:BitmapData;
		
		public function ImageHorizontalRepeat()
		{
		
		}
		
		public function create(width:int):BitmapData
		{
			var wLeft:int = m_LeftData.width;
			var wRight:int = m_RightData.width;
			var wCenter:int = m_CenterData.width;
			var h:int = m_LeftData.height;
			
			var wCenterTotal:int = width - wLeft - wRight;
			var nCenter:int = wCenterTotal / wCenter;
			var w:int = wLeft + nCenter * wCenter + wRight;
			var ret:BitmapData = new BitmapData(w, h);
			
			var rect:Rectangle = new Rectangle();
			var destPT:Point = new Point();
			rect.height = h;
			
			rect.width = wLeft;			
			ret.copyPixels(m_LeftData, rect, destPT);
			
			var i:int;
			rect.width = wCenter;		
			destPT.x = wLeft;
			for (i = 0; i < nCenter; i++)
			{
				ret.copyPixels(m_CenterData, rect, destPT);
				destPT.x += wCenter;
			}
			
			rect.width = wRight;			
			ret.copyPixels(m_RightData, rect, destPT);
			
			return ret;			
		}
		
		override public function parseSWF(swf:SWFResource):Boolean
		{
			var classname:String;
			var bit:BitmapData;
			var namePackage:String = fUtil.getNameOnly(this.name, "swf");
			namePackage = "art." + namePackage;
			classname = namePackage + ".left";
			bit = swf.getExportedAsset(classname) as BitmapData;
			
			m_LeftData = bit.clone();
			
			classname = namePackage + ".center";
			bit = swf.getExportedAsset(classname) as BitmapData;
			m_CenterData = bit.clone();
			
			classname = namePackage + ".right";
			bit = swf.getExportedAsset(classname) as BitmapData;
			if (bit == null)
			{
				m_RightData = PBUtil.flipBitmapDataHori(m_LeftData);
			}
			loadState = Image.Loaded;
			return true;
			
			loadState = Image.Failed;
			return false;
		}
	}

}
