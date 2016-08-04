package game.ui.uibackpack.wujiang 
{
	import com.bit101.components.Component;
	import com.bit101.components.Label;
	import com.bit101.components.Panel;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import modulecommon.GkContext;
	import modulecommon.scene.prop.skill.SkillIcon;
	import modulecommon.scene.prop.table.TSkillBaseItem;
	/**
	 * ...
	 * @author ...
	 * 武将天赋技能
	 */
	public class TianfuItem extends Component
	{
		private var m_gkContext:GkContext;
		private var m_skillbg:Panel;
		private var m_skillID:uint;
		private var m_skillIcon:SkillIcon;
		private var m_levelLabel:Label;
		private var m_index:int;		//天赋临时编号 1、2、3、4
		private var m_curLevel:int;		//当前天赋等级
		private var m_curMaxLevel:int;	//当前加数最高等级
		
		public function TianfuItem(gk:GkContext, parent:DisplayObjectContainer, xpos:Number = 0, ypos:Number = 0) 
		{
			super(parent, xpos, ypos);
			m_gkContext = gk;
			
			m_skillbg = new Panel(this, -6, -6);
			m_skillbg.setPanelImageSkin("commoncontrol/panel/wuzhuansheng/skillframe.png");
			
			m_skillIcon = new SkillIcon(m_gkContext);
			this.addChild(m_skillIcon);
			m_skillIcon.showNum = false;
			m_skillIcon.addEventListener(MouseEvent.ROLL_OVER, onMouseRollOver);
			m_skillIcon.addEventListener(MouseEvent.ROLL_OUT, onMouseRollOut);
			
			m_levelLabel = new Label(this, 45, 25);
			m_levelLabel.align = Component.RIGHT;
		}
		
		//level技能已学习等级
		public function setSkillID(skillid:uint, curLevel:int = 0, curMaxLevel:int = 0, actNum:int = 0):void
		{
			m_curLevel = curLevel;
			m_curMaxLevel = curMaxLevel;
			m_index = actNum;
			
			m_skillID = skillid;
			if (m_curLevel > 0)
			{
				m_skillIcon.becomeUnGray();
				m_skillID += (m_curLevel - 1);
			}
			else
			{
				m_skillIcon.becomeGray();
			}
			
			
			m_skillIcon.setSkillID(m_skillID);
			m_levelLabel.text = m_curLevel.toString() + "/" + m_curMaxLevel.toString();
		}
		
		private function onMouseRollOver(event:MouseEvent):void
		{
			var skill:SkillIcon = event.currentTarget as SkillIcon;
			var pt:Point = skill.localToScreen(new Point(42, -5));
			
			m_gkContext.m_uiTip.hintSkillInfoForTianfu(pt, skill.skillID, 0, lastText);
			m_gkContext.m_objMgr.showObjectMouseOverPanel(skill, -7, -7);
		}
		
		private function onMouseRollOut(event:MouseEvent):void
		{
			var skill:SkillIcon = event.currentTarget as SkillIcon;
			m_gkContext.m_uiTip.hideTip();
			m_gkContext.m_objMgr.hideObjectMouseOverPanel(skill);
		}
		
		private function get lastText():String
		{
			var ret:String;
			var skillBase:TSkillBaseItem = m_gkContext.m_skillMgr.skillItem(m_skillID) as TSkillBaseItem;
			
			if (m_curLevel)
			{
				if (m_curLevel == skillBase.m_levelMax)
				{
					ret = "武将自身持有";
				}
				else if (m_curLevel == m_curMaxLevel)
				{
					ret = "武将转生后，可提升技能等级上限";
				}
				else
				{
					ret = "关系武将 " + m_index.toString() + "激活 后，技能等级+1；武将再次转生后，技能等级上限+1";
				}
			}
			else
			{
				ret = "关系武将 " + m_index.toString() + "激活 后获得该技能";
			}
			
			return ret;
		}
		
		override public function dispose():void
		{
			m_skillIcon.removeSkill();
			
			super.dispose();
		}
		
	}

}