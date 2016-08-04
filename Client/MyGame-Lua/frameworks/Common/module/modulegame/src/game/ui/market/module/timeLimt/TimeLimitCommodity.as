package game.ui.market.module.timeLimt 
{
	import com.bit101.components.Label;
	import flash.events.MouseEvent;
	import game.ui.market.module.common.CommondityYuanbaoBase;
	
	import modulecommon.scene.market.stMarketOnSaleObj;
	import com.util.UtilColor;
	
	/**
	 * ...
	 * @author ...
	 */
	public class TimeLimitCommodity extends CommondityYuanbaoBase 
	{
		private var m_timeLabel:Label;
		public function TimeLimitCommodity(param:Object=null)
		{
			super(param);
		}
		
		override protected function createCtrls():void
		{
			super.createCtrls();
			m_timeLabel = new Label(this, 15, 87); m_timeLabel.mouseEnabled = true;
		}
		
		override public function init():void 
		{
			super.init();
			
			m_buyBtn.setSkinButton1Image("market.bluebuybtn");
			m_buyBtn.y = 61;
			this.setPanelImageSkin("market.commoditybg_");	
		}
		override public function update():void 
		{
			if (m_bHasShow == false)
			{
				return;
			}
			super.update();
			
			var data:stMarketOnSaleObj = m_commodityData as stMarketOnSaleObj;
			var curT:uint = m_gkContext.m_context.m_timeMgr.getCalendarTimeSecond();
			var remainTime:uint;
			if (curT >= data.starttime && curT <= data.endtime)
			{
				remainTime = data.endtime - curT;
			}
			else
			{
				remainTime = 0;
			}
			var hour:uint = (remainTime + 3599) / 3600;
			var day:uint = hour / 24;
			hour = hour % 24;
		
			m_timeLabel.text = "剩余时间 " + day + "天" + hour + "小时";
			
			var buyEnaled:Boolean = true;
			if (m_commodityData.buylimit > 0)
			{
				if (m_numCanBuyToday == null)
				{
					m_numCanBuyToday = new Label(this, m_nameLabel.x, 63);	
				}
				var numBuyed:int = m_commodityData.buylimit - m_gkContext.m_marketMgr.queryNumObjBuy(m_commodityData.id);
				if (numBuyed > 0)
				{
					m_numCanBuyToday.text = "今日可购买数量 " + numBuyed;
					m_numCanBuyToday.setFontColor(UtilColor.GREEN);
				}
				else
				{
					m_numCanBuyToday.text = "今日不能再购买";
					m_numCanBuyToday.setFontColor(UtilColor.RED);
					buyEnaled = false;					
				}
				m_buyBtn.enabled = buyEnaled;
			}		
			
		}
		
	}

}