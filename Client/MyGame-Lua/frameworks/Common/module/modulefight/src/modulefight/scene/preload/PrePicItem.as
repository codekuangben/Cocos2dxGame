package modulefight.scene.preload
{
	import modulecommon.GkContext;
	import org.ffilmation.engine.helpers.fObjectDefinition;
	import org.ffilmation.engine.helpers.fUtil;
	import com.pblabs.engine.entity.EntityCValue;
	import com.pblabs.engine.resource.SWFResource;
	import com.pblabs.engine.resource.ResourceEvent;

	public class PrePicItem extends PreItem
	{
		public var m_onLF:Function;	// 加载完成后回调函数
		public var m_modelStrList:Vector.<String>;		// 模型字符串，例如 e2_e131
		
		public function PrePicItem(value:GkContext)
		{
			super(value);
			m_modelStrList = new Vector.<String>();
		}
		
		// 重载加载的资源
		override public function loadRes():void
		{
			var insID:String = "";
			var insdef:fObjectDefinition;
			var modelstr:String;
			var filename:String = "";
			var path:String;
			
			for each(modelstr in m_modelStrList)
			{
				insID = fUtil.insStrFromModelStr(modelstr);
				insdef = this.m_gkContext.m_context.m_sceneResMgr.getInsDefinition(insID);
				if (insdef)	// 不存在就加载，如果已经有了就不加载了
				{
					filename = insdef.dicAction[0].directDic[0].spriteVec[0].mediaPath;
					path = this.m_gkContext.m_context.m_path.getPathByName(filename, EntityCValue.PHEFF);
					
					if(m_nameList.indexOf(path) == -1)	// 如果没有加入
					{
						// 如果这个资源没有加载就加载，如果已经有了或者正在加载就不加载了
						//if(!this.m_gkContext.m_context.m_resMgrNoProg.getResource(path, SWFResource))
						if(!this.m_gkContext.m_context.m_resMgr.getResource(path, SWFResource))
						{
							m_nameList.push(path);
						}
					}
				}
			}
			
			super.loadRes();
		}
		
		override public function onResLoaded(event:ResourceEvent):void
		{
			super.onResLoaded(event);
			if (m_failedNameList.length + m_loadedNameList.length == m_nameList.length)
			{
				if(m_onLF != null)
				{
					m_onLF();
				}
			}
		}
		
		override public function onResFailed(event:ResourceEvent):void
		{
			super.onResFailed(event);
			if (m_failedNameList.length + m_loadedNameList.length == m_nameList.length)
			{
				if(m_onLF != null)
				{
					m_onLF();
				}
			}
		}
	}
}