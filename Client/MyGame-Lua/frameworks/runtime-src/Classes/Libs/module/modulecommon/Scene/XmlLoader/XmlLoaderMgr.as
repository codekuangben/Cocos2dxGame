package modulecommon.scene.xmlloader 
{
	import com.pblabs.engine.debug.Logger;
	import modulecommon.GkContext;
	import com.pblabs.engine.resource.ResourceEvent;
	import com.pblabs.engine.resource.XMLResource;
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author ...
	 * 加载某个xml文件
	 */
	public class XmlLoaderMgr 
	{
		public var m_gkContext:GkContext;
		private var m_dic:Dictionary;
		public function XmlLoaderMgr(gk:GkContext) 
		{
			m_gkContext = gk;
			m_dic = new Dictionary();
		}
		
		public function load(xmlFileName:String, onLoad:Function):void
		{
			var fullName:String = "asset/config/" + xmlFileName;			
			if (m_dic[fullName] != undefined)
			{
				return;
			}
			
			var info:XmlLoaderInfo = new XmlLoaderInfo();
			info.m_fullName = fullName;
			info.m_funLoaded = onLoad;
			m_dic[fullName] = info;
			m_gkContext.m_context.m_resMgr.load(fullName, XMLResource, onLoaded, onFailed);
		}
		public function onLoaded(event:ResourceEvent):void
		{
			var res:XMLResource = event.resourceObject as XMLResource;
			var info:XmlLoaderInfo = m_dic[res.filename];
			if (info)
			{
				info.m_funLoaded(res.XMLData);
				delete m_dic[res.filename];
			}
			m_gkContext.m_context.m_resMgr.unload(res.filename, XMLResource);			
		}
		
		public function releaseFun(xmlFileName:String):void
		{			
			var fullName:String = "asset/config/" + xmlFileName;			
			if (m_dic[fullName] != undefined)
			{
				delete m_dic[fullName];
			}
		}
		
		private function onFailed(event:ResourceEvent):void
		{
			var res:XMLResource = event.resourceObject as XMLResource;
			var info:XmlLoaderInfo = m_dic[res.filename];
			delete m_dic[res.filename];
			
			m_gkContext.addLog(res.filename);
			Logger.info(null, null, "XmlLoaderMgr--"+res.filename+"加载失败");
		}
	}

}