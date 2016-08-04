package game.ui.market 
{
	/**
	 * ...
	 * @author 
	 */
	import flash.events.MouseEvent;
	import modulecommon.net.msg.shoppingCmd.stBuyMarketObjCmd;
	import modulecommon.scene.market.MarkerBaseObjWithNum;
	import modulecommon.scene.market.stMarket;
	import modulecommon.scene.market.stMarketBaseObj;
	import modulecommon.scene.prop.BeingProp;
	public class UIMarketBuy_Gold extends UIMarketBuy_Base 
	{
		
		public function UIMarketBuy_Gold() 
		{
			super();
			
		}
		override public function onReady():void 
		{
			super.onReady();
			
			m_money.m_value.x = 22;			
			m_money.m_moneyPanel.type = BeingProp.YUAN_BAO;
			m_money.m_value.setPos(22, 0);
			m_money.y = 128;
			m_money.m_moneyPanel.visible = true;
		}
		
		override public function updateData(data:Object=null):void
		{
			var obj:MarkerBaseObjWithNum = data as MarkerBaseObjWithNum;
			var defNum:uint = obj.m_num;
			m_marketObj = obj.m_data;
			setPanelAndName(m_marketObj.id);
			
			var maxBuy:int = m_marketObj.computeMaxNumWidthBuyLimit(m_gkcontext);	
			
			m_numberCtrl.setParam(1, maxBuy, defNum);			
			
		}
		override protected function onBuyBtnClick(e:MouseEvent):void 
		{
			var n:int = m_numberCtrl.number;			
			
			if (n <= 0)
			{
				m_gkcontext.m_systemPrompt.prompt("请输入数量");
				return;
			}
			var money:int = n * m_marketObj.discoutprice;
			if (money > m_gkcontext.m_beingProp.getMoney(BeingProp.YUAN_BAO))
			{
				m_gkcontext.m_systemPrompt.prompt("元宝不足");
				return;
			}
			
			var send:stBuyMarketObjCmd = new stBuyMarketObjCmd();
			send.objid = m_marketObj.id;
			send.num = n;
			send.markettype = stBuyMarketObjCmd.MARKETTYPE_GOLD;			
			
			switch(m_marketObj.m_market.m_type)
			{
				case stMarket.TYPE_baoshi:send.objtype = 2; break;
				case stMarket.TYPE_daoju:send.objtype = 0; break;
				case stMarket.TYPE_remai:send.objtype = 1; break;
				case stMarket.TYPE_timelimit:send.objtype = 3; break;
			}
			
			m_gkcontext.sendMsg(send);
			this.exit();
		}
	}

}