package game.ui.uimysteryshop
{
	import com.bit101.components.Component;
	import flash.display.DisplayObjectContainer;
	import modulecommon.GkContext;
	import modulecommon.net.msg.giftCmd.stBuySecretStoreObjCmd;
	import modulecommon.scene.prop.object.ObjectPanel;
	import com.bit101.components.Label;
	import com.bit101.components.Panel;
	import modulecommon.appcontrol.MonkeyAndValue;
	import modulecommon.scene.prop.object.ZObjectDef;
	import com.bit101.components.PushButton;
	import game.ui.uimysteryshop.CommodityBase;
	import modulecommon.scene.prop.object.ZObject;
	import flash.events.MouseEvent;
	import modulecommon.scene.prop.BeingProp;
	import modulecommon.scene.prop.object.ZObjectDef
	import com.util.UtilColor;
	import modulecommon.uiinterface.IUIMysteryShop;
	/**
	 * ...
	 * @author 
	 */
	public class CommodityPanel extends Component 
	{
		protected var m_dataShop:DataShop;
		public var m_commodityData:CommodityBase;
		protected var m_gkContext:GkContext;
		protected var m_nameLabel:Label;
		protected var m_normalPrice:ValueWithLine;	
		protected var m_normalReprice:ValueWithLine;
		protected var m_buyBtn:PushButton;
		
		public var m_idx:uint = 0;
		
		public function CommodityPanel(data:DataShop, parent:DisplayObjectContainer=null,gk:GkContext=null,xpos:Number=0, ypos:Number=0) 
		{
			super(parent, xpos, ypos);
			m_gkContext = gk;
			m_dataShop = data;
			
			m_nameLabel = new Label(this, 74, 20);			
			m_buyBtn = new PushButton(this, 147, 72, onBuyClick);
			m_buyBtn.setSkinButton1Image("commoncontrol/button/buyBtn_yellow.png");
			m_normalReprice = new ValueWithLine(m_gkContext, this, BeingProp.YUAN_BAO, m_nameLabel.x + 32, 38, true, "原价:");
			m_normalReprice.m_value.setPos(25, 0);			
			m_normalPrice = new ValueWithLine(m_gkContext, this, BeingProp.YUAN_BAO, m_nameLabel.x + 32, 56, false, "现价:");
			m_normalPrice.m_value.setPos(25, 0);
		}	
		
		public function setData(data:Object):void 
		{
			m_commodityData = data as CommodityBase;
			m_nameLabel.text = m_commodityData.m_name;
			m_nameLabel.setFontColor(ZObjectDef.colorValue(m_commodityData.m_namecolor));
			if (m_normalPrice)
			{
				m_normalPrice.value = m_commodityData.m_discountprice;				
			}
			if (m_normalReprice)
			{
				m_normalReprice.value = m_commodityData.m_price;
				m_normalReprice.color = UtilColor.BLUE;
			}
		}
		
		protected function onBuyClick(e:MouseEvent):void
		{	
			if (m_commodityData.m_discountprice > m_gkContext.m_beingProp.getMoney(BeingProp.YUAN_BAO))
			{
				m_gkContext.m_systemPrompt.promptOnTopOfMousePos("元宝不足",UtilColor.RED,-20);
				return;
			}
			//if (m_commodityData.m_viplevel > m_gkContext.m_beingProp.vipLevel)
			//{
			//	m_gkContext.m_systemPrompt.promptOnTopOfMousePos("vip等级达到"+m_commodityData.m_viplevel+"级开放",UtilColor.RED,-20);
			//	return;
			//}
			
			var send:stBuySecretStoreObjCmd = new stBuySecretStoreObjCmd();
			send.objno = m_commodityData.m_id + m_commodityData.m_lvlLabel.m_id * 1000;
			m_gkContext.sendMsg(send);
		}	
		
		public function upDataBtnandPanel():void
		{
			//if (m_gkContext.m_yizhelibaoMgr.isCommodityBuyed(m_commodityData.curTabLabel.m_id, m_commodityData.m_id))
			//{
			//	m_buyBtn.enabled = false;				
			//}
			
			if (m_gkContext.m_rankSys.objlist[m_idx] % 10)
			{
				m_buyBtn.enabled = false;
			}
		}
		
		public function initRes():void
		{
			
		}
	}
}