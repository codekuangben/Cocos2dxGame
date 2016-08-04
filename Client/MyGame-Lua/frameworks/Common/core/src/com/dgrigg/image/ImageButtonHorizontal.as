package com.dgrigg.image 
{
	/**
	 * ...
	 * @author 
	 */
	import com.dgrigg.utils.UIConst;
	import com.pblabs.engine.debug.Logger;
	import org.ffilmation.engine.helpers.fUtil;
	import flash.display.BitmapData;
	import com.pblabs.engine.resource.SWFResource;
	
	public class ImageButtonHorizontal extends Image 
	{
		//UIConst.EtBtnNormal,UIConst.EtBtnDown,UIConst.EtBtnOver,UIConst.EtBtnSelected
		private var m_dataList:Vector.<HorizontalImage>;
		
		public function ImageButtonHorizontal()
		{
			m_dataList = new Vector.<HorizontalImage>(4);
		}
		public function createData(state:int, w:int):BitmapData
		{
			return m_dataList[state].create(w);
		}
		
		override public function parseSWF(res:SWFResource):Boolean
		{
			var namePackage:String = fUtil.getNameOnly(this.name, "swf");
			var classname:String;
			namePackage = namePackage + ".";
			
			var image:HorizontalImage;
			image = new HorizontalImage();
			image.name = namePackage + "normal";
			if (false == image.parseSWF(res))
			{
				Logger.error(this, "ImageButtonHorizontal::parseSWF", "ImageButtonHorizontal::parseSWF"+image.name + " Failed");
				loadState = Image.Failed;				
				return false;
			}
			m_dataList[UIConst.EtBtnNormal] = image;
			
			image = new HorizontalImage();
			image.name = namePackage + "over";
			if (false == image.parseSWF(res))
			{
				image = null;
			}
			m_dataList[UIConst.EtBtnOver] = image;
			
			image = new HorizontalImage();
			image.name = namePackage + "down";
			if (false == image.parseSWF(res))
			{
				image = null;
			}
			m_dataList[UIConst.EtBtnDown] = image;
			
			classname = "art."+namePackage + "selected.left";
			if (res.getAssetClass(classname) != null)
			{
				classname = namePackage + "selected";
				image = new HorizontalImage();
				image.name = classname;
				if (true == image.parseSWF(res))
				{
					m_dataList[UIConst.EtBtnSelected] = image;
				}				
			}
			
			loadState = Image.Loaded;
			return true;
		}
	}

}