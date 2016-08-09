package modulecommon.ui 
{
	/**
	 * ...
	 * @author zouzhiqiang
	 */
	import flash.utils.Dictionary;
	public class UILayer 
	{
		private var m_layer:int;	//UIFormID.FirstLayer定义
		private var m_deskTop:DeskTop;
		private var m_winDic:Dictionary;
		public var m_closeReguarlyProcessed:Boolean;
		public function UILayer(layer:int) 
		{
			m_layer = layer;
			m_deskTop = new DeskTop();
			m_winDic = new Dictionary();
		}
		public function get deskTop():DeskTop
		{
			return m_deskTop;
		}
		
		public function get winDic():Dictionary
		{
			return m_winDic;
		}
		
		public function hasForm(form:Form):Boolean
		{
			return m_winDic[form.id] != undefined;
		}
		
		public function removeForm(form:Form):void
		{			
			if (m_winDic[form.id] != undefined)
			{
				delete m_winDic[form.id];
				if (form.parent == m_deskTop)
				{
					m_deskTop.removeChild(form);
				}
			}
		}
		public function get layerID():int
		{
			return m_layer;
		}
		
		public function addForm(form:Form, bShow:Boolean):void
		{
			m_winDic[form.id] = form;
			if (bShow)
			{
				m_deskTop.addChild(form);
			}
		}
		public function onStageReSize():void
		{
			var num:int = m_deskTop.numChildren;
			var index:int = 0;
			var form:Form;
			for (index = 0; index < num; index++)
			{
				form = m_deskTop.getChildAt(index) as Form;
				form.onStageReSize();
			}
		}
		
		/*定时地关闭界面
		 * return - true执行某个界面的销毁操作
		 * false - 没有找到需要销毁的界面
		 */
		public function closeFormRegularly():Boolean
		{			
			var form:Form;						
			var formClose:Form;
			for each (form in m_winDic)
			{
				if (form.isVisible() == false && form.isTimeClose())
				{
					formClose = form;
					break;
				}
			}
			if (formClose)
			{
				formClose.destroy();
				return true;
			}
			else
			{
				return false;
			}
			
		}
		public function closeAllForm():void
		{
			var num:int = m_deskTop.numChildren;
			var index:int = 0;
			var form:Form;
			var list:Vector.<Form> = new Vector.<Form>();
			for (index = 0; index < num; index++)
			{				
				form = m_deskTop.getChildAt(index) as Form;
				if (form.bCloseOnSwitchMap)
				{
					list.push(form);
				}
			}
			
			for each(form in list)
			{
				form.exit();
			}
		}
	}
}