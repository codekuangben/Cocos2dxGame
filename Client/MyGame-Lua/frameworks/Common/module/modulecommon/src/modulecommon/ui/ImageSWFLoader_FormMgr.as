package modulecommon.ui 
{
	/**
	 * ...
	 * @author 
	 */
	import flash.utils.Dictionary;
	import modulecommon.GkContext;
	import com.dgrigg.image.CommonImageManager;
	public class ImageSWFLoader_FormMgr 
	{
		private var m_gkContext:GkContext;
		private var m_dicImageName:Dictionary;	//[the id of form, the imageswf fullpath]
		private var m_dicLoader:Dictionary;	//[the id of form, ImageSWFLoader_Form]
		public function ImageSWFLoader_FormMgr(gk:GkContext) 
		{
			m_gkContext = gk;
			m_dicImageName = new Dictionary();
			m_dicImageName[UIFormID.UIZhenfa] = "imageZhenfa.swf";
			m_dicImageName[UIFormID.UIXingMai] = "xingmai.swf";
			m_dicImageName[UIFormID.UITaskTrace] = "imageTasktrace.swf";
			m_dicLoader = new Dictionary();
		}
		
		
		public function showForm(id:uint):void
		{
			var imageLoader:ImageSWFLoader_Form = m_dicLoader[id];
			if (imageLoader != null)
			{
				if (m_gkContext.m_UIMgr.m_showLog)
				{
					m_gkContext.addLog("Form不存在" + m_gkContext.m_UIMgr.getFormName(id));
				}
				return;
			}
			
			if (m_gkContext.m_UIMgr.m_showLog)
			{
				m_gkContext.addLog("创建Form" + m_gkContext.m_UIMgr.getFormName(id));
			}
			imageLoader = new ImageSWFLoader_Form(m_gkContext,this);			
			var fileName:String = computeFileName(id);
			m_dicLoader[id] = imageLoader;
			imageLoader.showForm(id, fileName);
		}
		public function showForm_NoProgress(id:uint):void
		{
			var imageLoader:ImageSWFLoader_Form_NoProgress = m_dicLoader[id];
			if (imageLoader != null)
			{
				if (m_gkContext.m_UIMgr.m_showLog)
				{
					m_gkContext.addLog("Form不存在" + m_gkContext.m_UIMgr.getFormName(id));
				}
				return;
			}
			
			if (m_gkContext.m_UIMgr.m_showLog)
			{
				m_gkContext.addLog("创建Form" + m_gkContext.m_UIMgr.getFormName(id));
			}
			imageLoader = new ImageSWFLoader_Form_NoProgress(m_gkContext,this);			
			var fileName:String = computeFileName(id);
			m_dicLoader[id] = imageLoader;
			imageLoader.showForm(id, fileName);
		}
		public function removeLoader(imageLoader:ImageSWFLoader_Form_Base):void
		{
			var id:uint = imageLoader.loadingFormID;
			if (m_dicLoader[id] != undefined)
			{
				delete m_dicLoader[id];
			}
		}
		private function computeFileName(id:uint):String
		{
			return CommonImageManager.toPathString("module/" + m_dicImageName[id]);
		}
	}

}