package modulecommon.commonfuntion.delayloader
{
	import com.pblabs.engine.resource.ResourceEvent;
	import com.pblabs.engine.resource.SWFResource;
	
	import modulecommon.GkContext;
	import modulecommon.ui.UIResourceLoading;

	/**
	 * @brief 延迟加载 UI
	 * */
	public class DelayLoaderUI extends DelayLoaderBase
	{
		public var m_gkcontext:GkContext;
		public var m_uiID:uint;	// 加载的 ui 的ID
		public var m_fcbLoaded:Function;
		//public var m_fcbFailed:Function;
		
		override public function loadRes():Boolean
		{
			//m_gkcontext.m_UIMgr.loadForm(m_uiID);
			//return true;
			if(m_gkcontext.m_UIMgr.getForm(m_uiID))
			{
				m_fcbLoaded();
				return true;
			}
			else
			{
				return false;
			}
		}
		
		override public function onResLoaded(res:SWFResource):void
		{
			//m_gkcontext.m_UIMgr.loadForm(m_uiID);
			var uiRes:UIResourceLoading = new UIResourceLoading();
			uiRes.id = m_uiID;
			m_gkcontext.m_UIMgr.m_UIResDic[m_path] = uiRes;
			var event:ResourceEvent = new ResourceEvent(ResourceEvent.LOADED_EVENT, res)
			m_gkcontext.m_UIMgr.onloadedSWF(event);
		}
		
		//override public function onResFailed(res:SWFResource):void
		//{
		//	
		//}
		
		override public function set fcbLoaded(fn:Function):void
		{
			m_fcbLoaded = fn;
		}
		
		//override public function set fcbFailed(fn:Function):void
		//{
		//	m_fcbFailed = fn;
		//}
		
		override public function dispose():void
		{
			m_gkcontext = null;
			m_fcbLoaded = null;
			super.dispose();
		}
	}
}