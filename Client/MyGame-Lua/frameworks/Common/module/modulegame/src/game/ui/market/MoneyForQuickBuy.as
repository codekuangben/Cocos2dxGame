package game.ui.market 
{
	import com.bit101.components.ButtonRadio;
	import com.bit101.components.controlList.CtrolVHeightComponent;
	import com.bit101.components.label.Label2;
	import com.bit101.components.label.LabelFormat;
	import modulecommon.scene.prop.object.ZObjectDef;

	import modulecommon.appcontrol.MonkeyAndValue;
	import modulecommon.GkContext;
	import modulecommon.scene.market.stMarket;
	import modulecommon.scene.market.stMarketBaseObj;
	import modulecommon.scene.prop.BeingProp;
	/**
	 * ...
	 * @author 
	 */
	public class MoneyForQuickBuy extends CtrolVHeightComponent 
	{
		private var m_radioBtn:ButtonRadio;
		protected var m_money:MonkeyAndValue;
		protected var m_marketObj:stMarketBaseObj;
		protected var m_form:UIMarketBuy_Quick;
		protected var m_gkContext:GkContext;
		public function MoneyForQuickBuy(param:Object) 
		{
			super();
			m_form = param.form;
			m_gkContext = param.gk;
			
			m_radioBtn = new ButtonRadio(this, 0, 0);
			m_radioBtn.setPanelImageSkin("commoncontrol/button/bb_buttonradio.swf");
			
			var label:Label2;
			label = new Label2(this, 30, 0);
			var lf:LabelFormat = new LabelFormat();
			lf.text = "购买总价";
			label.labelFormat = lf;
			
			m_money = new MonkeyAndValue(m_gkContext, this, BeingProp.YUAN_BAO, 90, 0);
			m_money.m_moneyPanel.showTip = true;
			m_money.m_moneyPanel.recycleSkins = true; 
		}
		
		override public function setData(_data:Object):void 
		{
			m_marketObj = _data as stMarketBaseObj;
			if (m_marketObj.m_market.m_moneyType == stMarket.MONEYTYPE_yuanbao)
			{
				m_money.m_moneyPanel.type = BeingProp.YUAN_BAO;				
			}
			else if (m_marketObj.m_market.m_moneyType == stMarket.MONEYTYPE_rongyu)
			{
				m_money.m_moneyPanel.type = BeingProp.RONGYU_PAI;				
			}
			m_money.m_value.setPos(29, 3);
			this.drawRectBG();			
		}
		override public function update():void 
		{
			if (m_marketObj.m_market.m_moneyType == stMarket.MONEYTYPE_yuanbao)
			{
				m_money.value = m_form.numOfBuy * m_marketObj.discoutprice;
			}
			else if (m_marketObj.m_market.m_moneyType == stMarket.MONEYTYPE_rongyu)
			{
				m_money.m_value.text = m_form.numOfBuy * m_marketObj.discoutprice + " / "+ m_gkContext.m_objMgr.computeObjNumInCommonPackage(ZObjectDef.OBJID_rongyu);
			}
			
		}
		override public function onSelected():void 
		{
			super.onSelected();
			m_radioBtn.selected = true;
			
			var max:int = m_marketObj.computeMaxNumWidthBuyLimit(m_gkContext);
			m_form.initMaxNum(max);
		}
		override public function onNotSelected():void 
		{
			super.onNotSelected();
			m_radioBtn.selected = false;
		}
		
		public function get marketBaseObj():stMarketBaseObj
		{
			return m_marketObj;
		}
	}

}