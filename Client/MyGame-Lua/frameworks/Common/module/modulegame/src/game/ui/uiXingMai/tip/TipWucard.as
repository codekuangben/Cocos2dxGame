package game.ui.uiXingMai.tip 
{
	import com.bit101.components.Label;
	import com.bit101.components.Panel;
	import com.bit101.components.PanelContainer;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import modulecommon.commonfuntion.SysNewFeatures;
	import modulecommon.GkContext;
	import modulecommon.res.ResGrid9;
	import modulecommon.scene.beings.NpcBattleBaseMgr;
	import modulecommon.scene.prop.table.TNpcBattleItem;
	import modulecommon.scene.wu.WuHeroProperty;
	import modulecommon.scene.xingmai.ItemSkill;
	import com.util.UtilColor;
	import com.util.UtilHtml;
	/**
	 * ...
	 * @author ...
	 * 星脉技能激活武将Tips
	 */
	public class TipWucard extends PanelContainer
	{
		private var m_gkContext:GkContext;
		private var m_nameLabel:Label;
		private var m_container:PanelContainer;
		private var m_bottomSegment:Panel;
		private var m_txtField:TextField;
		private var m_lastText:TextField;
		
		public function TipWucard(gk:GkContext) 
		{
			m_gkContext = gk;
			m_nameLabel = new Label(this, 20, 14);	m_nameLabel.setFontSize(16);	m_nameLabel.setBold(true);
			
			m_container = new PanelContainer(this, 4, 45);
			m_container.setSize(258, 60);
			m_container.autoSizeByImage = false;
			m_container.setPanelImageSkin("commoncontrol/panel/tipwideblue.png");
			
			var panel:Panel;
			panel = new Panel(m_container, 0, 0);	panel.setSize(258,1);
			panel.setPanelImageSkin("commoncontrol/panel/tipsegment.png");
			
			m_bottomSegment = new Panel(m_container);	m_bottomSegment.setSize(258,1);
			m_bottomSegment.setPanelImageSkin("commoncontrol/panel/tipsegment.png");
			
			m_txtField = new TextField();
			this.addChild(m_txtField);
			m_txtField.multiline = true;
			m_txtField.wordWrap = true
			m_txtField.x = 15;
			m_txtField.y = 10;
			m_txtField.width = 236;
			m_txtField.height = 60;
			
			var tformat:TextFormat = new TextFormat();
			tformat.color = 0xbbbbbb;
			tformat.leading = 3;
			tformat.letterSpacing = 1;
			tformat.font = "Times New Roman";
			m_txtField.defaultTextFormat = tformat;
			
			m_lastText = new TextField();
			this.addChild(m_lastText);
			m_lastText.multiline = true;
			m_lastText.wordWrap = true
			m_lastText.x = 15;
			m_lastText.y = 60;
			m_lastText.width = 236;
			m_lastText.height = 150;
			m_lastText.mouseEnabled = false;
			m_lastText.defaultTextFormat = tformat;
			
			this.setSize(266, 120);
			this.setSkinGrid9Image9(ResGrid9.StypeTip);
		}
		
		public function showTip(heroid:uint, bAct:Boolean, skillname:String, desc:String):void
		{
			var wu:WuHeroProperty = m_gkContext.m_wuMgr.getWuByHeroID(heroid) as WuHeroProperty;
			var wuname:String = "";
			var wucolor:uint;
			var wuadd:uint = heroid % 10;
			var wuID:uint = heroid / 10;
			var npcBase:TNpcBattleItem = m_gkContext.m_npcBattleBaseMgr.getTNpcBattleItem(wuID);
			
			if (null == npcBase)
			{
				return;
			}
			
			wuname = WuHeroProperty.s_fullName(wuadd, npcBase.m_name)
			wucolor = WuHeroProperty.s_colorValue(npcBase.m_uColor);
			
			m_nameLabel.text = wuname;		m_nameLabel.setFontColor(wucolor);	m_nameLabel.flush();
			
			var str:String = "<body>";
			if (wuadd < WuHeroProperty.Add_Shen)
			{
				str += "放入 " + UtilHtml.formatFont(wuname, wucolor, 12);
				str += "，能让" + UtilHtml.formatFont(" 【" + skillname + "】 ", 0xFFCC00, 12) + "等级+1";
			}
			else
			{
				str += "当前 " + UtilHtml.formatFont(npcBase.m_name, wucolor) + " 已经激活到最高等级";
			}
			str += "</body>";
			m_txtField.htmlText = str;
			m_txtField.y = m_container.y + 10;
			
			m_container.height = m_txtField.textHeight + 20;
			m_bottomSegment.y = m_container.height - 1;
			
			m_lastText.htmlText = "历史：" + desc;
			
			if (null == wu && !bAct && !m_gkContext.m_jiuguanMgr.hasWu(wuID))
			{
				var wulist:Vector.<uint> = m_gkContext.m_wuMgr.getWuRelationList(wuID);
				UtilHtml.beginCompose();
				UtilHtml.addStringNoFormat("<body>");
				UtilHtml.breakline();
				UtilHtml.add("获得以下任意武将时出现在酒馆中：", UtilColor.WHITE_B, 12);
				UtilHtml.breakline();
				for (var i:int; i < wulist.length; i++)
				{
					UtilHtml.add(m_gkContext.m_npcBattleBaseMgr.getTNpcBattleItem(wulist[i] / 10).m_name + "   ", NpcBattleBaseMgr.colorValue(wulist[i] % 10), 12);
				}
				if (!m_gkContext.m_sysnewfeatures.isSet(SysNewFeatures.NFT_JIUGUAN))
				{
					UtilHtml.add("（酒馆招将 功能还未开启）", UtilColor.WHITE_B, 12);
				}
				UtilHtml.addStringNoFormat("</body>");
				m_lastText.htmlText += UtilHtml.getComposedContent();
			}
			
			m_lastText.y = m_container.y + m_container.height + 10;
			
			this.height = m_lastText.y + m_lastText.textHeight + 20;
		}
	}

}