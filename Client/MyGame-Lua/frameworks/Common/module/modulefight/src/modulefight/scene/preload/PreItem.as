package modulefight.scene.preload
{
	import com.pblabs.engine.debug.Logger;
	import com.pblabs.engine.resource.ResourceEvent;
	import com.pblabs.engine.resource.SWFResource;
	
	import flash.utils.Dictionary;
	
	import modulecommon.GkContext;
	
	/**
	 * ...
	 * @author ...
	 * @brief 每一次战斗提前加载的内容
	 */
	public class PreItem 
	{
		public var m_gkContext:GkContext;
		public var m_nameList:Vector.<String>;	// 加载的资源的名字列表
		public var m_resDict:Dictionary;	// 加载的资源的名字列表

		public var m_loadedNameList:Vector.<String>;	// 已经成功加载的资源的名字列表
		public var m_failedNameList:Vector.<String>;	// 已经失败加载的资源的名字列表
		
		public function PreItem(value:GkContext) 
		{
			m_gkContext = value;
			
			m_nameList = new Vector.<String>();
			m_resDict = new Dictionary();
			m_loadedNameList = new Vector.<String>();
			m_failedNameList = new Vector.<String>();
		}
		
		// 资源加载成功
		public function onResLoaded(event:ResourceEvent):void
		{
			m_loadedNameList.push(event.resourceObject.filename);
			Logger.info(null, null, event.resourceObject.filename + " loaded");
			
			event.resourceObject.removeEventListener(ResourceEvent.LOADED_EVENT, onResLoaded);
			event.resourceObject.removeEventListener(ResourceEvent.FAILED_EVENT, onResFailed);
		}
		
		// 资源加载失败
		public function onResFailed(event:ResourceEvent):void
		{
			m_failedNameList.push(event.resourceObject.filename);
			Logger.error(null, null, event.resourceObject.filename + " failed");
			
			event.resourceObject.removeEventListener(ResourceEvent.LOADED_EVENT, onResLoaded);
			event.resourceObject.removeEventListener(ResourceEvent.FAILED_EVENT, onResFailed);

			//this.m_gkContext.m_context.m_resMgrNoProg.unload(event.resourceObject.filename, SWFResource);
			this.m_gkContext.m_context.m_resMgr.unload(event.resourceObject.filename, SWFResource);
			m_resDict[event.resourceObject.filename] = null;
			delete m_resDict[event.resourceObject.filename];
		}
		
		// 加载里面的所有资源
		public function loadRes():void
		{
			for each(var key:String in m_nameList)
			{
				//m_resDict[key] = this.m_gkContext.m_context.m_resMgrNoProg.load(key, SWFResource, onResLoaded, onResFailed);
				m_resDict[key] = this.m_gkContext.m_context.m_resMgr.load(key, SWFResource, onResLoaded, onResFailed);
			}
		}
		
		// 释放里面的所有资源
		public function dispose():void
		{
			for (var key:String in m_resDict)
			{
				if (m_resDict[key])
				{
					// 移除可能的事件监听器
					m_resDict[key].removeEventListener(ResourceEvent.LOADED_EVENT, onResLoaded);
					m_resDict[key].removeEventListener(ResourceEvent.FAILED_EVENT, onResFailed);
					//this.m_gkContext.m_context.m_resMgrNoProg.unload(m_resDict[key].filename, SWFResource);
					this.m_gkContext.m_context.m_resMgr.unload(m_resDict[key].filename, SWFResource);
					
					m_resDict[key] = null;
				}
			}
			
			m_resDict = null;
			m_loadedNameList.length = 0;
			m_loadedNameList = null;
			
			m_failedNameList.length = 0;
			m_failedNameList = null;
		}
	}
}