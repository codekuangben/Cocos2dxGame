package game.ui.uibackpack.tips 
{
	import com.bit101.components.Label;
	import com.bit101.components.Panel;
	import com.bit101.components.PanelContainer;
	import com.bit101.components.TextNoScroll;
	import flash.utils.Dictionary;
	import modulecommon.appcontrol.AttrStrip;
	import modulecommon.appcontrol.Name_ValueCtrol;
	import modulecommon.GkContext;
	import modulecommon.res.ResGrid9;
	import modulecommon.scene.wu.TrainAttr;
	import com.util.UtilColor;
	import com.util.UtilHtml;
	/**
	 * ...
	 * @author ...
	 * 武将培养经验进度条Tips
	 */
	public class TrainTip extends PanelContainer
	{
		private var m_gkContext:GkContext;
		private var m_nameLabel:Label;
		private var m_expLabel:Label;
		private var m_nextAddLabel:Label;
		private var m_addAttrs:TextNoScroll;
		
		public function TrainTip(gk:GkContext) 
		{
			m_gkContext = gk;
			this.setSkinGrid9Image9(ResGrid9.StypeTip);
			
			m_nameLabel = new Label(this, 15, 14, "", UtilColor.GOLD, 16);
			m_nameLabel.setBold(true);
			
			var label:Label;
			label = new Label(this, 15, 42, "升级经验：", UtilColor.WHITE_Yellow);
			m_expLabel = new Label(this, 80, 42, "", UtilColor.GREEN);
			label = new Label(this, 15, 62, "下级加成：", UtilColor.WHITE_Yellow);
			m_nextAddLabel = new Label(this, 80, 62, "", UtilColor.GREEN);
			
			var panel:Panel;
			panel = new Panel(this, 1, 87);
			panel.setSize(258, 1);
			panel.setPanelImageSkin("commoncontrol/panel/tipsegment.png");
			
			label = new Label(this, 15, 95, "已提升属性：", UtilColor.WHITE_Yellow);
			
			m_addAttrs = new TextNoScroll();
			m_addAttrs.x = 29;
			m_addAttrs.y = 115;
			m_addAttrs.width = 200;
			m_addAttrs.setCSS("body", {leading: 3,letterSpacing:1});
			this.addChild(m_addAttrs);
		}
		
		public function showTip(level:uint, exp:uint):void
		{
			var str:String;
			var curAttr:TrainAttr = m_gkContext.m_wuMgr.getTrainAttrByLevel(level);
			var nextAttr:TrainAttr = m_gkContext.m_wuMgr.getTrainAttrByLevel(level + 1);
			m_nameLabel.text = "培养等级  " + level;
			m_expLabel.text = exp + "/" + curAttr.m_maxpower;
			m_nextAddLabel.text = TrainAttr.getStrAddAttr(nextAttr.m_proptype) + " +" + nextAttr.m_propvalue;
			
			var dic:Dictionary = m_gkContext.m_wuMgr.getAllHavedAttrs(level);
			m_addAttrs.htmlText = getAttrStr(dic);
			
			var height:uint = m_addAttrs.y + m_addAttrs.textHeight + 10;
			this.setSize(260, height);
		}
		
		private function getAttrStr(dic:Dictionary):String
		{
			var str:String;
			UtilHtml.beginCompose();
			UtilHtml.addStringNoFormat("<body>");
			if (dic[TrainAttr.HT_ADDATK] != undefined)
			{
				str = TrainAttr.getStrAddAttr(TrainAttr.HT_ADDATK);
				UtilHtml.add(str, UtilColor.WHITE_Yellow);
				
				str = " +" + dic[TrainAttr.HT_ADDATK];
				UtilHtml.add(str, UtilColor.GREEN);
				UtilHtml.breakline();
			}
			
			if (dic[TrainAttr.HT_ADDDOUBLEDEF] != undefined)
			{
				str = TrainAttr.getStrAddAttr(TrainAttr.HT_ADDDOUBLEDEF);
				UtilHtml.add(str, UtilColor.WHITE_Yellow);
				
				str = " +" + dic[TrainAttr.HT_ADDDOUBLEDEF];
				UtilHtml.add(str, UtilColor.GREEN);
				UtilHtml.breakline();
			}
			
			if (dic[TrainAttr.HT_ADDBAOJI] != undefined)
			{
				str = TrainAttr.getStrAddAttr(TrainAttr.HT_ADDBAOJI);
				UtilHtml.add(str, UtilColor.WHITE_Yellow);
				
				str = " +" + dic[TrainAttr.HT_ADDBAOJI];
				UtilHtml.add(str, UtilColor.GREEN);
				UtilHtml.breakline();
			}
			
			if (dic[TrainAttr.HT_ADDBJDEF] != undefined)
			{
				str = TrainAttr.getStrAddAttr(TrainAttr.HT_ADDBJDEF);
				UtilHtml.add(str, UtilColor.WHITE_Yellow);
				
				str = " +" + dic[TrainAttr.HT_ADDBJDEF];
				UtilHtml.add(str, UtilColor.GREEN);
				UtilHtml.breakline();
			}
			
			if (dic[TrainAttr.HT_ADDSPEED] != undefined)
			{
				str = TrainAttr.getStrAddAttr(TrainAttr.HT_ADDSPEED);
				UtilHtml.add(str, UtilColor.WHITE_Yellow);
				
				str = " +" + dic[TrainAttr.HT_ADDSPEED];
				UtilHtml.add(str, UtilColor.GREEN);
				UtilHtml.breakline();
			}
			
			UtilHtml.addStringNoFormat("</body>");
			return UtilHtml.getComposedContent();
		}
	}

}