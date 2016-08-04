package com.dgrigg.image
{
	import flash.display.BitmapData;
	import com.pblabs.engine.resource.SWFResource;
	import org.ffilmation.engine.helpers.fUtil;
	import com.pblabs.engine.debug.Logger;
	import com.util.PBUtil;
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	public class ButtonImage extends Image
	{
		private var m_NormalData:BitmapData; //按钮的正常状态
		private var m_OverData:BitmapData; //鼠标移到按钮上
		private var m_DownData:BitmapData; //鼠标在按钮上按下
		private var m_SeletedData:BitmapData; //按钮被选中。用于页标签情况，普通按钮不需这个状态
		
				
		public function ButtonImage()
		{
		
		}
		
		public function setData(normalData:BitmapData, overData:BitmapData, downData:BitmapData, seletedData:BitmapData = null):void
		{
			m_NormalData = normalData;
			m_OverData = overData;
			m_DownData = downData;
			m_SeletedData = seletedData;
		}
		public function get width():uint
		{
			return m_NormalData.width;
		}
		
		public function get height():uint
		{
			return m_NormalData.height;
		}
		public function get normalData():BitmapData
		{
			return m_NormalData;
		}
		
		public function get overData():BitmapData
		{
			return m_OverData;
		}
		
		public function get downData():BitmapData
		{
			return m_DownData;
		}
		
		public function get seletedData():BitmapData
		{
			return m_SeletedData;
		}
		override public function parseSWF(res:SWFResource):Boolean
		{
			if (this.name.search("_mirror") == -1)
			{
				return parseSWFNotMirror(res);
			}
			else
			{
				return parseSWFMirror(res);
			}			
		}	
		
		private function parseSWFMirror(res:SWFResource):Boolean
		{
			var namePackage:String = fUtil.getNameOnly(this.name, "swf");
			var classname:String;
			var data:BitmapData;
		
			
			namePackage = "art." + namePackage + ".";
			
			classname = namePackage + "normal";
			
			data = (res.getExportedAsset(classname)) as BitmapData;		
			if (data == null)
			{
				Logger.error(this, "ButtonImage::parseSWF", classname + " Failed");
				loadState = Image.Failed;
				return false;
			}
			m_NormalData = PanelImage.composeFromLeftPart(data);
			
			classname = namePackage + "over";
			data = (res.getExportedAsset(classname)) as BitmapData;		
			if (data)
			{
				m_OverData = PanelImage.composeFromLeftPart(data);
			}
			
			classname = namePackage + "down";
			data = (res.getExportedAsset(classname)) as BitmapData;			
			if (data != null)
			{
				m_DownData = PanelImage.composeFromLeftPart(data);
			}
			
			classname = namePackage + "selected";
			data = (res.getExportedAsset(classname)) as BitmapData;	
			if (data != null)
			{
				m_SeletedData = PanelImage.composeFromLeftPart(data);
			}
			loadState = Image.Loaded;
			return true;
		}
		private function parseSWFNotMirror(res:SWFResource):Boolean
		{
			var namePackage:String = fUtil.getNameOnly(this.name, "swf");
			var classname:String;
			var data:BitmapData;
			
			namePackage = "art." + namePackage + ".";
			
			classname = namePackage + "normal";
			
			data = (res.getExportedAsset(classname)) as BitmapData;		
			if (data == null)
			{
				Logger.error(this, "ButtonImage::parseSWF", "ButtonImage::parseSWF"+classname + " Failed");
				loadState = Image.Failed;
				return false;
			}
			m_NormalData = data.clone();
			
			classname = namePackage + "over";
			data = (res.getExportedAsset(classname)) as BitmapData;		
			if (data)
			{
				m_OverData = data.clone();
			}
			
			classname = namePackage + "down";
			data = (res.getExportedAsset(classname)) as BitmapData;			
			if (data != null)
			{
				m_DownData = data.clone();
			}
			
			classname = namePackage + "selected";
			data = (res.getExportedAsset(classname)) as BitmapData;	
			if (data != null)
			{
				m_SeletedData = data.clone();
			}
			loadState = Image.Loaded;
			return true;
		}
		
		override public function mirrorImage(mode:String):Image
		{		
			var mirror:ButtonImage = new ButtonImage();
			var execFun:Function;
			if (mode == MirrorMode_HOR)
			{
				execFun = PBUtil.flipBitmapDataHori;				
			}
			else if(mode == MirrorMode_VER)
			{
				execFun = PBUtil.flipBitmapDataVer;				
			}
			else if(mode == MirrorMode_ClockwiseRotation90)
			{
				execFun = PBUtil.flipBitmapDataClockwiseRotation90;				
			}
			else if(mode == MirrorMode_AnticlockwiseRotation90)
			{
				execFun = PBUtil.flipBitmapDataAnticlockwiseRotation90;				
			}
			mirror.m_NormalData = execFun(m_NormalData);					
			mirror.m_OverData = execFun(m_OverData);
			mirror.m_DownData = execFun(m_DownData);
			if (m_SeletedData != null)
			{
				mirror.m_SeletedData = execFun(m_SeletedData);
			}
			mirror.loadState = Image.Loaded;
			mirror.name = this.name + mode;
			return mirror;
		}
	}

}