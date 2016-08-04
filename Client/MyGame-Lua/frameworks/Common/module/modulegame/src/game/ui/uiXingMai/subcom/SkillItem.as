package game.ui.uiXingMai.subcom 
{
	import com.bit101.components.Component;
	import com.bit101.components.controlList.CtrolComponent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import modulecommon.GkContext;
	import modulecommon.scene.prop.skill.SkillIcon;
	import game.ui.uiXingMai.UIXingMai;
	/**
	 * ...
	 * @author ...
	 */
	public class SkillItem extends CtrolComponent
	{
		private var m_gkContext:GkContext;
		private var m_ui:UIXingMai;
		private var m_skillsPanel:SkillsPanel;
		private var m_skillIcon:SkillIcon;
		private var m_skillid:uint;
		
		public function SkillItem(param:Object) 
		{
			m_gkContext = param["gk"] as GkContext;	
			m_ui = param["ui"] as UIXingMai;
			m_skillsPanel = param["skillspanel"] as SkillsPanel;
			
			m_skillIcon = new SkillIcon(m_gkContext);
			this.addChild(m_skillIcon);
			m_skillIcon.setPos(25, 25);
			m_skillIcon.buttonMode = true;
			m_skillIcon.addEventListener(MouseEvent.ROLL_OVER, onMouseRollOver);
			m_skillIcon.addEventListener(MouseEvent.ROLL_OUT, onMouseRollOut);
			m_skillIcon.addEventListener(MouseEvent.CLICK, onMouseClick);
			
			this.setSize(90, 90);
		}
		
		override public function setData(data:Object):void
		{
			super.setData(data);
			m_skillid = data as uint;
			
			m_skillIcon.setSkillID(m_gkContext.m_xingmaiMgr.getXMSkillLevelID(m_skillid));
			if (m_skillid == m_gkContext.m_xingmaiMgr.m_curUsingSkillBaseID)
			{
				m_skillsPanel.setUsingPanel(this);
			}
		}
		
		private function onMouseRollOver(event:MouseEvent):void
		{
			var panel:Component = event.currentTarget as SkillIcon;
			var pt:Point = panel.localToScreen(new Point(45, -5));
			
			m_ui.showTipsOfSkill(pt, m_skillIcon.skillID);
			m_gkContext.m_objMgr.showObjectMouseOverPanel(m_skillIcon, -7, -7);
		}
		
		private function onMouseRollOut(event:MouseEvent):void
		{
			m_gkContext.m_uiTip.hideTip();
			m_gkContext.m_objMgr.hideObjectMouseOverPanel(m_skillIcon);
		}
		
		private function onMouseClick(event:MouseEvent):void
		{
			setUsingSkill();
		}
		
		public function setUsingSkill():void
		{
			m_skillsPanel.changeUserSkill(this, m_skillid);
			m_skillsPanel.showActWuPanel(this, m_skillid);
		}
	}

}