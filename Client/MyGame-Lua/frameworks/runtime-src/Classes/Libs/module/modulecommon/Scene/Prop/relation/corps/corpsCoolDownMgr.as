package modulecommon.scene.prop.relation.corps 
{
	import modulecommon.GkContext;
	import modulecommon.net.msg.corpscmd.updateCoolDownTimeCorpsUserCmd;
	import modulecommon.time.Daojishi;
	import flash.utils.ByteArray;
	import modulecommon.ui.UIFormID;
	import modulecommon.uiinterface.IUICorpsKejiYanjiu;
	/**
	 * ...
	 * @author ...
	 */
	public class corpsCoolDownMgr 
	{
		public var m_gkContext:GkContext;
		private var m_daojishiForMain:Daojishi;//主基地升级冷却时间
		private var m_daojishiForKeji:Daojishi;//科技升级冷却时间
		public function corpsCoolDownMgr(gk:GkContext) 
		{
			m_gkContext = gk;
			m_daojishiForMain = new Daojishi(m_gkContext.m_context);
			m_daojishiForMain.funCallBack = coldTimeUpdateForMain;
			
			m_daojishiForKeji = new Daojishi(m_gkContext.m_context);
			m_daojishiForKeji.funCallBack = coldTimeUpdateForKeji;
		}
		public function process_updateCoolDownTimeCorpsUserCmd(msg:ByteArray, param:uint):void
		{
			var rev:updateCoolDownTimeCorpsUserCmd = new updateCoolDownTimeCorpsUserCmd();
			rev.deserialize(msg);
			m_daojishiForMain.initLastTime_Second = rev.mainCoolDown;	m_daojishiForMain.begin();
			m_daojishiForKeji.initLastTime_Second = rev.kejiCoolDown;	m_daojishiForKeji.begin();	
		}
		
		public function onCoolFormHide():void
		{
			if (m_gkContext.m_UIMgr.isFormVisible(UIFormID.UICorpsInfo) == false)
			{
				m_daojishiForMain.pause();
				
				if (m_gkContext.m_UIMgr.isFormVisible(UIFormID.UICorpsKejiYanjiu) == false)
				{
					m_daojishiForKeji.pause();
				}
			}
		}
		
		public function onCoolFormShow():void
		{
			if (m_gkContext.m_UIMgr.isFormVisible(UIFormID.UICorpsInfo))
			{
				m_daojishiForMain.continue_s();
				m_daojishiForKeji.continue_s();
			}
			if (m_gkContext.m_UIMgr.isFormVisible(UIFormID.UICorpsKejiYanjiu))
			{
				m_daojishiForKeji.continue_s();
			}
		}
		public function get coolDownRemainTimeForMain():int
		{
			if (m_daojishiForMain)
			{
				return m_daojishiForMain.timeSecond;
			}
			return 0;
		}		
				
		public function get coolDownRemainTimeForKeji():int
		{
			if (m_daojishiForKeji)
			{
				return m_daojishiForKeji.timeSecond;
			}
			return 0;
		}
		private function coldTimeUpdateForMain(d:Daojishi):void
		{
			if (m_daojishiForMain.isStop())
			{				
				m_daojishiForMain.end();
			}
			
			if (m_gkContext.m_corpsMgr.m_ui)
			{
				m_gkContext.m_corpsMgr.m_ui.updateCoolDownForMain();
			}
		}
		private function coldTimeUpdateForKeji(d:Daojishi):void
		{
			if (m_daojishiForKeji.isStop())
			{				
				m_daojishiForKeji.end();
			}
			
			if (m_gkContext.m_corpsMgr.m_ui)
			{
				m_gkContext.m_corpsMgr.m_ui.updateCoolDownForKeji();
			}		
			
			var iui:IUICorpsKejiYanjiu = m_gkContext.m_UIMgr.getForm(UIFormID.UICorpsKejiYanjiu) as IUICorpsKejiYanjiu;
			if (iui && iui.isVisible())
			{
				iui.updateCoolDown();
			}
		}
	}

}