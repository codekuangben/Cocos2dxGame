package game.ui.market 
{
	/**
	 * ...
	 * @author 
	 */
	import com.bit101.components.Label;
	import flash.events.MouseEvent;
	import modulecommon.net.msg.shoppingCmd.stBuyMarketObjCmd;
	import modulecommon.scene.market.MarkerBaseObjWithNum;
	import modulecommon.scene.market.stMarket;
	import modulecommon.scene.market.stMarketBaseObj;
	import modulecommon.scene.prop.BeingProp;
	import com.util.UtilColor;
	public class UIMarketBuy_Corps extends UIMarketBuy_Base 
	{
		private var m_prompt:Label;
		public function UIMarketBuy_Corps() 
		{
			super();
			
		}
		
		override public function onReady():void 
		{
			super.onReady();
			
			m_money.m_moneyPanel.visible = false;
			m_money.m_value.x = 0;
			
			m_prompt = new Label(this, 146, 210, "", UtilColor.RED, 14);
			m_prompt.setBold(true);
			m_prompt.align = CENTER;
		}
		
		override public function updateData(data:Object=null):void
		{
			var obj:MarkerBaseObjWithNum = data as MarkerBaseObjWithNum;
			var defNum:uint = obj.m_num;
			m_marketObj = obj.m_data;
			setPanelAndName(m_marketObj.id);
			
			var maxBuy:int = m_marketObj.computeMaxNumWidthBuyLimit(m_gkcontext);			
			
			m_numberCtrl.setParam(1, maxBuy, defNum);
			
			
			var str:String;
			if (!m_gkcontext.m_corpsMgr.hasCorps)
			{
				str = "请先加入军团！";
				m_buyBtn.visible = false;
			}
			
			if (str)
			{
				m_buyBtn.visible = false;
				m_prompt.visible = true;
				m_prompt.text = str;
			}
			else
			{
				m_buyBtn.visible = true;
				m_prompt.visible = false;
			}
			
		}
		
		override protected function numOnChange(n:int):void
		{
			m_money.m_value.text = n * m_marketObj.discoutprice + " 军团贡献";
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
		
			var send:stBuyMarketObjCmd = new stBuyMarketObjCmd();
			send.objid = m_marketObj.id;
			send.num = n;
			send.markettype = stBuyMarketObjCmd.MARKETTYPE_CorpsGongxian;			
			
			m_gkcontext.sendMsg(send);
			this.exit();
		}
		
	}

}