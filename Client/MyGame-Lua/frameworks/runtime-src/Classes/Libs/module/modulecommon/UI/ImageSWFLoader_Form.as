package modulecommon.ui 
{
	
	import com.pblabs.engine.debug.Logger;
	import com.pblabs.engine.resource.SWFResource;
	import com.util.DebugBox;
	import flash.utils.Dictionary;
	import modulecommon.GkContext;
	import com.pblabs.engine.resource.ResourceEvent;
	import com.pblabs.engine.resource.ResourceProgressEvent;
	/**
	 * ...
	 * @author 
	 * Form对象的图片包(swf文件)加载器，
	 * 
	 */
	public class ImageSWFLoader_Form  extends ImageSWFLoader_Form_Base 
	{
		
		public function ImageSWFLoader_Form(gk:GkContext, mgr:ImageSWFLoader_FormMgr) 
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
			
			
			m_gkContext.m_UIs.circleLoading.loadRes(m_fileName);
			m_gkContext.m_context.m_resMgr.load(m_fileName, SWFResource, onImageSwfLoaded, onImageSwfFailed, onProgressSWF, onStartedSWF) as SWFResource;
		}
		
		private function onImageSwfLoaded(event:ResourceEvent):void
		{
			m_gkContext.m_UIs.circleLoading.circleResLoaded(m_fileName);
			var res:SWFResource = event.resourceObject as SWFResource;			
			
			createForm(m_loadingFormID, res);
			
			removeSelf();
		}
		
	
		
		private function onImageSwfFailed(event:ResourceEvent):void
		{
			m_gkContext.m_UIs.circleLoading.circleResLoaded(m_fileName);
			Logger.info(null, null, event.resourceObject.filename + " Failed");
			m_loadingFormID = 0;
			removeSelf();
		}
		
		
		
		private function onProgressSWF(event:ResourceProgressEvent):void
		{
			m_gkContext.circleResProgress(event.resourceObject.filename, event._percentLoaded);
		}
		
		private function onStartedSWF(event:ResourceEvent):void
		{
			// 加载进度条
			m_gkContext.circleResStarted(event.resourceObject.filename);
		}					
	}

}