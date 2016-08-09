package com.dgrigg.display 
{
	import com.dgrigg.image.Image;
	import com.dgrigg.image.ImageList;
	import common.Context;
	import flash.display.Bitmap;
	import flash.display.DisplayObjectContainer;
	
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	public class DisplayImageListBase extends Bitmap 
	{
		protected var m_imagList:ImageList;
		protected var m_context:Context;
		protected var m_onFailed:Function;
		public function DisplayImageListBase(con:Context, parent:DisplayObjectContainer = null) 
		{
			m_context = con;
			if (parent != null)
			{
				parent.addChild(this);
			}
		}
		public function load(name:String):void 
		{
			m_context.m_commonImageMgr.loadImage(name, ImageList, onLoaded, onFailed);
		}
		
		protected function onLoaded(image:Image):void
		{
			m_imagList = image as ImageList;		
			m_onFailed = null;
		}
		
		protected function onFailed(fileName:String):void
		{
			if (m_onFailed != null)
			{
				m_onFailed();
			}
		}
		
		public function dispose():void
		{
			if (m_imagList != null)
			{
				m_context.m_commonImageMgr.unLoad(m_imagList.name);
			}
		}
		
		public function set onFailedFun(fun:Function):void
		{
			m_onFailed = fun;
		}
		
	}

}