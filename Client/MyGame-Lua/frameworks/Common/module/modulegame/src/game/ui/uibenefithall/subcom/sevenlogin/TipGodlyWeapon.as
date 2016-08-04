package game.ui.uibenefithall.subcom.sevenlogin 
{
	import com.bit101.components.Panel;
	import com.bit101.components.PanelContainer;
	import flash.display.DisplayObjectContainer;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import modulecommon.GkContext;
	import modulecommon.scene.beings.MountsAttr;
	import modulecommon.appcontrol.DigitComponentWidthSign;
	import modulecommon.scene.godlyweapon.WeaponItem;
	import com.util.UtilColor;
	import modulecommon.net.msg.sceneUserCmd.t_ItemData;
	import com.bit101.components.Label;
	/**
	 * ...
	 * @author 
	 */
	public class TipGodlyWeapon extends PanelContainer 
	{	
		private var m_gkContext:GkContext;
		private var m_data:WeaponItem;
		private var m_id:uint;

		private var m_weaponWordPanel:Panel;
		private var m_zhanliDC:DigitComponentWidthSign;
		private var m_vecAttrs:Vector.<Label>;
		private var m_descText:TextField;
		
		public function TipGodlyWeapon(gk:GkContext) 
		{			
			m_gkContext = gk;
			
			this.setPanelImageSkin("module/benefithall/qiridenglu/tipsbg.png");	
			
			m_weaponWordPanel = new Panel(this, 45, 7);
			
			m_zhanliDC = new DigitComponentWidthSign(m_gkContext.m_context, this, 123, 65);
			m_zhanliDC.setParam("commoncontrol/digit/digit02", 16, 35, "commoncontrol/digit/digit02/add.png", 0, 23);
			
			m_vecAttrs = new Vector.<Label>();
			
			var tformat:TextFormat = new TextFormat();
			tformat.color = UtilColor.GOLD;
			tformat.leading = 3;
			tformat.letterSpacing = 1;
			tformat.font = "Times New Roman";
			
			m_descText = new TextField();
			this.addChild(m_descText);
			m_descText.multiline = true;
			m_descText.wordWrap = true
			m_descText.x = 13;
			m_descText.y = 303;
			m_descText.width = 246;
			m_descText.height = 150;
			m_descText.mouseEnabled = true;
			m_descText.defaultTextFormat = tformat;			
			
			this.mouseEnabled = false;
			this.mouseChildren = false;
		}
		
		public function setData(id:uint):void
		{
			m_id = id;
			m_data = m_gkContext.m_godlyWeaponMgr.getWeaponDataByID(m_id);
			if (null == m_data)
			{
				return;
			}
		
			m_weaponWordPanel.setPanelImageSkin("godlyweapon/" + m_data.m_image +"_word.png");
			m_weaponWordPanel.x = (262 - m_weaponWordPanel.width)/2
			
			m_zhanliDC.digit = m_data.m_zhanli;
			
			var attr:Label;
			var i:int;
			var attrData:t_ItemData;
			for (i = 0; i < m_data.m_effect.length; i++)
			{
				attrData = m_data.m_effect[i];
				attr = new Label(this, 80, 175 + i * 20, MountsAttr.m_tblAttrId2Name[attrData.type] + " +" + attrData.value.toString(), UtilColor.GOLD, 12);
				attr.mouseEnabled = true;
				m_vecAttrs.push(attr);
			}
			
			m_descText.htmlText = m_data.m_desc;
		}
		
		public function get ID():uint
		{
			return m_id;
		}
	}

}