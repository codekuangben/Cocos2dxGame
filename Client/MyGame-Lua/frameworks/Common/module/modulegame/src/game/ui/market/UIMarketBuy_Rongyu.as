package game.ui.market
{
	import flash.events.MouseEvent;
	import modulecommon.net.msg.shoppingCmd.stBuyMarketObjCmd;
	import modulecommon.scene.market.MarkerBaseObjWithNum;
	import modulecommon.scene.market.stMarket;
	import modulecommon.scene.market.stMarketBaseObj;
	import modulecommon.scene.prop.BeingProp;
	import modulecommon.scene.prop.object.ZObjectDef;
	
	/**
	 * ...
	 * @author
	 */
	public class UIMarketBuy_Rongyu extends UIMarketBuy_Base
	{
		
		public function UIMarketBuy_Rongyu()
		{
			super();
		
		}
		
		override public function onReady():void
		{
			super.onReady();
			
			m_money.m_moneyPanel.type = BeingProp.RONGYU_PAI;
			m_money.m_value.setPos(29, 3);
			m_money.y = 126;
			m_money.m_moneyPanel.visible = true;
		}
		
		override public function updateData(data:Object=null):void
		{
			var obj:MarkerBaseObjWithNum = data as MarkerBaseObjWithNum;
			var defNum:uint = obj.m_num;
			m_marketObj = obj.m_data;
			setPanelAndName(m_marketObj.id);
			
			var maxBuy:int = m_obj.maxNum;
		
			m_numberCtrl.setParam(1, maxBuy, defNum);
		}
		
		override protected function numOnChange(n:int):void
		{
			m_money.m_value.text = n * m_marketObj.discoutprice + " / "+ m_gkcontext.m_objMgr.computeObjNumInCommonPackage(ZObjectDef.OBJID_rongyu);
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
			var nRongyu:int = m_gkcontext.m_objMgr.computeObjNumInCommonPackage(ZObjectDef.OBJID_rongyu);
			if (money > nRongyu)
			{
				m_gkcontext.m_systemPrompt.prompt("荣誉勋章不足");
				return;
			}
			var send:stBuyMarketObjCmd = new stBuyMarketObjCmd();
			send.objid = m_marketObj.id;
			send.num = n;
			send.markettype = stBuyMarketObjCmd.MARKETTYPE_HONOR;
			
			m_gkcontext.sendMsg(send);
			this.exit();
		}
	}

}