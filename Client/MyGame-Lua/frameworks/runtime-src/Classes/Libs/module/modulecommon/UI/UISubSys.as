package modulecommon.ui
{
	/**
	 * @brief ui 子功能模块
	 * */
	public class UISubSys extends Form
	{
		protected var m_uiLst:Vector.<uint>;
		protected var m_exiting:Boolean;		// 是否处在退出模块中

		public function UISubSys()
		{
			m_uiLst = new Vector.<uint>();
		}
		
		override public function exit():void
		{
			m_exiting = true;
			// 关闭所有界面
			var idx:int = m_uiLst.length - 1;
			var form:Form;
			while (idx >= 0)
			{
				form = m_gkcontext.m_UIMgr.getForm(m_uiLst[idx]);
				if (form)
				{
					form.exit();
				}
				
				--idx;
			}
			
			super.exit();
		}
		
		// 自界面关闭的时候调用
		public function onUIClose(formid:uint):void
		{
			var idx:int = 0;
			idx = m_uiLst.indexOf(formid);
			if (idx >= 0)
			{
				m_uiLst.splice(idx, 1);
			}
			
			if (!m_exiting)
			{
				if (!m_uiLst.length)
				{
					exit();
				}
			}
		}
		
		public function addOpenFlag(formid:uint):Boolean
		{
			var idx:int = -1;
			idx = m_uiLst.indexOf(formid);
			if (idx == -1)
			{
				m_uiLst.push(formid);
				return true;
			}
			
			return false;
		}
	}
}