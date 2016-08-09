package com.dgrigg.utils 
{
	import common.Context;
	import flash.utils.Dictionary;
	import com.dgrigg.image.Image;
	/**
	 * ...
	 * @author 
	 */
	public class ImageTempStorage 
	{
		/*m_dicImages: key是个字符串，是Image对象的唯一标识, value-有3中可能
		 * 1. Image对象，该资源加载成功
		 * 2. String对象，表示资源名称，在少数情况下不同于mage对象的唯一标识，例如利用Component::setPanelImageSkinMirror函数时
		 * 3. 0 - 该资源加载失败
		 */
		private var m_dicImages:Dictionary;
		private var m_context:Context;
		
		public function ImageTempStorage(con:Context) 
		{
			m_dicImages = new Dictionary();
			m_context = con;
		}
		
		public function add(_imageClass:Class, resName:String):void
		{
			m_dicImages[resName] = resName;
			m_context.m_commonImageMgr.loadImage(resName, _imageClass, onLoaded, onFailed);			
		}
		
		public function hasRes(resName:String):Boolean
		{
			return m_dicImages[resName] != undefined;
		}
		
		protected function onLoaded(resImage:Image):void
		{
			m_dicImages[resImage.name] = resImage;	
		}
		
		protected function onFailed(filename:String):void
		{
			m_dicImages[filename] = 0;
		}
		
		public function clear():void
		{
			var item:Object;
			for each(item in m_dicImages)
			{
				if (item is String)
				{
					m_context.m_commonImageMgr.removeFun(item as String, onLoaded, onFailed);
				}
				else if (item is Image)
				{
					m_context.m_commonImageMgr.unLoad((item as Image).name);
				}
			}
			m_dicImages = new Dictionary();			
		}
	}

}