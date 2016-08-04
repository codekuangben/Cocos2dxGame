package game.ui.market.module.common 
{
	import com.bit101.components.Label;
	import game.ui.market.module.CommodityBase;
	import game.ui.market.MoneyAndValue_Line;
	import com.bit101.components.Ani;
	import modulecommon.appcontrol.MonkeyAndValue;
	import modulecommon.scene.market.stMarketBaseObj;
	import modulecommon.scene.prop.BeingProp;
	/**
	 * ...
	 * @author ...
	 * 元宝商品基类
	 */
	public class CommondityYuanbaoBase extends CommodityBase 
	{
		protected var m_marginPrice:MoneyAndValue_Line;
		protected var m_numCanBuyToday:Label;
		protected var m_aniTag:Ani;
		public function CommondityYuanbaoBase(param:Object=null) 
		{
			super(param);
			
		}
		override protected function createCtrls():void
		{
			super.createCtrls();
			m_normalPrice = new MonkeyAndValue(m_gkContext, this, BeingProp.YUAN_BAO, m_nameLabel.x, 40);	
		}
		override public function init():void 
		{
				
			super.init();
			
			if (m_commodityData.discoutprice < m_commodityData.price)
			{
				if (m_marginPrice == null)
				{
					m_marginPrice = new MoneyAndValue_Line(m_gkContext, this, BeingProp.YUAN_BAO, m_nameLabel.x + 70, 40);
				}
				m_marginPrice.value = m_commodityData.price;
				var _xPos:Number = m_normalPrice.x;
				m_normalPrice.x = m_marginPrice.x;
				m_marginPrice.x = _xPos;
			}			
			
			var iTag:int = m_commodityData.tag;
			if (iTag == stMarketBaseObj.TAG_None)
			{
				if (m_aniTag)
				{
					m_aniTag.dispose();
					if (m_aniTag.parent)
					{
						m_aniTag.parent.removeChild(m_aniTag);
					}
					m_aniTag = null;
				}
			}
			else
			{
				var str:String;
				if (iTag == stMarketBaseObj.TAG_Remai)
				{
					str = "ejshangchengre.swf";
				}
				else
				{
					str = "ejshangchengqiang.swf";
				}
				if (m_aniTag == null)
				{
					m_aniTag = new Ani(m_gkContext.m_context);	
					m_aniTag.x = 10;
					m_aniTag.y = 16;
					m_aniTag.repeatCount = 0;
					this.addChild(m_aniTag);
					m_aniTag.mouseEnabled = false;
					m_aniTag.centerPlay = true;
				}
				m_aniTag.setImageAni(str);
				m_aniTag.duration = 1;
				m_aniTag.begin();
			}
			
			update();
		}		
		override public function onUIMarketShow():void
		{
			if (m_aniTag)
			{
				m_aniTag.begin();
			}
		}
		override public function onUIMarketHide():void
		{
			if (m_aniTag)
			{
				m_aniTag.stop();
			}
		}
	}

}