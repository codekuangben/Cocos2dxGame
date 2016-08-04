package game.ui.uibackpack.tips 
{
	import com.bit101.components.PanelContainer;
	import com.bit101.components.TextNoScroll;
	import com.util.UtilColor;
	import com.util.UtilHtml;
	import modulecommon.GkContext;
	import modulecommon.net.msg.sceneUserCmd.t_ItemData;
	import modulecommon.res.ResGrid9;
	import modulecommon.scene.beings.MountsAttr;
	import modulecommon.scene.godlyweapon.GWSkill;
	import modulecommon.scene.godlyweapon.SkillItem;
	import modulecommon.scene.godlyweapon.WeaponItem;
	/**
	 * ...
	 * @author ...
	 * 其他玩家神兵信息tips
	 */
	public class GodlyweaponTip extends PanelContainer
	{
		private var m_gkContext:GkContext;
		private var m_txtField:TextNoScroll;
		private var m_defaultCSS:Object;
		
		public function GodlyweaponTip(gk:GkContext) 
		{
			m_gkContext = gk;
			this.setSize(170, 40);
			this.setSkinGrid9Image9(ResGrid9.StypeTip);
			
			m_txtField = new TextNoScroll();
			this.addChild(m_txtField);
			
			m_txtField.x = 15;
			m_txtField.y = 15;
			m_txtField.width = 170;
			m_defaultCSS = { leading:4, color:"#eeeeee", letterSpacing:2 };
			m_txtField.setCSS("body", m_defaultCSS );
		}
		
		//bSelf 是否自己的神兵信息
		public function showTip(weargwid:uint, gwslevel:uint, bSelf:Boolean = false):void
		{
			var str:String;
			var weaponitem:WeaponItem;
			var skillitem:SkillItem;
			
			weaponitem = m_gkContext.m_godlyWeaponMgr.getWeaponDataByID(weargwid);
			
			UtilHtml.beginCompose();
			UtilHtml.add(UtilHtml.formatBold(weaponitem.m_name), UtilColor.BLUE, 14);
			if (bSelf)
			{
				UtilHtml.add("  （我的）", UtilColor.WHITE_B);
			}
			
			UtilHtml.breakline();
			UtilHtml.add("战力", 0xD78E03, 12);
			UtilHtml.add("  +" + weaponitem.m_zhanli.toString(), 0x23C911, 12);
			
			UtilHtml.breakline();
			UtilHtml.add("属性加成：", UtilColor.WHITE_Yellow, 12);
			
			var i:int;
			var attrData:t_ItemData;
			for (i = 0; i < weaponitem.m_effect.length; i++)
			{
				attrData = weaponitem.m_effect[i];
				UtilHtml.breakline();
				UtilHtml.add(MountsAttr.m_tblAttrId2Name[attrData.type], 0xD78E03, 12);
				UtilHtml.add("  +" + attrData.value.toString(), 0x23C911, 12);
			}
			
			UtilHtml.breakline();
			UtilHtml.add("号令天下（" + gwslevel.toString() + "级）", UtilColor.WHITE_Yellow, 12);
			skillitem = m_gkContext.m_godlyWeaponMgr.getGWSkillItem(gwslevel);
			if (skillitem)
			{
				for (i = 0; i < skillitem.m_effect.length; i++)
				{
					attrData = skillitem.m_effect[i];
					UtilHtml.breakline();
					UtilHtml.add(GWSkill.getAttrStr(attrData.type), 0xD78E03, 12);
					UtilHtml.add("  +" + attrData.value.toString(), 0x23C911, 12);
				}
			}
			
			var outStr:String = UtilHtml.removeWhitespace(UtilHtml.getComposedContent());
			outStr = "<body>" + outStr + "</body>";
			m_txtField.htmlText = outStr;
			
			this.height = m_txtField.y * 2 + m_txtField.height;			
		}
	}

}