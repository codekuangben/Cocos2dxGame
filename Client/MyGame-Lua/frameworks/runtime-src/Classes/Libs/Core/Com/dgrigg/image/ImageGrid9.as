package com.dgrigg.image 
{
	import com.pblabs.engine.resource.SWFResource;
	import com.util.DebugBox;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import org.ffilmation.engine.helpers.fUtil;
	import com.util.PBUtil;
	//import com.pblabs.engine.debug.Logger;
	/**
	 * ...
	 * @author zouzhiqiang
	 * 能够解析9宫格图片
	 * 每个部分的类名如下
	 * art.grid9StyleTwo.m1
	 * art.grid9styleTwo.m2等等
	 * 目前有3种解析方式(这3种解析方式是由名称(Image.name)来区分的):
	 *	1. 9部分在一张图片内.(SWFResource内不含m1这个类)
	 * 	2. 提供m1、ma、mb、me。m2、m3、m4有m1镜像得到；mc由ma镜像得到；md由mb镜像得到。(默认方式)
	 *  3. 提供m1、m3、ma、mb、mc、me。m2由m1镜像得到；m4由m3镜像得到；md由mb镜像得到。(嵌入类的名称中含有_1)
	 * 	4. 提供左上角m1，m1这里的m1与上面的m1不同。该m1中包含正常的m1,ma,mb,me(嵌入类的名称中含有_2)
	 */
	public class ImageGrid9 extends Image 
	{		
		private var m_1:BitmapData; //左上
		private var m_2:BitmapData; //右上
		private var m_3:BitmapData; //左下
		private var m_4:BitmapData; //右下
		
		private var m_a:BitmapData; //上
		private var m_b:BitmapData; //左
		private var m_c:BitmapData; //下
		private var m_d:BitmapData; //右
		
		public var m_colorCenter:uint;	//中间部分的颜色
		private var m_e:BitmapData; //中
			
		public function get m1():BitmapData
		{
			return m_1;
		}
		
		public function get m2():BitmapData
		{
			return m_2;
		}
		
		public function get m3():BitmapData
		{
			return m_3;
		}
		
		public function get m4():BitmapData
		{
			return m_4;
		}
		
		public function get ma():BitmapData
		{
			return m_a;
		}
		
		public function get mb():BitmapData
		{
			return m_b;
		}
		
		public function get mc():BitmapData
		{
			return m_c;
		}
		
		public function get md():BitmapData
		{
			return m_d;
		}	
		
		public function get me():BitmapData
		{
			return m_e;
		}
		
		
		//rect表示中间部分的范围
		override public function parseSWF(res:SWFResource):Boolean
		{
			var namePackage:String = fUtil.getNameOnly(this.name, "swf");
			var classname:String;
			var data:BitmapData;
			
			namePackage = "art." + namePackage;
			classname = namePackage;
			if (res.hasAssetClass(classname))
			{
				data = (res.getExportedAsset(classname)) as BitmapData;
				parseBitmapData(data);
				return true;
			}
			
			classname = namePackage + "." + "m1";
			if (res.hasAssetClass(classname))
			{
				subParse(namePackage + ".", res);				
				return true;
			}
			
			classname = namePackage + "_1." + "m1";
			if (res.hasAssetClass(classname))
			{
				subParse1(namePackage + "_1.", res);				
				return true;
			}
			classname = namePackage + "_2." + "m1";
			if (res.hasAssetClass(classname))
			{
				subParse2(namePackage + "_2.", res);				
				return true;
			}
			return false;			
		}
		
		protected function subParse(namePackage:String, res:SWFResource):void
		{
			var classname:String = namePackage + "m1";
			var data:BitmapData;
			
			data = (res.getExportedAsset(classname)) as BitmapData;
			m_1 = data.clone();
			
			classname = namePackage + "m2";
			data = (res.getExportedAsset(classname)) as BitmapData;
			if (data!=null)
			{
				m_2 = data.clone();
			}
			else
			{
				m_2 = PBUtil.flipBitmapDataHori(m_1);
			}
						
			classname = namePackage + "m3";
			data = (res.getExportedAsset(classname)) as BitmapData;
			if (data!=null)
			{
				m_3 = data.clone();
			}
			else
			{
				m_3 = PBUtil.flipBitmapDataVer(m_1);
			}
			
			classname = namePackage + "m4";
			data = (res.getExportedAsset(classname)) as BitmapData;
			if (data!=null)
			{
				m_4 = data.clone();
			}
			else
			{
				m_4 = PBUtil.flipBitmapDataHori(m_3); 
			}		
			 
			
			classname = namePackage + "ma";
			data = (res.getExportedAsset(classname)) as BitmapData;
			m_a = data.clone();
			
			classname = namePackage + "mc";
			data = (res.getExportedAsset(classname)) as BitmapData;
			if (data!=null)
			{
				m_c = data.clone();
			}
			else
			{
				m_c = PBUtil.flipBitmapDataVer(m_a);
			}	
			
			
			classname = namePackage + "mb";
			data = (res.getExportedAsset(classname)) as BitmapData;
			m_b = data.clone();
			
			classname = namePackage + "md";
			data = (res.getExportedAsset(classname)) as BitmapData;
			if (data!=null)
			{
				m_d = data.clone();
			}
			else
			{
				m_d = PBUtil.flipBitmapDataHori(m_b);
			}	
			
			
			classname = namePackage + "me";
			data = (res.getExportedAsset(classname)) as BitmapData;
			if (data != null)
			{
				m_e = data.clone();
				m_colorCenter = m_e.getPixel32(0, 0);
			}
			else
			{
				m_e = new BitmapData(1, 1, true, 0);
				m_colorCenter = 0;
			}
			loadState = Image.Loaded;
		}
		
		protected function subParse1(namePackage:String, res:SWFResource):void
		{
			var classname:String = namePackage + "m1";
			var data:BitmapData;
			
			data = (res.getExportedAsset(classname)) as BitmapData;
			m_1 = data.clone();
			m_2 = PBUtil.flipBitmapDataHori(m_1);
			
			classname = namePackage + "m3";
			data = (res.getExportedAsset(classname)) as BitmapData;
			m_3 = data;
			m_4 = PBUtil.flipBitmapDataHori(m_3);
			
			
			classname = namePackage + "ma";
			data = (res.getExportedAsset(classname)) as BitmapData;
			m_a = data.clone();
			
			classname = namePackage + "mc";
			data = (res.getExportedAsset(classname)) as BitmapData;			
			m_c = data.clone();
			
			classname = namePackage + "mb";
			data = (res.getExportedAsset(classname)) as BitmapData;
			m_b = data.clone();
			m_d = PBUtil.flipBitmapDataHori(m_b);
			
			classname = namePackage + "me";
			data = (res.getExportedAsset(classname)) as BitmapData;
			if (data != null)
			{
				m_e = data.clone();
				m_colorCenter = m_e.getPixel32(0, 0);
			}
			else
			{
				m_e = new BitmapData(1, 1, true, 0);
				m_colorCenter = 0;
			}
			loadState = Image.Loaded;			
		}
		
		protected function subParse2(namePackage:String, res:SWFResource):void
		{
			var classname:String = namePackage + "m1";
			var data:BitmapData;
			var rect:Rectangle = new Rectangle();
			var pt:Point = new Point();
			
			data = (res.getExportedAsset(classname)) as BitmapData;
			
			var aW:int = data.width - 1;
			var aH:int = data.height - 1;
			
			m_1 = new BitmapData(aW, aH);
			rect.width = aW;
			rect.height = aH;
			pt.x = 0;
			pt.y = 0;
			m_1.copyPixels(data, rect, pt);
			m_2 = PBUtil.flipBitmapDataHori(m_1);			
			
			m_3 = PBUtil.flipBitmapDataVer(m_1);
			m_4 = PBUtil.flipBitmapDataHori(m_3);
			
			m_a = new BitmapData(1, aH);
			rect.x = aW;
			rect.width = 1;
			rect.height = aH;
			m_a.copyPixels(data, rect, pt);
			
			m_b = new BitmapData(aW, 1);
			rect.x = 0;
			rect.y = aH;
			rect.width = aW;
			rect.height = 1;
			m_b.copyPixels(data, rect, pt);
			
			m_c=PBUtil.flipBitmapDataVer(m_a);
			m_d = PBUtil.flipBitmapDataHori(m_b);
			
			m_colorCenter = data.getPixel32(aW, aH);
			m_e = new BitmapData(1, 1, true, 0);
			m_e.setPixel32(0, 0, m_colorCenter);			
			loadState = Image.Loaded;
		}
		override public function parseBitmapData(bitMD:BitmapData):void
		{
			var left:int = bitMD.width / 2;
			var right:int = bitMD.height / 2;
			var rect:Rectangle = new Rectangle(left, right, 1, 1);
			var sourceRect:Rectangle = new Rectangle();
			var desPoint:Point = new Point(0, 0);
			sourceRect.x = 0;
			sourceRect.y = 0;
			sourceRect.width = rect.x;
			sourceRect.height = rect.y;
			
			m_1 = new BitmapData(sourceRect.width, sourceRect.height);
			m_1.copyPixels(bitMD, sourceRect, desPoint);
			
			
			sourceRect.x = rect.x;
			sourceRect.y = 0;
			sourceRect.width = rect.width;
			sourceRect.height = rect.y;
			
			m_a = new BitmapData(sourceRect.width, sourceRect.height);
			m_a.copyPixels(bitMD, sourceRect, desPoint);
			
			sourceRect.x = rect.x + rect.width;
			sourceRect.y = 0;
			sourceRect.width = bitMD.width - sourceRect.x;
			sourceRect.height = rect.y;
			
			m_2 = new BitmapData(sourceRect.width, sourceRect.height);
			m_2.copyPixels(bitMD, sourceRect, desPoint);
			//-------------
			sourceRect.x = 0;
			sourceRect.y = rect.y;
			sourceRect.width = rect.x;
			sourceRect.height = rect.height;
			
			m_b = new BitmapData(sourceRect.width, sourceRect.height);
			m_b.copyPixels(bitMD, sourceRect, desPoint);
			
			sourceRect.x = rect.x;
			sourceRect.y = rect.y;
			sourceRect.width = rect.width;
			sourceRect.height = rect.height;
			
			m_e = new BitmapData(sourceRect.width, sourceRect.height);
			m_e.copyPixels(bitMD, sourceRect, desPoint);
			m_colorCenter = m_e.getPixel32(0, 0);
			
			sourceRect.x = rect.x + rect.width;
			sourceRect.y = rect.y;
			sourceRect.width = bitMD.width - sourceRect.x;
			sourceRect.height = rect.height;
			
			m_d = new BitmapData(sourceRect.width, sourceRect.height);
			m_d.copyPixels(bitMD, sourceRect, desPoint);
			
			//------------
			sourceRect.x = 0;
			sourceRect.y = rect.y + rect.height;
			sourceRect.width = rect.x;
			sourceRect.height = bitMD.height - sourceRect.y;
			
			m_3 = new BitmapData(sourceRect.width, sourceRect.height);
			m_3.copyPixels(bitMD, sourceRect, desPoint);
			
			sourceRect.x = rect.x;
			sourceRect.y = rect.y + rect.height;
			sourceRect.width = rect.width;
			sourceRect.height = bitMD.height - sourceRect.y;
			
			m_c = new BitmapData(sourceRect.width, sourceRect.height);
			m_c.copyPixels(bitMD, sourceRect, desPoint);
			
			sourceRect.x = rect.x + rect.width;
			sourceRect.y = rect.y + rect.height;
			sourceRect.width = bitMD.width - sourceRect.x;
			sourceRect.height = bitMD.height - sourceRect.y;
			
			m_4 = new BitmapData(sourceRect.width, sourceRect.height);
			m_4.copyPixels(bitMD, sourceRect, desPoint);
			
			loadState = Image.Loaded;
		}
		public function createStretching(width:int, height:int):BitmapData
		{
			if (width < m1.width + m1.height)
			{
				width = m1.width + m1.height;
			}
			if (height < m1.height + m3.height)
			{
				height = m1.height + m3.height;
			}
						
			var data:BitmapData = new BitmapData(width, height, true, m_colorCenter);
			
			var sourceRect:Rectangle = new Rectangle(0,0,m_1.width, m_1.height);
			var desPoint:Point = new Point(0, 0);			
			data.copyPixels(m_1, sourceRect, desPoint);
			
			sourceRect.width = m_2.width;
			desPoint.x = width - m_2.width;
			data.copyPixels(m_2, sourceRect, desPoint);
			
			sourceRect.width = m_3.width;
			sourceRect.height = m_3.height;
			desPoint.x = 0;
			desPoint.y = height - m_3.height;
			data.copyPixels(m_3, sourceRect, desPoint);
			
			sourceRect.width = m_4.width;
			sourceRect.height = m_4.height;
			desPoint.x = width - m_4.width;
			desPoint.y = height - m_4.height;
			data.copyPixels(m_4, sourceRect, desPoint);
			
			
			var mat:Matrix = new Matrix();
			//a部分
			mat.tx = m_1.width;
			mat.a = (width - (m_1.width + m_2.width)) / m_a.width;
			data.draw(m_a, mat);
			
			//c部分
			mat.ty = height - m_c.height;			
			data.draw(m_c, mat);
					
			//b部分
			mat.tx = 0;
			mat.a = 1;			
			mat.ty = m_1.height;
			mat.d = (height - (m_1.height + m_3.height)) / m_b.height;		
			data.draw(m_b, mat);
			
			//d部分
			mat.tx = width - m_d.width;
			mat.ty = m_1.height;
			mat.d = (height - (m_1.height + m_3.height)) / m_b.height;		
			data.draw(m_d, mat);			
			
			return data;
		}
		public function create(width:int, height:int):BitmapData
		{
			width = roundWidth(width);
			height = roundHeight(height);
			if (width == 0 || height == 0)
			{				
				return null;
			}
			var data:BitmapData = new BitmapData(width, height, true, m_colorCenter);
			
			var sourceRect:Rectangle = new Rectangle(0,0,m_1.width, m_1.height);
			var desPoint:Point = new Point(0, 0);			
			data.copyPixels(m_1, sourceRect, desPoint);
			
			sourceRect.width = m_2.width;
			desPoint.x = width - m_2.width;
			data.copyPixels(m_2, sourceRect, desPoint);
			
			sourceRect.width = m_3.width;
			sourceRect.height = m_3.height;
			desPoint.x = 0;
			desPoint.y = height - m_3.height;
			data.copyPixels(m_3, sourceRect, desPoint);
			
			sourceRect.width = m_4.width;
			sourceRect.height = m_4.height;
			desPoint.x = width - m_4.width;
			desPoint.y = height - m_4.height;
			data.copyPixels(m_4, sourceRect, desPoint);
			
			//叠加a,b,c,d部分
			var i:int;
			sourceRect.width = m_a.width;
			sourceRect.height = m_a.height;
			desPoint.x = m_1.width;
			desPoint.y = 0;
			var size:int = (width - (m_1.width + m_2.width)) / m_a.width;
			for (i = 0; i < size; i++)
			{
				data.copyPixels(m_a, sourceRect, desPoint);
				desPoint.x += m_a.width;
			}
			
			//叠加c部分
			sourceRect.width = m_c.width;
			sourceRect.height = m_c.height;
			desPoint.x = m_3.width;
			desPoint.y = height - m_c.height;
			size = (width - (m_3.width + m_4.width)) / m_c.width;
			for (i = 0; i < size; i++)
			{
				data.copyPixels(m_c, sourceRect, desPoint);
				desPoint.x += m_c.width;
			}
			
			//叠加b部分
			sourceRect.width = m_b.width;
			sourceRect.height = m_b.height;
			desPoint.x = 0;
			desPoint.y = m_1.height;
			size = (height - (m_1.height + m_3.height)) / m_b.height;
			for (i = 0; i < size; i++)
			{
				data.copyPixels(m_b, sourceRect, desPoint);
				desPoint.y += m_b.height;
			}
			
			//叠加d部分
			sourceRect.width = m_d.width;
			sourceRect.height = m_d.height;
			desPoint.x = width - m_d.width;
			desPoint.y = m_2.height;
			size = (height - (m_2.height + m_4.height)) / m_d.height;
			for (i = 0; i < size; i++)
			{
				data.copyPixels(m_d, sourceRect, desPoint);
				desPoint.y += m_d.height;
			}			
			
			return data;
		}
		public function roundWidth(width:int):int
		{
			var lenTwoEnd:int = m_1.width + m_2.width;
			if (width < lenTwoEnd)
			{
				DebugBox.info("ImageGrid9::roundWidth 宽度是0；最小宽度是"+lenTwoEnd.toString());
				return 0;
			}
			var widthCenter:int = width - lenTwoEnd;
			var widthRet:int;
			var size:int = widthCenter / m_a.width;
			widthRet = size * m_a.width + lenTwoEnd;
			return widthRet;
		}
		public function roundHeight(height:int):int
		{
			var lenTwoEnd:int = m_1.height + m_3.height;
			if (height < lenTwoEnd)
			{
				DebugBox.info("ImageGrid9::roundHeight 高度是0；最小高度是"+lenTwoEnd.toString());
				return 0;
			}
			var heightCenter:int = height - lenTwoEnd;
			var heightRet:int = (heightCenter / m_b.height) * m_b.height + lenTwoEnd;
			return heightRet;
		}
		
	}

}