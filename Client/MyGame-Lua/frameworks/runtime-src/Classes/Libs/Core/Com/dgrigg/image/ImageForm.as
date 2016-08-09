package com.dgrigg.image 
{
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	import flash.display.BitmapData;
	import com.pblabs.engine.resource.SWFResource;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import com.pblabs.engine.debug.Logger;
	import org.ffilmation.engine.datatypes.IntPoint;
	import org.ffilmation.engine.helpers.fUtil;
	import com.util.PBUtil;
	
	public class ImageForm extends Image 
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
		//pubprivate var m_e:BitmapData; //中
		public function ImageForm()
		{
			
		}
		
		override public function parseSWF(res:SWFResource):Boolean
		{			
			/*
			 * 
			 * name= commoncontrol/form1.swf
			 * 类名定义规则
			 * form1.m1,这是个隐含规则,在用flash cs打swf文件时，注意这点:form1是package name;m1是类名			 * 
			 * 
			*/
			var namePackage:String = fUtil.getNameOnly(this.name, "swf");	
			
			var classname:String;
			var data:BitmapData;
			
			namePackage = "art." + namePackage + ".";
			
			classname = namePackage + "m1";
			data = (res.getExportedAsset(classname)) as BitmapData;
			if (data == null)
			{
				Logger.info(null, null, "ImageForm.parseSWF" + "没有找到" + classname);
				loadState = Image.Failed;
				return false;
			}
			m_1 = data.clone();
			
			classname = namePackage + "m2";
			data = (res.getExportedAsset(classname)) as BitmapData;	
			if (data == null)
			{
				m_2 = PBUtil.flipBitmapDataHori(m_1);
			}
			else
			{
				m_2 = data.clone();
			}
						
			classname = namePackage + "m3";
			data = (res.getExportedAsset(classname)) as BitmapData;		
			if (data == null)
			{
				m_3 = PBUtil.flipBitmapDataVer(m_1);
			}
			else
			{
				m_3 = data.clone();
			}		
			
			classname = namePackage + "m4";
			data = (res.getExportedAsset(classname)) as BitmapData;	
			if (data == null)
			{
				m_4 = PBUtil.flipBitmapDataHori(m_3);
			}
			else
			{
				m_4 = data.clone();
			}
			
			classname = namePackage + "ma";
			data = (res.getExportedAsset(classname)) as BitmapData;			
			m_a = data.clone();
			
			classname = namePackage + "mb";
			data = (res.getExportedAsset(classname)) as BitmapData;			
			m_b = data.clone();
			
			classname = namePackage + "mc";
			data = (res.getExportedAsset(classname)) as BitmapData;			
			if (data == null)
			{
				m_c = PBUtil.flipBitmapDataVer(m_a);
			}
			else
			{
				m_c = data.clone();
			}
			
			classname = namePackage + "md";
			data = (res.getExportedAsset(classname)) as BitmapData;			
			if (data == null)
			{
				m_d = PBUtil.flipBitmapDataHori(m_b);
			}
			else
			{
				m_d = data.clone();
			}
			
			classname = namePackage + "me";
			data = (res.getExportedAsset(classname)) as BitmapData;		
			if (data)
			{
				m_colorCenter = data.getPixel32(0, 0);
			}
			else
			{
				m_colorCenter = 0;
			}
			loadState = Image.Loaded;
			return true;
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
			if (width < lenTwoEnd)
			{
				return 0;
			}
			var lenTwoEnd:int = m_1.width + m_2.width;
			var widthCenter:int = width - lenTwoEnd;
			var widthRet:int;
			var size:int = widthCenter / m_a.width;
			widthRet = size * m_a.width + lenTwoEnd;
			return widthRet;
		}
		public function roundHeight(height:int):int
		{
			if (height < lenTwoEnd)
			{
				return 0;
			}
			var lenTwoEnd:int = m_1.height + m_3.height;
			var heightCenter:int = height - lenTwoEnd;
			var iMid:int = heightCenter / m_b.height;
			var heightRet:int = iMid * m_b.height + lenTwoEnd;
			return heightRet;
		}
		
		public static function s_round(width:int, height:int, name:String="form1.swf"):IntPoint
		{
			var wLeft:int;
			var wCenter:int;
			var wRight:int;
			
			var hTop:int;
			var hCenter:int;
			var hBottom:int;
			var ret:IntPoint = new IntPoint();
			if (name == "form1.swf")
			{
				wLeft = 42;				
				wCenter = 10;
				wRight = 42;
				
				hTop = 42;
				hCenter = 10;
				hBottom = 42;
			}
			else if (name == "form8.swf")
			{
				wLeft = 90;				
				wCenter = 1;
				wRight = 90;
				
				hTop = 37;
				hCenter = 1;
				hBottom = 37;
			}
			else 
			{
				ret.x = width;
				ret.y = height;
				return ret;
			}
			
			var n:int;
			n = (width - wLeft - wRight) / wCenter;
			ret.x = wLeft + wRight + wCenter * n;
			
			n = (height - hTop - hBottom) / hCenter;
			ret.y = hTop + hBottom + hCenter * n;
			return ret;
		}
		
	}

}