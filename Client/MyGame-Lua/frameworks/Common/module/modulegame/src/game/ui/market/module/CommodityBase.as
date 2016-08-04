package game.ui.market.module 
{	
	
	import com.bit101.components.controlList.CtrolComponent;
	import com.bit101.components.controlList.CtrolComponentBase;
	import com.bit101.components.Label;
	import com.bit101.components.Panel;
	import com.bit101.components.PushButton;
	import flash.events.MouseEvent;
	import game.ui.market.module.CommodityBase;
	import game.ui.market.MoneyAndValue_Line;
	import modulecommon.appcontrol.MonkeyAndValue;
	import modulecommon.net.msg.shoppingCmd.stReqViewMarketGiftBoxCmd;
	import modulecommon.scene.market.stMarket;
	import modulecommon.scene.market.stMarketBaseObj;
	import modulecommon.scene.prop.BeingProp;
	import modulecommon.scene.prop.object.ObjectPanel;
	import modulecommon.GkContext;
	import modulecommon.scene.prop.object.ZObject;
	import modulecommon.scene.prop.object.ZObjectDef;
	import com.util.UtilColor;
	import modulecommon.ui.Form;
	import modulecommon.ui.UIFormID;
	/**
	 * ...
	 * @author ...
	 */
	public class CommodityBase extends CtrolComponent 
	{
		protected var m_marektData:stMarket;
		protected var m_commodityData:stMarketBaseObj;
		protected var m_gkContext:GkContext;
		protected var m_objPanel:ObjectPanel;
		protected var m_nameLabel:Label;
		protected var m_normalPrice:MonkeyAndValue;		
		protected var m_buyBtn:PushButton;
		protected var m_watchBtn:PushButton;
		
		public function CommodityBase(param:Object=null) 
		{
			super(param);		
			m_gkContext = param["gk"] as GkContext;
			m_marektData = param["market"] as stMarket;			
		}		
	
		protected function createCtrls():void
		{			
			m_objPanel = new ObjectPanel(m_gkContext, this, 14, 12);
			m_objPanel.setPanelImageSkin(ZObject.IconBg);
			m_objPanel.showObjectTip = true;
			m_objPanel.objectIcon.showNum = false;
			m_nameLabel = new Label(this, 67, 14);
			
			m_buyBtn = new PushButton(this, 15, 64, onBuyClick);
		}
		override public function init():void 
		{			
			m_commodityData = data as stMarketBaseObj;			
			createCtrls();
			
			var objZ:ZObject = ZObject.createClientObject(m_commodityData.id);
			m_objPanel.objectIcon.setZObject(objZ);
			m_nameLabel.text = objZ.name;
			m_nameLabel.setFontColor(objZ.colorValue);
			if (m_normalPrice)
			{
				m_normalPrice.value = m_commodityData.discoutprice;			
			}
			if (objZ.type == ZObjectDef.ItemType_SuiJiLiBao)
			{
				if (m_watchBtn == null)
				{
					m_watchBtn = new PushButton(this, 170, 11, onWatchClick);
					m_watchBtn.setSkinButton1Image("commoncontrol/menuicon/watch.png");
				}
				m_watchBtn.visible = true;
			}
			else
			{
				if (m_watchBtn)
				{
					m_watchBtn.visible = false;
				}
			}
		}
		
		public function onUIMarketShow():void
		{
		
		}
		public function onUIMarketHide():void
		{
			
		}
		
		public static function s_aniShowOrHid(ctrl:CtrolComponentBase, param:Object):void
		{
			var bShow:Boolean = param as Boolean;
			var com:CommodityBase = ctrl as CommodityBase;
			
				if (bShow)
				{
					com.onUIMarketShow();
				}
				else
				{
					com.onUIMarketHide();
				}
				
		}		
	
		protected function onBuyClick(e:MouseEvent):void
		{
			m_gkContext.m_marketMgr.buy(m_commodityData);
		}
		protected function onWatchClick(e:MouseEvent):void
		{
			var id:uint = m_objPanel.objectIcon.zObject.ObjID;
			var list:Array = m_gkContext.m_marketMgr.getGiftPackContent(id);
			if (list == null)
			{
				var send:stReqViewMarketGiftBoxCmd = new stReqViewMarketGiftBoxCmd();
				send.boxid = id;
				m_gkContext.sendMsg(send);
				return;
			}
			var formGift:Form = m_gkContext.m_UIMgr.createFormInGame(UIFormID.UIGiftWatch);
			formGift.updateData(id);
			formGift.show();
		}
		
	}

}