package game.ui.uiXingMai.tip 
{
	import com.bit101.components.Label;
	import com.bit101.components.PanelContainer;
	import modulecommon.appcontrol.AttrStrip;
	import modulecommon.appcontrol.Name_ValueCtrol;
	import modulecommon.GkContext;
	import modulecommon.res.ResGrid9;
	import modulecommon.scene.prop.BeingProp;
	import modulecommon.scene.xingmai.AttrData;
	import modulecommon.scene.xingmai.XingmaiMgr;
	import com.util.UtilColor;
	/**
	 * ...
	 * @author ...
	 * 属性tips
	 */
	public class TipAttr extends PanelContainer
	{
		public static const WIDTH:uint = 190;
		
		private var m_gkContext:GkContext;
		private var m_nameLabel:Label;
		private var m_typeLabel:Label;
		private var m_attrStrip1:AttrStrip;
		private var m_ctrol1:Name_ValueCtrol;
		private var m_attrStrip2:AttrStrip;
		private var m_ctrol2:Name_ValueCtrol;
		private var m_descLabel:Label;
		
		public function TipAttr(gk:GkContext)
		{
			m_gkContext = gk;
			
			m_nameLabel = new Label(this, 12, 13, "", UtilColor.GOLD, 14);
			m_nameLabel.setBold(true);
			m_typeLabel = new Label(this, 150, 15, "觉醒", UtilColor.GOLD);
			
			m_attrStrip1 = new AttrStrip(this, 4, 40);
			m_attrStrip1.setSize(WIDTH - 8, 30);
			m_ctrol1 = new Name_ValueCtrol(m_attrStrip1);
			m_ctrol1.setPos(15, 6);
			m_ctrol1.m_name.setFontColor(UtilColor.GREEN);
			m_ctrol1.m_value.setFontColor(UtilColor.GREEN);
			
			m_attrStrip2 = new AttrStrip(this, 4, 102);
			m_attrStrip2.setSize(WIDTH - 8, 30);
			m_ctrol2 = new Name_ValueCtrol(m_attrStrip2);
			m_ctrol2.setPos(15, 6);
			m_ctrol2.m_name.setFontColor(UtilColor.WHITE_B);
			m_ctrol2.m_value.setFontColor(UtilColor.WHITE_B);
			
			m_descLabel = new Label(this, 12);
			
			this.setSkinGrid9Image9(ResGrid9.StypeTip);
		}
		
		public function showTip(attr:AttrData):void
		{
			var i:int;
			var color:uint;
			var top:uint = 25;
			
			m_nameLabel.text = getAttrName(attr.m_id) + " " + attr.m_level.toString() + "级";
			
			m_ctrol1.m_name.text = propName(attr.m_id);
			m_ctrol1.m_value.text = "+" + attr.curValue.toString();
			m_ctrol1.m_value.x = m_ctrol1.m_name.text.length * 12 + 10;
			
			top = m_attrStrip1.y + m_attrStrip1.height + 4;
			
			var nextLabel:Label = new Label(this, 12, top + 5, "下一级", UtilColor.GOLD);
			var nextattr:AttrData = m_gkContext.m_xingmaiMgr.getNextLevelAttr(attr.m_id, attr.m_level);
			
			m_ctrol2.m_name.text = propName(nextattr.m_id);
			m_ctrol2.m_value.text = "+" + nextattr.curValue.toString();
			m_ctrol2.m_value.x = m_ctrol2.m_name.text.length * 12 + 10;
			
			top = m_attrStrip2.y + m_attrStrip2.height + 4;
			
			var payvalue:uint = XingmaiMgr.getPayValue(nextattr.m_level);
			m_descLabel.y = top + 4;
			m_descLabel.text = "消耗将魂: " + payvalue.toString();
			
			if (payvalue > m_gkContext.m_beingProp.getMoney(BeingProp.JIANG_HUN))
			{
				color = UtilColor.RED;
			}
			else
			{
				color = UtilColor.GREEN;
			}
			
			m_descLabel.setFontColor(color);
			top = m_descLabel.y + 20;
			
			this.setSize(WIDTH, top + 10);
		}
		
		public static function propName(id:uint):String
		{
			var str:String = "";
			switch (id)
			{
				case XingmaiMgr.XM_FORCE_IQ:
					str = "武力/智力";
					break;
				case XingmaiMgr.XM_CHIEF:
					str = "统率";
					break;
				case XingmaiMgr.XM_SOLDIERLIMIT:
					str = "兵力";
					break;
				case XingmaiMgr.XM_ATTCK:
					str = "攻击力";
					break;
				case XingmaiMgr.XM_DEF:
					str = "防御力";
					break;
				case XingmaiMgr.XM_SPEED:
					str = "速度";
					break;
			}
			return str;
		}
		
		public static function getAttrName(id:uint):String
		{
			var str:String = "";
			switch (id)
			{
				case XingmaiMgr.XM_FORCE_IQ:
					str = "神力";
					break;
				case XingmaiMgr.XM_CHIEF:
					str = "统率";
					break;
				case XingmaiMgr.XM_SOLDIERLIMIT:
					str = "兵力";
					break;
				case XingmaiMgr.XM_ATTCK:
					str = "战斗";
					break;
				case XingmaiMgr.XM_DEF:
					str = "防御";
					break;
				case XingmaiMgr.XM_SPEED:
					str = "速度";
					break;
			}
			return str;
		}
	}

}