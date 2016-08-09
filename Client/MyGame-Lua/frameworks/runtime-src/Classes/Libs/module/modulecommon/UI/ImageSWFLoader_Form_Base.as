package modulecommon.ui 
{
	/**
	 * ...
	 * @author 
	 */	
	import com.pblabs.engine.resource.SWFResource;
	import com.util.DebugBox;
	import flash.utils.Dictionary;
	import modulecommon.GkContext;
	import com.pblabs.engine.resource.ResourceEvent;
	
	public class ImageSWFLoader_Form_Base 
	{
		
		protected var m_gkContext:GkContext;	
		protected var m_loadingFormID:uint;
		protected var m_fileName:String;
		protected var m_mgr:ImageSWFLoader_FormMgr;
		public function ImageSWFLoader_Form_Base(gk:GkContext, mgr:ImageSWFLoader_FormMgr) 
		{
			m_gkContext = gk;
			m_mgr = mgr;
			m_loadingFormID = 0;
		}
		
		public function showForm(id:uint, fileName:String):void
		{
			
		}
		protected function createForm(id:uint, res:SWFResource):void
		{
			var form:Form = m_gkContext.m_UIMgr.createFormInGame(id);
			form.setImageSWF(res);
			if (form.isShouldShow())
			{
				form.show();
			}
		}		
		
		
		protected function removeSelf():void
		{
			m_mgr.removeLoader(this);
		}	
		
		public function get loadingFormID():uint
		{
			return m_loadingFormID;
		}
		
	}

}