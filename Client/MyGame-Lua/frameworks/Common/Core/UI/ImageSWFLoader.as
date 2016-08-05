package ui 
{
	import com.dgrigg.image.CommonImageManager;
	import com.pblabs.engine.resource.Resource;
	import common.Context;
	import com.pblabs.engine.resource.SWFResource;
	import com.pblabs.engine.resource.ResourceEvent;
	import com.pblabs.engine.debug.Logger;
	/**
	 * ...
	 * 加载图片包的机制
	 * @author 
	 */
	public class ImageSWFLoader 
	{
		private var m_context:Context;
		private var m_host:IImageSWFHost;
		private var m_resource:SWFResource;
		private var m_bReleaseOnLoaded:Boolean=true;
		public function ImageSWFLoader(con:Context, host:IImageSWFHost) 
		{
			m_context = con;
			m_host = host;
		}
		
		public function setParam(bReleaseOnLoaded:Boolean):void
		{
			m_bReleaseOnLoaded = bReleaseOnLoaded;
		}
		
		//fileName的路径在image之内
		public function load(fileName:String):void
		{
			m_context.m_resMgr.load(CommonImageManager.toPathString(fileName), SWFResource, onImageSwfLoaded, onImageSwfFailed) as SWFResource;
		}
		
		private function onImageSwfLoaded(event:ResourceEvent):void
		{			
			m_resource = event.resourceObject as SWFResource;
			m_host.createImage(m_resource);			
			if (m_bReleaseOnLoaded)
			{
				releaseResource();
			}
		}
		
		private function onImageSwfFailed(event:ResourceEvent):void
		{
			Logger.info(null, null, event.resourceObject.filename + " Failed");
			releaseResource();
		}
		
		private function releaseResource():void
		{
			if (m_resource)
			{
				m_resource.removeEventListener(ResourceEvent.LOADED_EVENT, onImageSwfLoaded);
				m_resource.removeEventListener(ResourceEvent.FAILED_EVENT, onImageSwfFailed);
				m_context.m_resMgr.unload(m_resource.filename, SWFResource);
				m_resource = null;
			}
		}
		public function get resource():SWFResource
		{
			return m_resource;
		}
		public function dispose():void
		{
			releaseResource();
			m_host = null;
		}
	}

}