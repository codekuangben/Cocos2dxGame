package modulecommon.commonfuntion.delayloader
{
	import com.pblabs.engine.debug.Logger;
	import com.pblabs.engine.resource.ResourceEvent;
	import com.pblabs.engine.resource.SWFResource;
	
	//import flash.display.BitmapData;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import modulecommon.GkContext;

	/**
	 * @brief 延迟加载队列，主要是预加载一些内容，延迟加载队列不保存加载的资源的引用
	 * */
	public class DelayLoaderMgr
	{
		public var m_gkcontext:GkContext;
		protected var m_preLoadList:Vector.<DelayLoaderBase>;		// 这个列表是预加载的资源列表
		//protected var m_loadInterval:uint = 5;	//   加载间隔
		protected var m_bStarted:Boolean;			// 是否启动延迟加载
		// 暂时 10 秒间隔加载一个资源，更好的机制想到
		protected var m_timeID:uint;				// 定时器 ID
		public var m_curFileVec:Vector.<String>;	// 当前加载的文件列表,记录当前加载的内容,下一次加载的时候需要手工把不需要的资源卸载,这个主要用在脚本预加载
		public var m_heroLoaded:Boolean = false;	// 主角的资源是否加载过
		
		public function DelayLoaderMgr(con:GkContext)
		{
			m_gkcontext = con;
			m_preLoadList = new Vector.<DelayLoaderBase>();
			m_curFileVec = new Vector.<String>();
		}
		
		public function get bStarted():Boolean
		{
			return m_bStarted;
		}

		public function set bStarted(value:Boolean):void
		{
			m_bStarted = value;
			loadNext();
		}

		public function addDelayLoadItem(item:DelayLoaderBase):void
		{
			m_preLoadList.push(item);
			loadNext();
		}
		
		protected function loadOneRes():void
		{
			if(m_preLoadList.length)
			{
				//clearInterval(m_timeID);
				clearTimeout(m_timeID);
				m_timeID = 0;
				
				m_preLoadList[0].fcbFailed = cbFailed;
				m_preLoadList[0].fcbLoaded = cbLoaded;
				if(!m_preLoadList[0].loadRes())
				{
					//m_gkcontext.m_context.m_resMgrNoProg.load(m_preLoadList[0].m_path, SWFResource, onResLoaded, onResFailed) as SWFResource;
					m_gkcontext.m_context.m_resMgr.load(m_preLoadList[0].m_path, SWFResource, onResLoaded, onResFailed) as SWFResource;
				}
			}
		}
		
		public function onResLoaded(event:ResourceEvent):void
		{
			event.resourceObject.removeEventListener(ResourceEvent.LOADED_EVENT, onResLoaded);
			event.resourceObject.removeEventListener(ResourceEvent.FAILED_EVENT, onResFailed);
			
			Logger.info(null, null, event.resourceObject.filename + " loaded(DelayLoaderMgr:onResLoaded)");
			
			m_preLoadList[0].onResLoaded(event.resourceObject as SWFResource);
			
			cbLoaded();
		}
		
		public function onResFailed(event:ResourceEvent):void
		{
			event.resourceObject.removeEventListener(ResourceEvent.LOADED_EVENT, onResLoaded);
			event.resourceObject.removeEventListener(ResourceEvent.FAILED_EVENT, onResFailed);
			
			Logger.error(null, null, event.resourceObject.filename + " failed(DelayLoaderMgr:onResFailed)");
			
			m_preLoadList[0].onResFailed(event.resourceObject as SWFResource);
			
			// 删除这个资源
			//this.m_gkcontext.m_context.m_resMgrNoProg.unload(event.resourceObject.filename, SWFResource);
			this.m_gkcontext.m_context.m_resMgr.unload(event.resourceObject.filename, SWFResource);
			
			cbFailed();
		}
		
		// 自定义资源加载成功回调处理
		public function cbLoaded():void
		{
			m_preLoadList[0].dispose();
			m_preLoadList.shift();
			loadNext();
		}
		
		public function cbFailed():void
		{
			m_preLoadList[0].dispose();
			m_preLoadList.shift();
			loadNext();
		}
		
		protected function loadNext():void
		{
			if(m_preLoadList.length && !m_preLoadList[0].m_loadState && m_bStarted)
			{
				m_timeID = setTimeout(loadOneRes, m_preLoadList[0].m_loadInterval * 1000);
				// 在这个地方设置加载状态
				m_preLoadList[0].m_loadState = DelayLoaderBase.Loading;
			}
		}
	}
}