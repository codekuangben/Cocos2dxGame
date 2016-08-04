package game.ui.market.corps 
{
	
	import com.bit101.components.Label;
	import game.ui.market.module.CommodityBase;
	import com.util.UtilColor;
	/**
	 * ...
	 * @author
	 * 军团商城中的商品
	 */
	public class CorpsCommodity extends CommodityBase 
	{
		protected var m_priceLabel:Label;
		protected var m_infoLabel:Label;
		public function CorpsCommodity(param:Object=null) 
		{
			super(param);
			
		}
	
		override protected function createCtrls():void
		{
			super.createCtrls();
			m_priceLabel = new Label(this, m_nameLabel.x, 40);
			m_infoLabel = new Label(this, m_nameLabel.x, 68);
		}
		
		override public function init():void 
		{
			super.init()
			this.setPanelImageSkin("market.commoditybg");
			m_buyBtn.setSkinButton1Image("commoncontrol/button/duihuanbtn.png");			
			m_priceLabel.text = m_commodityData.discoutprice + " 贡献";
			update();
		}
		override public function update():void 
		{
			if (m_bHasShow ==false)
			{
				return;
			}
			super.update();
			var bBuyBtnGray:Boolean = true;
			if (m_commodityData.state > m_gkContext.m_corpsMgr.m_corpsInfo.level)
			{
				m_infoLabel.setFontColor(UtilColor.RED);
				m_infoLabel.text = "需要军团等级" + m_commodityData.state;
				bBuyBtnGray = false;
			}
			else if (m_commodityData.buylimit > 0)
			{
				var numBuyed:int = m_gkContext.m_marketMgr.queryNumObjBuyInCorpsMarket(m_commodityData.id);
				if (numBuyed >= m_commodityData.buylimit)
				{
					m_infoLabel.setFontColor(UtilColor.RED);
					m_infoLabel.text = "今日不能再购买";
					bBuyBtnGray = false;
				}
				else
				{
					m_infoLabel.setFontColor(UtilColor.GREEN);
					m_infoLabel.text = "今日可购买数量 "+(m_commodityData.buylimit-numBuyed);
				}
			}
			else
			{
				m_infoLabel.visible = false;
			}
			
			m_buyBtn.enabled = bBuyBtnGray;
		}
		
	}

}