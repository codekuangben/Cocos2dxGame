package modulefight.scene.preload 
{
	import flash.utils.ByteArray;
	import org.ffilmation.engine.helpers.fUtil;
	import modulefight.scene.preload.PreItem;
	import com.pblabs.engine.resource.ResourceEvent;
	import org.ffilmation.engine.helpers.fObjectDefinition;
	import com.pblabs.engine.resource.SWFResource;
	
	import com.pblabs.engine.debug.Logger;
	import modulecommon.GkContext;

	/**
	 * ...
	 * @author ...
	 * @brief 预加载 XML 配置
	 */
	public class PreXMLItem extends PreItem
	{
		public var m_onLF:Function;	// 加载完成后回调函数 

		public function PreXMLItem(value:GkContext)
		{
			super(value);
		}
		
		// 加载一个资源，判断完直接加载一个资源，不再再次遍历的时候加载了
		public function loadOne(filename:String):void
		{
			if (filename == null)
			{
				return;
			}
			//var res:SWFResource = this.m_gkContext.m_context.m_resMgrNoProg.getResource(filename, SWFResource) as SWFResource;
			var res:SWFResource = this.m_gkContext.m_context.m_resMgr.getResource(filename, SWFResource) as SWFResource;
			if (!res) // 不存在就加载 
			{
				//m_resDict[filename] = this.m_gkContext.m_context.m_resMgrNoProg.load(filename, SWFResource, this.onResLoaded, this.onResFailed) as SWFResource;
				m_resDict[filename] = this.m_gkContext.m_context.m_resMgr.load(filename, SWFResource, this.onResLoaded, this.onResFailed) as SWFResource;
				// 显示加载进度条
				//m_gkContext.m_UIs.circleLoading.loadRes(filename);
				// 清除加载中显示的数据
				//m_gkContext.m_UIs.circleLoading.clearDesc();
			}
			else if (res.didFail)
			{
				res.incrementReferenceCount();
				//res.addEventListener(ResourceEvent.LOADED_EVENT, onResLoaded);
				//res.addEventListener(ResourceEvent.FAILED_EVENT, onResFailed);
				onResFailed(new ResourceEvent(ResourceEvent.LOADED_EVENT, res));
			}
			else if (res.isLoaded)
			{
				res.incrementReferenceCount();
				onResLoaded(new ResourceEvent(ResourceEvent.LOADED_EVENT, res));
			}
			else
			{
				res.addEventListener(ResourceEvent.LOADED_EVENT, onResLoaded);
				res.addEventListener(ResourceEvent.FAILED_EVENT, onResFailed);
				m_resDict[filename] = res;	// 保存资源，卸载的时候如果没有清理事件就清理事件
			}
		}
		
		override public function onResLoaded(event:ResourceEvent):void
		{
			event.resourceObject.removeEventListener(ResourceEvent.LOADED_EVENT, onResLoaded);
			event.resourceObject.removeEventListener(ResourceEvent.FAILED_EVENT, onResFailed);
			
			//m_gkContext.m_UIs.circleLoading.circleResLoaded(event.resourceObject.filename);
			
			var insID:String;
			var insdef:fObjectDefinition;
			insID = fUtil.getInsIDByPath(event.resourceObject.filename);
			insdef = this.m_gkContext.m_context.m_sceneResMgr.getInsDefinition(insID);
			// 检查一遍是否被其它地方填充了这个定义 
			if (!insdef)
			{
				// 直接解析 xml 
				var bytes:ByteArray;
				var clase:String = fUtil.xmlResClase(event.resourceObject.filename);
				bytes = (event.resourceObject as SWFResource).getExportedAsset(clase) as ByteArray;
				
				var xml:XML;
				xml = new XML(bytes.readUTFBytes(bytes.length));
				
				// 不再拷贝
				//insdef = new fObjectDefinition(xml.copy(), event.resourceObject.filename);
				insdef = new fObjectDefinition(xml, event.resourceObject.filename);
				xml = null;
				if (insdef)
				{
					this.m_gkContext.m_context.m_sceneResMgr.addInsDefinition(insdef);
				}
			}
			
			// 清理加载的资源
			m_loadedNameList.push(event.resourceObject.filename);
			
			// 删除资源
			m_resDict[event.resourceObject.filename] = null;
			delete m_resDict[event.resourceObject.filename];
			
			Logger.info(null, null, event.resourceObject.filename + " loaded");
			//this.m_gkContext.m_context.m_resMgrNoProg.unload(event.resourceObject.filename, SWFResource);
			this.m_gkContext.m_context.m_resMgr.unload(event.resourceObject.filename, SWFResource);
			
			if (m_failedNameList.length + m_loadedNameList.length == m_nameList.length)
			{
				//this.m_gkContext.m_fightControl.attemptBegin();
				m_onLF();
			}
		}
		
		override public function onResFailed(event:ResourceEvent):void
		{
			super.onResFailed(event);
			
			//m_gkContext.m_UIs.circleLoading.circleResFailed(event.resourceObject.filename);
			
			if (m_failedNameList.length + m_loadedNameList.length == m_nameList.length)
			{
				//this.m_gkContext.m_fightControl.attemptBegin();
				m_onLF();
			}
		}
	}
}