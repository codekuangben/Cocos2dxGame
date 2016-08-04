package game.ui.market 
{
	/**
	 * ...
	 * @author 
	 */
	import com.bit101.components.ButtonRadio;
	import com.bit101.components.controlList.ControlAlignmentParamBase;
	import com.bit101.components.controlList.ControlListVHeight;
	import com.bit101.components.controlList.ControlVHeightAlignmentParam;
	import com.util.UtilCommon;
	import flash.events.MouseEvent;
	import modulecommon.appcontrol.MonkeyAndValue;
	import modulecommon.scene.market.MarketObjIDWidthNum;
	import modulecommon.scene.market.stMarket;
	import modulecommon.scene.market.stMarketBaseObj;
	import com.util.UtilColor;
	
	public class UIMarketBuy_Quick extends UIMarketBuy_Base_Base 
	{
		private var m_numOfBuy:int;
		private var m_buyInfo:MarketObjIDWidthNum;
		private var m_list:ControlListVHeight;
		public function UIMarketBuy_Quick() 
		{
			super();
			
		}
		override public function onReady():void 
		{
			this.setSize(291,281);
			this.setPanelImageSkin("commoncontrol/formbg/marketbuybg2.png");
			super.onReady();
			m_numLabel.y = 188;
			m_numberCtrl.y = 188;
			m_buyBtn.y = 225;
			m_list = new ControlListVHeight(this, 20, 125);
			
			var param:ControlVHeightAlignmentParam = new ControlVHeightAlignmentParam();
			param.m_width = 200;
			param.m_height = 22;
			param.m_intervalV = 5;
			param.m_class = MoneyForQuickBuy;
			param.m_scrollType = ControlAlignmentParamBase.ScrollType_AutoHeight;
			var dataParam:Object = new Object();
			dataParam.form = this;
			dataParam.gk = this.m_gkcontext;
			param.m_dataParam = dataParam;
			m_list.setParam(param);
		}
		
		override public function updateData(data:Object=null):void
		{
			m_buyInfo = data as MarketObjIDWidthNum;
			setPanelAndName(m_buyInfo.m_objID);
			var marketFlag:uint = m_gkcontext.m_marketMgr.getQuickBuyMarketFlag(m_buyInfo.m_objID);
			
			var dataList:Array = new Array();
			var i:int;
			var marketBase:stMarketBaseObj;
			for (i = 0; i <= stMarket.MONEYTYPE_corpsGongxian; i++)
			{
				if (UtilCommon.isSetUint(marketFlag, i))
				{
					marketBase = m_gkcontext.m_marketMgr.getMarketByMoneyTypeAndID(i, m_buyInfo.m_objID);
					if (marketBase)
					{
						dataList.push(marketBase);
					}
					else
					{
						m_gkcontext.m_systemPrompt.promptOnTopOfMousePos("商场" + i + "不卖道具" + m_buyInfo.m_objID, UtilColor.RED);
					}
				}
			}
			
			m_list.setDatas(dataList);
			m_list.setSeleced(0);
		}
		override protected function numOnChange(n:int):void
		{
			m_numOfBuy = n;
			m_list.update();			
		}
		
		public function initMaxNum(maxNum:int):void
		{
			m_numberCtrl.setParam(1, maxNum, m_buyInfo.m_num);
		}
		
		public function get numOfBuy():int
		{
			return m_numOfBuy;
		}
		
		override protected function onBuyBtnClick(e:MouseEvent):void
		{
			var n:int = m_numberCtrl.number;		
		
			var moneyCtrl:MoneyForQuickBuy = m_list.getControlSelected() as MoneyForQuickBuy;
			if (moneyCtrl==null)
			{
				return;
			}
			
			var marketObj:stMarketBaseObj = moneyCtrl.marketBaseObj;
			BuyMarketTool.buy(m_gkcontext, marketObj, n);
			this.exit();
		}
	}

}