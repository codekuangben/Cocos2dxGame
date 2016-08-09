package com.dgrigg.image 
{
	/**
	 * ...
	 * @author zouzhiqiang
	 * 可以存放多个不同类型的Image对象
	 * ImageList对象的资源文件是SWF文件，其名称部分包括2子部分，第一部分是Image类型，第二部分是唯一标识改资源的名称
	 * 例如：gp_bubble.swf，其中gp标识Image类型，表示含有ImageGrid9、PanelImage；bubble是标识该资源的唯一名称
	 * 进一步可以推导出里面嵌入类的名称:
	 * art.bubble.m0.m1
	 * art.bubble.m0.ma
	 * art.bubble.m0.mb
	 * art.bubble.m0.me
	 * 
	 * art.bubble.m1
	 * 
	 */
	import com.pblabs.engine.resource.SWFResource;
	import org.ffilmation.engine.helpers.fUtil;
	
	public class ImageList extends Image 
	{
		private var m_vecData:Vector.<Image>;
		public function ImageList() 
		{
			m_vecData = new Vector.<Image>();
		}
		override public function parseSWF(res:SWFResource):Boolean
		{
			var swfName:String = fUtil.getNameOnly(this.name, "swf");
			var ar:Array = swfName.split("_");
			if (ar.length != 2)
			{
				return false;
			}
						
			var resName:String = (ar[1] as String) + ".m";
			var imageTypeStr:String = ar[0] as String;
						
			var k:int = 0;
			var imageClass:Class;
			var image:Image;
			for (k = 0; k < imageTypeStr.length; k++)
			{
				imageClass = null;
				switch(imageTypeStr.charAt(k))
				{
					case "g": imageClass = ImageGrid9; break;
					case "p": imageClass = PanelImage; break;
					case "h": imageClass = HorizontalImage; break;
					case "f": imageClass = ImageForm; break;
					case "b": imageClass = ButtonImage; break;
				}
				if (imageClass == null)
				{
					continue;
				}
				
				image = new imageClass();
				image.name = resName + k.toString();
				image.parseSWF(res);
				if (image.loaded == true)
				{
					m_vecData.push(image);
				}
			}
			loadState = Image.Loaded;
			return true;
		}
		public function get length():uint
		{
			return m_vecData.length;
		}
		public function getImage(index:uint):Image
		{
			return m_vecData[index];
		}
	}

}