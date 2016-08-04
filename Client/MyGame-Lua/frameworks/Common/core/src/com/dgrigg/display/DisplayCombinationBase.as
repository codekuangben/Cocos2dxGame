package com.dgrigg.display 
{
	import com.dgrigg.image.Image;
	import com.dgrigg.image.ImageAni;
	import common.Context;
	import flash.display.Bitmap;
	import flash.display.DisplayObjectContainer;
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	public class DisplayCombinationBase extends Bitmap
	{
		protected var m_imageName:String;
		protected var m_imagList:ImageAni;
		protected var m_context:Context;
		protected var m_onFailed:Function;
		public function DisplayCombinationBase(con:Context, parent:DisplayObjectContainer = null) 
		{
			m_context = con;
			if (parent != null)
			{
				parent.addChild(this);
			}
		}
		public function load(name:String):void 
		{
			m_imageName = name;
			m_context.m_commonImageMgr.loadImage(name, ImageAni, onLoaded, onFailed);
		}
		
		protected function onLoaded(image:Image):void
		{
			m_imagList = image as ImageAni;		
			m_onFailed = null;
			m_imageName = null;
		}
		
		protected function onFailed(fileName:String):void
		{
			if (m_onFailed != null)
			{
				m_onFailed();
				m_onFailed = null;
			}
		}
		
		public function dispose():void
		{
			if (m_imageName != null)
			{
				m_context.m_commonImageMgr.removeFun(m_imageName, onLoaded, onFailed);
			}
			if (m_imagList != null)
			{
				m_context.m_commonImageMgr.unLoad(m_imagList.name);
			}
			m_onFailed = null;
		}
		
		public function set onFailedFun(fun:Function):void
		{
			m_onFailed = fun;
		}
		
	}

}