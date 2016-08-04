package game.ui.uiXingMai.tip 
{
	import com.bit101.components.Label;
	import com.bit101.components.PanelContainer;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import modulecommon.appcontrol.AttrStrip;
	import modulecommon.GkContext;
	import modulecommon.res.ResGrid9;
	import modulecommon.scene.prop.table.TSkillBaseItem;
	import modulecommon.scene.xingmai.ItemSkill;
	import modulecommon.scene.xingmai.OpenSkill;
	import com.util.UtilColor;
	/**
	 * ...
	 * @author ...
	 * 下一个将要被激活的觉醒技能
	 */
	public class TipNextActSkill extends PanelContainer
	{
		public static const WIDTH:uint = 266;
		
		private var m_gkContext:GkContext;
		private var m_nameLabel:Label;
		private var m_typeLabel:Label;
		private var m_attrStrip:AttrStrip;
		private var m_txtField:TextField;
		private var m_lastText:TextField;
		
		public function TipNextActSkill(gk:GkContext) 
		{
			m_gkContext = gk;
			
			m_nameLabel = new Label(this, 12, 14, "", 0xFFCC00, 14);
			m_nameLabel.setBold(true);
			m_typeLabel = new Label(this, 220, 16, "技能", 0xFFCC00, 12);
			
			m_attrStrip = new AttrStrip(this, 3, 40);
			
			var format:TextFormat = new TextFormat();
			format.color = 0x00ff00;
			format.size = 12;
			format.letterSpacing = 1;
			format.leading = 3;
			
			m_txtField = new TextField();
			m_attrStrip.addChild(m_txtField);
			m_txtField.multiline = true;
			m_txtField.wordWrap = true;
			m_txtField.x = 12;
			m_txtField.y = 5;
			m_txtField.width = 242;
			m_txtField.height = 300;
			m_txtField.mouseEnabled = false;
			m_txtField.defaultTextFormat = format;
			
			m_lastText = new TextField();
			this.addChild(m_lastText);
			m_lastText.multiline = true;
			m_lastText.wordWrap = true;
			m_lastText.x = 12;
			m_lastText.y = 16;
			m_lastText.width = 242;
			m_lastText.height = 300;
			m_lastText.mouseEnabled = false;
			format.color = 0xdFa600;
			m_lastText.defaultTextFormat = format;
			
			this.setSkinGrid9Image9(ResGrid9.StypeTip);
		}
		
		//skillid:觉醒技能BaseID
		public function showTip(skillid:uint, bAct:Boolean):void
		{
			var skillbase:TSkillBaseItem = m_gkContext.m_skillMgr.skillItem(skillid) as TSkillBaseItem;
			var itemskill:ItemSkill = m_gkContext.m_xingmaiMgr.getItemSkill(skillid);
			if (null == skillbase || null == itemskill)
			{
				return;
			}
			
			m_nameLabel.text = itemskill.m_name;
			m_typeLabel.text = skillbase.typeName;
			m_txtField.text = skillbase.m_desc;
			
			m_attrStrip.setSize(260, m_txtField.textHeight + 16);
			
			var str:String = "";
			var openskill:OpenSkill = m_gkContext.m_xingmaiMgr.getOpenSkill(skillid);
			if (openskill)
			{
				if (bAct)
				{
					str = "该技能已开启";
				}
				else
				{
					str = "所有觉醒等级达到 " + openskill.m_attrlevel.toString() + "级 时开启";
				}
			}
			else
			{
				str = "觉醒等级提升可获得新技能";
			}
			m_lastText.text = str;
			m_lastText.y = m_attrStrip.y + m_attrStrip.height + 8;
			
			this.setSize(WIDTH, m_lastText.y + m_lastText.textHeight + 15);
		}
	}

}