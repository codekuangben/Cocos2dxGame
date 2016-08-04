package game.ui.market 
{
	/**
	 * ...
	 * @author 
	 */
	
	import com.bit101.components.Label;
	
	
	import modulecommon.appcontrol.MonkeyAndValue;	
	import modulecommon.scene.market.stMarket;
	import modulecommon.scene.market.stMarketBaseObj;
	import modulecommon.scene.prop.BeingProp;

	
	public class UIMarketBuy_Base  extends UIMarketBuy_Base_Base
	{
		protected var m_marketObj:stMarketBaseObj;	
		protected var m_money:MonkeyAndValue;		
		public function UIMarketBuy_Base()
		{
			super();
			exitMode = EXITMODE_HIDE;
		}
		override public function onReady():void 
		{
			this.setSize(291,251);
			this.setPanelImageSkin("commoncontrol/formbg/marketbuybg.png");
			super.onReady();
			var label:Label;
			label = new Label(this, 52, 128, "购买总价");		
			
			m_money = new MonkeyAndValue(m_gkcontext, this, BeingProp.YUAN_BAO, 117, 128);
			m_money.m_moneyPanel.showTip = true;
			m_money.m_moneyPanel.recycleSkins = true;			
		}	
		
		
	
		override protected function numOnChange(n:int):void
		{			
			m_money.value = n * m_marketObj.discoutprice;
		}		
	}

}