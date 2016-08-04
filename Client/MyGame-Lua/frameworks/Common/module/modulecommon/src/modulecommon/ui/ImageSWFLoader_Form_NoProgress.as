package modulecommon.ui 
{
	/**
	 * ...
	 * @author 
	 * 加载界面资源时，不显示加载进度
	 */
	import com.pblabs.engine.debug.Logger;
	import com.pblabs.engine.resource.SWFResource;
	import com.util.DebugBox;
	import flash.utils.Dictionary;
	import modulecommon.GkContext;
	import com.pblabs.engine.resource.ResourceEvent;
	public class ImageSWFLoader_Form_NoProgress extends ImageSWFLoader_Form_Base 
	{
		
		public function ImageSWFLoader_Form_NoProgress(gk:GkContext, mgr:ImageSWFLoader_FormMgr) 
		{
			super(gk, mgr);
			
		}
		
		override public function showForm(id:uint, fileName:String):void
		{
			m_fileName = fileName;			
			m_loadingFormID = id;
			
			var res:SWFResource = m_gkContext.m_context.m_resMgr.getResource(fileName, SWFResource) as SWFResource;
			var loadState:int;
			if (res)
			{
				if (res.isLoaded)
				{
					if (res.didFail)
					{
						removeSelf();
						return;
					}					
				}
			}		
			
			m_gkContext.m_context.m_resMgr.load(m_fileName, SWFResource, onImageSwfLoaded, onImageSwfFailed) as SWFResource;
		}
		private function onImageSwfLoaded(event:ResourceEvent):void
		{			
			var res:SWFResource = event.resourceObject as SWFResource;			
			createForm(m_loadingFormID, res);
			
			removeSelf();
		}
		private function onImageSwfFailed(event:ResourceEvent):void
		{			
			Logger.info(null, null, event.resourceObject.filename + " Failed");
			m_loadingFormID = 0;
			removeSelf();
		}
	}

}