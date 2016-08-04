package game.ui.uibackpack.subForm.fastZhuansheng 
{
	import modulecommon.GkContext;
	import modulecommon.scene.wu.WuHeroProperty;
	/**
	 * ...
	 * @author 
	 */
	public class FastZhuanshengMgr 
	{
		private var m_gkContext:GkContext;
		private var m_stack:Vector.<UIFastZhuansheng>;
		public function FastZhuanshengMgr(gk:GkContext) 
		{
			m_gkContext = gk;
			m_stack = new Vector.<UIFastZhuansheng>();
		}
		
		public function zhuansheng(wu:WuHeroProperty):void
		{
			var ui:UIFastZhuansheng = new UIFastZhuansheng(this);
			ui.id = m_gkContext.m_dynamicFormIDAllocator.allocate();
			m_gkContext.m_UIMgr.addForm(ui);	
			ui.zhuanshengWu(wu);
			ui.show();
			if (m_stack.length > 0)
			{
				m_stack[m_stack.length - 1].hide();
			}
			m_stack.push(ui);
		}
		
		public function onDestroyForm(ui:UIFastZhuansheng):void
		{
			if (m_stack.length == 0)
			{
				return;
			}
			var lastUI:UIFastZhuansheng = m_stack.pop();
			if (lastUI != ui)
			{
				//出现bug
			}
			if (m_stack.length > 0)
			{
				lastUI = m_stack[m_stack.length - 1];
				lastUI.update();
				lastUI.show();
			}
		}
		public function updateForm():void
		{
			if (m_stack.length == 0)
			{
				return;
			}
			var lastUI:UIFastZhuansheng = m_stack[m_stack.length - 1];
			lastUI.update();
		}
		
	}

}