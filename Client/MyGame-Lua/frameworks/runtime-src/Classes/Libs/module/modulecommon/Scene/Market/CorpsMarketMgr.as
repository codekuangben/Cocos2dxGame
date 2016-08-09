package modulecommon.scene.market 
{
	/**
	 * ...
	 * @author 
	 */
	
	 import modulecommon.GkContext;
	 import flash.utils.ByteArray;
	 import modulecommon.net.msg.shoppingCmd.stReqCorpsMallObjListCmd;
	 import modulecommon.net.msg.shoppingCmd.stRetCorpsMallObjListCmd;
	 import modulecommon.ui.Form;
	 import modulecommon.ui.UIFormID;
	 import modulecommon.uiinterface.IUICorpsMarket;
	public class CorpsMarketMgr 
	{
		private var m_gkContext:GkContext;
		public var m_uiCorpsMarketForm:IUICorpsMarket;
		private var m_MarketData:MarketsData;
		public function CorpsMarketMgr(gk:GkContext) 
		{
			m_gkContext = gk;
			m_MarketData = m_gkContext.m_marketMgr.marketData;
		}
		
		//打开军团商城界面
		public function openUICorpsMarket():void
		{
			if (m_gkContext.m_marketMgr.isBuyLimitRequested == false)
			{
				m_gkContext.m_marketMgr.requestReqObjBuyLimitNumCmd();
			}
			if (m_MarketData.hasMarket(stMarket.TYPE_corps) == false)
			{
				var send:stReqCorpsMallObjListCmd = new stReqCorpsMallObjListCmd();
				m_gkContext.sendMsg(send);
				return;
			}
			openUICorpsMarketEx();
		}
		private function openUICorpsMarketEx():void
		{			
			if (m_uiCorpsMarketForm == null)
			{
				if (m_gkContext.m_UIMgr.getForm(UIFormID.UICorpsMarket))
				{
					return;
				}
				
				m_gkContext.m_UIMgr.createFormInGame(UIFormID.UICorpsMarket);
				return;
			}
			
			if (m_uiCorpsMarketForm)
			{
				m_uiCorpsMarketForm.show();				
			}
		}
		
		//军团商城数据
		public function process_stRetCorpsMallObjListCmd(msg:ByteArray, param:int):void
		{
			var rev:stRetCorpsMallObjListCmd = new stRetCorpsMallObjListCmd();
			rev.deserialize(msg);
			
			var marekt:stMarket = new stMarket(stMarket.TYPE_corps, stMarket.MONEYTYPE_corpsGongxian);
			marekt.setList(rev.m_list);
			m_MarketData.add(stMarket.TYPE_corps, marekt);		
			
			openUICorpsMarketEx();
		}
		public function updateNumOfbuy():void
		{
			if (m_uiCorpsMarketForm && m_uiCorpsMarketForm.isVisible())
			{
				m_uiCorpsMarketForm.updateNumOfbuy();
			}
		}
		
		public function setDataDirty():void
		{
			if (m_uiCorpsMarketForm)
			{
				(m_uiCorpsMarketForm as Form).destroy();
			}
		}
		
		public function process7ClockUserCmd():void
		{
			
		}
		
	}

}