package game.ui.market 
{
	import modulecommon.GkContext;
	import modulecommon.net.msg.shoppingCmd.stBuyMarketObjCmd;
	import modulecommon.scene.market.stMarket;
	import modulecommon.scene.market.stMarketBaseObj;
	import modulecommon.scene.prop.BeingProp;
	import modulecommon.scene.prop.object.ZObjectDef;
	/**
	 * ...
	 * @author 
	 */
	public class BuyMarketTool 
	{
		
		public static function buy_Gold(gk:GkContext, marketObj:stMarketBaseObj, n:int):void
		{
						
			if (n <= 0)
			{
				gk.m_systemPrompt.prompt("请输入数量");
				return;
			}
			var money:int = n * marketObj.discoutprice;
			if (money > gk.m_beingProp.getMoney(BeingProp.YUAN_BAO))
			{
				gk.m_systemPrompt.prompt("元宝不足");
				return;
			}
			
			var send:stBuyMarketObjCmd = new stBuyMarketObjCmd();
			send.objid = marketObj.id;
			send.num = n;
			send.markettype = stBuyMarketObjCmd.MARKETTYPE_GOLD;			
			
			switch(marketObj.m_market.m_type)
			{
				case stMarket.TYPE_baoshi:send.objtype = 2; break;
				case stMarket.TYPE_daoju:send.objtype = 0; break;
				case stMarket.TYPE_remai:send.objtype = 1; break;
				case stMarket.TYPE_timelimit:send.objtype = 3; break;
			}
			
			gk.sendMsg(send);			
		}
		public static function buy_RongYu(gk:GkContext, marketObj:stMarketBaseObj, n:int):void
		{						
			if (n <= 0)
			{
				gk.m_systemPrompt.prompt("请输入数量");
				return;
			}
			var money:int = n * marketObj.discoutprice;
			var nRongyu:int = gk.m_objMgr.computeObjNumInCommonPackage(ZObjectDef.OBJID_rongyu);
			if (money > nRongyu)
			{
				gk.m_systemPrompt.prompt("荣誉勋章不足");
				return;
			}
			var send:stBuyMarketObjCmd = new stBuyMarketObjCmd();
			send.objid = marketObj.id;
			send.num = n;
			send.markettype = stBuyMarketObjCmd.MARKETTYPE_HONOR;
			
			gk.sendMsg(send);	
		}
		
		public static function buy(gk:GkContext, marketObj:stMarketBaseObj, n:int):void
		{
			if (marketObj.m_market.m_moneyType == stMarket.MONEYTYPE_yuanbao)
			{
				buy_Gold(gk,marketObj,n);
			}
			else if (marketObj.m_market.m_moneyType == stMarket.MONEYTYPE_rongyu)
			{
				buy_RongYu(gk,marketObj,n);
			}
		}
	}

}