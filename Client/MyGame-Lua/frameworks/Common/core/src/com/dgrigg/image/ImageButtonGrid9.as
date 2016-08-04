package com.dgrigg.image 
{
	/**
	 * ...
	 * @author 
	 */
	import com.dgrigg.utils.UIConst;
	import com.pblabs.engine.debug.Logger;
	import com.pblabs.engine.resource.SWFResource;
	import flash.display.BitmapData;
	import org.ffilmation.engine.helpers.fUtil;
	
	public class ImageButtonGrid9 extends Image 
	{
		//UIConst.EtBtnNormal,UIConst.EtBtnDown,UIConst.EtBtnOver,UIConst.EtBtnSelected
		private var m_dataList:Vector.<ImageGrid9>;		
		
		public function ImageButtonGrid9() 
		{
			m_dataList = new Vector.<ImageGrid9>(4);
		}
		
		public function createData(state:int, w:int,h:int):BitmapData
		{
			return m_dataList[state].create(w, h);
		}
		
		override public function parseSWF(res:SWFResource):Boolean
		{
			var namePackage:String = fUtil.getNameOnly(this.name, "swf");
			var classname:String;
			namePackage = namePackage + ".";
			
			var image:ImageGrid9;
			image = new ImageGrid9();
			image.name = namePackage + "normal";
			if (false == image.parseSWF(res))
			{
				Logger.error(this, "ImageButtonGrid9::parseSWF", "ImageButtonGrid9::parseSWF"+image.name + " Failed");
				loadState = Image.Failed;				
				return false;
			}
			m_dataList[UIConst.EtBtnNormal] = image;
			
			image = new ImageGrid9();
			image.name = namePackage + "over";
			if (false == image.parseSWF(res))
			{
				image = null;
			}
			m_dataList[UIConst.EtBtnOver] = image;
			
			image = new ImageGrid9();
			image.name = namePackage + "down";
			if (false == image.parseSWF(res))
			{
				image = null;
			}
			m_dataList[UIConst.EtBtnDown] = image;
			
			classname = namePackage + "selected";
			if (res.getAssetClass(classname) != null)
			{
				image = new ImageGrid9();
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