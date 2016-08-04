package game.ui.uibackpack.tips 
{
	import com.bit101.components.Label;
	import com.bit101.components.Panel;
	import com.bit101.components.PanelContainer;
	import com.bit101.components.TextNoScroll;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import modulecommon.GkContext;
	import modulecommon.res.ResGrid9;
	import modulecommon.scene.prop.skill.SkillMgr;
	import modulecommon.scene.prop.table.TSkillBaseItem;
	import com.util.UtilColor;
	import com.util.UtilHtml;
	/**
	 * ...
	 * @author ...
	 * 人物界面，武将锦囊Tips
	 */
	public class WuJinnangTip extends PanelContainer
	{
		private var m_gkContext:GkContext;
		private var m_nameLabel:Label;
		private var m_textTf:TextNoScroll;
		private var m_container:PanelContainer;
		private var m_bottomSegment:Panel;
		private var m_lastText:TextField;
		
		public function WuJinnangTip(gk:GkContext) 
		{
			m_gkContext = gk;
			this.setSize(266, 200);
			this.setSkinGrid9Image9(ResGrid9.StypeTip);
			
			m_nameLabel = new Label(this, 12, 14, "", 0x00FFFF, 14);
			m_nameLabel.setBold(true);
			
			var label:Label;
			label = new Label(this, 220, 14, "锦囊", 0x00FFFF);
			
			m_container = new PanelContainer(this, 4, 40);
			m_container.autoSizeByImage = false;
			m_container.width = 258;
			m_container.setPanelImageSkin("commoncontrol/panel/tipwideblue.png");
			
			var panel:Panel;
			panel = new Panel(m_container, 0, 0);
			panel.setSize(258,1);
			panel.setPanelImageSkin("commoncontrol/panel/tipsegment.png");
			
			m_bottomSegment = new Panel(m_container);
			m_bottomSegment.setSize(258,1);
			m_bottomSegment.setPanelImageSkin("commoncontrol/panel/tipsegment.png");
			
			m_textTf = new TextNoScroll();
			m_container.addChild(m_textTf);
			m_textTf.x = 12;
			m_textTf.y = 5;
			m_textTf.width = 242;
			m_textTf.setCSS("body", {leading: 3,letterSpacing:1});
			
			m_lastText = new TextField();
			this.addChild(m_lastText);
			m_lastText.multiline = true;
			m_lastText.wordWrap = true
			m_lastText.x = 12;
			m_lastText.y = 16;
			m_lastText.width = 242;
			m_lastText.height = 100;
			m_lastText.mouseEnabled = false;			
			
			var tformat:TextFormat = new TextFormat();
			tformat.color = 0xdFa600;			
			tformat.letterSpacing = 1;
			tformat.leading = 3;
			m_lastText.defaultTextFormat = tformat;
		}
		
		public function showTip(skillid:uint, wuadd:int = 0):void
		{
			var base:TSkillBaseItem = m_gkContext.m_skillMgr.skillItem(skillid + wuadd) as TSkillBaseItem;
			if (base == null)
			{
				return ;
			}
			
			m_nameLabel.text = base.m_name;
			
			var str:String;
			var jnAttr:int = SkillMgr.jnAttrType(skillid);
			
			UtilHtml.beginCompose();
			UtilHtml.addStringNoFormat("<body>");
			UtilHtml.add("使锦囊库中", UtilColor.GREEN);
			UtilHtml.add("【" + SkillMgr.jnAttrNameByID(skillid) + "】锦囊", 0x00FFFF);
			UtilHtml.add("等级+" + (1 + wuadd) + "，相同武将对锦囊库中锦囊等级加成无效", UtilColor.GREEN);
			UtilHtml.breakline();
			UtilHtml.add("【" + SkillMgr.jnAttrNameByID(skillid) + "】锦囊", 0x00FFFF);
			UtilHtml.add("克制任意等级", UtilColor.GREEN);
			UtilHtml.add("【" + SkillMgr.jnAttrName(SkillMgr.jnAttrInhibit(jnAttr)) + "】锦囊", 0x00FFFF);
			UtilHtml.add("，被", UtilColor.GREEN);
			UtilHtml.add("【" + SkillMgr.jnAttrName(SkillMgr.jnAttrInhibitedBy(jnAttr)) + "】锦囊", 0x00FFFF);
			UtilHtml.add("克制", UtilColor.GREEN);
			UtilHtml.addStringNoFormat("</body>");
			m_textTf.text = UtilHtml.getComposedContent();
			
			m_container.height = m_textTf.textHeight + 15;
			m_bottomSegment.y = m_container.height - 1;
			
			if (wuadd < 3)
			{
				str = "升级方式：武将转生 锦囊等级+1";
			}
			else
			{
				str = "该武将所携带锦囊，已达到最高等级";
			}
			
			m_lastText.text = str;
			m_lastText.y = m_container.y + m_container.height + 10;
			
			this.height = m_lastText.y + m_lastText.textHeight + 20;
		}
		
	}

}