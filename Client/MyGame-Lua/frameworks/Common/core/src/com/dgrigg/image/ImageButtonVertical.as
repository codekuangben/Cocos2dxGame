package com.dgrigg.image
{
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	import com.dgrigg.utils.UIConst;
	import com.pblabs.engine.debug.Logger;
	//import flash.display.Bitmap;
	import flash.display.BitmapData;
	import com.pblabs.engine.resource.SWFResource;
	import org.ffilmation.engine.helpers.fUtil;
	
	public class ImageButtonVertical extends Image
	{
		private var m_dataList:Vector.<ImageVertical>;				
		public function ImageButtonVertical()
		{
			m_dataList = new Vector.<ImageVertical>(4);
		}
		public function createData(state:int, h:int):BitmapData
		{
			return m_dataList[state].create(h);
		}
		
		/*
		 * 调用前，必须在外面设置好name。
		 * 4个状态图片的类名是name + ".normal"；其它依次类推
		 */
		override public function parseSWF(res:SWFResource):Boolean
		{
			var namePackage:String = fUtil.getNameOnly(this.name, "swf");
			var classname:String;
			namePackage = namePackage + ".";
			
			var image:ImageVertical;
			image = new ImageVertical();
			image.name = namePackage + "normal";
			if (false == image.parseSWF(res))
			{
				Logger.error(this, "ImageButtonVertical::parseSWF", "ImageButtonVertical::parseSWF"+image.name + " Failed");
				loadState = Image.Failed;				
				return false;
			}
			m_dataList[UIConst.EtBtnNormal] = image;
			
			image = new ImageVertical();
			image.name = namePackage + "over";
			if (false == image.parseSWF(res))
			{
				loadState = Image.Failed;				
				return false;
			}
			m_dataList[UIConst.EtBtnOver] = image;
			
			image = new ImageVertical();
			image.name = namePackage + "down";
			if (false == image.parseSWF(res))
			{
				loadState = Image.Failed;				
				return false;
			}
			m_dataList[UIConst.EtBtnDown] = image;
			
			classname = "art."+namePackage + "selected.up";
			if (res.getAssetClass(classname) != null)
			{
				image = new ImageVertical();
				image.name = namePackage + "selected";
				if (false == image.parseSWF(res))
				{
					loadState = Image.Failed;				
					return false;
				}
				m_dataList[UIConst.EtBtnSelected] = image;
			}			
			loadState = Image.Loaded;
			return true;
		}
	
	}

}