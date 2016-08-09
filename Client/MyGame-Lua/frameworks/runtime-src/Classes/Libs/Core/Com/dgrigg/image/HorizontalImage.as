package com.dgrigg.image
{
	import flash.display.BitmapData;
	import com.pblabs.engine.resource.SWFResource;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import com.util.PBUtil;
	import org.ffilmation.engine.helpers.fUtil;
	
	/**
	 * ...
	 * @author zouzhiqiang
	 * 有3种解析方式
	 * 1. 3部分在一张png图片内，分成左中右3部分
	 * 2. 3部分在一张png图片内，只提供左中部分
	 * 3. 3部分分别在3张图片内，通过swf包的形式存在，每个部分的类名分别是left, center, right
	 */
	public class HorizontalImage extends Image
	{
		private var m_LeftData:BitmapData; //左部分
		private var m_CenterData:BitmapData; //中间部分
		private var m_RightData:BitmapData; //右部分
		
		public function HorizontalImage()
		{
		
		}
		
		public function get leftWidth():uint
		{
			if (m_LeftData != null)
			{
				return m_LeftData.width;
			}
			return 0;
		}
		
		public function get centerWidth():uint
		{
			if (m_CenterData != null)
			{
				return m_CenterData.width;
			}
			return 0;
		}
		
		public function get rightWidth():uint
		{
			if (m_RightData != null)
			{
				return m_RightData.width;
			}
			return 0;
		}
		
		public function get height():uint
		{
			if (m_LeftData != null)
			{
				return m_LeftData.height;
			}
			return 0;
		}
		
		public function get leftData():BitmapData
		{
			return m_LeftData;
		}
		
		public function get centerData():BitmapData
		{
			return m_CenterData;
		}
		
		public function get rightData():BitmapData
		{
			return m_RightData;
		}
		
		public function create(width:int):BitmapData
		{
			var ret:BitmapData = new BitmapData(width, height);
			var wCenter:Number = width - leftWidth - rightWidth;
			
			if (wCenter < 0)
			{
				return m_LeftData;
			}
			var rect:Rectangle = new Rectangle();
			var destPT:Point = new Point();
			if (m_CenterData.width == 1)
			{
				var i:int = leftWidth;
				rect.width = 1;
				rect.height = m_CenterData.height;
				destPT.x = leftWidth;
				for (i = 0; i < wCenter; i++)
				{
					ret.copyPixels(m_CenterData, rect, destPT);
					destPT.x++;
				}
			}
			else
			{
				var mat:Matrix = new Matrix(wCenter / centerWidth, 0, 0, 1, leftWidth, 0);			
				ret.draw(m_CenterData, mat, null, null, null, true);
			}
			
			rect.x = 0;
			rect.y = 0;			
			rect.width = leftWidth;
			rect.height = height;
			destPT.x = 0;
			destPT.y = 0;
			ret.copyPixels(m_LeftData, rect, destPT);
			
			rect.width = rightWidth;
			destPT.x = width - rightWidth;
			ret.copyPixels(m_RightData, rect, destPT);
			return ret;
		}
		
		override public function parseSWF(swf:SWFResource):Boolean
		{
			var classname:String = "art." + this.name;
			var bit:BitmapData = swf.getExportedAsset(classname) as BitmapData;
			if (bit != null)
			{
				parseBitmapData(bit);
				loadState = Image.Loaded;
				return true;
			}
			
			var namePackage:String = fUtil.getNameOnly(this.name, "swf");
			namePackage = "art." + namePackage;
			classname = namePackage + ".left";
			bit = swf.getExportedAsset(classname) as BitmapData;
			if (bit != null)
			{
				m_LeftData = bit.clone();
				classname = namePackage + ".center";
				bit = swf.getExportedAsset(classname) as BitmapData;
				if (bit)
				{
					//采用.left; .center; .right方式					
					classname = namePackage + ".center";
					bit = swf.getExportedAsset(classname) as BitmapData;
					m_CenterData = bit.clone();
					
					classname = namePackage + ".right";
					bit = swf.getExportedAsset(classname) as BitmapData;
					if (bit)
					{
						m_RightData = bit.clone();
					}
					else
					{
						m_RightData = PBUtil.flipBitmapDataHori(m_LeftData);
					}
				}
				else
				{
					//只有left。m_CenterData是left的最后一列；right是left的映像
					var rect:Rectangle = new Rectangle();
					rect.x = m_LeftData.width - 1;
					rect.width = 1;
					rect.height = m_LeftData.height;
					var destPT:Point = new Point();
					m_CenterData = new BitmapData(1, rect.height);
					m_CenterData.copyPixels(m_LeftData, rect, destPT);
					m_RightData = PBUtil.flipBitmapDataHori(m_LeftData);
					
				}
				loadState = Image.Loaded;
				return true;
			}
			
			loadState = Image.Failed;
			return false;
		}
		
		/*
		 * 输入bitMD内只包含左中2部分，不包含右部分。右部分由左部分映像得到
		 *
		 */
		public function parseBitmapDataMirror(bitMD:BitmapData):void
		{
			var sourceRect:Rectangle = new Rectangle(0, 0, bitMD.width - 1, bitMD.height);
			var desPoint:Point = new Point(0, 0);
			
			m_LeftData = new BitmapData(sourceRect.width, sourceRect.height);
			m_LeftData.copyPixels(bitMD, sourceRect, desPoint);
			
			sourceRect.x = sourceRect.width;
			sourceRect.width = 1;
			m_CenterData = new BitmapData(sourceRect.width, sourceRect.height);
			m_CenterData.copyPixels(bitMD, sourceRect, desPoint);
			
			m_RightData = PBUtil.flipBitmapDataHori(m_LeftData);
		}
		
		/*
		 * 输入bitMD内只包含左中2部分，不包含右部分。右部分由左部分映像得到
		 *
		 */
		public function parseBitmapDataNotMirror(bitMD:BitmapData, coor:Point = null):void
		{
			var cutP:Point = new Point();
			var sourceRect:Rectangle = new Rectangle();
			var desPoint:Point = new Point(0, 0);
			if (coor != null)
			{
				cutP = coor;
			}
			else
			{
				cutP.x = bitMD.width / 2;
				cutP.y = 1;
			}
			
			sourceRect.x = 0;
			sourceRect.y = 0;
			sourceRect.width = cutP.x;
			sourceRect.height = bitMD.height;
			
			m_LeftData = new BitmapData(sourceRect.width, sourceRect.height);
			m_LeftData.copyPixels(bitMD, sourceRect, desPoint);
			
			sourceRect.x = cutP.x;
			sourceRect.width = cutP.y;
			
			m_CenterData = new BitmapData(sourceRect.width, sourceRect.height);
			m_CenterData.copyPixels(bitMD, sourceRect, desPoint);
			
			sourceRect.x = cutP.x + cutP.y;
			sourceRect.width = bitMD.width - sourceRect.x;
			
			m_RightData = new BitmapData(sourceRect.width, sourceRect.height);
			m_RightData.copyPixels(bitMD, sourceRect, desPoint);
		}
		
		/*
		 * coor表示图像的截取方式：x:中间部分的x坐标；y:表示中间部分的宽度
		 */
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
	
	}

}