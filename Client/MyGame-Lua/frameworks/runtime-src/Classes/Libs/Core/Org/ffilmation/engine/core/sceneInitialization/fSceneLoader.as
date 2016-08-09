package org.ffilmation.engine.core.sceneInitialization
{
	// Imports
	import com.pblabs.engine.entity.EntityCValue;
	import com.pblabs.engine.resource.ResourceEvent;
	import com.pblabs.engine.resource.SWFResource;
	
	import common.Context;
	
	import flash.utils.ByteArray;
	
	import org.ffilmation.engine.core.fScene;
	import org.ffilmation.engine.helpers.fUtil;
	import org.ffilmation.engine.interfaces.fEngineSceneRetriever;
	
	/**
	 * This is the simplest scene retriever class. Loads an scene definition from an external file
	 */
	public class fSceneLoader implements fEngineSceneRetriever
	{
		// Private vars
		private var xml:XML; // Definition data
		private var src:String;
		public var m_serverSceneID:uint;		// 服务器场景 id
		protected var m_context:Context;	// 所有全局变量
		public var m_terFileLoaded:Boolean = false;	// 记录地形文件是否加载
		
		// Constructor
		public function fSceneLoader(src:String, sceneid:uint):void
		{
			this.src = src;
			this.m_serverSceneID = sceneid;
		}
		
		public function getServerSceneID():uint
		{
			// this.src 类似这样的 asset/scene/xml/terrain/x1001.swf
			//var splash:int = this.src.lastIndexOf('/');
			//var dot:int = this.src.lastIndexOf('.');
			//return int(this.src.substring(splash + 2, dot));
			
			return m_serverSceneID;
		}
		
		/**
		 * @private
		 * The scene will call this when it is ready to receive an scene. Then the engine will listen for a COMPLETE event
		 * before retrieving the final xml
		 */
		//public function start():EventDispatcher
		//{
			// Start xml load process
			//var url:URLRequest = new URLRequest(this.src);
			//var loadUrl:URLLoader = new URLLoader(url);
			//loadUrl.load(url);
			//loadUrl.addEventListener(Event.COMPLETE, this.loadListener);
			//return loadUrl;
		//}
		
		//public function start(context:Context):SWFResource
		public function start(context:Context, scene:fScene):SWFResource
		{
			// Start xml load process
			m_context = context;
			
			// 首先查一下当前场景资源是否已经加载过
			if(m_context.m_sceneResMgr.m_sceneFileDict[scene.m_serverSceneID])
			{
				this.xml = m_context.m_sceneResMgr.m_sceneFileDict[scene.m_serverSceneID];
				return null;
			}
			else
			{
				//var res:SWFResource = m_context.m_resMgrNoProg.getResource(this.src, SWFResource) as SWFResource;
				var res:SWFResource = m_context.m_resMgr.getResource(this.src, SWFResource) as SWFResource;
				if(res)		// 如果资源存在并且已经加载完成
				{
					if(res.isLoaded && !res.didFail)	// 成功加载才行
					{
						m_terFileLoaded = true;
						// 外面有引用这个资源的，因此增加引用计数
						//res.incrementReferenceCount();
						loadListener(new ResourceEvent(ResourceEvent.LOADED_EVENT, res));
						//return res;
					}
					else	// 如果资源存在，但是没有加载完成
					{
						res.addEventListener(ResourceEvent.LOADED_EVENT, this.loadListener);
						res.addEventListener(ResourceEvent.FAILED_EVENT, this.failListener);
					}
					return res
				}
				else		// 资源不存在，因为所有加载失败的资源都会在错误处理函数中释放资源
				{
					//return m_context.m_resMgrNoProg.load(this.src, SWFResource, this.loadListener, this.failListener) as SWFResource;
					return m_context.m_resMgr.load(this.src, SWFResource, this.loadListener, this.failListener) as SWFResource;
				}
			}
		}
		
		//private function loadListener(evt:Event):void
		//{
			//this.xml = new XML(evt.target.data);
		//}
		
		private function loadListener(event:ResourceEvent):void
		{
			var bytes:ByteArray;
			var clase:String = fUtil.xmlResClase(event.resourceObject.filename);
			var res:SWFResource = event.resourceObject as SWFResource;
			bytes = res.getExportedAsset(clase) as ByteArray;
			this.xml = new XML(bytes.readUTFBytes(bytes.length));
			
			// bug: 卸载掉加载的资源，否则再次加载的时候上层收不到加载完成的消息，bug 已经修复，资源卸载再外面的监听器中卸载
			//m_context.m_resMgrNoProg.unload(event.resourceObject.filename, SWFResource);
		}
		
		private function failListener(event:ResourceEvent):void
		{
			event.resourceObject.removeEventListener(ResourceEvent.LOADED_EVENT, this.loadListener);
			event.resourceObject.removeEventListener(ResourceEvent.FAILED_EVENT, this.failListener);
			// 释放资源    
			//m_context.m_resMgrNoProg.unload(event.resourceObject.filename, SWFResource);
			m_context.m_resMgr.unload(event.resourceObject.filename, SWFResource);
		}
		
		/**
		 * @private
		 * When this class dispatches a COMPLETE event, the scene will use this method to retrieve the XML definition
		 */
		public function getXML():XML
		{
			return this.xml;
		}
		
		/**
		 * @private
		 * The scene will use this method to retrieve the basepath for this XML. This basepath will be used to resolve paths inside this XML
		 */
		public function getBasePath():String
		{
			return this.src;
		}
		
		public function dispose():void
		{
			// bug: 没有释放资源
			this.xml = null;
			m_context = null;
		}
	}
}