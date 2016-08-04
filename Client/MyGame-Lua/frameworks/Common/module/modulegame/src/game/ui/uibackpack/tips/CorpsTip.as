package game.ui.uibackpack.tips 
{
	import com.bit101.components.PanelContainer;
	import com.bit101.components.TextNoScroll;
	import modulecommon.GkContext;
	import modulecommon.res.ResGrid9;
	import modulecommon.scene.prop.relation.KejiItemInfo;
	import modulecommon.scene.prop.relation.KejiLearnedItem;
	import com.util.UtilColor;
	import com.util.UtilHtml;
	/**
	 * ...
	 * @author ...
	 * 其他玩家已学习军团科技信息
	 */
	public class CorpsTip extends PanelContainer
	{
		private var m_gkContext:GkContext;
		private var m_txtField:TextNoScroll;
		private var m_defaultCSS:Object;
		
		public function CorpsTip(gk:GkContext) 
		{
			m_gkContext = gk;
			this.setSize(170, 40);
			this.setSkinGrid9Image9(ResGrid9.StypeTip);
			
			m_txtField = new TextNoScroll();
			this.addChild(m_txtField);
			
			m_txtField.x = 15;
			m_txtField.y = 15;
			m_txtField.width = 230;
			m_defaultCSS = { leading:4, color:"#eeeeee", letterSpacing:2 };
			m_txtField.setCSS("body", m_defaultCSS );
		}
		
		//bSelf 是否自己的军团信息
		public function showTip(data:Array, bSelf:Boolean = false):void
		{
			var str:String;
			
			UtilHtml.beginCompose();
			str = UtilHtml.formatBold("军团科技");
			UtilHtml.add(str, UtilColor.BLUE, 14);
			if (bSelf)
			{
				UtilHtml.add("  （我的）", UtilColor.WHITE_B);
			}
			UtilHtml.breakline();
			
			UtilHtml.add("加成效果：", UtilColor.WHITE_Yellow, 12);
			
			var item:KejiLearnedItem;
			var kejiInfo:KejiItemInfo;
			for each (item in data)
			{
				kejiInfo = m_gkContext.m_corpsMgr.getKejiInfoByType(item.m_type);
				if (kejiInfo)
				{
					UtilHtml.breakline();
					UtilHtml.add(kejiInfo.m_name, 0xD78E03, 12);
					UtilHtml.add("  +" + item.m_value, 0x23C911, 12);						
				}
			}
			
			var outStr:String = UtilHtml.removeWhitespace(UtilHtml.getComposedContent());
			outStr = "<body>" + outStr + "</body>";
			m_txtField.htmlText = outStr;
			
			this.height = m_txtField.y * 2 + m_txtField.height;			
		}
	}

}