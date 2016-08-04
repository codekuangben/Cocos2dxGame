package game.ui.uiHintMgr.subform
{
	import com.bit101.components.Panel;
	import flash.events.MouseEvent;
	import modulecommon.uiinterface.IForm;
	import uiHintMgr.UIHintMgr;
	import com.util.UtilHtml;
	import modulecommon.ui.UIFormID;

	/**
	 * @ brief 战斗失败提示框
	 * */
	public class UIFGFail extends UIHint
	{
		private var m_upgradePanel:Panel;
		public function UIFGFail(mgr:UIHintMgr) 
		{
			super(mgr);
		}
		
		override public function onReady():void 
		{
			m_upgradePanel = new Panel(this, 36, 51);
			m_upgradePanel.setPanelImageSkin("commoncontrol/panel/objectBG.png");
			var panel:Panel = new Panel(m_upgradePanel, 3, 3);
			panel.setPanelImageSkin("commoncontrol/panel/upgrade.png");
			
			super.onReady();
		}
		
		public function addDesc():void
		{
			UtilHtml.beginCompose();
			UtilHtml.addStringNoFormat("很遗憾您战斗失败，提升下战力再战吧。");
			UtilHtml.breakline();
			UtilHtml.addStringNoFormat("提升战力");
			var str:String = UtilHtml.getComposedContent();
			this.setText(str);
			m_funBtn.label = "查看信息";
		}
		
		override protected function onFunBtnClick(event:MouseEvent):void 
		{
			//if (m_gkcontext.m_xingmaiMgr.hasRequest() == false)
			//{
			//	m_gkcontext.m_xingmaiMgr.loadConfig();
			//}
			if (m_gkcontext.m_zhanliupgradeMgr.hasRequest() == false)
			{
				m_gkcontext.m_zhanliupgradeMgr.loadConfig();
			}
			
			var data:Object = new Object();
			data["reason"] = m_gkcontext.m_beingProp.m_jnReason;
			data["otherjnid"] = m_gkcontext.m_beingProp.m_otherJNID;
			m_gkcontext.m_contentBuffer.addContent("jinnangRestraint_info", data);
			
			if(m_gkcontext.m_UIMgr.isFormVisible(UIFormID.UIZhanliUpgrade) == false)
			{
				m_gkcontext.m_UIMgr.loadForm(UIFormID.UIZhanliUpgrade);
			}
			
			exit();
		}
		
		override public function exit():void
		{
			super.exit();
			m_gkcontext.m_beingProp.m_jnReason = 0;
		}
	}
}