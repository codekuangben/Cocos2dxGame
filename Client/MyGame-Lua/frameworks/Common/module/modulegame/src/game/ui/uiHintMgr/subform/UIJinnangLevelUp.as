package game.ui.uiHintMgr.subform 
{
	import com.bit101.components.Panel;
	import flash.events.MouseEvent;
	import modulecommon.scene.prop.skill.SkillMgr;
	import modulecommon.scene.wu.WuHeroProperty;
	import com.util.UtilColor;
	import com.util.UtilHtml;
	import modulecommon.ui.Form;
	import modulecommon.ui.UIFormID;
	import game.ui.uiHintMgr.UIHintMgr;
	/**
	 * ...
	 * @author ...
	 * 锦囊库中，有锦囊等级提升时提示
	 */
	public class UIJinnangLevelUp extends UIHint
	{
		private var m_jinnangPanel:Panel;
		
		public function UIJinnangLevelUp(mgr:UIHintMgr) 
		{
			super(mgr);
		}
		
		override public function onReady():void 
		{
			var panel:Panel = new Panel(this, 36, 51);
			panel.setPanelImageSkin("commoncontrol/panel/objectBG.png");
			m_jinnangPanel = new Panel(panel, 3, 3);
			
			super.onReady();
		}
		
		public function addDesc(wuhero:WuHeroProperty):void
		{
			var jinnangid:uint = wuhero.m_wuPropertyBase.m_uJinnang1;
			m_jinnangPanel.setPanelImageSkin(m_gkcontext.m_skillMgr.iconResName(jinnangid));
			
			UtilHtml.beginCompose();
			UtilHtml.addStringNoFormat("由于");
			UtilHtml.add(wuhero.fullName, wuhero.colorValue);
			UtilHtml.addStringNoFormat("的加入/转生，您的");
			UtilHtml.add("【" + SkillMgr.jnAttrNameByID(jinnangid) + "】锦囊", 0x00FFFF);
			UtilHtml.addStringNoFormat("等级提升了。");
			var str:String = UtilHtml.getComposedContent();
			this.setText(str);
			m_funBtn.label = "变更锦囊";
		}
		
		override protected function onFunBtnClick(event:MouseEvent):void 
		{
			if (false == m_gkcontext.m_UIMgr.isFormVisible(UIFormID.UIZhenfa))
			{				
				m_gkcontext.m_UIMgr.showFormWidthProgress(UIFormID.UIZhenfa);
			}
			
			exit();
		}
	}

}