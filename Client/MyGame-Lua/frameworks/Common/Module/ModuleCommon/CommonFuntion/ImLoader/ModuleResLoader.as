package modulecommon.commonfuntion.imloader 
{
	import com.pblabs.engine.debug.Logger;
	import com.pblabs.engine.resource.Resource;
	import com.pblabs.engine.resource.ResourceEvent;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	import modulecommon.GkContext;

	/**
	 * @brief 坐骑资源加载
	 */
	public class ModuleResLoader extends EventDispatcher
	{
		public static const EventLoadEnd:String = "EventLoadEnd";
		
		public var m_gkContext:GkContext;
		public var m_resLoadingLst:Vector.<ModuleResLoadingItem>;
		
		public var m_resLoadedLst:Vector.<ModuleResLoadingItem>;
		public var m_resLoadFailedLst:Vector.<ModuleResLoadingItem>;
		public var m_resLoadedDic:Dictionary;			// 加载的资源映射
		public var m_resLoaded:Boolean;					// 资源加载是否完成

		public function ModuleResLoader(gkcontext:GkContext)
		{
			m_gkContext = gkcontext;
			m_resLoadingLst = new Vector.<ModuleResLoadingItem>();
			m_resLoadedLst = new Vector.<ModuleResLoadingItem>();
			m_resLoadFailedLst = new Vector.<ModuleResLoadingItem>();
			m_resLoadedDic = new Dictionary();
		}
		
		public function addResName(item:ModuleResLoadingItem):void
		{
			m_resLoadingLst.push(item);
		}
		
		public function loadRes():void
		{
			var item:ModuleResLoadingItem;
			if(m_resLoadingLst.length == 0)
			{
				m_resLoaded = true;
				dispatchEvent(new Event(ModuleResLoader.EventLoadEnd));
			}
			else
			{
				for each(item in m_resLoadingLst)
				{
					m_gkContext.m_context.m_resMgr.load(item.m_path, item.m_classType, onLoaded, onFailed);
				}
			}
		}
		
		public function unloadRes():void
		{
			var key:String;
			var item:ModuleResLoadingItem;
			for (key in m_resLoadedDic)
			{
				item = findLoadingItem(key);
				m_gkContext.m_context.m_resMgr.unload(key, item.m_classType);
				
				m_resLoadedDic[key] = null;
			}
			
			var res:Resource;
			// 可能还有未加载完成的资源
			for each(item in m_resLoadingLst)
			{
				if(!isLoadedOrFailed(item.m_path))
				{
					res = m_gkContext.m_context.m_resMgr.getResource(item.m_path, item.m_classType);
					res.removeEventListener(ResourceEvent.LOADED_EVENT, onLoaded);
					res.removeEventListener(ResourceEvent.FAILED_EVENT, onFailed);
					m_gkContext.m_context.m_resMgr.unload(item.m_path, item.m_classType);
				}
			}
		}
		
		public function onLoaded(event:ResourceEvent):void
		{
			Logger.info(null, null, event.resourceObject.filename + " loaded");

			m_resLoadedLst.push(findLoadingItem(event.resourceObject.filename));
			m_resLoadedDic[event.resourceObject.filename] = event.resourceObject;
			
			if (m_resLoadedLst.length + m_resLoadFailedLst.length == m_resLoadingLst.length)
			{
				m_resLoaded = true;
				dispatchEvent(new Event(ModuleResLoader.EventLoadEnd));
			}
		}

		private function onFailed(event:ResourceEvent):void
		{
			Logger.info(null, null, event.resourceObject.filename + " failed");
			
			m_resLoadFailedLst.push(findLoadingItem(event.resourceObject.filename));
			
			m_gkContext.m_context.m_resMgr.unload(event.resourceObject.filename, m_resLoadFailedLst[m_resLoadFailedLst.length - 1].m_classType);
			
			if (m_resLoadedLst.length + m_resLoadFailedLst.length == m_resLoadingLst.length)
			{
				m_resLoaded = true;
				dispatchEvent(new Event(ModuleResLoader.EventLoadEnd));
			}
		}
		
		protected function findLoadingItem(path:String):ModuleResLoadingItem
		{
			for each(var item:ModuleResLoadingItem in m_resLoadingLst)
			{
				if(item.m_path == path)
				{
					return item;
				}
			}
			
			return null;
		}
		
		protected function isLoadedOrFailed(path:String):Boolean
		{
			for each(var item:ModuleResLoadingItem in m_resLoadingLst)
			{
				if(item.m_path == path)
				{
					return item;
				}
			}
			
			return null;
		}
	}
}