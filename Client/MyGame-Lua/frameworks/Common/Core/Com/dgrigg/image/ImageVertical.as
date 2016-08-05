package com.dgrigg.image 
{
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	import flash.display.BitmapData;
	import com.pblabs.engine.resource.SWFResource;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import com.util.PBUtil;
	import org.ffilmation.engine.helpers.fUtil;
	
	public class ImageVertical extends Image 
	{
		private var m_UpData:BitmapData; //上部分
		private var m_CenterData:BitmapData; 	 //中间部分
		private var m_BottomData:BitmapData;   //下部分
		
		public function ImageVertical() 
		{
			
		}
		public function get width():uint
		{
			return m_UpData.width;
		}
		public function get upHeight():uint
		{
			return m_UpData.height;
		}
		public function get centerHeight():uint
		{
			return m_CenterData.height;
		}
		public function get bottomHeight():uint
		{
			return m_BottomData.height;
		}
		
		public function get upData():BitmapData
		{
			return m_UpData;
		}
		
		public function get centerData():BitmapData
		{
			return m_CenterData;
		}
		
		public function get bottomData():BitmapData
		{
			return m_BottomData;
		}
		
		override public function parseBitmapData(bitMD:BitmapData):void
		{
			if (this.name.search("_mirror") == -1)
			{
				parseBitmapDataNotMirror(bitMD);
				
			}
			else
			{
				parseBitmapDataMirror(bitMD);
			}
		}
		
		/*
		 * 输入bitMD内只包含上中2部分，不包含下部分。下部分由上部分映像得到		 
		 */
		public function parseBitmapDataMirror(bitMD:BitmapData):void
		{
			var sourceRect:Rectangle = new Rectangle(0, 0, bitMD.width, bitMD.height-1);
			var desPoint:Point = new Point(0, 0);
			
			m_UpData = new BitmapData(sourceRect.width, sourceRect.height);
			m_UpData.copyPixels(bitMD, sourceRect, desPoint);
			
			sourceRect.y = sourceRect.height;
			sourceRect.height = 1;
			m_CenterData = new BitmapData(sourceRect.width, sourceRect.height);
			m_CenterData.copyPixels(bitMD, sourceRect, desPoint);
			
			m_BottomData = PBUtil.flipBitmapDataVer(m_UpData);
		}
		
		override public function parseSWF(res:SWFResource):Boolean
		{
			var classname:String = "art." + this.name;
			
			var bit:BitmapData = res.getExportedAsset(classname) as BitmapData;			
			if (bit != null)
			{	
				parseBitmapData(bit);
				loadState = Image.Loaded;
				return true;
			}
			var namePackage:String = fUtil.getNameOnly(this.name, "swf");
			namePackage = "art." + namePackage;
			classname = namePackage + ".up";
			bit = res.getExportedAsset(classname) as BitmapData;
			if(bit != null)
			{
				m_UpData = bit.clone();
				
				classname = namePackage + ".center";
				bit = res.getExportedAsset(classname) as BitmapData;
				m_CenterData = bit.clone();
				
				classname = namePackage + ".down";
				bit = res.getExportedAsset(classname) as BitmapData;
				m_BottomData = bit.clone();
				loadState = Image.Loaded;
				return true;
			}		
			loadState = Image.Failed;
			return false;
		}
		public function parseBitmapDataNotMirror(bitMD:BitmapData):void
		{
			var center:uint = bitMD.height / 2;
			var topHeight:uint = center;
			var bottomHeight:uint = bitMD.height - center - 1;
			
			m_UpData = new BitmapData(bitMD.width, topHeight);
			var sourceRect:Rectangle;
			var desPoint:Point = new Point(0, 0);
			sourceRect = new Rectangle(0, 0, bitMD.width, topHeight);
			m_UpData.copyPixels(bitMD, sourceRect, desPoint);
			
			m_CenterData = new BitmapData(bitMD.width, 1);
			sourceRect.y = topHeight;
			sourceRect.height = 1;
			m_CenterData.copyPixels(bitMD, sourceRect, desPoint);
			
			m_BottomData = new BitmapData(bitMD.width, bottomHeight);
			sourceRect.y = topHeight + 1;
			sourceRect.height = bottomHeight;
			m_BottomData.copyPixels(bitMD, sourceRect, desPoint);										
				
		}
		public function create(height:int):BitmapData
		{
			var ret:BitmapData = new BitmapData(width, height);
			var hCenter:Number = height - upHeight - bottomHeight;
			var mat:Matrix = new Matrix(1, 0,0,hCenter/centerHeight,0,upHeight);
			
			ret.draw(m_CenterData, mat, null, null, null, true);
			
			var rect:Rectangle = new Rectangle();
			var destPT:Point = new Point();
			
			rect.width = width;
			rect.height = upHeight;			
			ret.copyPixels(m_UpData, rect, destPT);
			
			rect.height = bottomHeight;
			destPT.y = height - bottomHeight;
			ret.copyPixels(m_BottomData, rect, destPT);
			return ret;
		}
	}

}