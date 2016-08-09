package login 
{
	/**
	 * 在登陆模块时，玩家必须要下载的东西在这里完成
	 * @author zouzhiqiang
	 */
	//import common.logicinterface.IPreLoad;
	import com.dgrigg.image.Image;
	import common.Context;
	
	import com.pblabs.engine.resource.SWFResource;
	import com.pblabs.engine.resource.ResourceEvent;
	import com.pblabs.engine.entity.EntityCValue;
	import flash.events.*;	

	import com.pblabs.engine.debug.Logger;
	//import com.dgrigg.image.CommonImageManager;
	import com.pblabs.engine.resource.ResourceProgressEvent;
	
	public class PreLoad
	{
		private var m_state:int;	//Image.None等定义
		private var m_Flag:uint = 0;
		private var m_context:Context;	// 逻辑使用
		private var m_moduleAppRoot:Object;//ModuleAppRoot		
		public var m_tableSWF:SWFResource;
		public var m_xmlSWF:SWFResource;
		public function PreLoad(con:Context, moduleAppRoot:Object)
		{
			m_context = con;
			m_moduleAppRoot = moduleAppRoot;
			m_state = Image.None;
		}
		
		public function setLoad(bit:uint):void
		{
			m_Flag |= 1 << bit;
			if(hasLoadAll())
			{
				m_state = Image.Loaded;
				m_moduleAppRoot.onPreLoaded();
			}
		}
		private function hasLoadAll():Boolean
		{
			if (m_Flag == ( (1 << EntityCValue.PreloadRES_MAX) - 1))
			{
				return true;
			}
			return false;
		}
		public function load():void
		{
			if (m_state != Image.None)
			{
				return;
			}
			m_state = Image.Loading;
			var path:String;
			m_moduleAppRoot.loadModule(EntityCValue.ModuleGame);
			m_context.m_commonImageMgr.load();
			m_context.m_replaceResSys.load();
			path = m_context.m_path.getPathByID(0, EntityCValue.RESTBL);
			m_context.m_resMgr.load("asset/config/table.swf", SWFResource, onloadedSWF, onFailedSWF, onProgress, onStarted);
			m_context.m_resMgr.load("asset/config/xml.swf", SWFResource, onloadedSWF, onFailedSWF);
			//m_gkcontext.m_dataXml.load();
		}
		
		private function onloadedSWF(event:ResourceEvent):void
		{
			var resource:SWFResource = event.resourceObject as SWFResource;
			Logger.info(this, "PreLoad::onloadedSWF ", resource.filename + " loaded");
			if (resource.filename == "asset/config/table.swf")
			{
				m_tableSWF = resource as SWFResource;			
				setLoad(EntityCValue.PreloadRES_TABLE);
			}
			else if (resource.filename == "asset/config/xml.swf")
			{
				m_xmlSWF = resource as SWFResource;	
				setLoad(EntityCValue.PreloadRES_DataXML);
			}
			
			
			// 加载进度条
			m_context.progLoading.progResLoaded(resource.filename);
			// 卸载表资源
			//m_gkcontext.m_context.m_resMgr.unload(resource.filename, SWFResource);
		}
		
		private function onFailedSWF(event:ResourceEvent):void
		{
			var resource:SWFResource = event.resourceObject as SWFResource;
			Logger.error(this, "PreLoad::onFailedSWF ", resource.filename + " failed");
			
			// 加载进度条
			m_context.progLoading.progResFailed(resource.filename);
			// 卸载表资源
			m_context.m_resMgr.unload(resource.filename, SWFResource);
		}
		
		private function onProgress(event:ResourceProgressEvent):void
		{
			//m_gkcontext.progResProgress(event.resourceObject.filename, event._percentLoaded);
		}
		
		private function onStarted(event:ResourceEvent):void
		{	
			// 加载进度条
			//m_gkcontext.progResStarted(event.resourceObject.filename);
		}
		
		public function get loadNone():Boolean
		{
			return m_state == Image.None;
		}
		public function get loaded():Boolean
		{
			return m_state == Image.Loaded;
		}
	}
}